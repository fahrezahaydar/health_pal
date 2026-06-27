# Standarisasi Placeholder Widget — Todo List

**Tanggal:** 27 Juni 2026
**Referensi:** ADR-008

---

## 1. Widget Baru yang Harus Dibuat

| # | Widget | File Target | Estimasi |
|---|--------|-------------|----------|
| 1 | `AppNetworkImage` — wrapper `CachedNetworkImage` dengan placeholder + error + null fallback | `lib/widgets/shared/app_network_image.dart` | 20 menit |
| 2 | `AvatarInitials` — avatar fallback dengan inisial user | `lib/widgets/shared/avatar_initials.dart` | 15 menit |

---

## 2. File yang Perlu Dimigrasi

### Kategori A: CachedNetworkImage → `AppNetworkImage`

| # | File | Line | Saat Ini | Estimasi |
|---|------|------|----------|----------|
| 1 | `lib/widgets/card/doctor_card.dart` | 78-109 | Inline `Container(grey100)` + `CachedNetworkImage` + `Icon(person)` | 5 menit |
| 2 | `lib/widgets/card/doctor_card_detail.dart` | 46-65 | Inline `CachedNetworkImage` + `CircularProgressIndicator` + `Icon(person)` | 5 menit |
| 3 | `lib/widgets/card/appointment_card.dart` | 65-84 | Inline `CachedNetworkImage` + `CircularProgressIndicator` + `Icon(person)` | 5 menit |
| 4 | `lib/widgets/card/upcoming_appointment_card.dart` | 139-158 | `_DoctorAvatar` inline `CachedNetworkImage` + `CircularProgressIndicator` + `Icon(AppIcons.user)` | 5 menit |
| 5 | `lib/features/booking/presentation/page/booking_detail_page.dart` | 153-171 | Inline `CachedNetworkImage` + `CircularProgressIndicator` + `Icon(person)` | 5 menit |
| 6 | `lib/widgets/shared/profile_avatar.dart` | 27-36 | Inline `CachedNetworkImage` + `SizedBox.shrink()` placeholder | 5 menit |
| 7 | `lib/widgets/card/banner_card.dart` | 53-58 | Inline `CachedNetworkImage` + `SizedBox.shrink()` placeholder + `SizedBox.shrink()` error | 5 menit |
| 8 | `lib/features/profile/presentation/page/profile_page.dart` | 130-137 | Inline `CachedNetworkImage` + `_avatarPlaceholder()` both for placeholder & error | 5 menit |

### Kategori B: Avatar Fallback → `AvatarInitials`

| # | File | Line | Saat Ini | Estimasi |
|---|------|------|----------|----------|
| 9 | `lib/widgets/shared/profile_avatar.dart` | 40-58 | Private `_buildFallback()` — Container + inisial | 5 menit |
| 10 | `lib/features/profile/presentation/page/profile_page.dart` | 159-170 | Private `_avatarPlaceholder()` — inisial fullName | 5 menit |
| 11 | `lib/widgets/picker/app_image_picker.dart` | 159-183 | Private class `_Placeholder` — circular icon | 5 menit |

### Kategori C: Private Skeleton Classes → Skeletonizer + Production Widget

| # | File | Widget | Estimasi |
|---|------|--------|----------|
| 12 | `lib/features/profile/presentation/page/profile_page.dart:242` | `_ProfileSkeleton` — reuse profile card with mock data | 10 menit |
| 13 | `lib/features/profile/presentation/page/favorite_page.dart:109` | `_FavSkeleton` — reuse DoctorCard skeleton | 10 menit |
| 14 | `lib/features/profile/presentation/page/notification_page.dart:194` | `_NotificationSkeleton` — reuse notification card | 10 menit |
| 15 | `lib/features/profile/presentation/page/edit_profile_page.dart:284` | `_EditSkeleton` — reuse edit form | 10 menit |
| 16 | `lib/features/booking/presentation/page/booking_history_page.dart:163` | `_ListSkeleton` — reuse booking card | 10 menit |
| 17 | `lib/features/booking/presentation/page/booking_detail_page.dart:338` | `_DetailSkeleton` — reuse detail card | 10 menit |

### Kategori D: Hardcoded Colors → AppTheme

| # | File | Line | Saat Ini | Estimasi |
|---|------|------|----------|----------|
| 18 | `lib/widgets/loader/dot_loader.dart` | 9 | Default color `Color(0xFF2D2D2D)` — pindahkan ke AppTheme | 5 menit |
| 19 | `lib/widgets/dialog/app_loading_dialog.dart` | 54 | `Color(0xFF1F2A37)` — ganti ke `AppTheme.grey800` | 5 menit |

---

## 3. Pola Standar yang Dipakai

### AppNetworkImage

```dart
AppNetworkImage(
  imageUrl: doctor.photoUrl,
  width: 72,
  height: 72,
  borderRadius: 12,
  iconData: Icons.person,
  iconSize: 28,
)
```

### AvatarInitials

```dart
AvatarInitials(
  name: user.fullName,
  size: 80,
)
```

---

## 4. Verifikasi

| # | Item | Status |
|---|------|--------|
| 1 | `flutter analyze` — 0 issues | ⬜ |
| 2 | Semua card masih tampil dengan placeholder/error yang benar | ⬜ |
| 3 | AppNetworkImage — placeholder menampilkan spinner saat loading | ⬜ |
| 4 | AppNetworkImage — error menampilkan icon fallback | ⬜ |
| 5 | AppNetworkImage — null URL menampilkan icon fallback (tidak crash) | ⬜ |
| 6 | AvatarInitials — menampilkan inisial yang benar | ⬜ |
| 7 | AvatarInitials — fallback `?` untuk nama kosong | ⬜ |
| 8 | Semua skeleton classes dihapus — tidak ada widget `_XxxSkeleton` tersisa | ⬜ |
| 9 | DotLoader default color dari AppTheme | ⬜ |
| 10 | `grep "#[0-9A-Fa-f]\{6\}\|#[0-9A-Fa-f]\{8\}" lib/` — 0 hardcoded hex di placeholder widgets | ⬜ |

---

## 5. Total Estimasi

| Kategori | Item | Estimasi |
|----------|------|----------|
| Widget baru | 2 file | ~35 menit |
| Migrasi CachedNetworkImage | 8 file | ~40 menit |
| Migrasi avatar fallback | 3 file | ~15 menit |
| Hapus skeleton classes | 6 file | ~60 menit |
| Hardcoded colors | 2 file | ~10 menit |
| **Total** | **~21 file** | **~2,5 jam** |

---

*Dibuat: 27 Juni 2026 · Referensi: ADR-008*