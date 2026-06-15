# Widget Extraction Audit — Project-Wide Tracker

**Last Updated:** 2026-06-16
**Scope:** All `lib/features/*/`

---

## Master Progress

| Feature | Audit Status | Extraction Status | Candidates | Extracted |
|---------|-------------|-------------------|-----------|-----------|
| home | Completed | Partial | 3 | 3 |
| auth | Completed | Completed | 1 (utility) | 1 (→ `Validators.email()`) |
| booking | Completed | Completed | 4 | 4 (1 utility + 3 replace) |
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

---

### loc

**Audit Date:** 2026-06-16

#### Candidates

| Widget | Source File | Proposed Destination | Confidence | Reason |
|--------|-----------|---------------------|-----------|--------|
| `_LoadingView` | `loc_page.dart` | `widgets/loader` | Low | Generic centered spinner, trivially simple |

#### Outcome

Rejected — switched to `DotLoader` (existing widget) instead. Kept in-feature.

#### Skipped (feature-specific)

| Widget | Source | Reason |
|--------|--------|--------|
| `ClinicCard` | `clinic_card.dart` | References `ClinicEntity` |
| `_LocView` | `loc_page.dart` | Contains bloc, business logic |
| `_permissionDenied` | `loc_page.dart` | Method, references `LocCubit` |
| `_errorView` | `loc_page.dart` | Method, references `LocCubit` |
| `_emptyState` | `loc_page.dart` | Method, references `LocCubit` |

---

### onboarding

**Audit Date:** 2026-06-16

No `widget/` directory. Page uses only external widgets (`LightFilledButton`, `SmoothPageIndicator`, `AutoSizeText`). No candidates.

---

### profile

**Audit Date:** 2026-06-16

#### Candidates

| Widget / Method | Source File | Proposed Destination | Confidence | Reason |
|----------------|-----------|---------------------|-----------|--------|
| `_Divider` | `profile_page.dart` | `widgets/shared` | Low | Generic themed divider |
| `_menuItem` | `profile_page.dart` | `widgets/shared` | Medium | Generic icon + label + trailing arrow |
| `_field` | `edit_profile_page.dart` | `widgets/form` | Medium | Generic label + TextFormField pair |
| `_dateField` | `edit_profile_page.dart` | `widgets/form` | Low | Date picker field pattern |

#### Outcome

| Extracted To | Widget Name |
|-------------|------------|
| `widgets/shared/app_divider.dart` | `AppDivider` |
| `widgets/shared/menu_item_tile.dart` | `MenuItemTile` |
| `widgets/form/labeled_text_field.dart` | `LabeledTextField` |
| `widgets/form/date_picker_field.dart` | `DatePickerField` |

#### Skipped (feature-specific)

| Widget | Source | Reason |
|--------|--------|--------|
| `NotificationCard` | `notification_card.dart` | References `NotificationEntity` |
| `_EditProfileView` / `_EditProfileViewState` | `edit_profile_page.dart` | Bloc, forms, business logic |
| `_NotificationView` | `notification_page.dart` | Bloc, navigation, mark-read logic |
| `_ProfileView` | `profile_page.dart` | Bloc, logout, navigation |

---

### auth

**Audit Date:** 2026-06-16

#### Candidates

| Candidate | Source Files | Proposed Destination | Confidence | Reason |
|-----------|------------|---------------------|-----------|--------|
| `_isValidEmail` | `login_page.dart`, `sign_up_page.dart`, `forgot_password_page.dart` (×3) | `core/utils/validators.dart` | High | Duplicated email regex validator |

#### Outcome

Replaced all 3 usages with existing `Validators.email()`.

#### Skipped

All pages use existing shared widgets (`AppForm`, `AppTextFormField`, `LightFilledButton`, etc.). No private UI widgets.

---

### settings

**Audit Date:** 2026-06-16

#### Candidates

| Candidate | Source File | Proposed Destination | Confidence | Reason |
|-----------|-----------|---------------------|-----------|--------|
| `_sectionLabel` | `settings_page.dart`, `help_support_page.dart` (×2) | `widgets/shared` | High | Duplicated styled section label |
| `_switchItem` | `settings_page.dart` | `widgets/shared` | Medium | Generic switch row |
| `_card` | `settings_page.dart` | `widgets/layouts` | Medium | Generic white rounded card container |
| `_contactCard` | `help_support_page.dart` | `widgets/shared` | Medium | Generic contact info card |
| `_faqTile` | `help_support_page.dart` | `widgets/shared` | Low | FAQ expansion tile pattern |
| `_Divider` | `settings_page.dart` | — | High | Replace only — already exists as `AppDivider` |
| `_menuItem` | `settings_page.dart` | — | Medium | Replace only — similar to `MenuItemTile` |

