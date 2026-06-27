# ADR 007: Doctor Card Redesign v2.0

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 27 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | Data Layer (DoctorEntity/Model), UI (DoctorCard widget), 2 consumer pages (search, favorite), docs/wireframe/08-doctor-search.md |

---

## 1. Konteks

Doctor Card v1.0 (terdefinisi di `docs/wireframe/08-doctor-search.md` dan `lib/widgets/card/doctor_card.dart`) memiliki layout:

```
┌─ Doctor Card v1.0 ──────────────────────┐
│ 🟣 (circle 56px) dr. Budi Santoso    ⭐ │
│                    Sp.PD              4.85│
│                    Klinik Sehat          │
│                    Rp150,000             │
└──────────────────────────────────────────┘
```

Setelah evaluasi UX dan alignment dengan Clinic Card v2.0 (ADR-005), ditemukan beberapa kekurangan:

| Aspek | v1.0 | Masalah |
|-------|------|---------|
| **Foto dokter** | Circle 56px (tidak proporsional) | Tidak konsisten dengan wireframe detail yang pakai 1:1. Foto terpotong jadi lingkaran kecil. |
| **Favorite button** | ❌ Tidak ada | User tidak bisa menandai dokter favorit dari list. Favorite hanya ada di halaman detail (`DoctorCardDetail`). |
| **Rating & Review** | Rating badge kecil di kanan, tanpa review count | Informasi kurang prominent. User perlu melihat jumlah ulasan untuk menilai kredibilitas rating. |
| **Layout** | Vertikal (info di kolom kanan) | Tidak optimal untuk menampilkan informasi tambahan (favorite, review count, location). |
| **Biaya** | Ditampilkan di card (`Rp150,000`) | Bertentangan dengan wireframe v2.0 yang memindahkan biaya ke halaman detail. |

### Referensi Desain Baru

Clinic Card v2.0 (ADR-005) sudah menerapkan pattern: cover image, rating + review count, favorite button, separator visual. Doctor Card perlu mengikuti pattern yang sama untuk konsistensi UI.

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: Redesign DoctorCard — horizontal, 1:1 image, favorite, rating + review (DIUSULKAN)

Satu widget `DoctorCard` shared untuk search page dan favorite page, dengan layout baru.

- **Pro:** Konsisten dengan Clinic Card v2.0 pattern (rating, review, favorite).
- **Pro:** Foto 1:1 lebih proporsional dan konsisten dengan halaman detail.
- **Pro:** Favorite button di card memungkinkan toggle tanpa masuk ke halaman detail.
- **Pro:** Satu widget untuk semua konteks — zero duplikasi.
- **Kontra:** Breaking change untuk 2 consumer pages (search, favorite) — perlu update parameter.
- **Kontra:** `DoctorEntity` perlu tambah field `isFavorite` atau dikelola via state eksternal.

### Opsi B: Split — DoctorCardSearch + DoctorCardFavorite

Widget terpisah untuk konteks search (dengan rating) dan favorite (dengan unfavorite button).

- **Pro:** Masing-masing widget bisa optimal untuk konteksnya.
- **Kontra:** Duplikasi layout ~70% antara kedua card.
- **Kontra:** Maintenance overhead — perubahan layout harus di-sync ke 2 widget.
- **Kontra:** Tidak konsisten dengan pendekatan `ClinicCard` yang 1 widget untuk semua.

### Opsi C: Expand v1.0 — tambah favorite button di layout existing

Pertahankan layout horizontal circle 56px, cukup tambah favorite icon di pojok.

- **Pro:** Minimal change — tidak perlu refactor besar.
- **Kontra:** Foto lingkaran 56px tidak proporsional — wireframe detail pakai 1:1.
- **Kontra:** Tidak ada ruang untuk review count tanpa mengubah layout.
- **Kontra:** Tidak konsisten dengan Clinic Card v2.0 yang full-width cover.

---

## 3. Keputusan

**Pilih Opsi A: Redesign DoctorCard ke v2.0 — layout horizontal dengan foto 1:1, favorite, rating + review count.**

### Detail Keputusan

1. **Layout:** Row — kiri `ClipRRect` + `AspectRatio(1/1)` untuk foto, kanan `Expanded Column` untuk info.
2. **Favorite:** `IconButton` dengan `isFavorite` + `onFavoriteTap` callback. State dikelola oleh parent (cubit), bukan internal widget. Pattern identik dengan `ClinicCard` (ADR-005).
3. **Rating + Review:** Ditampilkan sebagai row: `⭐ 4.85 | 234 ulasan` dengan separator vertikal.
4. **Hapus fee** dari card — dipindah ke halaman detail (konsisten wireframe v2.0).
5. **Foto:** 1:1 aspect ratio dengan `CachedNetworkImage` (konsisten ADR-006) + `placeholder` + `errorWidget`.
6. **Divider:** Horizontal `Divider` di bawah nama dokter, sebelum spesialisasi.
7. **Location:** Row dengan icon lokasi + nama klinik (clinicName).
8. **isFavorite state:** Tidak ditambahkan ke `DoctorEntity` — cukup dikelola via `Set<String>` di cubit (pattern identik dengan `LocCubit._favoriteIds`). Jika nanti perlu persist server, tambah migration.

