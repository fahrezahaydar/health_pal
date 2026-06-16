# Audit — Card Extraction Progress

You are the Flutter Tech Lead of **health_pal**. You have decided to extract all reusable card widgets from `lib/features/*/presentation/` into `lib/widgets/card/`, decoupled from their domain entities using the `fromEntity()` + `skeleton()` factory pattern — as already demonstrated in `lib/widgets/card/banner_card.dart`.

Add This file is your docs. Read it at the start of every session, update it after every change, and never modify code without recording it here.

---

## Your Tasks

1. Read this file top to bottom before doing anything
2. Pick the next feature with status `NOT_SCANNED` or `PARTIAL`
3. Scan all files under `lib/features/<feature>/presentation/`
4. For each private widget (`_`) found — decide: extract or skip
5. Extract following `CARD_EXTRACTION.md`, using `lib/widgets/card/banner_card.dart` as reference
6. Update this file after each change
7. Update Summary Counter at the bottom

---

## Legend

| Status | Arti |
|---|---|
| ⬜ `NOT_SCANNED` | Belum di-scan |
| 🔍 `SCANNING` | Sedang diproses |
| ✅ `DONE` | Selesai semua |
| ⚠️ `PARTIAL` | Sebagian selesai |
| ⏭️ `SKIPPED` | Tidak ada yang perlu diekstrak |

---

## Feature Scan Progress

| Feature | Status | Scanned At | Notes |
|---|---|---|---|
| `home` | ✅ `DONE` | 2026-06-16 | BannerCard ✅, UpcomingAppointmentCard ✅, NearbyClinicCard ✅. Semua widget di-scan. `_AppointmentCard` diekstrak, `_NearbyCard`+`_PlaceholderImage` diekstrak, `_HeaderTitle` replacement via shared `HeaderTitle` widget. Sisanya di-skip. |
| `profile` | ⏭️ `SKIPPED` | 2026-06-16 | Tidak ada private widget cards. `NotificationCard` sudah public. |
| `auth` | ⏭️ `SKIPPED` | 2026-06-16 | Tidak ada private widget cards. Semua widget adalah page-level state. |
| `doctor` | ⏭️ `SKIPPED` | 2026-06-16 | `DoctorCardDetail`, `DoctorFilterChip`, `SlotAvailabilityText` sudah public. Tidak ada private widgets. |
| `booking` | ⏭️ `SKIPPED` | 2026-06-16 | `AppointmentCard`, `BookingSummaryCard`, `StatusTimeline` sudah public. `_TimelineItem`/`_TimelineEntry` di-skip (spesifik booking timeline). |
| `loc` | ⏭️ `SKIPPED` | 2026-06-16 | `ClinicCard` sudah public. `_LocView`/`_LoadingView` di-skip (page-level). |
| `settings` | ⏭️ `SKIPPED` | 2026-06-16 | Tidak ada private widget cards. |
| `onboarding` | ⏭️ `SKIPPED` | 2026-06-16 | Tidak ada private widget cards. |

---

## Card Extraction Log

### ✅ Extracted

| Widget Lama | File Asal | Widget Baru | File Tujuan | Entity Decoupled | fromEntity() | skeleton() | Exported |
|---|---|---|---|---|---|---|---|
| `_BannerCard` | `lib/features/home/presentation/widgets/banner_carousel.dart` | `BannerCard` | `lib/widgets/card/banner_card.dart` | ✅ | ✅ | ✅ | ✅ |
| `_AppointmentCard` | `lib/features/home/presentation/widget/upcoming_card.dart` | `UpcomingAppointmentCard` | `lib/widgets/card/upcoming_appointment_card.dart` | ✅ | ✅ | ✅ | ✅ |
| `_NearbyCard` | `lib/features/home/presentation/widget/nearby_facilities.dart` | `NearbyClinicCard` | `lib/widgets/card/nearby_clinic_card.dart` | ✅ | ✅ | ✅ | ✅ |
| `_CategoryItem` | `lib/features/home/presentation/widget/quick_categories.dart` | `CategoryCard` | `lib/widgets/card/category_card.dart` | ✅ | ✅ | ✅ | ✅ |

