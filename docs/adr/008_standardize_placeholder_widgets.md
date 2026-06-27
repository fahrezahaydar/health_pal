# ADR 008: Standarisasi Placeholder Widget ke Reusable Global Widgets

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 27 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | ~20 Dart files (placeholder refactor), `lib/widgets/shared/` (new widgets), `lib/widgets/avatar/` (new widget) |

---

## 1. Konteks

Health Pal memiliki berbagai jenis placeholder di seluruh aplikasi — image fallback, avatar fallback, loading skeleton, dan empty state. Audit pada 27 Juni 2026 mengungkap pola duplikasi yang signifikan:

### 1.1 Image Placeholder (CachedNetworkImage fallback)

8 file mengulang pola yang hampir identik untuk `placeholder` dan `errorWidget`:

| File | Size | placeholder | errorWidget | null fallback |
|------|------|-------------|-------------|---------------|
| `doctor_card.dart` | 72×72 | `Container(grey100) + Icon(person)` | Sama | Sama |
| `doctor_card_detail.dart` | 80×80 | `CircularProgressIndicator` | `Icon(person)` | `Icon(person)` |
| `appointment_card.dart` | 48×48 | `CircularProgressIndicator` | `Icon(person)` | `Icon(person)` |
| `upcoming_appointment_card.dart` | 56×56 | `CircularProgressIndicator` | `Icon(AppIcons.user)` | `Icon(AppIcons.user)` |
| `booking_detail_page.dart` | 56×56 | `CircularProgressIndicator` | `Icon(person)` | `Icon(person)` |
| `profile_avatar.dart` | 42×42 | `SizedBox.shrink()` | Initials fallback | Initials fallback |
| `profile_page.dart` | 80×80 | `_avatarPlaceholder()` | `_avatarPlaceholder()` | `_avatarPlaceholder()` |
| `banner_card.dart` | full | `SizedBox.shrink()` | `SizedBox.shrink()` | Gallery icon |

### 1.2 Avatar Placeholder (Initials Fallback)

3 implementasi berbeda untuk fallback inisial:

| File | Output | Implementation |
|------|--------|----------------|
| `profile_avatar.dart` | First char nickname, `primary` bg 15% alpha | Private method `_buildFallback` |
| `profile_page.dart` | First char fullName, bg `transparent` | Private method `_avatarPlaceholder` |
| `app_image_picker.dart` | Circular icon with `grey200` bg | Private class `_Placeholder` |

### 1.3 Loading Skeleton Classes

6 private skeleton widget classes dengan struktur identik:

| File | Widget | Structure |
|------|--------|-----------|
| `profile_page.dart` | `_ProfileSkeleton` | Grey boxes simulating profile card |
| `favorite_page.dart` | `_FavSkeleton` | 3 grey rows (96h) |
| `notification_page.dart` | `_NotificationSkeleton` | 5 grey rows (80h) |
| `edit_profile_page.dart` | `_EditSkeleton` | Circle + 3 grey fields |
| `booking_history_page.dart` | `_ListSkeleton` | 5 grey rows (80h) |
| `booking_detail_page.dart` | `_DetailSkeleton` | 3 grey blocks |

### 1.4 Masalah yang Diidentifikasi

1. **Duplikasi tinggi** — 8 file mengulang pola `CachedNetworkImage` placeholder/error yang sama dengan variasi minor (icon pilih, ukuran, warna).
2. **Inkonsistensi loading indicator** — 5 file pakai `CircularProgressIndicator`, 2 file pakai `SizedBox.shrink()` (tidak terlihat), 1 file pakai shimmer.
3. **Avatar fallback terfragmentasi** — 3 implementasi berbeda untuk pattern yang sama (inisial user).
4. **Skeleton boilerplate** — 6 private skeleton classes dengan layout copy-paste. Setiap perubahan UI membutuhkan sync ke skeleton variant.
5. **Hardcoded colors minor** — `DotLoader` default `Color(0xFF2D2D2D)` dan `AppLoadingDialog` line 54 menggunakan `Color(0xFF1F2A37)` tanpa melalui AppTheme.

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: Buat Reusable Placeholder Widgets + Standard Pattern (DIUSULKAN)

Buat widget global reusable di `lib/widgets/shared/` untuk setiap kategori placeholder, dengan properti yang dapat dikonfigurasi.

**Pro:**
- Satu source of truth untuk setiap jenis placeholder.
- Perubahan UI (warna, ukuran, icon) cukup di satu tempat.
- Placeholder `CachedNetworkImage` konsisten di semua card.
- Avatar fallback terstandarisasi — inisial, ukuran, warna dari AppTheme.
- Tidak perlu dependency baru.