### Widget Interface Baru

```dart
class DoctorCard extends StatelessWidget {
  const DoctorCard({
    required this.name,
    required this.specialization,
    this.rating,
    this.reviewCount,
    this.clinic,
    this.photoUrl,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });
}
```

---

## 4. Alasan

1. **Konsistensi dengan Clinic Card v2.0** — Pattern yang sama (rating, review count, favorite, separator) memudahkan user mengenali interaksi yang tersedia.
2. **Foto 1:1 lebih informatif** — Menampilkan wajah dokter dengan proporsi benar, konsisten dengan halaman detail. Wireframe detail (`09-doctor-detail.md`) sudah pakai foto 1:1.
3. **Favorite dari list** — User bisa menandai favorit tanpa harus membuka halaman detail setiap kali. Engagement meningkat.
4. **Rating + review count prominent** — Informasi kredibilitas ditampilkan jelas, membantu user memutuskan lebih cepat.
5. **isFavorite via external state** — Tidak perlu ubah `DoctorEntity`/`DoctorModel`. Cukup `Set<String>` di cubit. Migration zero DB change.
6. **Fee dihapus dari card** — Informasi biaya lebih kontekstual di halaman detail (bersama jadwal dan booking). Card tetap fokus pada identitas dokter.

---

## 5. Konsekuensi

### Positif

- ✅ Layout konsisten dengan Clinic Card v2.0 — user experience seragam.
- ✅ Favorite button di list — reduce tap count untuk mark favorite.
- ✅ Foto 1:1 — visual lebih baik, konsisten dengan detail page.
- ✅ Rating + review count membantu user decision.
- ✅ Tidak perlu perubahan DB/API — isFavorite state local di cubit.
- ✅ Fee dipindah ke detail — card lebih fokus pada identitas dokter.

### Negatif

- ⚠️ **Breaking change** — `DoctorCard` widget mengubah parameter signature. 2 consumer pages perlu diupdate:
  - `doctor_search_page.dart` — tambah `reviewCount`, `isFavorite`, `onFavoriteTap`
  - `favorite_page.dart` — tambah `reviewCount`, `isFavorite`, `onFavoriteTap`
- ⚠️ **Layout berubah** — Jika ada widget test untuk DoctorCard v1.0, perlu update.
- ⚠️ **Favorite tidak persist** — State hilang saat app restart (sama dengan ClinicCard). Migrasi ke server di sprint berikutnya.

### Risiko & Mitigasi

| Risiko | Mitigasi |
|--------|----------|
| Foto 1:1 terlalu besar di card dengan banyak informasi | Set width ~72px (sedikit lebih besar dari v1.0 56px, tapi tidak overbesar). |
| Favorite state hilang setelah restart | Simpan di SharedPreferences sementara (key: `favorite_doctor_ids`). Migrasi ke server di sprint berikutnya. |
| Review count tidak ada data (MVP — reviews belum diimplementasi) | Tampilkan `0` sebagai default. Jika `ratingCount == 0`, sembunyikan rating row. |
| `onFavoriteTap` callback tidak dipass oleh consumer | Default `null` — favorite button tidak ditampilkan jika callback null. |

---

## 6. Compliance

| Mekanisme | Detail |
|---|---|
| **Wireframe** | `docs/wireframe/08-doctor-search.md` — Doctor Card v2.0 section |
| **ADR ini** | Dokumen keputusan arsitektur |
| **Todo List** | `docs/progress/doctor_card_redesign_todo.md` |
| **Code Review** | WAJIB cek: (1) DoctorCard layout match wireframe v2.0, (2) favorite state management, (3) konsistensi dengan ClinicCard pattern |

---

## 7. Referensi

- Wireframe: `docs/wireframe/08-doctor-search.md` — Doctor Card v2.0
- ADR 005: Clinic Card Redesign v2.0 — pattern reference (favorite, rating, review)
- ADR 006: CachedNetworkImage — image loading standard
- Existing Widget: `lib/widgets/card/doctor_card.dart`
- Consumer Pages: `lib/features/doctor/presentation/page/doctor_search_page.dart`, `lib/features/profile/presentation/page/favorite_page.dart`

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*