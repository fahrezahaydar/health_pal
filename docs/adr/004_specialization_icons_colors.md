# ADR 004: Specialization Icons (SVG) & Warna

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 24 Juni 2026 |
| **Penulis** | Backend Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | Data Layer (model/entity) + UI (CategoryCard) + Supabase query select |

---

## 1. Konteks

Sebelum ADR ini, specialization hanya punya `icon_url` (string PNG dari bucket `icons/`). Dua masalah:

1. **Ikon PNG tidak konsisten** — Ukuran, style, dan warna antar ikon berbeda karena来源从 internet. SVG memberi vector scaling sempurna di semua resolusi device.
2. **Warna card/icon background hardcoded** — `CategoryCard` pakai `AppTheme.paleBlue` untuk semua specialization. Setelah diskusi dengan desainer, setiap specialization perlu warna unik (mis. Jantung → merah, Anak → orange, Gigi → biru) agar user lebih mudah mengenali kategori secara visual.

### Perubahan Database (sudah di-deploy via migration `006`)

| Perubahan | Detail |
|---|---|
| Bucket `specialization-icons` | Public read, 1MB limit, hanya `image/svg+xml` |
| Kolom `color_hex` (nullable) | Format: `#RRGGBB` atau `#AARRGGBB`, validasi CHECK constraint |
| RLS | SELECT public, INSERT/UPDATE/DELETE hanya via service role (admin) |
| Schema comment | `icon_url` diupdate → referensi ke bucket `specialization-icons`. `color_hex` didokumentasikan nullable. |

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: Color Enum di Flutter side (TIDAK DIPILIH)

Map specialization name → color di Dart, tanpa kolom DB.

- **Pro:** Tidak perlu migration DB.
- **Kontra:** Setiap tambah spesialisasi baru → harus update APK. Tidak scalable.
- **Kontra:** Backend (admin panel) tidak bisa kontrol warna — harus rilis app baru.

### Opsi B: Kolom `color_hex` di DB + render di Flutter (DIPILIH)

- **Pro:** Admin bisa update warna kapan saja tanpa rilis app.
- **Pro:** Frontend tinggal baca `color_hex` dari JSON response — zero logic mapping.
- **Pro:** Konsisten zero-boilerplate: entity → model → UI tanpa switch-case.
- **Kontra:** Butuh migration DB (sudah selesai).
- **Kontra:** Flutter harus handle parsing HEX ke `Color` object.

### Opsi C: Dual storage — PNG tetap + SVG baru (TIDAK DIPILIH)

- **Pro:** Backward compatibility.
- **Kontra:** Duplikasi storage + maintenance. `icon_url` sudah nullable dan migration idempotent.

---

## 3. Keputusan

**Pilih Opsi B: `color_hex` dari DB + `specialization-icons` bucket untuk SVG.**

### Detail Keputusan

1. **Entity:** `SpecializationEntity.colorHex` — nullable `String?`.
2. **Model:** `SpecializationModel.colorHex` — `@JsonKey(name: 'color_hex') String?`.
3. **UI:** `CategoryCard` — background `Container` pakai `colorHex` yang di-parse ke `Color`, fallback ke `AppTheme.paleBlue` jika null.
4. **Supabase select:** Semua query `specializations` WAJIB include `color_hex`.
5. **Icon rendering:** `Image.network()` tetap sama — sekarang SVG dari bucket `specialization-icons`.
6. **Error handling:** Jika SVG gagal load (`errorBuilder`), fallback ke Material icon + `colorHex` background (tetap tampil baik).

---

## 4. Alasan

1. **Scalability:** Admin bisa update warna + ganti SVG kapan saja via Supabase Studio → zero app update.
2. **User experience:** Warna unik per spesialisasi mempercepat visual scanning.
3. **Vector quality:** SVG render sharp di semua device density (1x, 2x, 3x).
4. **File size:** SVG icon ~1-3 KB vs PNG ~10-50 KB → lebih cepat load + lebih hemat bandwidth.
5. **Consistency:** Semua card pakai warna dari DB — tidak ada lagi `_iconData()` fallback yang hardcoded.

