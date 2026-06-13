# Health Pal — Sprint Progress Report

| Field | Detail |
|---|---|
| **Tanggal** | 13 Juni 2026 |
| **Dibuat oleh** | Claude Code Audit (Tech Lead) |
| **Versi** | v1.0 |
| **Status Sprint** | Sprint 0 (Foundation) selesai, Sprint 1 siap dimulai |
| **Last Commit** | (belum di-commit) — perubahan setup Sprint 1 |

---

## 1. Summary

| Metrik | Nilai |
|---|---|
| Total Features | 8 (Onboarding, Auth, Home, Doctor, Booking, Profile, Loc, Settings) |
| Completed (✅) | 3 (Onboarding, Auth, Home) |
| Partial (🟡) | 4 (Doctor, Booking, Profile, Loc) |
| Not Started (❌) | 1 (Test layer) |
| Overall Progress | **~40%** (foundation + 3 features substantial, 4 stub) |
| flutter analyze | **0 issues** ✅ |
| Test Coverage | **0%** (test/ folder belum ada) |

---

## 2. Feature Progress Table

| Layer | Feature | Status | File Count | Notes |
|-------|---------|--------|------------|-------|
| Presentation | Onboarding | ✅ | 2 files | Full PageView + Notifier, navigation OK |
| Data | Auth | ✅ | 4 files | Remote + Local DataSource, Repository Impl, UserModel |
| Domain | Auth | ✅ | 6 files | UserEntity, AuthRepository, 4 UseCase |
| Presentation | Auth | ✅ | 11 files | 4 BLoC, 4 pages (login/signup/create/forgot), full impl 14-15KB each |
| Data | Home | ✅ | 6 files | Remote + Local DataSource, 4 Models (Banner, Spec, Upcoming, Profile) |
| Domain | Home | ✅ | 9 files | 4 Entities, 1 Repository, 4 UseCase |
| Presentation | Home | ✅ | 11 files | 4 Cubit+State, 1 Page, 4 Widgets, 1 BlocIndex |
| Presentation | Doctor | 🟡 | 2 files | **Stub pages** (385 / 332 bytes), no data/domain/BLoC yet |
| Presentation | Booking | 🟡 | 4 files | **Stub pages** (338-403 bytes), no data/domain/BLoC yet |
| Presentation | Loc | 🟡 | 1 file | **Stub page** (316 bytes), no implementation |
| Presentation | Profile | 🟡 | 4 files | **Stub pages** (316-332 bytes), no implementation |
| Presentation | Settings | 🟡 | 4 files | **Stub pages** (319-349 bytes) — T&C, Help, NoInternet, Settings menu |
| Data | Doctor | ❌ | 0 files | Folder exists, no files |
| Domain | Doctor | ❌ | 0 files | Folder exists, no files |
| Data | Booking | ❌ | 0 files | Folder exists, no files |
| Domain | Booking | ❌ | 0 files | Folder exists, no files |
| Data | Profile | ❌ | 0 files | Folder exists, no files |
| Domain | Profile | ❌ | 0 files | Folder exists, no files |
| Data | Loc | ❌ | 0 files | No folder yet |
| Domain | Loc | ❌ | 0 files | No folder yet |
| — | **Test** | ❌ | 0 files | `test/` folder belum ada |

### Ringkasan per Feature

| Feature | Layer | Status | Implementasi |
|---|---|:---:|---|
| **Onboarding** | Presentation | ✅ | Lengkap |
| **Auth** | All 3 | ✅ | Full Clean Architecture |
| **Home** | All 3 | ✅ | Full Clean Architecture + 4 widget reusable |
| **Doctor** | Presentation | 🟡 | Stub only |
| **Booking** | Presentation | 🟡 | Stub only |
| **Loc** | Presentation | 🟡 | Stub only |
| **Profile** | Presentation | 🟡 | Stub only |
| **Settings** | Presentation | 🟡 | Stub only (acceptable — menu pages) |
| **Test** | All | ❌ | 0 files |

---

