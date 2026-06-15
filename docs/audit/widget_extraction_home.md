# Widget Extraction Audit — Project-Wide Tracker

**Last Updated:** 2026-06-16
**Scope:** All `lib/features/*/`

---

## Master Progress

| Feature | Audit Status | Extraction Status | Candidates | Extracted |
|---------|-------------|-------------------|-----------|-----------|
| home | Completed | Partial | 3 | 3 |
| auth | Completed | Completed | 1 (utility) | 1 (→ `Validators.email()`) |
| booking | Pending | Not Started | — | — |
| doctor | Completed | Completed | 3 | 3 |
| loc | Completed | Completed | 1 | 0 (rejected — too trivial; switched to DotLoader instead) |
| onboarding | Completed | Completed | 0 | — |
| profile | Completed | Completed | 4 | 4 |
| settings | Completed | Completed | 7 | 7 (5 extract + 2 replace) |

---

## Feature Details

### home

**Audit Date:** 2026-06-16

#### Candidates

| Widget | Source File | Proposed Destination | Confidence | Reason |
|--------|-----------|---------------------|-----------|--------|
| `_DotsIndicator` | `banner_carousel.dart` | `widgets/indicators` | High | Generic carousel indicator, pure UI, no feature dependency |
| `_ProfileAvatar` | `greeting_section.dart` | `widgets/shared` | Medium | Generic circular avatar with fallback initials, no entity dependency |
| `_InfoRow` | `upcoming_card.dart` | `widgets/shared` | High | Generic icon+text row, pure UI, no feature dependency |

#### Skipped (feature-specific)

| Widget | Source | Reason |
|--------|--------|--------|
| `_BannerCard` | `banner_carousel.dart` | References `BannerEntity` |
| `_NearbyCard` | `nearby_facilities.dart` | References `ClinicEntity` |
| `_CategoryItem` | `quick_categories.dart` | References `SpecializationEntity`, contains navigation |
| `_AppointmentCard` | `upcoming_card.dart` | References `UpcomingAppointmentEntity`, contains navigation |
| `_EmptyState` | `upcoming_card.dart` | Contains feature-specific navigation to doctor search |