**Kontra:**
- Perlu refactor ~20 file — effort ~3-4 jam.
- Migrasi bertahap — risiko break layout card yang ada.

### Opsi B: Biarkan Status Quo

Pertahankan semua placeholder inline seperti sekarang.

**Pro:**
- Zero effort.
- Setiap card bisa punya placeholder berbeda jika desain memang membutuhkan.

**Kontra:**
- Duplikasi terus bertambah setiap ada card baru.
- Inkonsistensi loading indicator tidak teratasi.
- Bug fix placeholder harus di-sync ke 8 file manual.

### Opsi C: Buat Satu Widget `AppImage` Universal

Buat wrapper widget yang menangani semua jenis image (network, asset, file) dengan placeholder/error built-in.

**Pro:**
- Satu widget untuk semua kebutuhan image.
- Placeholder/error konsisten otomatis.

**Kontra:**
- 8 file harus dimigrasi.
- Override untuk konteks spesifik jadi lebih kompleks.
- Over-engineering — untuk MVP, reusable placeholder + CachedNetworkImage sudah cukup.

---

## 3. Keputusan

**Pilih Opsi A: Buat reusable global placeholder widgets + standarisasi pola `CachedNetworkImage` placeholder/error.**

### Detail Keputusan

1. **Buat `AppNetworkImage`** di `lib/widgets/shared/app_network_image.dart`:
   - Wrapper reusable untuk `CachedNetworkImage` dengan placeholder + errorWidget built-in.
   - Parameter: `imageUrl`, `width`, `height`, `fit`, `borderRadius`, `iconSize`, `iconData` (default `Icons.person`).
   - Placeholder: `Container` dengan `CircularProgressIndicator` (loading).
   - Error widget: `Container` dengan icon fallback (error).
   - Null URL fallback: Container dengan icon fallback (sama dengan error).
   - Semua warna dari AppTheme, bukan hardcoded.

2. **Buat `AvatarInitials`** di `lib/widgets/shared/avatar_initials.dart`:
   - Standarisasi fallback avatar — menampilkan inisial user dalam lingkaran.
   - Parameter: `name` (untuk inisial), `size`, `backgroundColor`, `textStyle`.
   - Default warna dari AppTheme (primary bg dengan alpha, primary text).
   - Bisa dipakai oleh ProfileAvatar, ProfilePage, dan siapapun yang butuh avatar fallback.

3. **Standarisasi placeholder `CachedNetworkImage`** di semua card — ganti 8 inline pattern dengan `AppNetworkImage`.

4. **Ganti 3 avatar fallback** dengan `AvatarInitials`.

5. **Hapus 6 private skeleton classes** — ganti dengan `Skeletonizer` + reuse production widget (konsisten ADR-001). Untuk page yang tidak punya production widget mock, gunakan `AppSkeleton` pattern.

6. **Fix `DotLoader`** — pindahkan default color ke AppTheme.

7. **Fix `AppLoadingDialog`** — ganti `Color(0xFF1F2A37)` dengan `AppTheme.grey800`.

```dart
// Contoh AppNetworkImage
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.iconSize,
    this.iconData,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? borderRadius;
  final double? iconSize;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius != null
          ? BorderRadius.circular(borderRadius!)
          : BorderRadius.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                placeholder: (_, _) => _buildPlaceholder(context),
                errorWidget: (_, _, _) => _buildFallback(context),
              )
            : _buildFallback(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: AppTheme.grey100,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.grey400,
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      color: AppTheme.grey100,
      alignment: Alignment.center,
      child: Icon(
        iconData ?? Icons.person,
        size: iconSize ?? 28,
        color: AppTheme.grey400,
      ),
    );
  }
}
```

```dart
// Contoh AvatarInitials
class AvatarInitials extends StatelessWidget {
  const AvatarInitials({
    super.key,
    required this.name,
    this.size = 42,
    this.backgroundColor,
    this.textStyle,
  });

  final String name;
  final double size;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: textStyle ??
            AppTextTheme.titleLarge.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
```

---

## 4. Alasan