## 3. Layer Completeness (per Feature)

### Auth (✅ Full)
| Layer | Done | Partial | Missing | % |
|---|---|---|---|---|
| DataSource | 2 | 0 | 0 | 100% |
| Model | 1 | 0 | 0 | 100% |
| Repository | 1 | 0 | 0 | 100% |
| Entity | 1 | 0 | 0 | 100% |
| UseCase | 4 | 0 | 0 | 100% |
| BLoC/Cubit | 4 | 0 | 0 | 100% |
| Pages | 4 | 0 | 0 | 100% |
| **Total** | **17** | **0** | **0** | **100%** |

### Home (✅ Full)
| Layer | Done | Partial | Missing | % |
|---|---|---|---|---|
| DataSource | 2 | 0 | 0 | 100% |
| Model | 4 | 0 | 0 | 100% |
| Repository | 1 | 0 | 0 | 100% |
| Entity | 4 | 0 | 0 | 100% |
| UseCase | 4 | 0 | 0 | 100% |
| BLoC/Cubit | 5 | 0 | 0 | 100% |
| Pages | 1 | 0 | 0 | 100% |
| Widgets | 4 | 0 | 0 | 100% |
| **Total** | **25** | **0** | **0** | **100%** |

### Onboarding (✅ Complete for scope)
| Layer | Done | Partial | Missing | % |
|---|---|---|---|---|
| Notifier (Cubit) | 1 | 0 | 0 | 100% |
| Pages | 1 | 0 | 0 | 100% |
| **Total** | **2** | **0** | **0** | **100%** |

### Doctor (🟡 Presentation stub only)
| Layer | Done | Partial | Missing | % |
|---|---|---|---|---|
| DataSource | 0 | 0 | 1 | 0% |
| Model | 0 | 0 | 1 | 0% |
| Repository | 0 | 0 | 1 | 0% |
| Entity | 0 | 0 | 1 | 0% |
| UseCase | 0 | 0 | 4 | 0% |
| BLoC/Cubit | 0 | 0 | 3 | 0% |
| Pages | 2 | 0 | 0 | 50% (stub) |
| Widgets | 0 | 0 | 5 | 0% |
| **Total** | **2** | **0** | **16** | **11%** |

### Booking (🟡 Presentation stub only)
| Layer | Done | Partial | Missing | % |
|---|---|---|---|---|
| DataSource | 0 | 0 | 1 | 0% |
| Model | 0 | 0 | 1 | 0% |
| Repository | 0 | 0 | 1 | 0% |
| Entity | 0 | 0 | 1 | 0% |
| UseCase | 0 | 0 | 4 | 0% |
| BLoC/Cubit | 0 | 0 | 3 | 0% |
| Pages | 4 | 0 | 0 | 50% (stub) |
| Widgets | 0 | 0 | 5 | 0% |
| **Total** | **4** | **0** | **16** | **20%** |

### Loc (🟡 Presentation stub only)
| Layer | Done | Partial | Missing | % |
|---|---|---|---|---|
| Pages | 1 | 0 | 0 | 50% (stub) |
| **Total** | **1** | **0** | **~10** | **~10%** |

### Profile (🟡 Presentation stub only)
| Layer | Done | Partial | Missing | % |
|---|---|---|---|---|
| DataSource | 0 | 0 | 1 | 0% |
| Model | 0 | 0 | 1 | 0% |
| Repository | 0 | 0 | 1 | 0% |
| Entity | 0 | 0 | 1 | 0% |
| UseCase | 0 | 0 | 3 | 0% |
| BLoC/Cubit | 0 | 0 | 2 | 0% |
| Pages | 4 | 0 | 0 | 50% (stub) |
| **Total** | **4** | **0** | **~10** | **~20%** |

### Settings (🟡 Presentation stub only — acceptable untuk menu pages)
| Layer | Done | Partial | Missing | % |
|---|---|---|---|---|
| Pages | 4 | 0 | 0 | 80% (stub tapi pattern OK) |
| **Total** | **4** | **0** | **~2** | **~67%** |

