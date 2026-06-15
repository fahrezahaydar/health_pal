# Health Pal 🏥

> **Platform mobile-first untuk booking dokter yang cepat, terpadu, dan seamless di Indonesia.**
> Cari dokter, lihat slot real-time, buat janji temu dalam < 5 tap — semuanya dalam satu aplikasi.

[![Flutter](https://img.shields.io/badge/Flutter-3.10.4-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.4-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Private-red)]()

---

## 📱 Screenshots

> Placeholder — akan diisi setelah UI final dan device testing selesai.

| Onboarding | Home | Doctor Detail | Booking |
|:---:|:---:|:---:|:---:|
| _TBD_ | _TBD_ | _TBD_ | _TBD_ |

---

## 🚀 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter `^3.10.4` (Dart SDK) |
| **State Management** | `flutter_bloc` + Cubit (event-driven Bloc untuk flow kompleks) |
| **Navigation** | `go_router` dengan `StatefulShellRoute` (bottom nav ter-stateful) |
| **Backend (BaaS)** | Supabase (PostgreSQL + Auth + Storage + Edge Functions) |
| **Push Notification** | Firebase Cloud Messaging (FCM) + Deep Link handler |
| **Dependency Injection** | `injectable` + `get_it` |
| **Code Generation** | `freezed` + `json_serializable` + `injectable_generator` |
| **Location** | `geolocator` (current position) + PostgREST `rpc()` (nearby clinics) |
| **Networking** | `supabase_flutter` (no Dio/http — Supabase adalah sole backend) |
| **Local Cache** | `shared_preferences` + Hive (planned v2) |
| **Utilities** | `flutter_dotenv` (env), `intl` (date format), `connectivity_plus` (offline) |
| **UI Kit** | `google_fonts` + `iconsax_latest` + `skeletonizer` + `lottie` (no Material) |
| **Native Bridge** | `image_picker`, `url_launcher` |

---

## 🏗️ Architecture

Proyek ini mengimplementasikan **Clean Architecture** dengan pemisahan tegas antara layer, ditambah pola **Repository + UseCase** untuk skalabilitas dan testability.

```
lib/
├── core/              # Fondasi cross-cutting (DI, router, theme, services, enums, network, utils)
├── features/          # 7 fitur bisnis — masing-masing independen dengan 3 layer
├── widgets/           # Shared reusable widgets (buttons, dialogs, form fields, loaders, dll)
├── preview/           # Widget previews untuk development (dev-only)
├── firebase_options.dart  # Generated Firebase config
└── main.dart          # Entrypoint (init order: dotenv → Supabase → Firebase → DI → FCM → runApp)
```

### Pola Setiap Feature (Clean Architecture)

```
feature/
├── data/                    # Layer terluar — berbicara dengan dunia luar
│   ├── datasource/          #   • remote (Supabase) + local (SharedPrefs)
│   ├── model/               #   • @freezed + @JsonKey untuk JSON mapping
│   └── repository/          #   • implementasi dari domain/repository
├── domain/                  # Layer paling dalam — pure business logic
│   ├── entity/              #   • pure Dart class (no Flutter, no annotation)
│   ├── repository/          #   • abstract contract
│   └── usecase/             #   • single responsibility per class
└── presentation/            # Layer UI — Flutter widgets
    ├── bloc/                #   • Cubit (default) atau Bloc (event-driven)
    ├── page/                #   • screens (StatefulWidget)
    └── widget/              #   • widget spesifik feature
```

### Prinsip Arsitektur

1. **Dependency Rule:** `presentation` → `domain` ← `data`. Domain tidak boleh tahu layer lain.
2. **Single Source of Truth:** State UI = state BLoC/Cubit. Tidak ada state lokal yang tidak ter-ekspos.
3. **Sealed States:** Pakai `@freezed sealed class` untuk type-safe `switch` expression.
4. **Result<T> + Failure:** Repository mengembalikan `Result<T>`; try/catch di-convert ke `Failure`.
5. **PostgREST vs Edge Function:** Simple CRUD → PostgREST; atomic/multi-step transactions → Edge Function.
6. **No Material:** Pure Flutter widgets (`WidgetsApp.router`), bukan `MaterialApp`.

---

## ✨ Features

| # | Feature | Status | Sprint | Commit |
|---|---------|:---:|:---:|---|
| 1 | Onboarding (3-slide carousel) | ✅ | Pre | — |
| 2 | Auth (Sign In, Sign Up, Forgot Password, Create Profile) | ✅ | Pre | — |
| 3 | Home (Greeting, Banner, Quick Categories, Upcoming Card) | ✅ | Pre | — |
| 4 | Doctor Search & Detail + Filter | ✅ | Sprint 1 | `356311e` |
| 5 | Booking (Create, History, Detail, Cancel) | ✅ | Sprint 1 | `8a23b2f` |
| 6 | Profile (View, Edit, Favorites) | ✅ | Sprint 1 | `5cebecd` |
| 7 | Nearby Clinics (Loc) — Geolocation + PostgREST RPC | ✅ | Sprint 1 | `cfec420` |
| 8 | Settings (Menu, Help, TnC, No Internet) | ✅ | Sprint 1 | `95496c5` |
| 9 | Push Notification (FCM + Deep Link + Inbox) | ✅ | Sprint 1 | `50386f8` |
| 10 | Test Layer (unit + widget + integration) | ❌ | **Sprint 2** | — |

> **Sprint 1 Status: CLOSED ✅** — 9/9 deliverable selesai. Test layer di-defer ke Sprint 2 sesuai AGENTS.md policy.

---

## 🛠️ Getting Started

### Prerequisites

Pastikan environment lokal kamu sudah punya:

- **Flutter SDK** dengan Dart `^3.10.4` ([install guide](https://docs.flutter.dev/get-started/install))
- **IDE**: Android Studio / VS Code + Flutter plugin
- **Supabase project** — buat di [supabase.com](https://supabase.com), ambil `URL` & `anon key`
- **Firebase project** — buat di [console.firebase.google.com](https://console.firebase.google.com), download `firebase_options.dart` via FlutterFire CLI
- **Git**

### Installation

```bash
# 1. Clone repository
git clone <repo-url>
cd health_pal

# 2. Install dependencies
flutter pub get

# 3. Setup environment
cp .env.example .env
# Edit .env → isi SUPABASE_URL dan SUPABASE_ANON_KEY dari project Supabase kamu

# 4. Setup Firebase (sekali saja per developer)
dart pub global activate flutterfire_cli
flutterfire configure   # generate lib/firebase_options.dart

# 5. Generate code (freezed + json_serializable + injectable)
dart run build_runner build --force-jit

# 6. Verifikasi tidak ada lint issues
flutter analyze         # harusnya "No issues found!"

# 7. Run app
flutter run             # pilih device Android/iOS
```

> **Penting:** Sejak Dart SDK 3.10+, command `build_runner` **wajib** pakai flag `--force-jit` (JIT mode). Tanpa flag: error `'dart compile' does not support build hooks`.

### Environment Variables

Buat file `.env` di **root project** (jangan di-commit):

```env
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOi...your-anon-key
```

> `.env` di-load oleh `flutter_dotenv` di `main.dart` **sebelum** `Supabase.initialize()`.

---

## 📁 Project Structure

```
lib/
├── core/                                    # Fondasi cross-cutting
│   ├── constants/
│   │   └── app_constants.dart               # Konstanta global (limit, key, dll)
│   ├── di/                                  # Dependency Injection
│   │   ├── locator.dart                     # GetIt + @InjectableInit
│   │   ├── locator.config.dart              # GENERATED — jangan edit manual
│   │   └── register_module.dart             # Manual @module registration
│   ├── enums/                               # Domain enums
│   │   ├── app_status.dart                  # initial / loading / success / error
│   │   ├── booking_status.dart              # pending / upcoming / completed / cancelled
│   │   ├── failure_code.dart                # 11 kode error standar
│   │   └── gender.dart                      # male / female / other
│   ├── network/                             # Error & result handling
│   │   ├── api_exception.dart
│   │   ├── error_handler.dart
│   │   ├── json_converters.dart             # Custom DateTime/Enum converters
│   │   └── result.dart                      # sealed Result<T> { Success | Failure }
│   ├── router/                              # GoRouter
│   │   ├── app_router.dart                  # StatefulShellRoute config
│   │   └── route_paths.dart                 # Konstanta path
│   ├── services/                            # App-level services
│   │   ├── app_services.dart                # Session restore, routing decision
│   │   ├── cache_service.dart
│   │   ├── fcm_service.dart                 # FCM: permission, token upsert, listeners
│   │   └── shared_prefs.dart
│   ├── theme/
│   │   ├── app_text_theme.dart
│   │   └── app_theme.dart                   # Color palette, primary #1C2A3A
│   └── utils/
│       ├── date_formatter.dart
│       ├── debouncer.dart
│       └── validators.dart                  # Email, password, phone validators
│
├── features/                                # 7 fitur bisnis
│   ├── onboarding/                          # Presentation only
│   │   └── presentation/
│   │       ├── bloc/onboarding_notifier.dart
│   │       └── page/onboarding_page.dart
│   │
│   ├── auth/                                # ✅ Full Clean Architecture
│   │   ├── data/        (datasource, model, repository)
│   │   ├── domain/      (entity, repository, 4 usecase)
│   │   └── presentation/(4 cubit/bloc, 4 pages)
│   │
│   ├── home/                                # ✅ Full + 4 reusable widgets
│   │   ├── data/        (2 datasource, 4 model, repository)
│   │   ├── domain/      (4 entity, repository, 4 usecase)
│   │   └── presentation/(4 cubit, 1 page, 4 widget, bloc_index)
│   │
│   ├── doctor/                              # ✅ Search + Detail
│   │   ├── data/        (DoctorModel, ClinicModel, SlotModel — @freezed)
│   │   ├── domain/      (3 entity, repository, 3 usecase)
│   │   └── presentation/(SearchCubit, DoctorDetailCubit, 2 page, 3 widget)
│   │
│   ├── booking/                             # ✅ Create + History + Detail + Cancel
│   │   ├── data/        (AppointmentModel 14-field @freezed + Edge Function calls)
│   │   ├── domain/      (entity + 4 usecase)
│   │   └── presentation/(BookingBloc event-driven + 2 cubit + 4 page + 3 widget)
│   │
│   ├── profile/                             # ✅ View + Edit + Favorites + Notification
│   │   ├── data/        (ProfileRemoteDataSource, NotificationModel)
│   │   ├── domain/      (NotificationEntity + 4 usecase)
│   │   └── presentation/(4 cubit + 4 page + NotificationCard)
│   │
│   ├── loc/                                 # ✅ Nearby Clinics + Geolocation
│   │   ├── data/        (ClinicModel 10-field @freezed)
│   │   ├── domain/      (ClinicEntity + derived distanceKm)
│   │   └── presentation/(LocCubit 5 states + page + ClinicCard)
│   │
│   └── settings/                            # Presentation only (menu pages)
│       └── presentation/(SettingsCubit + 4 page)
│
├── widgets/                                 # Shared reusable widgets
│   ├── app_shell.dart                       # Main shell w/ bottom nav
│   ├── badge/app_badge.dart
│   ├── button/         (primary, outline, light_icon)
│   ├── card/           (doctor_card, status_badge)
│   ├── dialog/         (confirm, loading, success, date_picker)
│   ├── form/           (form, form_field, dropdown, pin)
│   ├── input/          (input_field, pin_field, date_picker, drop_down)
│   ├── loader/dot_loader.dart
│   ├── not_found_page.dart
│   └── picker/app_image_picker.dart
│
├── preview/                                 # Widget previews (dev-only)
│   ├── date_picker_preview.dart
│   └── home/           (4 preview files)
│
├── firebase_options.dart                    # GENERATED via flutterfire configure
└── main.dart                                # Init order: dotenv → Supabase → Firebase → DI → FCM → runApp
```

### Statistik File

| Category | Files | Notes |
|---|---:|---|
| `core/` | ~22 | Termasuk generated `locator.config.dart` |
| `features/auth/` | 17 | Full Clean Architecture |
| `features/home/` | 25 | Full + 4 reusable widget |
| `features/{doctor,booking,profile,loc}/` | ~25 each | Full Clean Architecture |
| `features/{onboarding,settings}/` | 2 + 5 | Presentation only |
| `widgets/` | 19 | Shared UI kit |
| **Total `lib/`** | **~120+** | **~280 KB** |

---

## 🔧 Code Generation

Proyek ini memakai 3 code generator paralel. Jalankan setelah setiap perubahan annotation.

```bash
# Generate semua sekaligus (freezed + json_serializable + injectable)
dart run build_runner build --force-jit

# Watch mode (auto-rebuild saat ada perubahan annotation)
dart run build_runner watch --force-jit

# Hapus output lama dulu jika ada konflik
dart run build_runner build --force-jit --delete-conflicting-outputs
```

**Generated files (jangan di-commit via PR manual — selalu di-regenerate):**
- `*.freezed.dart` — sealed classes, copyWith, equality
- `*.g.dart` — JSON serialization
- `lib/core/di/locator.config.dart` — DI registration
- `*.mocks.dart` — Mockito mocks (untuk testing)

---

## 📦 Key Dependencies

### Runtime

| Package | Versi | Fungsi |
|---|---|---|
| `flutter_bloc` | ^9.1.1 | State management (BLoC + Cubit) |
| `bloc` | ^9.2.0 | Core bloc package |
| `go_router` | ^17.2.1 | Declarative routing |
| `get_it` | ^9.2.1 | Service locator |
| `injectable` | ^3.0.0 | Annotation-based DI |
| `supabase_flutter` | ^2.8.4 | Backend (Auth + DB + Storage) |
| `firebase_core` | ^4.10.0 | Firebase init |
| `firebase_messaging` | ^16.3.0 | FCM push notification |
| `freezed_annotation` | ^3.1.0 | Sealed classes & unions |
| `json_annotation` | ^4.12.0 | JSON mapping |
| `flutter_dotenv` | ^6.0.1 | `.env` loader |
| `equatable` | ^2.0.8 | Value equality |
| `geolocator` | ^14.0.3 | Device GPS |
| `connectivity_plus` | ^7.1.1 | Network status |
| `shared_preferences` | ^2.5.5 | Simple KV cache |
| `image_picker` | ^1.2.2 | Native image picker |
| `url_launcher` | ^6.3.0 | Open external URL/Map |
| `intl` | ^0.20.2 | Date/number i18n |
| `provider` | ^6.1.5+1 | InheritedWidget helper |
| `google_fonts` | ^8.0.2 | Typography |
| `iconsax_latest` | ^1.0.0 | Icon set |
| ~~`shimmer`~~ `skeletonizer` | ~~^3.0.0~~ ^1.4.0 | ~~Loading skeleton~~ Skeleton loading (ADR Skeletonizer — shimmer DEPRECATED) |
| `lottie` | ^3.3.1 | Lottie animation |
| `smooth_page_indicator` | ^2.0.1 | Onboarding page indicator |
| `cached_network_image` | ^3.4.1 | Image cache |
| `flutter_auto_size_text` | ^5.0.0 | Responsive text |

### Dev / Codegen

| Package | Versi | Fungsi |
|---|---|---|
| `build_runner` | ^2.4.13 | Code gen orchestrator |
| `freezed` | ^3.2.5 | Sealed class generator |
| `json_serializable` | ^6.14.0 | JSON generator |
| `injectable_generator` | ^3.0.2 | DI generator |
| `mockito` | ^5.4.4 | Mock generator |
| `mocktail` | ^1.0.4 | Manual mock (null-safe) |
| `flutter_lints` | ^6.0.0 | Lint rules |
| `flutter_test` | sdk | Test framework |

---

## 🗺️ Navigation (GoRouter)

App menggunakan `StatefulShellRoute` untuk **bottom navigation yang stateful** — setiap tab mempertahankan state sendiri saat user switch tab.

| Path | Screen | Tab | Auth |
|---|---|---|:---:|
| `/onboarding` | OnboardingPage | — | ❌ |
| `/sign-in` | LoginPage | — | ❌ |
| `/sign-up` | SignUpPage | — | ❌ |
| `/sign-up/create-profile` | CreateProfilePage | — | ❌ |
| `/sign-in/forgot-password` | ForgotPasswordPage | — | ❌ |
| `/home` | HomePage | Tab 1 | ✅ |
| `/loc` | LocPage (Nearby Clinics) | Tab 2 | ✅ |
| `/booking-history` | BookingHistoryPage | Tab 3 | ✅ |
| `/profile` | ProfilePage | Tab 4 | ✅ |
| `/doctor/search` | DoctorSearchPage | Stack | ✅ |
| `/doctor/:doctorId` | DoctorDetailPage | Stack | ✅ |
| `/booking/:doctorId` | BookAppointmentPage | Stack | ✅ |
| `/booking/success` | BookingSuccessPage | Stack | ✅ |
| `/booking-history/:bookingId` | BookingDetailPage | Stack | ✅ |
| `/profile/edit` | EditProfilePage | Stack | ✅ |
| `/profile/favorite` | FavoritePage | Stack | ✅ |
| `/profile/notifications` | NotificationSettingsPage | Stack | ✅ |
| `/settings` | SettingsPage | Stack | ✅ |
| `/help-support` | HelpSupportPage | Stack | ✅ |
| `/terms-and-conditions` | TermsAndConditionsPage | Stack | ✅ |
| `/no-internet` | NoInternetPage | Global | — |

> Definisi lengkap ada di `lib/core/router/route_paths.dart`.

---

## 📋 Development Guidelines

Proyek ini mengikuti aturan ketat yang didefinisikan di **`AGENTS.md`**. Ringkasan:

### Arsitektur & Code Style

- **Clean Architecture WAJIB** untuk setiap feature (Data → Domain → Presentation → DI).
- **Naming:** `snake_case` untuk file & folder; `PascalCase` untuk class; `camelCase` untuk variabel.
- **Models:** Wajib `@freezed` + `@JsonKey(name: 'snake_case')` untuk semua field.
- **Datasource:** Wajib `@injectable` (auto-registered ke DI graph).
- **State management:** Default Cubit. Pakai Bloc event-driven hanya untuk flow kompleks (e.g. Booking).
- **No Material package** — pakai `WidgetsApp.router` & raw Flutter widgets.
- **No Dio/http** — Supabase adalah sole HTTP client.

### Init Order (wajib di `main.dart`)

```
1. WidgetsFlutterBinding.ensureInitialized()
2. dotenv.load()                  ← .env credentials
3. Supabase.initialize()          ← auth + db
4. Firebase.initializeApp()       ← required by FirebaseMessaging
5. configureDependencies()        ← DI (injectable)
6. AppServices.init()             ← session restore + routing decision
7. FcmService init                ← permission + token upsert
8. runApp()
```

> `firebaseMessagingBackgroundHandler` **harus** top-level function, di-register SEBELUM `runApp()`.

### Branching & Commit

- **Branch naming:** `feat/<feature>`, `fix/<bug>`, `chore/<task>`, `docs/<doc>`
- **Commit convention:** `feat:`, `fix:`, `chore:`, `docs:` (conventional commits)
- **Jangan commit langsung ke `master`** — pakai PR + review.
- **Jangan commit** `.env`, `coverage/`, `*.g.dart` (lihat `.gitignore`).

### Testing Policy (Sprint 1)

- ⛔ **DILARANG membuat file test** selama implementasi feature Sprint 1.
- ✅ Fokus: Data Layer → Domain Layer → Presentation Layer → DI → `flutter analyze`.
- 🟡 Testing (unit, widget, bloc, integration) dikerjakan **fase terpisah** (Sprint 2) setelah SEMUA feature Sprint 1 selesai.
- 🟡 Test infrastructure (`test/helpers/`, `mocks.mocks.dart`) yang sudah ada di-skip dulu.

---

## 🧪 Testing

Testing dilakukan dalam **fase terpisah** (Sprint 2) setelah semua feature selesai. Test infrastructure sudah tersedia sejak commit `7d2e85b` (`test/helpers/`, `mocks.mocks.dart`).

### Target Coverage per Sprint

| Sprint | Target Line Coverage | Fokus |
|---|:---:|---|
| Sprint 1 (CLOSED) | 0% (deferred) | Implementasi feature only |
| Sprint 2 | ≥ 60% | Domain (usecase, entity) + critical BLoC |
| Sprint 3 | ≥ 70% | + Datasource + Repository |
| Sprint 4+ | ≥ 80% | + Widget test + E2E critical path |

### Commands

```bash
# Jalankan semua test
flutter test

# Dengan coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html     # Windows
```

> Coverage threshold belum di-enforce. Akan di-integrate ke CI/CD pipeline.

### Test Pyramid Plan

| Layer | Target Count | Tooling |
|---|---:|---|
| Unit (usecase, entity, util) | ~30 | `flutter_test` + `mocktail` |
| Bloc/Cubit state transition | ~15 | `bloc_test` |
| Widget (per page) | ~15 | `flutter_test` WidgetTester |
| Integration (auth + booking) | 3 | `integration_test` |

---

## 🚦 Project Status

| Metrik | Nilai |
|---|:---:|
| **Overall Progress** | ~98% (Sprint 1 scope complete) |
| **Sprint** | Sprint 1 ✅ CLOSED (2026-06-14) |
| **Features Done** | 9/10 (semua UI + FCM) |
| **Features Pending** | 1 (Test layer → Sprint 2) |
| **`flutter analyze`** | 0 issues ✅ |
| **Test Coverage** | 0% (deferred per AGENTS.md policy) |
| **Total Commits** | 9 feat/docs sejak Sprint 0 |
| **Total Dart Files** | ~120+ |
| **Last Commit** | `50386f8` — feat(notification): FCM + deep link + inbox |
| **Beta Launch Target** | ~10-12 minggu dari Sprint 1 |

### Sprint 1 Scoreboard

| Feature | Commit | Status |
|---|---|:---:|
| Onboarding | (pre-sprint) | ✅ |
| Auth | (pre-sprint) | ✅ |
| Home | (pre-sprint) | ✅ |
| Doctor | `356311e` | ✅ |
| Booking | `8a23b2f` | ✅ |
| Profile | `5cebecd` | ✅ |
| Settings | `95496c5` | ✅ |
| Loc | `cfec420` | ✅ |
| Notification (FCM) | `50386f8` | ✅ |
| Test layer | — | ❌ Sprint 2 |

---

## 📄 Documentation

Dokumentasi lengkap proyek ada di folder `docs/`. Beberapa highlight:

| Topik | Path | Catatan |
|---|---|---|
| Business Requirement | `docs/business_requirement/brd_health_pal.md` | BRD v1.0.1 |
| Product Requirement | `docs/product/prd_health_pal.md` | PRD detail |
| API Contract | `docs/api_contract/api_contract_health_pal.md` | 19 endpoint |
| ERD | `docs/erd/erd_healh_pal.md` | 11 tabel, RLS, indexes |
| User Flow | `docs/user_flow/USER_FLOW.md` | 7 Mermaid diagrams |
| Wireframes | `docs/wireframe/` | 21 per-page wireframe |
| TDD Plan | `docs/tdd/01-arsitektur.md` … `12-task-breakdown.md` | 12 dokumen TDD |
| Audit | `docs/audit/` | 4 audit + CTO executive summary |
| Progress | `docs/progress/sprint_progress.md` | Sprint tracker |
| Agent Guide | `AGENTS.md` | Aturan wajib untuk AI agent & developer |

---

## 👥 Team

| Role | Tanggung Jawab |
|------|---------------|
| **CTO** | Architecture & Technical Decision |
| **Backend Lead** | API Contract, Supabase schema, Edge Functions |
| **Tech Lead** | Flutter Architecture, DI, Code Review, Sprint Audit |
| **UI/UX Designer** | Wireframe, Design System, Component Library |
| **Product Manager** | BRD, PRD, Sprint Planning, Backlog |
| **QA Lead** | Testing Strategy, Audit, Verification |

---

## 📜 License

Proprietary — All rights reserved. Internal team only.

---

*Last updated: 14 Juni 2026 · Sprint 1 CLOSED*
