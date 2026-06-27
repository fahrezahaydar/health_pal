# Standarisasi Placeholder Widget — Todo List

**Tanggal:** 27 Juni 2026
**Referensi:** ADR-008
**Progress:** ✅ 20/21 item selesai

---

## 1. Widget Baru yang Harus Dibuat

| # | Widget | Status |
|---|--------|--------|
| 1 | `AppNetworkImage` — wrapper `CachedNetworkImage` + placeholder + error + null fallback | ✅ |
| 2 | `AvatarInitials` — avatar fallback dengan inisial user | ✅ |

---

## 2. File yang Perlu Dimigrasi

### Kategori A: CachedNetworkImage → `AppNetworkImage`

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

### Kategori B: Avatar Fallback → `AvatarInitials`

| # | File | Status |
|---|------|--------|
| 9 | `lib/widgets/shared/profile_avatar.dart` | ✅ |
| 10 | `lib/features/profile/presentation/page/profile_page.dart` | ✅ |
| 11 | `lib/widgets/picker/app_image_picker.dart` | ⏸️ Skip — custom offset animation |

### Kategori C: Private Skeleton Classes → Skeletonizer + Inline Content

| # | File | Old Widget | New Widget | Status |
|---|------|------------|------------|--------|
| 12 | `lib/features/profile/presentation/page/profile_page.dart` | `_ProfileSkeleton` | `_ProfileSkeletonContent` | ✅ |
| 13 | `lib/features/profile/presentation/page/favorite_page.dart` | `_FavSkeleton` | `_FavSkeletonContent` (uses DoctorCard) | ✅ |
| 14 | `lib/features/profile/presentation/page/notification_page.dart` | `_NotificationSkeleton` | `_NotificationSkeletonContent` | ✅ |
| 15 | `lib/features/profile/presentation/page/edit_profile_page.dart` | `_EditSkeleton` | `_EditSkeletonContent` | ✅ |
| 16 | `lib/features/booking/presentation/page/booking_history_page.dart` | `_ListSkeleton` | `_ListSkeletonContent` | ✅ |
| 17 | `lib/features/booking/presentation/page/booking_detail_page.dart` | `_DetailSkeleton` | `_DetailSkeletonContent` | ✅ |

### Kategori D: Hardcoded Colors → AppTheme

| # | File | Status |
|---|------|--------|
| 18 | `lib/widgets/loader/dot_loader.dart` | ✅ |
| 19 | `lib/widgets/dialog/app_loading_dialog.dart` | ✅ |

---

## 3. Verifikasi

| # | Item | Status |
|---|------|--------|
| 1 | `flutter analyze` — 0 issues | ✅ |
| 2 | Semua `_XxxSkeleton` class dihapus | ✅ |
| 3 | Semua skeleton pakai `Skeletonizer` + inline content (no dedicated skeleton files) | ✅ |
| 4 | Hardcoded hex colors `#XXXXXXXX` di placeholder widgets = 0 | ✅ |
| 5 | `grep "CircleAvatar\|_XxxSkeleton\b" lib/` — hanya CircleAvatar di skeleton content | ✅ |

---

*Dibuat: 27 Juni 2026 · Referensi: ADR-008*