### Test Coverage (❌ Not Started)
| Layer | Done | Partial | Missing | % |
|---|---|---|---|---|
| Unit Test | 0 | 0 | ~30 | 0% |
| Widget Test | 0 | 0 | ~15 | 0% |
| Integration Test | 0 | 0 | 3 | 0% |
| **Total** | **0** | **0** | **~48** | **0%** |

---

## 4. Dependencies Status (pubspec.yaml)

| Package | Ada? | Versi | Tipe | Status |
|---|:---:|---|---|:---:|
| flutter_bloc | ✅ | ^9.1.1 | Runtime | OK |
| go_router | ✅ | ^17.2.1 | Runtime | OK |
| injectable | ✅ | ^3.0.0 | Runtime | OK |
| get_it | ✅ | ^9.2.1 | Runtime | OK |
| supabase_flutter | ✅ | ^2.8.4 | Runtime | OK |
| firebase_core | ✅ | ^4.10.0 | Runtime | OK |
| firebase_messaging | ✅ | ^16.3.0 | Runtime | OK |
| freezed_annotation | ✅ | ^3.1.0 | Runtime | OK |
| freezed | ✅ | ^3.2.5 | Dev | OK |
| json_annotation | ✅ | ^4.12.0 | Runtime | OK |
| json_serializable | ✅ | ^6.14.0 | Dev | OK |
| build_runner | ✅ | ^2.15.0 | Dev | OK |
| mocktail | ✅ | ^1.0.4 | Dev | OK |
| injectable_generator | ✅ | ^3.0.2 | Dev | OK |
| flutter_lints | ✅ | ^6.0.0 | Dev | OK |
| equatable | ✅ | ^2.0.8 | Runtime | OK |
| connectivity_plus | ✅ | ^7.1.1 | Runtime | OK |
| flutter_dotenv | ✅ | ^6.0.1 | Runtime | OK |
| geolocator | ✅ | ^14.0.3 | Runtime | OK |
| image_picker | ✅ | ^1.2.2 | Runtime | OK |
| google_fonts | ✅ | ^8.0.2 | Runtime | OK |
| shared_preferences | ✅ | ^2.5.5 | Runtime | OK |
| flutter_native_splash | ✅ | ^2.4.7 | Dev | OK |
| iconsax_latest | ✅ | ^1.0.0 | Runtime | OK |
| shimmer | ✅ | ^3.0.0 | Runtime | OK |
| smooth_page_indicator | ✅ | ^2.0.1 | Runtime | OK |
| cached_network_image | ✅ | ^3.4.1 | Runtime | OK |
| provider | ✅ | ^6.1.5+1 | Runtime | OK |
| bloc | ✅ | ^9.2.0 | Runtime | OK |
| flutter_auto_size_text | ✅ | ^5.0.0 | Runtime | OK |
| lottie | ✅ | ^3.3.1 | Runtime | OK |
| url_launcher | ❌ | — | Runtime | NOT FOUND — perlu ditambah untuk "Lihat Peta" external link |
| intl | ❌ | — | Runtime | NOT FOUND — perlu ditambah untuk date formatting |
| hive / isar | ❌ | — | Runtime | NOT FOUND — perlu ditambah untuk offline cache (v2) |

---

## 5. Build & Test Status

### flutter analyze
```
Analyzing health_pal...
No issues found! (ran in 5.2s)
```
✅ **PASS — 0 warnings, 0 errors**

### flutter test --coverage
```
Test directory "test" not found.
```
❌ **FAIL — test/ folder belum ada. Belum ada unit/widget/integration test.**

### dart run build_runner build
```
✓ Built with build_runner (1 output written in 31s)
```
✅ **PASS** — `lib/core/di/locator.config.dart` ter-generate (7648 bytes)

### flutter pub get
```
✓ Got dependencies! (20 packages upgraded)
```
✅ **PASS** — semua deps ter-resolve

---

## 6. File Tree (lib/)