---

## 5. Konsekuensi

### Positif

- ✅ Warna + ikon bisa diupdate dari Supabase Studio tanpa rilis app.
- ✅ SVG lebih ringan dan sharp dari PNG.
- ✅ `color_hex` nullable → zero breaking change untuk data existing.
- ✅ `select()` wildcard di `HomeRemoteDataSource.fetchSpecializations()` sudah otomatis include `color_hex`.

### Negatif

- ⚠️ Flutter tidak native render SVG via `Image.network()`. Perlu package `flutter_svg` jika ingin render SVG native. **Keputusan: tetap pakai `Image.network()`** — Supabase Storage otomatis serve SVG dengan `Content-Type: image/svg+xml`, Flutter `Image.network()` render SVG via platform views (OK untuk MVP). Jika ada issue rendering, migrasi ke `flutter_svg` di Sprint berikutnya.
- ⚠️ Parse HEX ke `Color` perlu custom extension — tidak ada di Flutter SDK (`Color(0xFF...`) hanya terima int, bukan string `"#RRGGBB"`).
- ⚠️ DoctorRemoteDataSource pakai select eksplisit `specializations(id, name, icon_url)` — perlu ditambah `color_hex`.

### Risiko & Mitigasi

| Risiko | Mitigasi |
|---|---|
| SVG tidak render di Flutter `Image.network()` | Fallback `errorBuilder` → Material icon + `colorHex` background. Jika mayoritas device gagal, migrasi ke `flutter_svg` + cache SVG lokal. |
| HEX format invalid dari admin | CHECK constraint di DB sudah mencegah. Jaga-jaga: fallback `colorHex` parse → `tryParse` return null → fallback `AppTheme.paleBlue`. |
| Lupa include `color_hex` di select query | WAJIB code review: semua `.select()` yang include `specializations(...)` harus punya `color_hex`. |

---

## 6. Panduan Implementasi untuk Flutter Developer

### 6.1 Entity — tambah field `colorHex`

**File:** `lib/features/home/domain/entity/specialization_entity.dart`

```dart
class SpecializationEntity extends Equatable {
  final String id;
  final String name;
  final String? iconUrl;
  final String? colorHex;                     // ← TAMBAH

  const SpecializationEntity({
    required this.id,
    required this.name,
    this.iconUrl,
    this.colorHex,                            // ← TAMBAH
  });

  @override
  List<Object?> get props => [id, name, iconUrl, colorHex]; // ← UPDATE
}
```

### 6.2 Model — tambah field `colorHex` dengan `@JsonKey`

**File:** `lib/features/home/data/model/specialization_model.dart`

```dart
const factory SpecializationModel({
  required String id,
  required String name,
  @JsonKey(name: 'icon_url') String? iconUrl,
  @JsonKey(name: 'color_hex') String? colorHex,      // ← TAMBAH
}) = _SpecializationModel;
```

Update `fromEntity` dan `toEntity`:
```dart
factory SpecializationModel.fromEntity(SpecializationEntity entity) =>
    SpecializationModel(
      id: entity.id,
      name: entity.name,
      iconUrl: entity.iconUrl,
      colorHex: entity.colorHex,                     // ← TAMBAH
    );

SpecializationEntity toEntity() => SpecializationEntity(
      id: id,
      name: name,
      iconUrl: iconUrl,
      colorHex: colorHex,                            // ← TAMBAH
    );
```

**Regenerate:** `dart run build_runner build --force-jit`

### 6.3 Supabase Select — tambah `color_hex`

**File:** `lib/features/doctor/data/datasource/doctor_remote_datasource.dart`

Line 29 — search endpoint:
```dart
// SEBELUM
'*, clinics(id, name, address, city), specializations(id, name, icon_url)'
// SESUDAH
'*, clinics(id, name, address, city), specializations(id, name, icon_url, color_hex)'
```