#### Outcome

| Extracted To | Widget Name |
|-------------|------------|
| `widgets/shared/section_label.dart` | `SectionLabel` |
| `widgets/shared/switch_tile.dart` | `SwitchTile` |
| `widgets/layouts/card_container.dart` | `CardContainer` |
| `widgets/shared/contact_card.dart` | `ContactCard` |
| `widgets/shared/faq_tile.dart` | `FaqTile` |

Replacements: `_Divider` → `AppDivider`, `_menuItem` → `MenuItemTile`.

#### Skipped (feature-specific)

| Widget | Source | Reason |
|--------|--------|--------|
| `_SettingsView` | `settings_page.dart` | Bloc, business logic |
| `_errorState` | `settings_page.dart` | References `SettingsCubit` |
| `_NoInternetPageState` | `no_internet_page.dart` | Connectivity logic |
| `_launchUrl` | `help_support_page.dart` | Utility, not UI |
| `_TncSection` | `terms_and_conditions_page.dart` | Data class |
| `_sectionBlock` | `terms_and_conditions_page.dart` | Feature-specific layout |

---

### doctor

**Audit Date:** 2026-06-16

#### Candidates

| Candidate | Source File | Proposed Destination | Confidence | Reason |
|-----------|-----------|---------------------|-----------|--------|
| `_InfoRow` | `doctor_detail_page.dart` | `widgets/shared` | High | Generic label:value info row |
| `_buildEmpty` | `doctor_search_page.dart` | `widgets/shared` | Medium | Generic empty state with icon, message, hint, retry |
| `_LoadingView` | `doctor_search_page.dart` | `widgets/loader` | Low | Trivial Center + DotLoader |

#### Outcome

| Extracted To | Widget Name |
|-------------|------------|
| `widgets/shared/label_value_row.dart` | `LabelValueRow` |
| `widgets/shared/empty_state_view.dart` | `EmptyStateView` |
| `widgets/loader/loading_view.dart` | `LoadingView` |

#### Skipped (feature-specific)

| Widget | Source | Reason |
|--------|--------|--------|
| `DoctorCardDetail` | `doctor_card_detail.dart` | References `DoctorEntity` |
| `DoctorFilterChip` | `doctor_filter_chip.dart` | Domain-named public class |
| `SlotAvailabilityText` | `slot_availability_text.dart` | Domain-specific text |
| `DoctorDetailView` / `DoctorDetailViewState` | `doctor_detail_page.dart` | State, business logic |
| `DoctorSearchView` / `DoctorSearchViewState` | `doctor_search_page.dart` | State, business logic |

---

### booking

**Audit Date:** 2026-06-16

#### Candidates

| Candidate | Source Files | Proposed Destination | Confidence | Reason |
|-----------|------------|---------------------|-----------|--------|
| `_formatDate` | 6 files across feature | `core/utils/date_formatter.dart` | High | 6× duplicated Indonesian date formatter |
| `_row` | `booking_summary_card.dart`, `booking_success_page.dart` | — | Medium | Replace — similar to `InfoRow` |
| `_infoRow` | `booking_detail_page.dart` | — | Medium | Replace — similar to `LabelValueRow` |
| `_emptyState` | `booking_history_page.dart` | — | Low | Replace — similar to `EmptyStateView` |

#### Outcome

| Change | Detail |
|--------|--------|
| `_formatDate` (×6) | → `DateFormatter.toShortDate()` / `toShortDateOrDash()` (new methods) |
| `_row` (×2) | → `InfoRow` (enhanced with `iconSize` + `valueColor`) |
| `_infoRow` | → `LabelValueRow` |
| `_emptyState` | → `EmptyStateView` |

#### Skipped (feature-specific)

| Widget | Source | Reason |
|--------|--------|--------|
| `AppointmentCard` | `appointment_card.dart` | References `AppointmentEntity` |
| `BookingSummaryCard` | `booking_summary_card.dart` | Domain-named |
| `StatusTimeline` / `_TimelineItem` | `status_timeline.dart` | References `AppointmentEntity` |
| `BookAppointmentView` / `BookAppointmentViewState` | `book_appointment_page.dart` | State, business logic |
| `_BookingDetailView` | `booking_detail_page.dart` | Bloc, business logic |
| `_BookingHistoryPageState` | `booking_history_page.dart` | State, business logic |