```
lib/
├── core/                                  (8 subdirs, ✅ complete)
│   ├── constants/
│   │   └── app_constants.dart            (254 B)
│   ├── di/                                (DI: injectable + get_it)
│   │   ├── locator.dart                   (239 B)
│   │   ├── locator.config.dart            (7648 B — generated)
│   │   └── register_module.dart           (376 B)
│   ├── enums/                             (4 enums)
│   │   ├── app_status.dart                (84 B)
│   │   ├── booking_status.dart            (72 B)
│   │   ├── failure_code.dart             (174 B)
│   │   └── gender.dart                    (144 B) — male, female, other
│   ├── network/                           (HTTP/Error handling)
│   │   ├── api_exception.dart            (387 B)
│   │   ├── error_handler.dart            (1470 B)
│   │   └── result.dart                   (483 B)
│   ├── router/                            (GoRouter + StatefulShellRoute)
│   │   ├── app_router.dart               (8157 B — full)
│   │   └── route_paths.dart              (1089 B)
│   ├── services/                          (3 services)
│   │   ├── app_services.dart             (2254 B)
│   │   ├── cache_service.dart            (901 B)
│   │   ├── fcm_service.dart              (822 B)
│   │   └── shared_prefs.dart             (1156 B)
│   ├── theme/                             (Theme)
│   │   ├── app_text_theme.dart           (1903 B)
│   │   └── app_theme.dart                (1511 B)
│   └── utils/                             (3 utils)
│       ├── date_formatter.dart           (926 B)
│       ├── debouncer.dart                (255 B)
│       └── validators.dart               (1133 B)
│
├── features/                              (8 features)
│   ├── onboarding/                        (Presentation only — ✅ complete)
│   │   └── presentation/
│   │       ├── bloc/onboarding_notifier.dart  (1143 B)
│   │       └── page/onboarding_page.dart      (5486 B)
│   │
│   ├── auth/                              (All 3 layers — ✅ complete)
│   │   ├── data/
│   │   │   ├── datasource/                (2 files)
│   │   │   │   ├── auth_local_datasource.dart   (734 B)
│   │   │   │   └── auth_remote_datasource.dart  (2648 B)
│   │   │   ├── model/user_model.dart      (2142 B)
│   │   │   └── repository/auth_repository_impl.dart  (4887 B)
│   │   ├── domain/
│   │   │   ├── entity/user_entity.dart    (1421 B)
│   │   │   ├── repository/auth_repository.dart  (650 B)
│   │   │   └── usecase/                   (4 UseCase)
│   │   │       ├── create_profile_usecase.dart  (458 B)
│   │   │       ├── forgot_password_usecase.dart (366 B)
│   │   │       ├── login_with_email_usecase.dart (429 B)
│   │   │       └── sign_up_usecase.dart   (413 B)
│   │   └── presentation/
│   │       ├── bloc/                       (4 BLoC)
│   │       │   ├── create_profile/create_profile_cubit.dart  (1629 B)
│   │       │   ├── forget_password/forget_password_state.dart (1774 B)
│   │       │   ├── sign_in/{sign_in_bloc,event,state}.dart
│   │       │   └── sign_up/{sign_up_bloc,event,state}.dart
│   │       └── page/                       (4 full pages)
│   │           ├── create_profile_page.dart   (9957 B)
│   │           ├── forgot_password_page.dart  (13979 B)
│   │           ├── login_page.dart            (14803 B)
│   │           └── sign_up_page.dart          (15004 B)
│   │
│   ├── home/                              (All 3 layers — ✅ complete)
│   │   ├── data/
│   │   │   ├── datasource/                (2 files)
│   │   │   │   ├── home_local_datasource.dart   (2809 B)
│   │   │   │   └── home_remote_datasource.dart  (2035 B)
│   │   │   ├── model/                     (4 Models)
│   │   │   │   ├── banner_model.dart         (1287 B)
│   │   │   │   ├── specialization_model.dart  (924 B)
│   │   │   │   ├── upcoming_appointment_model.dart  (1858 B)
│   │   │   │   └── user_profile_model.dart   (532 B)
│   │   │   └── repository/home_repository_impl.dart  (2356 B)
│   │   ├── domain/
│   │   │   ├── entity/                    (4 Entities)
│   │   │   │   ├── banner_entity.dart          (438 B)
│   │   │   │   ├── specialization_entity.dart  (323 B)
│   │   │   │   ├── upcoming_appointment_entity.dart  (852 B)
│   │   │   │   └── user_profile_entity.dart   (277 B)
│   │   │   ├── repository/home_repository.dart  (527 B)
│   │   │   └── usecase/                   (4 UseCase)
│   │   │       ├── get_banners_usecase.dart          (368 B)
│   │   │       ├── get_specializations_usecase.dart  (414 B)
│   │   │       ├── get_upcoming_appointment_usecase.dart  (446 B)
│   │   │       └── get_user_profile_usecase.dart     (410 B)
│   │   └── presentation/
│   │       ├── bloc/                       (5 Cubit + State)
│   │       │   ├── banner/{banner_cubit,state}.dart
│   │       │   ├── greeting/{greeting_cubit,state}.dart
│   │       │   ├── home_bloc_index.dart
│   │       │   ├── specialization/{specialization_cubit,state}.dart
│   │       │   └── upcoming/{upcoming_cubit,state}.dart
│   │       ├── page/home_page.dart        (3887 B)
│   │       └── widget/                    (4 Widgets)
│   │           ├── banner_carousel.dart   (4239 B)
│   │           ├── greeting_section.dart  (1265 B)
│   │           ├── quick_categories.dart  (4069 B)
│   │           └── upcoming_card.dart     (5546 B)
│   │
│   ├── doctor/                            (Presentation stub only — 🟡)
│   │   └── presentation/
│   │       └── page/
│   │           ├── doctor_detail_page.dart  (385 B — stub)
│   │           └── doctor_search_page.dart  (332 B — stub)
│   │   (data/ & domain/ folders exist but empty)
│   │
│   ├── booking/                           (Presentation stub only — 🟡)
│   │   └── presentation/
│   │       └── page/
│   │           ├── book_appointment_page.dart  (389 B — stub)
│   │           ├── booking_detail_page.dart    (403 B — stub)
│   │           ├── booking_history_page.dart   (338 B — stub)
│   │           └── booking_success_page.dart   (338 B — stub)
│   │   (data/ & domain/ folders exist but empty)
│   │
│   ├── loc/                               (Presentation stub only — 🟡)
│   │   └── presentation/
│   │       └── page/loc_page.dart          (316 B — stub)
│   │
│   ├── profile/                           (Presentation stub only — 🟡)
│   │   └── presentation/
│   │       └── page/
│   │           ├── edit_profile_page.dart  (329 B — stub)
│   │           ├── favorite_page.dart      (319 B — stub)
│   │           ├── notification_page.dart  (332 B — stub)
│   │           └── profile_page.dart       (316 B — stub)
│   │   (data/ & domain/ folders exist but empty)
│   │
│   └── settings/                          (Presentation stub only — 🟡 acceptable)
│       └── presentation/
│           └── page/
│               ├── help_support_page.dart          (331 B — stub)
│               ├── no_internet_page.dart           (326 B — stub)
│               ├── settings_page.dart              (319 B — stub)
│               └── terms_and_conditions_page.dart  (349 B — stub)
│
├── widgets/                               (Shared reusable widgets — ✅ extensive)
│   ├── app_shell.dart                     (1610 B)
│   ├── badge/app_badge.dart               (2019 B)
│   ├── button/                            (3 files)
│   │   ├── light_icon_button.dart         (1598 B)
│   │   ├── outline_button.dart            (2727 B)
│   │   └── primary_button.dart            (3541 B)
│   ├── card/                              (2 files)
│   │   ├── doctor_card.dart               (3335 B)
│   │   └── status_badge.dart              (1545 B)
│   ├── dialog/                            (5 files)
│   │   ├── app_confirm_dialog.dart        (1718 B)
│   │   ├── app_date_picker_dialog.dart    (5432 B)
│   │   ├── app_loading_dialog.dart        (1817 B)
│   │   └── app_succes_dialog.dart         (9086 B)
│   ├── form/                              (4 files)
│   │   ├── app_dropdown_field.dart        (3223 B)
│   │   ├── app_form.dart                  (8048 B)
│   │   ├── app_form_field.dart            (6167 B)
│   │   └── app_form_pin_field.dart        (4351 B)
│   ├── input/                             (5 files)
│   │   ├── app_date_picker_field.dart     (2616 B)
│   │   ├── app_date_picker_form_ifeld.dart  (4179 B) — typo "ifeld"
│   │   ├── app_input_field.dart           (8511 B)
│   │   ├── app_pin_field.dart             (15399 B)
│   │   └── drop_down_button.dart          (7789 B)
│   ├── loader/dot_loader.dart             (2986 B)
│   ├── not_found_page.dart                (953 B)
│   └── picker/app_image_picker.dart      (17461 B)
│
├── preview/                               (Widget preview — dev only)
│   ├── date_picker_preview.dart           (4468 B)
│   └── home/
│       ├── banner_carousel_preview.dart   (2163 B)
│       ├── greeting_section_preview.dart  (1222 B)
│       ├── quick_categories_preview.dart  (1879 B)
│       └── upcoming_card_preview.dart     (1332 B)
│
├── firebase_options.dart                  (2904 B — generated)
└── main.dart                              (1460 B)
```