Line 56 — detail endpoint:
```dart
// SEBELUM
'*, clinics(id, name, address, city, latitude, longitude, phone), specializations(id, name, icon_url)'
// SESUDAH
'*, clinics(id, name, address, city, latitude, longitude, phone), specializations(id, name, icon_url, color_hex)'
```

> **Catatan:** `HomeRemoteDataSource.fetchSpecializations()` (line 54-63) pakai `.select()` wildcard — `color_hex` otomatis termasuk. Tidak perlu perubahan.

### 6.4 CategoryCard — pakai `colorHex` untuk background

**File:** `lib/widgets/card/category_card.dart`

Tambah parameter `colorHex`:

```dart
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    this.name,
    this.iconUrl,
    this.colorHex,               // ← TAMBAH
    this.onTap,
  });

  final String? name;
  final String? iconUrl;
  final String? colorHex;        // ← TAMBAH
  final VoidCallback? onTap;
```

Update `fromEntity` factory:

```dart
factory CategoryCard.fromEntity(
  SpecializationEntity entity, {
  VoidCallback? onTap,
}) {
  return CategoryCard(
    name: entity.name,
    iconUrl: entity.iconUrl,
    colorHex: entity.colorHex,      // ← TAMBAH
    onTap: onTap,
  );
}
```

Update `Container` decoration — background pakai `colorHex`:

```dart
Container(
  decoration: BoxDecoration(
    color: _parseColor(colorHex) ?? AppTheme.paleBlue.withValues(alpha: 0.3), // ← UPDATE
    borderRadius: BorderRadius.circular(16),
  ),
  alignment: Alignment.center,
  child: iconUrl != null
      ? Image.network(
          iconUrl!,
          width: 28,
          height: 28,
          errorBuilder: (_, _, _) =>
              Icon(_iconData(name), size: 28, color: AppTheme.blue),
        )
      : Icon(_iconData(name), size: 28, color: AppTheme.blue),
),
```

Tambah helper function:

```dart
Color? _parseColor(String? hex) {
  if (hex == null) return null;
  final h = hex.replaceFirst('#', '');
  if (h.length != 6 && h.length != 8) return null;
  final v = int.tryParse(h, radix: 16);
  if (v == null) return null;
  if (h.length == 6) return Color(0xFF000000 | v);
  return Color(v);
}
```

> **Catatan:** `_parseColor` sudah handle format `#RRGGBB` (tambah alpha FF) dan `#AARRGGBB` (langsung). Jika parse gagal, fallback ke `AppTheme.paleBlue`.

### 6.5 Color HEX ke `Color` — Extension (Opsional)

Jika `_parseColor` dipakai di banyak tempat, buat extension di `core/extensions/`:

```dart
// lib/core/extensions/color_ext.dart
extension HexColor on String {
  Color? toColor() {
    final h = replaceFirst('#', '');
    if (h.length != 6 && h.length != 8) return null;
    final v = int.tryParse(h, radix: 16);
    if (v == null) return null;
    if (h.length == 6) return Color(0xFF000000 | v);
    return Color(v);
  }
}
```

---

## 7. Compliance

| Mekanisme | Detail |
|---|---|
| **AGENTS.md** | Icon Convention section — Material Icons untuk code baru + TODO comment |
| **Code Review** | WAJIB cek `select()` query include `color_hex` |
| **ADR ini** | Panduan implementasi Flutter di §6 |
| **Build Runner** | `dart run build_runner build --force-jit` setelah edit model |

---

## 8. Referensi

- Migration: `supabase/migrations/006_specialization_icons_colors.sql`
- ERD: `docs/erd/erd_healh_pal.md` — `specializations` table (+ `color_hex`)
- API Contract: `docs/api_contract/api_contract_health_pal.md` — response examples (+ `color_hex`)
- ADR Skeletonizer: `docs/adr/001_skeletonizer.md`
- Icon Convention: `AGENTS.md` — Icon Convention section (Sprint 2+)

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*