### ⏳ Legacy (extracted before this audit, no fromEntity/skeleton)

| Widget | File Tujuan | Entity Decoupled | fromEntity() | skeleton() | Notes |
|---|---|---|---|---|---|
| `DoctorCard` | `lib/widgets/card/doctor_card.dart` | ✅ (constructor params) | ❌ | ❌ | Legacy — tidak pakai pattern baru. Jangan diubah. |
| `StatusBadge` | `lib/widgets/card/status_badge.dart` | ✅ (BookingStatus enum) | ❌ | ❌ | Legacy — tidak pakai pattern baru. Jangan diubah. |

<details>
<summary>Lihat contoh hasil ekstraksi: <code>_BannerCard</code> → <code>BannerCard</code></summary>

```dart
// lib/widgets/card/banner_card.dart

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, this.url, this.imageUrl, required this.title});

  final String? url;
  final String? imageUrl;
  final String title;

  factory BannerCard.fromEntity(BannerEntity entity) => BannerCard(
        url: entity.actionUrl,
        imageUrl: entity.imageUrl,
        title: entity.title,
      );

  factory BannerCard.skeleton() =>
      const BannerCard(url: null, imageUrl: null, title: 'Loading...');

  @override
  Widget build(BuildContext context) { ... }
}
```

Usage di file asal:
```dart
itemBuilder: (context, index) => isLoading
    ? BannerCard.skeleton()
    : BannerCard.fromEntity(banners[index]),
```
</details>

---

### ⏭️ Skipped

| Widget | File | Alasan |
|---|---|---|
| `_BannerCarouselState` | `lib/features/home/presentation/widget/banner_carousel.dart` | Stateful orchestrator, spesifik home |
| `_EmptyState` | `lib/features/home/presentation/widget/upcoming_card.dart` | Spesifik upcoming — icon + text + CTA ke doctor search |
| `_StatusBody` | `lib/features/home/presentation/widget/nearby_facilities.dart` | Spesifik nearby — bound ke NearbyCubit |
| `_TimelineItem` | `lib/features/booking/presentation/widget/status_timeline.dart` | Spesifik booking timeline visual |
| `_TimelineEntry` | `lib/features/booking/presentation/widget/status_timeline.dart` | Model class, bukan widget |
| `_LoadingView` | `lib/features/loc/presentation/page/loc_page.dart` | Page-level, spesifik loc |

---

### 🔍 Candidates (belum diekstrak)

| Widget | File | Alasan Kandidat | Priority |
|---|---|---|---|
| — | — | — | — |

> Pindahkan ke tabel Extracted setelah selesai diekstrak.

---

## Barrel Export

| File | Status | Last Updated |
|---|---|---|
| `lib/widgets/widgets.dart` | ✅ Up to date | — |

---

## Scan Notes

```
[2026-06-16] — Full codebase scan
- home: scanned 7 widget files. Extracted _AppointmentCard → UpcomingAppointmentCard,
  _NearbyCard → NearbyClinicCard, _CategoryItem → CategoryCard.
  _HeaderTitle → shared HeaderTitle widget.
- profile: scanned 5 files. No private card widgets.
- auth: scanned 4 files. No private card widgets.
- doctor: scanned 5 files. All widgets already public.
- booking: scanned 7 files. AppointmentCard/BookingSummaryCard/StatusTimeline already public.
- loc: scanned 2 files. ClinicCard already public.
- settings: scanned 4 files. No private card widgets.
- onboarding: scanned 1 file. No private card widgets.
- Legacy DoctorCard & StatusBadge recorded as pre-existing extractions (no fromEntity/skeleton).
- banner_carousel.dart: replaced _BannerCard usage with BannerCard.fromEntity()
```

---

## Summary

| Metric | Count |
|---|---|
| Total fitur | 8 |
| DONE | 1 |
| PARTIAL | 0 |
| SKIPPED (no private widgets) | 6 |
| NOT_SCANNED | 0 |
| Card diekstrak (baru) | 4 |
| Card diekstrak (legacy) | 2 |
| Widget di-skip | 6 |
| Kandidat menunggu | 0 |