### File Statistics
| Category | File Count | Total Size |
|---|---:|---:|
| core/ | 22 files | ~26 KB |
| features/auth/ (full impl) | 17 files | ~80 KB |
| features/home/ (full impl) | 25 files | ~50 KB |
| features/onboarding/ | 2 files | ~6 KB |
| features/{doctor,booking,profile,loc,settings}/ (stub) | 15 files | ~5 KB |
| widgets/ | 19 files | ~95 KB |
| preview/ | 5 files | ~11 KB |
| root (main.dart, firebase_options.dart) | 2 files | ~4 KB |
| **TOTAL** | **~107 files** | **~280 KB** |

---

## 7. Rekomendasi Next Action

Berdasarkan audit, urutan pengerjaan Sprint 1:

1. **🔴 (Blokir Sprint 1) Buat test/ folder + initial test setup**
   - Jalankan `dart test --create` atau mkdir manual
   - Buat `test/helpers/mocks.dart` dengan `@GenerateNiceMocks` (per TDD 10)
   - Tambah `test/flutter_test_config.dart` (timezone, locale, kDebugMode)
   - Alasan: TDD 10 §7 merekomendasikan folder ini sejak hari pertama, dan tanpa setup ini Sprint 1 testing akan terhambat

2. **🟡 Sprint 1 Hari 1-2: Implement Doctor Search + Detail (Fase 5 per TDD 12)**
   - Data layer: `DoctorModel`, `ClinicModel`, `SpecializationModel`, `DoctorSlotModel`
   - Domain: 4 Entity + 4 UseCase (search, get_detail, get_slots, get_specializations)
   - Presentation: `SearchCubit`, `DoctorDetailCubit`, `LocCubit`, 2 pages + 5 widgets
   - Impact: tertinggi — fitur core yang dipakai semua user flow

