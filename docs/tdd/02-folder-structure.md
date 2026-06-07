# Technical Design Document — Bagian 2: Folder Structure

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Acuan** | TDD Bagian 1 — Arsitektur |

---

## Daftar Isi

1. [Pohon Folder Lengkap](#1-pohon-folder-lengkap)
2. [Penjelasan per Folder](#2-penjelasan-per-folder)
3. [Migrasi dari Struktur Saat Ini](#3-migrasi-dari-struktur-saat-ini)
4. [Aturan Penamaan](#4-aturan-penamaan)
5. [File Boundary Rules](#5-file-boundary-rules)

---

## 1. Pohon Folder Lengkap

```
lib/
├── main.dart                              # Entry point
│
├── core/                                   # Shared cross-cutting concerns
│   ├── di/
│   │   ├── locator.dart                   # configureDependencies()
│   │   ├── register_module.dart           # SharedPreferences module
│   │   └── locator.config.dart            # 🔹 Generated (injectable)
│   │
│   ├── enums/
│   │   ├── app_status.dart                # loading, onboarding, unauthenticated, authenticated
│   │   ├── gender.dart                    # male, female, notSpecified
│   │   ├── booking_status.dart            # pending, upcoming, completed, cancelled
│   │   └── failure_code.dart              # networkError, unauthorized, notFound, conflict, ...
│   │
│   ├── network/
│   │   ├── api_exception.dart             # ApiException class
│   │   ├── error_handler.dart             # mapToFailure()
│   │   ├── result.dart                    # sealed class Success / Failure
│   │   └── supabase_client.dart           # SupabaseClient singleton provider
│   │
│   ├── router/
│   │   ├── app_router.dart                # GoRouter + routes + redirect
│   │   └── route_names.dart               # Konstanta string route paths
│   │
│   ├── services/
│   │   ├── app_services.dart              # ChangeNotifier: AppStatus lifecycle
│   │   └── shared_prefs.dart              # SharedPrefService wrapper
│   │
│   ├── theme/
│   │   ├── app_theme.dart                 # Warna, spacing, radius
│   │   └── app_text_theme.dart            # Google Fonts (Inter + Poppins)
│   │
│   └── utils/
│       ├── debouncer.dart                 # Debounce untuk search input
│       ├── validators.dart                # Email, password, phone validators
│       └── date_formatter.dart            # Tanggal ke format "15 Jun 2026"
│
├── widgets/                                # Shared reusable widgets (non-feature-specific)
│   ├── button/
│   │   ├── primary_button.dart            # LightFilledButton
│   │   └── outline_button.dart            # LightOutlineButton
│   │
│   ├── card/
│   │   └── doctor_card.dart               # DoctorCard (dipakai di Loc, Search, Favorite)
│   │
│   ├── dialog/
│   │   ├── app_success_dialog.dart        # AppCustomDialog (success/error/warning/info)
│   │   ├── app_loading_dialog.dart        # AppLoadingDialog (dot loader)
│   │   └── app_confirm_dialog.dart        # Konfirmasi: "Yakin ingin ...?"
│   │
│   ├── form/
│   │   ├── app_form.dart                  # AppForm state management
│   │   ├── app_form_field.dart            # AppTextFormField
│   │   ├── app_form_pin_field.dart        # AppFormPinField (OTP)
│   │   └── app_dropdown_field.dart        # AppDropdownFormField
│   │
│   ├── input/
│   │   ├── app_input_field.dart           # AppInputField (low-level)
│   │   ├── app_pin_field.dart             # AppPinField (low-level OTP)
│   │   ├── app_date_picker_field.dart     # AppDatePickerField
│   │   └── drop_down_button.dart          # AppDropdownButton
│   │
│   ├── loader/
│   │   └── dot_loader.dart                # DotLoader (animasi)
│   │
│   ├── picker/
│   │   └── app_image_picker.dart          # AppPhotoPicker
│   │
│   └── app_shell.dart                     # AppShell (BottomNavigationBar + StatefulShellRoute)
│
├── features/
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── onboarding_notifier.dart    # ChangeNotifier
│   │       └── page/
│   │           └── onboarding_page.dart        # 3 slide PageView
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   ├── auth_remote_datasource.dart      # Supabase Auth API
│   │   │   │   └── auth_local_datasource.dart       # SharedPreferences cache
│   │   │   ├── model/
│   │   │   │   ├── user_model.dart                  # UserModel (json <-> Entity)
│   │   │   │   └── login_response_model.dart         # Response mapper
│   │   │   └── repository/
│   │   │       └── auth_repository_impl.dart        # Implements AuthRepository
│   │   │
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── user_entity.dart                 # UserEntity (Equatable)
│   │   │   ├── repository/
│   │   │   │   └── auth_repository.dart             # abstract class AuthRepository
│   │   │   └── usecase/
│   │   │       ├── login_with_email_usecase.dart
│   │   │       ├── sign_up_usecase.dart
│   │   │       ├── forgot_password_usecase.dart
│   │   │       └── create_profile_usecase.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── sign_in/
│   │       │   │   ├── sign_in_bloc.dart
│   │       │   │   ├── sign_in_event.dart
│   │       │   │   └── sign_in_state.dart
│   │       │   ├── sign_up/
│   │       │   │   ├── sign_up_bloc.dart
│   │       │   │   ├── sign_up_event.dart
│   │       │   │   └── sign_up_state.dart
│   │       │   ├── forgot_password/
│   │       │   │   └── forgot_password_cubit.dart   # ✅ Existing
│   │       │   └── create_profile/
│   │       │       ├── create_profile_cubit.dart
│   │       │       └── create_profile_state.dart
│   │       │
│   │       └── page/
│   │           ├── sign_in_page.dart                # ✅ Existing (rename)
│   │           ├── sign_up_page.dart                # ✅ Existing
│   │           ├── create_profile_page.dart         # ✅ Existing
│   │           └── forgot_password_page.dart        # ✅ Existing
│   │
│   ├── home/
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   ├── banner_datasource.dart
│   │   │   │   └── upcoming_datasource.dart
│   │   │   ├── model/
│   │   │   │   ├── banner_model.dart
│   │   │   │   └── upcoming_appointment_model.dart
│   │   │   └── repository/
│   │   │       └── home_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   ├── banner_entity.dart
│   │   │   │   └── upcoming_appointment_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── home_repository.dart
│   │   │   └── usecase/
│   │   │       ├── get_banners_usecase.dart
│   │   │       ├── get_upcoming_usecase.dart
│   │   │       └── get_specializations_usecase.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── home_cubit.dart
│   │       ├── page/
│   │       │   └── home_page.dart                   # 🔧 Rebuild
│   │       └── widget/
│   │           ├── greeting_section.dart
│   │           ├── banner_carousel.dart
│   │           ├── upcoming_card.dart
│   │           └── quick_categories.dart
│   │
│   ├── doctor/
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── doctor_datasource.dart
│   │   │   ├── model/
│   │   │   │   ├── doctor_model.dart
│   │   │   │   ├── doctor_slot_model.dart
│   │   │   │   └── specialization_model.dart
│   │   │   └── repository/
│   │   │       └── doctor_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   ├── doctor_entity.dart
│   │   │   │   ├── doctor_slot_entity.dart
│   │   │   │   └── specialization_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── doctor_repository.dart
│   │   │   └── usecase/
│   │   │       ├── search_doctors_usecase.dart
│   │   │       ├── get_doctor_detail_usecase.dart
│   │   │       ├── get_slots_usecase.dart
│   │   │       └── get_specializations_usecase.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── search/
│   │       │   │   ├── search_cubit.dart
│   │       │   │   └── search_state.dart
│   │       │   ├── detail/
│   │       │   │   ├── doctor_detail_cubit.dart
│   │       │   │   └── doctor_detail_state.dart
│   │       │   └── location/
│   │       │       ├── loc_cubit.dart
│   │       │       └── loc_state.dart
│   │       │
│   │       ├── page/
│   │       │   ├── doctor_search_page.dart
│   │       │   ├── doctor_detail_page.dart
│   │       │   └── loc_page.dart
│   │       │
│   │       └── widget/
│   │           ├── filter_chips.dart
│   │           ├── slot_chips.dart
│   │           ├── review_card.dart
│   │           ├── date_picker_horizontal.dart
│   │           └── doctor_info_card.dart
│   │
│   ├── booking/
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── booking_datasource.dart
│   │   │   ├── model/
│   │   │   │   ├── appointment_model.dart
│   │   │   │   └── create_appointment_response_model.dart
│   │   │   └── repository/
│   │   │       └── booking_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── appointment_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── booking_repository.dart
│   │   │   └── usecase/
│   │   │       ├── create_appointment_usecase.dart
│   │   │       ├── get_booking_history_usecase.dart
│   │   │       ├── get_booking_detail_usecase.dart
│   │   │       └── cancel_appointment_usecase.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── booking/
│   │       │   │   ├── booking_bloc.dart
│   │       │   │   ├── booking_event.dart
│   │       │   │   └── booking_state.dart
│   │       │   ├── history/
│   │       │   │   ├── booking_history_cubit.dart
│   │       │   │   └── booking_history_state.dart
│   │       │   └── detail/
│   │       │       ├── booking_detail_cubit.dart
│   │       │       └── booking_detail_state.dart
│   │       │
│   │       ├── page/
│   │       │   ├── book_appointment_page.dart
│   │       │   ├── booking_success_page.dart
│   │       │   ├── booking_history_page.dart
│   │       │   └── booking_detail_page.dart
│   │       │
│   │       └── widget/
│   │           ├── appointment_card.dart
│   │           ├── status_badge.dart
│   │           ├── booking_summary_card.dart
│   │           ├── confirmation_bottom_sheet.dart
│   │           └── status_timeline.dart
│   │
│   └── profile/
│       ├── data/
│       │   ├── datasource/
│       │   │   ├── profile_datasource.dart
│       │   │   └── notification_datasource.dart
│       │   ├── model/
│       │   │   └── profile_model.dart
│       │   └── repository/
│       │       └── profile_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entity/
│       │   │   └── profile_entity.dart
│       │   ├── repository/
│       │   │   └── profile_repository.dart
│       │   └── usecase/
│       │       ├── get_profile_usecase.dart
│       │       ├── update_profile_usecase.dart
│       │       └── upload_avatar_usecase.dart
│       │
│       └── presentation/
│           ├── bloc/
│           │   ├── profile_cubit.dart
│           │   └── edit_profile_cubit.dart
│           │
│           └── page/
│               ├── profile_page.dart
│               ├── edit_profile_page.dart
│               ├── favorite_page.dart
│               ├── notification_page.dart
│               ├── settings_page.dart
│               ├── help_support_page.dart
│               └── terms_page.dart
│
└── preview/                                     # Widget preview (dev only)
    └── date_picker_preview.dart
```

---

## 2. Penjelasan per Folder

### `lib/core/` — Shared Cross-Cutting

| Subfolder | Isi | Dependency Rule |
|---|---|---|
| `di/` | Injectable setup, module registrations | Boleh import semua |
| `enums/` | Enum global (AppStatus, Gender, BookingStatus, FailureCode) | Pure Dart, no Flutter |
| `network/` | ApiException, Result<T>, ErrorHandler, SupabaseClient | Hanya depend ke `enums/` |
| `router/` | GoRouter + route names | Boleh import semua page |
| `services/` | AppServices, SharedPrefService | Hanya depend ke `enums/` |
| `theme/` | AppTheme, AppTextTheme | Pure Flutter, no feature |
| `utils/` | Debouncer, validators, formatter | Pure Dart |

### `lib/widgets/` — Shared Reusable Widgets

**Aturan:**
- Tidak boleh import file dari `features/`
- Boleh import dari `core/theme/`
- Boleh pakai package eksternal (iconsax, google_fonts)
- Setiap widget memiliki minimal satu `const` constructor

### `lib/features/` — Per Fitur

| Subfolder | Isi | Dependency Rule |
|---|---|---|
| `data/datasource/` | Remote + Local data source | Hanya depend ke package eksternal |
| `data/model/` | Model (fromJson/toJson), extends Entity | Hanya depend ke Entity |
| `data/repository/` | Implements domain Repository interface | Depend ke Domain Repository |
| `domain/entity/` | Pure Dart entity (Equatable) | No dependency |
| `domain/repository/` | Abstract class interface | No dependency |
| `domain/usecase/` | UseCase class | Depend ke Repository Interface |
| `presentation/bloc/` | BLoC/Cubit + Event + State | Depend ke UseCase |
| `presentation/page/` | Halaman | Depend ke BLoC |
| `presentation/widget/` | Widget spesifik fitur | Depend ke BLoC |

---

## 3. Migrasi dari Struktur Saat Ini

### 3.1 Kondisi Saat Ini

```
lib/                    →  lib/ (target)
├── core/               →  core/ (sama)
├── domain/auth/        →  features/auth/domain/
├── features/auth/      →  features/auth/presentation/ + data/ + domain/
├── features/home/      →  features/home/presentation/
├── features/onboarding/→  features/onboarding/presentation/
└── widgets/            →  widgets/ (sama)
```

### 3.2 File yang Perlu Dipindah

| File Saat Ini | Tujuan Baru | Catatan |
|---|---|---|
| `lib/domain/auth/entity/user.dart` | `lib/features/auth/domain/entity/user_entity.dart` | Rename ke `user_entity.dart` |
| `lib/features/auth/page/` | `lib/features/auth/presentation/page/` | Pindahkan semua page |
| `lib/features/auth/bloc/` | `lib/features/auth/presentation/bloc/` | Pindahkan semua BLoC |
| `lib/features/home/page/` | `lib/features/home/presentation/page/` | Pindahkan |
| `lib/features/home/bloc/` | `lib/features/home/presentation/bloc/` | Pindahkan |
| `lib/features/onboarding/page/` | `lib/features/onboarding/presentation/page/` | Pindahkan |
| `lib/features/onboarding/bloc/` | `lib/features/onboarding/presentation/bloc/` | Pindahkan |

### 3.3 Tidak Perlu Dipindah

| File | Alasan |
|---|---|
| `lib/core/di/` | Struktur sudah benar |
| `lib/core/enums/` | Struktur sudah benar |
| `lib/core/router/` | Struktur sudah benar |
| `lib/core/services/` | Struktur sudah benar |
| `lib/core/theme/` | Struktur sudah benar |
| `lib/widgets/` | Struktur sudah benar |

### 3.4 File Baru yang Perlu Dibuat

| File | Fitur | Prioritas |
|---|---|---|
| `core/network/result.dart` | Shared | Segera |
| `core/network/error_handler.dart` | Shared | Segera |
| `core/network/api_exception.dart` | Shared | Segera |
| `core/network/supabase_client.dart` | Shared | Sebelum data layer |
| `core/utils/debouncer.dart` | Shared | Sebelum search |
| `core/utils/validators.dart` | Shared | Segera |
| `core/enums/booking_status.dart` | Shared | Sebelum booking |
| `core/enums/failure_code.dart` | Shared | Segera |
| `widgets/card/doctor_card.dart` | Shared | Sebelum search/loc |
| `widgets/dialog/app_confirm_dialog.dart` | Shared | Sebelum cancel flow |
| `widgets/app_shell.dart` | Shared | Sebelum bottom nav |
| `features/auth/data/` | Auth | Sebelum connect API |
| `features/auth/domain/` | Auth | Sebelum connect API |
| `features/doctor/` | Doctor | Fitur inti |
| `features/booking/` | Booking | Fitur inti |
| `features/profile/` | Profile | Setelah auth selesai |
| `features/home/data/` | Home | Setelah auth selesai |
| `features/home/domain/` | Home | Setelah auth selesai |

---

## 4. Aturan Penamaan

### 4.1 File & Folder

| Entitas | Convention | Contoh |
|---|---|---|
| Folder fitur | `snake_case` (1 kata) | `auth/`, `booking/`, `doctor/` |
| Folder layer | `snake_case` | `data/`, `domain/`, `presentation/` |
| File BLoC | `snake_case` | `sign_in_bloc.dart` |
| File Event | `snake_case` | `sign_in_event.dart` |
| File State | `snake_case` | `sign_in_state.dart` |
| File Cubit | `snake_case` | `home_cubit.dart` |
| File Page | `snake_case` | `sign_in_page.dart` |
| File Widget | `snake_case` | `doctor_card.dart` |
| File Model | `snake_case` | `user_model.dart` |
| File Entity | `snake_case` | `user_entity.dart` |
| File UseCase | `snake_case` | `login_usecase.dart` |
| File DataSource | `snake_case` | `auth_remote_datasource.dart` |

### 4.2 Class

| Entitas | Convention | Contoh |
|---|---|---|
| BLoC | `PascalCase + Bloc` | `SignInBloc` |
| Event | `PascalCase` | `SignInSubmitted`, `LoginWithGoogle` |
| State | `PascalCase + State` | `SignInInitial`, `SignInLoading` |
| Cubit | `PascalCase + Cubit` | `HomeCubit` |
| Page | `PascalCase + Page` | `SignInPage` |
| Model | `PascalCase + Model` | `UserModel` |
| Entity | `PascalCase + Entity` | `UserEntity` |
| Repository | `PascalCase + Repository` | `AuthRepository` |
| Repository Impl | `PascalCase + RepositoryImpl` | `AuthRepositoryImpl` |
| DataSource | `PascalCase + DataSource` | `AuthRemoteDataSource` |
| UseCase | `PascalCase + UseCase` | `LoginWithEmailUseCase` |

### 4.3 Route Names

```dart
// lib/core/router/route_names.dart
class RoutePaths {
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const forgotPassword = '/sign-in/forgot-password';
  static const signUp = '/sign-up';
  static const createProfile = '/sign-up/create-profile';
  static const home = '/home';
  static const loc = '/loc';
  static const bookingHistory = '/booking-history';
  static const profile = '/profile';
  static const doctorSearch = '/doctor/search';
  static const doctorDetail = '/doctor/:doctorId';
  static const bookAppointment = '/booking/:doctorId';
  static const bookingSuccess = '/booking/success';
  static const bookingDetail = '/booking-history/:appointmentId';
  static const editProfile = '/profile/edit';
  static const favorite = '/profile/favorite';
  static const notification = '/profile/notification';
  static const settings = '/profile/settings';
  static const help = '/profile/help';
  static const tnc = '/profile/tnc';
  static const noInternet = '/no-internet';
}
```

---

## 5. File Boundary Rules

### 5.1 Apa yang Boleh Import ke Mana

```
core/enums/      → ✅ semua layer
core/network/    → ✅ data layer only
core/theme/      → ✅ presentation + widgets only
core/services/   → ✅ core/router, semua data layer
core/router/     → ✅ main.dart, core/services
core/utils/      → ✅ semua layer

widgets/         → ✅ presentation pages only (bukan data/domain)

features/*/data/ → ✅ core/network, core/enums, features/*/domain/
features/*/domain/ → ✅ core/enums only (pure dart!)
features/*/presentation/ → ✅ features/*/domain, core/theme, widgets/
```

### 5.2 Larangan Ketat

```
🚫 domain/  → import package:flutter
🚫 domain/  → import features/*/data/
🚫 data/    → import features/*/presentation/
🚫 widgets/ → import features/*/
🚫 core/enums/ → import core/network/ (atau layer lain)
```

---

*Dokumen ini adalah living document. Setiap perubahan struktur folder harus di-update di sini sebelum refactoring.*