1. **Eliminasi duplikasi** — 8 card dengan inline placeholder pattern identik → 1 reusable widget `AppNetworkImage`.
2. **Konsistensi loading state** — Semua `CachedNetworkImage` akan punya loading spinner yang seragam (CircularProgressIndicator `grey400`), bukan campuran spinner + shrink + shimmer.
3. **Konsistensi error state** — Semua image fallback akan menampilkan icon yang sama dengan background yang sama, dengan perubahan hanya pada icon dan ukuran (via parameter).
4. **Satu source of truth avatar** — `AvatarInitials` menggantikan 3 implementasi avatar fallback. Perubahan warna/styling cukup di satu file.
5. **Alignment dengan ADR-001** — Menghapus 6 private skeleton classes sesuai pattern Skeletonizer (reuse production widget, bukan buat skeleton terpisah).
6. **Alignment dengan ADR-006** — Semua network image sudah pakai CachedNetworkImage; `AppNetworkImage` adalah lapisan standarisasi di atasnya.
7. **Self-documenting** — `AppNetworkImage` dengan parameter eksplisit (`width`, `height`, `borderRadius`, `iconData`) lebih mudah dibaca daripada inline `Container(color: grey100, child: Icon(person))` yang diulang 8 kali.
8. **Waktu refactor minimal** — ~3-4 jam untuk ~20 file; pengurangan ~150 baris duplicate code.

---

## 5. Konsekuensi

### Positif

- ✅ Satu widget `AppNetworkImage` untuk semua network image — placeholder + error handling built-in.
- ✅ Satu widget `AvatarInitials` untuk semua fallback avatar — konsisten di greeting, profile, dan picker.
- ✅ Eliminasi 6 private skeleton classes — pengurangan boilerplate signifikan.
- ✅ Semua warna placeholder dari AppTheme — siap untuk dark mode.
- ✅ Perubahan UI placeholder cukup di 2 file (`AppNetworkImage`, `AvatarInitials`) — bukan di 20+ file.
- ✅ `DotLoader` default color pindah ke AppTheme — konsisten.

### Negatif

- ⚠️ Refactor ~20 file — perlu testing ulang setiap card/layout yang menggunakan placeholder.
- ⚠️ `AppNetworkImage` menambahkan satu lapisan abstraksi di atas `CachedNetworkImage` — minor indirection.
- ⚠️ Card yang sebelumnya punya loading spinner berbeda (misal shimmer di app_image_picker) akan kehilangan variasi tersebut. Jika desain memang membutuhkan shimmer spesifik, `AppNetworkImage` perlu parameter opsional `placeholderBuilder`.

### Risiko & Mitigasi

| Risiko | Mitigasi |
|--------|----------|
| Layout card berubah setelah migrasi `AppNetworkImage` | Test visual setiap card setelah refactor. Pastikan `borderRadius`, `fit`, `width`, `height` identik. |
| `CircularProgressIndicator` di placeholder kurang smooth dibanding shimmer | Parameter opsional `placeholderBuilder` di masa depan jika dibutuhkan. Untuk MVP, spinner cukup. |
| AvatarInitials tidak cocok untuk semua konteks (misal ukuran font berbeda) | Parameter `textStyle` dan `backgroundColor` bisa di-override per konteks. |
| Refactor 20 file dalam satu commit sulit di-review | Commit per kategori: (1) buat widget baru, (2) migrasi CachedNetworkImage → AppNetworkImage, (3) migrasi avatar, (4) hapus skeleton classes, (5) fix DotLoader. |

---

## 6. Compliance

| Mekanisme | Detail |
|---|---|
| **AGENTS.md** | Update Placeholder Rule — WAJIB pakai `AppNetworkImage` untuk network image, DILARANG inline `CachedNetworkImage` dengan placeholder/error duplikat |
| **Code Review** | DILARANG merge PR yang mengandung inline `CachedNetworkImage` dengan placeholder/error widget baru tanpa justification |
| **ADR 001** | Skeletonizer pattern — hapus private skeleton classes, reuse production widget |
| **ADR 006** | CachedNetworkImage standard — `AppNetworkImage` adalah lapisan standarisasi di atasnya |

---

## 7. Referensi

- ADR 001: Skeletonizer — standarisasi loading skeleton
- ADR 006: CachedNetworkImage — standarisasi network image
- Existing shared widgets: `lib/widgets/shared/placeholder_image.dart`, `lib/widgets/shared/empty_state_view.dart`, `lib/widgets/shared/profile_avatar.dart`
- Widget yang akan dimigrasi: `doctor_card.dart`, `doctor_card_detail.dart`, `appointment_card.dart`, `upcoming_appointment_card.dart`, `booking_detail_page.dart`, `profile_page.dart`, `profile_avatar.dart`, `banner_card.dart`, `app_image_picker.dart`, `favorite_page.dart`, `notification_page.dart`, `edit_profile_page.dart`, `booking_history_page.dart`, `settings_page.dart`, `app_loading_dialog.dart`

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*