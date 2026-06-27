# Standarisasi Placeholder Widget — Todo List

**Tanggal:** 27 Juni 2026
**Referensi:** ADR-008
**Progress:** ✅ 14/21 item selesai

---

## 1. Widget Baru yang Harus Dibuat ✅

| # | Widget | Status |
|---|--------|--------|
| 1 | `AppNetworkImage` — wrapper `CachedNetworkImage` dengan placeholder + error + null fallback | ✅ |
| 2 | `AvatarInitials` — avatar fallback dengan inisial user | ✅ |

---

## 2. File yang Perlu Dimigrasi

### Kategori A: CachedNetworkImage → `AppNetworkImage` ✅

| # | File | Status |
|---|------|--------|
| 1 | `lib/widgets/card/doctor_card.dart` | ✅ |
| 2 | `lib/widgets/card/doctor_card_detail.dart` | ✅ |
| 3 | `lib/widgets/card/appointment_card.dart` | ✅ |
| 4 | `lib/widgets/card/upcoming_appointment_card.dart` | ✅ |
| 5 | `lib/features/booking/presentation/page/booking_detail_page.dart` | ✅ |
| 6 | `lib/widgets/shared/profile_avatar.dart` | ✅ |
| 7 | `lib/widgets/card/banner_card.dart` | ✅ |
| 8 | `lib/features/profile/presentation/page/profile_page.dart` | ✅ |

### Kategori B: Avatar Fallback → `AvatarInitials` ✅

| # | File | Status |
|---|------|--------|
| 9 | `lib/widgets/shared/profile_avatar.dart` | ✅ |
| 10 | `lib/features/profile/presentation/page/profile_page.dart` | ✅ |
| 11 | `lib/widgets/picker/app_image_picker.dart` | ⏸️ Skip — `_Placeholder` punya custom offset animation, tidak cocok diganti |

### Kategori C: Private Skeleton Classes → Skeletonizer + Production Widget ⏸️

| # | File | Widget | Status |
|---|------|--------|--------|
| 12 | `lib/features/profile/presentation/page/profile_page.dart:242` | `_ProfileSkeleton` | ⏸️ |
| 13 | `lib/features/profile/presentation/page/favorite_page.dart:109` | `_FavSkeleton` | ⏸️ |
| 14 | `lib/features/profile/presentation/page/notification_page.dart:194` | `_NotificationSkeleton` | ⏸️ |
| 15 | `lib/features/profile/presentation/page/edit_profile_page.dart:284` | `_EditSkeleton` | ⏸️ |
| 16 | `lib/features/booking/presentation/page/booking_history_page.dart:163` | `_ListSkeleton` | ⏸️ |
| 17 | `lib/features/booking/presentation/page/booking_detail_page.dart:338` | `_DetailSkeleton` | ⏸️ |

### Kategori D: Hardcoded Colors → AppTheme ✅

| # | File | Status |
|---|------|--------|
| 18 | `lib/widgets/loader/dot_loader.dart` | ✅ |
| 19 | `lib/widgets/dialog/app_loading_dialog.dart` | ✅ |

---

## 3. Verifikasi

| # | Item | Status |
|---|------|--------|
| 1 | `flutter analyze` — 0 issues | ✅ |
| 2 | AppNetworkImage — placeholder menampilkan spinner saat loading | ✅ |
| 3 | AppNetworkImage — error menampilkan icon fallback | ✅ |
| 4 | AppNetworkImage — null URL menampilkan icon fallback (tidak crash) | ✅ |
| 5 | AvatarInitials — menampilkan inisial yang benar | ✅ |
| 6 | DotLoader default color dari AppTheme | ✅ |
| 7 | Semua skeleton classes dihapus — tidak ada widget `_XxxSkeleton` tersisa | ⏸️ (6 remaining) |

---

*Dibuat: 27 Juni 2026 · Referensi: ADR-008*