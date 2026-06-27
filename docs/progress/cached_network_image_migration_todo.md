# Migrasi ke CachedNetworkImage — Todo List

**Tanggal:** 27 Juni 2026
**Referensi:** ADR-006

---

## 1. File yang Perlu Dimigrasi

### Kategori A: `Image.network` → `CachedNetworkImage`

| # | File | Konteks | Line | Catatan | Estimasi |
|---|------|---------|------|---------|----------|
| 1 | `lib/features/booking/presentation/page/booking_detail_page.dart` | Doctor photo (booking detail) | 152 | Sudah ada `errorBuilder` → `Icons.person`. Tambah `placeholder` shimmer | 10 menit |
| 2 | `lib/features/profile/presentation/page/profile_page.dart` | User avatar (profile page) | 130 | Sudah ada `errorBuilder` → `_avatarPlaceholder`. Tambah `placeholder` | 10 menit |
| 3 | `lib/widgets/card/appointment_card.dart` | Doctor photo (appointment card) | 64 | Sudah ada `errorBuilder` → `Icons.person`. Tambah `placeholder` | 10 menit |
| 4 | `lib/widgets/card/clinic_card.dart` | Clinic cover image | 46 | Sudah ada `errorBuilder` → `PlaceholderImage`. Tambah `placeholder` | 10 menit |
| 5 | `lib/widgets/card/doctor_card_detail.dart` | Doctor photo (detail card) | 45 | Sudah ada `errorBuilder` → `Icons.person`. Tambah `placeholder` | 10 menit |
| 6 | `lib/widgets/card/nearby_clinic_card.dart` | Clinic cover (nearby) | 76 | Sudah ada `errorBuilder` → `PlaceholderImage`. Tambah `placeholder` | 10 menit |
| 7 | `lib/widgets/card/upcoming_appointment_card.dart` | Doctor photo (upcoming) | 139 | Sudah ada `errorBuilder` → `AppIcons.user`. Tambah `placeholder` | 10 menit |
| 8 | `lib/widgets/picker/app_image_picker.dart` | Remote profile photo | 141 | **Paling lengkap** — sudah ada `loadingBuilder` (shimmer) + `errorBuilder`. Ganti Image.network → CachedNetworkImage | 15 menit |
| 9 | `lib/widgets/shared/profile_avatar.dart` | Avatar photo (greeting) | 20 | **Prioritas tinggi** — `avatarUrl ?? ''` kirim request ke URL kosong. Tambah null check + ganti ke CachedNetworkImage | 10 menit |

### Kategori B: `DecorationImage` + `NetworkImage` → `CachedNetworkImage`

| # | File | Konteks | Line | Catatan | Estimasi |
|---|------|---------|------|---------|----------|
| 10 | `lib/widgets/card/banner_card.dart` | Banner image | 48 | **Paling kompleks** — `DecorationImage` tidak support error handling. Migrasi dari background image ke child `CachedNetworkImage`. Pastikan `aspectRatio`, `borderRadius`, `fit` tetap sama | 20 menit |

### Kategori C: Tidak Perlu Migrasi (Local Asset)

| # | File | Konteks | Alasan |
|---|------|---------|--------|
| — | `lib/features/auth/presentation/page/forgot_password_page.dart` | Icon asset | `Image.asset` — local asset, bukan network |
| — | `lib/features/auth/presentation/page/login_page.dart` | Icon asset | `Image.asset` — local asset, bukan network |
| — | `lib/features/auth/presentation/page/sign_up_page.dart` | Icon asset | `Image.asset` — local asset, bukan network |
| — | `lib/features/onboarding/presentation/page/onboarding_page.dart` | Onboarding images | `Image.asset` / `AssetImage` — local asset, bukan network |

---

## 2. Pola Standar yang Dipakai

Setiap `CachedNetworkImage` harus punya:

```dart
CachedNetworkImage(
  imageUrl: url,
  fit: BoxFit.cover,
  placeholder: (context, url) => const Center(
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  ),
  errorWidget: (context, url, error) => Icon(
    Icons.person,                          // ganti sesuai konteks
    color: AppTheme.grey400,
  ),
)
```

### Placeholder per Konteks

| Konteks | Placeholder |
|---------|-------------|
| Doctor / User photo (circle, 40-80px) | `CircularProgressIndicator` (kecil, 2px stroke) atau shimmer container |
| Clinic / Banner cover (full-width) | `Skeletonizer` shimmer (konsisten ADR-001) atau Container dengan `AppTheme.grey200` |
| Remote picker | `_Shimmer` widget yang sudah ada di `app_image_picker.dart` |

### Error Fallback per Konteks

| Konteks | Error Widget |
|---------|-------------|
| Doctor photo | `Icons.person` (atau `AppIcons.user`) |
| Clinic cover | `PlaceholderImage` (widget reusable) |
| User avatar | Initial character fallback (`_avatarPlaceholder`) |
| Banner | Container dengan `AppTheme.grey200` |
| Remote picker | `_Placeholder` widget |

---

## 3. Verifikasi

| # | Item | Status |
|---|------|--------|
| 1 | `dart run build_runner build --force-jit` — 0 error | ⬜ |
| 2 | `flutter analyze` — 0 issues | ⬜ |
| 3 | Semua `Image.network` / `NetworkImage` sudah diganti | ⬜ |
| 4 | `Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" \| Select-String -Pattern "Image\.network\|NetworkImage"` return 0 hasil | ⬜ |
| 5 | Semua `CachedNetworkImage` punya `placeholder` + `errorWidget` | ⬜ |
| 6 | Regression check: banner_card layout tidak berubah (aspectRatio, borderRadius) | ⬜ |
| 7 | Regression check: profile_avatar tidak kirim request saat avatarUrl null | ⬜ |

---

## 4. Total Estimasi

| Item | Jumlah | Estimasi |
|------|--------|----------|
| File dimigrasi (Image.network → CachedNetworkImage) | 9 file | ~1.5 jam |
| File dimigrasi (DecorationImage → CachedNetworkImage) | 1 file | ~20 menit |
| Verifikasi (analyze + grep regression) | — | ~15 menit |
| **Total** | **10 file** | **~2 jam** |

---

*Dibuat: 27 Juni 2026 · Referensi: ADR-006*