3. **🟡 Sprint 1 Hari 3-4: Implement Booking Flow (Fase 6 per TDD 12)**
   - Data layer: `AppointmentModel` (paling kompleks — 13 fields + 3 nested)
   - Domain: 4 UseCase (create, get_history, get_detail, cancel)
   - Presentation: `BookingBloc` (event-driven), `BookingHistoryCubit`, `BookingDetailCubit`, 4 pages
   - Highlight: Implement SS#10 alignment — `BookingInitialized` event + extra param dari DoctorDetail

4. **🟢 Sprint 1 Hari 5: Polish + minor features**
   - Profile + Settings (mostly menu pages, low complexity)
   - Tambah unit test untuk Auth & Home (priority tinggi)
   - Wireframe enhancement untuk `01-onboarding.md` dan `18-settings.md`

5. **🟢 Sprint 1 Hari 6-7: Push Notification + Polish**
   - Wire up FCM token upsert
   - Notification inbox UI
   - Push notification deep link handler

6. **🔵 Backlog (bukan Sprint 1)**
   - Tambah `url_launcher` ke pubspec untuk "Lihat Peta" external
   - Tambah `intl` ke pubspec untuk date formatting i18n
   - Renaming typo `app_date_picker_form_ifeld.dart` → `app_date_picker_form_field.dart`
   - Tambah Hive/Isar untuk offline cache (v2.0)
   - Setup CI/CD pipeline (GitHub Actions + codecov)

---

## 8. Blocking Issues

| # | Issue | File | Severity | Fix |
|---|---|---|---|:---:|
| 1 | **test/ folder tidak ada** | — | 🔴 High | Buat `test/helpers/mocks.dart` dan initial test scaffolding |
| 2 | **5 feature folders masih stub** (Doctor, Booking, Loc, Profile, Settings) | `lib/features/*/presentation/page/*.dart` | 🟡 Medium | Implement per Sprint 1 plan |
| 3 | **url_launcher missing** (diperlukan untuk "Lihat Peta") | `pubspec.yaml` | 🟡 Medium | Tambah `url_launcher: ^6.x` |
| 4 | **intl missing** (diperlukan untuk date formatting) | `pubspec.yaml` | 🟢 Low | Tambah `intl: ^0.19.0` |
| 5 | **Typo filename** | `lib/widgets/input/app_date_picker_form_ifeld.dart` | 🟢 Low | Rename ke `app_date_picker_form_field.dart` |
| 6 | **Empty stub files** bisa membingungkan developer baru | `lib/features/{doctor,booking,loc,profile,settings}/presentation/page/*.dart` (~316-403 B) | 🟢 Low | Tambah `@todo` header atau hapus sampai Sprint 1 implement |
| 7 | **No version control untuk pubspec.lock conflict** | `pubspec.lock` | 🟢 Low | Verify tracked di git |

---

## 9. Kesiapan Sprint 1

| Aspek | Status | Catatan |
|---|:---:|---|
| Project foundation | ✅ | `flutter analyze` 0 issues, deps lengkap, build_runner OK |
| Folder structure | ✅ | Match TDD 02 §1 |
| DI + Routing | ✅ | `locator.config.dart` ter-generate, GoRouter full |
| Auth feature | ✅ | 17 files, full Clean Architecture |
| Home feature | ✅ | 25 files, full + 4 widget reusable |
| Other features | 🟡 | Stub pages — akan diisi Sprint 1 |
| Test infrastructure | ❌ | `test/` belum ada — blocker Sprint 1 |
| Documentation | ✅ | docs/ audit lengkap, 4 audit files, cto_executive_summary.md |

**Sprint 1 Go/No-Go:** 🟡 **GO WITH CAVEAT** — buat test/ folder dan tambah url_launcher SEBELUM Sprint 1 kick off. Sisanya bisa on-the-fly.

---

## 10. Git Status

| Item | Value |
|---|---|
| Branch | `master` |
| Commits ahead of origin | 3 (`bdcb371`, `7839d9d`, `4e0662a`) |
| Working tree | Modified (uncommitted setup changes: pubspec.yaml, 6 lib files) |
| Last commit | `4e0662a` fix(docs): resolve 3 Tech Lead showstoppers (SS#5, SS#7, SS#10) |

> **Catatan:** Perubahan Sprint 1 setup (pubspec.yaml, button fixes, 7 unused import/print removals) belum di-commit. Disarankan commit terpisah sebelum Sprint 1 kick off:
> `chore(setup): Sprint 1 foundation — fix analyze issues, add freezed/json_serializable`

---

*Generated by Claude Code Audit (Tech Lead persona) · 13 Juni 2026*
