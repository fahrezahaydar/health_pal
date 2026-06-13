# Task Breakdown

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Acuan** | PRD Prioritas, TDD 1-11 |
| **Estimasi** | ~320 jam / ~40 hari kerja |

---

## Daftar Isi

1. [Fase 0: Foundation](#fase-0-foundation)
2. [Fase 1: Core Infrastructure](#fase-1-core-infrastructure)
3. [Fase 2: Auth Flow (P1)](#fase-2-auth-flow-p1)
4. [Fase 3: Main Shell + Bottom Navigation](#fase-3-main-shell--bottom-navigation)
5. [Fase 4: Home Dashboard (P1)](#fase-4-home-dashboard-p1)
6. [Fase 5: Doctor Search & Detail (P1)](#fase-5-doctor-search--detail-p1)
7. [Fase 6: Booking Flow (P1)](#fase-6-booking-flow-p1)
8. [Fase 7: Booking History (P2)](#fase-7-booking-history-p2)
9. [Fase 8: Profile (P2)](#fase-8-profile-p2)
10. [Fase 9: Location Search (P2)](#fase-9-location-search-p2)
11. [Fase 10: Push Notification (P1)](#fase-10-push-notification-p1)
12. [Fase 11: Testing (P1)](#fase-11-testing-p1)

---

## Fase 0: Foundation

> **Prioritas:** P0 — Prasyarat semua fase berikutnya
> **Estimasi:** 3 hari / 24 jam
> **Dependencies:** —

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 0.1 | Setup Flutter project & dependencies | 2 | `pubspec.yaml` updated | — |
| 0.2 | Setup `.env` + `flutter_dotenv` | 1 | `.env`, `.env.example`, loader di `main.dart` | 0.1 |
| 0.3 | Setup Firebase project + download config | 2 | `google-services.json`, `GoogleService-Info.plist` | 0.1 |
| 0.4 | Setup Supabase project + get credentials | 2 | Supabase URL + anon key, init di `main.dart` | 0.1 |
| 0.5 | Run Supabase migration SQL (from ERD) | 4 | Semua tabel + RLS + indexes + trigger | 0.4 |
| 0.6 | Setup `injectable` + `build_runner` | 1 | `locator.config.dart` regenerated | 0.1 |
| 0.7 | Install FCM dependencies | 1 | `firebase_messaging` di `pubspec.yaml` | 0.3 |
| 0.8 | Setup code analysis (`analysis_options.yaml`) | 1 | Lint rules, exclude generated | 0.1 |
| 0.9 | Seed data: spesialisasi, dokter, klinik (dummy) | 4 | Data dummy untuk development | 0.5 |
| 0.10 | Verify all dependencies compile | 2 | `flutter run` sukses tanpa error | 0.1-0.9 |
| 0.11 | Setup AGENTS.md dengan quick commands | 1 | `AGENTS.md` updated | 0.1 |
| 0.12 | Generate mock Supabase client untuk testing | 3 | `mockito` + `@GenerateNiceMocks` | 0.1 |

**Checklist Fase 0:**
- [ ] `flutter pub get` tanpa error
- [ ] Supabase connected (query specializations return data)
- [ ] `.env` loaded di runtime
- [ ] `build_runner build` sukses
- [ ] `flutter analyze` tanpa error

---

## Fase 1: Core Infrastructure

> **Prioritas:** P0 — Prasyarat semua fitur
> **Estimasi:** 4 hari / 32 jam
> **Dependencies:** Fase 0

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 1.1 | Buat `Result<T>` sealed class | 1 | `core/network/result.dart` | 0.1 |
| 1.2 | Buat `ApiException` + `FailureCode` enum | 1 | `core/network/api_exception.dart` + `enums/failure_code.dart` | 0.1 |
| 1.3 | Buat `ErrorHandler` (map Supabase error → Failure) | 2 | `core/network/error_handler.dart` | 1.2 |
| 1.4 | Buat `SupabaseClient` singleton DI module | 1 | `core/network/supabase_client.dart` | 0.4 |
| 1.5 | Buat `Debouncer` utility | 1 | `core/utils/debouncer.dart` | 0.1 |
| 1.6 | Buat `Validators` utility (email, password, phone) | 1 | `core/utils/validators.dart` | 0.1 |
| 1.7 | Buat `DateFormatter` utility | 1 | `core/utils/date_formatter.dart` | 0.1 |
| 1.8 | Migrasi `lib/domain/auth/entity/user.dart` → `features/auth/domain/entity/user_entity.dart` | 1 | Rename + pindah file | 0.1 |
| 1.9 | Pindah `features/auth/page/` → `features/auth/presentation/page/` | 1 | Restruktur folder | 0.1 |
| 1.10 | Pindah `features/auth/bloc/` → `features/auth/presentation/bloc/` | 1 | Restruktur folder | 0.1 |
| 1.11 | Pindah `features/home/` + `onboarding/` sesuai struktur baru | 1 | Restruktur folder | 0.1 |
| 1.12 | Update `locator.config.dart` setelah restruktur | 1 | Regenerate DI | 1.8-1.11 |
| 1.13 | Update imports di semua file yang dipindah | 2 | No broken imports | 1.8-1.11 |
| 1.14 | Tambah enum `BookingStatus` | 1 | `core/enums/booking_status.dart` | 0.1 |
| 1.15 | Buat `RoutePaths` constants | 1 | `core/router/route_names.dart` | 0.1 |
| 1.16 | Update `AppRouter` dengan semua 21 route + redirect logic | 4 | `app_router.dart` full | 1.15 |
| 1.17 | Buat `AppShell` widget (BottomNavigationBar + StatefulShellRoute) | 2 | `widgets/app_shell.dart` | 1.16 |
| 1.18 | Buat `NotFoundPage` | 1 | `widgets/not_found_page.dart` | 0.1 |
| 1.19 | Buat `AppConfirmDialog` (konfirmasi generic) | 1 | `widgets/dialog/app_confirm_dialog.dart` | 0.1 |
| 1.20 | Buat `DoctorCard` reusable widget | 2 | `widgets/card/doctor_card.dart` | 0.1 |
| 1.21 | Buat `StatusBadge` reusable widget | 1 | `widgets/card/status_badge.dart` | 0.1 |
| 1.22 | Update `main.dart` dengan init sequence lengkap | 2 | Supabase + dotenv + DI + AppServices | 1.4 |
| 1.23 | Setup `CacheService` | 2 | `core/services/cache_service.dart` | 0.1 |
| 1.24 | Setup `FcmService` skeleton (init + token upsert) | 2 | `core/services/fcm_service.dart` | 0.7 |
| 1.25 | Verify: `flutter analyze` bersih setelah semua perubahan | 2 | Zero warnings | 1.1-1.24 |

**Total Fase 1:** 32 jam

**Checklist Fase 1:**
- [ ] GoRouter bisa navigasi ke semua 21 path (stub pages)
- [ ] AppShell render 4 tab bottom nav
- [ ] Redirect logic: onboarding → sign-in → home
- [ ] `flutter analyze` 0 warning
- [ ] Semua file migrated, imports fix

---

## Fase 2: Auth Flow (P1)

> **Prioritas:** P1 (PRD — auth adalah fondasi)
> **Estimasi:** 5 hari / 40 jam
> **Dependencies:** Fase 1

### 2A: Onboarding (existing — minor update)

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 2.1 | Review `OnboardingPage` — pastikan route name sync | 1 | ✅ /onboarding uses RoutePaths | 1.16 |
| 2.2 | Verify `skip()` calls `AppServices.completeOnboarding()` | 1 | ✅ redirect ke /sign-in | 1.22 |

### 2B: Sign In Bloc + Page

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 2.3 | Buat `UserEntity` + `UserModel` (fromJson/toJson) | 2 | `auth/domain/entity/user_entity.dart` + `data/model/user_model.dart` | 1.8 |
| 2.4 | Buat `AuthRepository` abstract interface | 1 | `auth/domain/repository/auth_repository.dart` | 2.3 |
| 2.5 | Buat `AuthRemoteDataSource` | 2 | `auth/data/datasource/auth_remote_datasource.dart` | 1.4 |
| 2.6 | Buat `AuthLocalDataSource` | 1 | `auth/data/datasource/auth_local_datasource.dart` | 1.23 |
| 2.7 | Buat `AuthRepositoryImpl` | 2 | `auth/data/repository/auth_repository_impl.dart` | 2.4, 2.5, 2.6 |
| 2.8 | Buat `LoginWithEmailUseCase` | 1 | `auth/domain/usecase/login_with_email_usecase.dart` | 2.4 |
| 2.9 | Buat `SignInBloc` + `SignInEvent` + `SignInState` | 3 | All 3 files | 2.8 |
| 2.10 | Update `SignInPage` — rename dari `LoginPage`, pastikan route synced | 1 | ✅ /sign-in | 1.9 |
| 2.11 | Integrasi `SignInBloc` ke `SignInPage` | 2 | BlocProvider + BlocConsumer | 2.9, 2.10 |
| 2.12 | Handle: Google OAuth button → `SignInWithGoogle` event | 1 | Event handler di Bloc | 2.9 |
| 2.13 | Handle: Facebook button → snackbar "Fitur belum tersedia" | 1 | Snackbar | 2.10 |

### 2C: Sign Up + Create Profile

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 2.14 | Buat `SignUpUseCase` | 1 | `auth/domain/usecase/sign_up_usecase.dart` | 2.4 |
| 2.15 | Buat `SignUpBloc` | 2 | `sign_up_bloc.dart`, event, state | 2.14 |
| 2.16 | Integrasi `SignUpBloc` ke `SignUpPage` | 2 | BlocProvider | 2.15 |
| 2.17 | Buat `CreateProfileUseCase` | 1 | `auth/domain/usecase/create_profile_usecase.dart` | 2.4 |
| 2.18 | Buat `CreateProfileCubit` | 1 | `create_profile_cubit.dart` + state | 2.17 |
| 2.19 | Integrasi `CreateProfileCubit` ke `CreateProfilePage` | 2 | Submit logic + API call | 2.18 |
| 2.20 | Handle: loading dialog saat "Save Profile" | 1 | `AppLoadingDialog.show()` | 2.19 |

### 2D: Forgot Password

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 2.21 | Buat `ForgotPasswordUseCase` | 1 | `auth/domain/usecase/forgot_password_usecase.dart` | 2.4 |
| 2.22 | Update `ForgotPasswordCubit` — ganti `Future.delayed` dengan real API | 2 | Send email + verify + reset | 2.21 |
| 2.23 | Test: forgot password flow end-to-end | 1 | Manual test | 2.22 |

### 2E: DI Registration

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 2.24 | Daftarkan semua Auth dependency di `@module` dan `@lazySingleton` | 1 | `locator.config.dart` regenerated | 2.3-2.22 |
| 2.25 | `flutter analyze` + fix | 1 | Zero warnings | 2.24 |

**Total Fase 2:** 40 jam

**Checklist Fase 2:**
- [ ] Register with email → create profile → home
- [ ] Login with email → home
- [ ] Login Google → home
- [ ] Forgot password → email → OTP → reset → login
- [ ] Validation errors muncul di form
- [ ] API errors handling (email not confirmed, invalid credentials)

---

## Fase 3: Main Shell + Bottom Navigation

> **Prioritas:** P1 — prerequisite navigasi
> **Estimasi:** 1 hari / 8 jam
> **Dependencies:** Fase 1

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 3.1 | Finalisasi `AppShell` — icon, label, active color | 1 | `widgets/app_shell.dart` | 1.17 |
| 3.2 | Buat stub pages: `LocPage`, `BookingHistoryPage`, `ProfilePage` | 2 | 3 stub pages with placeholder text | 1.16 |
| 3.3 | Verify: tap bottom nav → switch tab, state preserved | 1 | Manual test | 3.1, 3.2 |
| 3.4 | Verify: push stack route → bottom nav hidden, pop → visible | 1 | Manual test | 3.1 |
| 3.5 | Verify: auth → /home → shell render 4 tabs | 1 | Manual test | 2.0, 3.1 |
| 3.6 | Handle: logout → redirect /sign-in, shell destroyed | 1 | `AppServices.logout()` | 3.1 |
| 3.7 | Handle: back button pada stack routes | 1 | `context.pop()` + transitions | 3.1 |

**Total Fase 3:** 8 jam

---

## Fase 4: Home Dashboard (P1)

> **Prioritas:** P1 (PRD — core)
> **Estimasi:** 3 hari / 24 jam
> **Dependencies:** Fase 3

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 4.1 | Buat `BannerEntity` + `BannerModel` | 1 | `features/home/data/model/banner_model.dart` | 0.5 |
| 4.2 | Buat `UpcomingAppointmentEntity` + model | 1 | `features/home/data/model/upcoming_appointment_model.dart` | 2.3 |
| 4.3 | Buat `SpecializationEntity` + `SpecializationModel` | 1 | `features/doctor/` (shared) | 0.5 |
| 4.4 | Buat `HomeRepository` interface | 1 | `features/home/domain/repository/home_repository.dart` | 4.1 |
| 4.5 | Buat `HomeRemoteDataSource` | 2 | Fetch banners, upcoming, specializations | 1.4 |
| 4.6 | Buat `HomeRepositoryImpl` | 1 | Remote first + cache fallback | 4.4, 4.5, 1.23 |
| 4.7 | Buat `GetBannersUseCase` | 1 | `features/home/domain/usecase/get_banners_usecase.dart` | 4.4 |
| 4.8 | Buat `GetUpcomingUseCase` | 1 | `features/home/domain/usecase/get_upcoming_usecase.dart` | 4.4 |
| 4.9 | Buat `GetSpecializationsUseCase` | 1 | `features/doctor/domain/usecase/` | 4.3 |
| 4.10 | Buat `HomeCubit` | 2 | load banners + upcoming + specializations | 4.7, 4.8, 4.9 |
| 4.11 | Rebuild `HomePage` — greeting, search bar, banner carousel | 4 | `home_page.dart` + widgets | 4.10 |
| 4.12 | Buat `GreetingSection` widget | 1 | Tampilkan "Halo, {nickname}!" | 2.3 |
| 4.13 | Buat `BannerCarousel` widget | 2 | PageView + auto scroll + indicator | 4.1 |
| 4.14 | Buat `UpcomingCard` widget | 1 | Card appointment terdekat | 4.2 |
| 4.15 | Buat `QuickCategories` widget | 1 | Grid specializations | 4.3 |
| 4.16 | Handle: empty state (no upcoming) | 1 | CTA "Cari Dokter Sekarang" | 4.11 |
| 4.17 | Handle: banner loading + error state | 1 | Shimmer / error placeholder | 4.11 |
| 4.18 | Integrasi: tap search bar → navigate `/doctor/search` | 1 | `context.push(RoutePaths.doctorSearch)` | 4.11, 1.15 |
| 4.19 | Integrasi: tap category → navigate `/loc` with filter preset | 1 | `context.go('/loc', extra: filter)` | 4.11 |
| 4.20 | Integrasi: tap upcoming card → navigate booking detail | 1 | `context.push('/booking-history/:id')` | 4.11 |

**Total Fase 4:** 24 jam

---

## Fase 5: Doctor Search & Detail (P1)

> **Prioritas:** P1 (PRD — fitur inti)
> **Estimasi:** 5 hari / 40 jam
> **Dependencies:** Fase 3

### 5A: Data Layer Doctor

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 5.1 | Buat `DoctorEntity`, `ClinicEntity`, `DoctorSlotEntity` | 2 | 3 entity files di `doctor/domain/entity/` | 0.5 |
| 5.2 | Buat `DoctorModel`, `ClinicModel`, `DoctorSlotModel` | 2 | 3 model files (fromJson/toJson) | 5.1 |
| 5.3 | Buat `DoctorRepository` abstract interface | 1 | `doctor/domain/repository/doctor_repository.dart` | 5.1 |
| 5.4 | Buat `DoctorRemoteDataSource` | 2 | Search + detail + slots dari Supabase | 1.4 |
| 5.5 | Buat `DoctorRepositoryImpl` | 1 | Implements DoctorRepository | 5.3, 5.4 |

### 5B: Use Cases

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 5.6 | Buat `SearchDoctorsUseCase` | 1 | `doctor/domain/usecase/search_doctors_usecase.dart` | 5.3 |
| 5.7 | Buat `GetDoctorDetailUseCase` | 1 | | 5.3 |
| 5.8 | Buat `GetSlotsUseCase` | 1 | | 5.3 |
| 5.9 | Buat `GetSpecializationsUseCase` | 1 | | 5.3 |
| 5.10 | Buat `SearchByLocationUseCase` | 1 | | 5.3 |

### 5C: Search Cubit + Page

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 5.11 | Buat `SearchCubit` + `SearchState` | 2 | debounce, filter, loadMore | 5.6 |
| 5.12 | Buat `DoctorSearchPage` | 3 | Search bar + filter chips + doctor list | 5.11, 1.20 |
| 5.13 | Buat `FilterChips` widget | 1 | Horizontal scroll + pilih specialization | 4.9 |
| 5.14 | Handle: empty search result | 1 | "Dokter tidak ditemukan" | 5.12 |
| 5.15 | Handle: pagination (infinite scroll) | 2 | ScrollController + loadMore | 5.12 |

### 5D: Doctor Detail Cubit + Page

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 5.16 | Buat `DoctorDetailCubit` + state | 2 | Load detail + slots + selectDate | 5.7, 5.8 |
| 5.17 | Buat `DoctorDetailPage` | 4 | Full layout sesuai wireframe 09 | 5.16 |
| 5.18 | Buat `HorizontalDatePicker` widget | 2 | 7 hari, tap → select date | 5.16 |
| 5.19 | Buat `SlotChips` widget | 1 | Green/abv chips, tap select | 5.16 |
| 5.20 | Buat `DoctorInfoCard` widget | 1 | Pendidikan, pengalaman, klinik, fee | 5.16 |
| 5.21 | Buat `ReviewCard` widget (placeholder v1.1) | 1 | List review + "Lihat semua" | 5.16 |
| 5.22 | Handle: no slots available → empty state | 1 | "Tidak ada jadwal untuk tanggal ini" | 5.17 |
| 5.23 | Handle: tap "Book Appointment" → navigate `/booking/:doctorId` | 1 | Pass doctor data via extra (TANPA `selectedDate` per SS#10 v1.0.1) | 5.17 |

**Catatan SS#10 alignment v1.0.1:** Sejak wireframe 09-doctor-detail.md dan 10-book-appointment.md diperbarui (commit `7839d9d`), kontrak navigasi dari DoctorDetailPage → BookAppointmentPage berubah:

```dart
// SEBELUM (v1.0 awal)
context.push('/booking/:doctorId', extra: {
  'doctor': doctor,
  'selectedDate': selectedDate,    // ← ADA
  'suggestedSlotId': suggestedSlotId,
});

// SESUDAH (v1.0.1)
context.push('/booking/:doctorId', extra: {
  'doctor': doctor,
  'suggestedSlotId': suggestedSlotId,  // ← opsional, null jika belum pilih
  // 'selectedDate' DIHAPUS — date picker single source di BookAppointmentPage
});
```

Update TDD 04 §4.10 (BookingBloc spec) sudah dilakukan: tambah `BookingInitialized` event dengan `doctor` + `suggestedSlotId`, dan hapus asumsi `selectedDate` dari extra. BookingState tetap punya `selectedDate` — tapi di-set lewat interaksi `SelectSlot(date, slotId)` di BookAppointmentPage, BUKAN dari extra param.
| 5.24 | Handle: tap "Lihat Peta" → open Google Maps external | 1 | Launch URL | 5.17 |

**Total Fase 5:** 40 jam

---

## Fase 6: Booking Flow (P1)

> **Prioritas:** P1 (PRD — fitur inti)
> **Estimasi:** 4 hari / 32 jam
> **Dependencies:** Fase 5

### 6A: Data Layer Booking

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 6.1 | Buat `AppointmentEntity` | 1 | `booking/domain/entity/appointment_entity.dart` | 0.5 |
| 6.2 | Buat `AppointmentModel` | 1 | via `appointments` table | 6.1 |
| 6.3 | Buat `CreateAppointmentResponseModel` | 1 | Response dari Edge Function | 6.1 |
| 6.4 | Buat `BookingRepository` interface | 1 | `booking/domain/repository/booking_repository.dart` | 6.1 |
| 6.5 | Buat `BookingRemoteDataSource` | 2 | Create + get history + cancel | 1.4 |
| 6.6 | Buat `BookingRepositoryImpl` | 1 | | 6.4, 6.5 |

### 6B: Use Cases

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 6.7 | Buat `CreateAppointmentUseCase` | 1 | | 6.4 |
| 6.8 | Buat `GetBookingHistoryUseCase` | 1 | | 6.4 |
| 6.9 | Buat `GetBookingDetailUseCase` | 1 | | 6.4 |
| 6.10 | Buat `CancelAppointmentUseCase` | 1 | | 6.4 |

### 6C: Booking Bloc + Page

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 6.11 | Buat `BookingBloc` + `BookingEvent` + `BookingState` | 3 | SelectSlot, UpdateComplaint, SubmitBooking | 6.7 |
| 6.12 | Buat `BookAppointmentPage` | 3 | Layout wireframe 10: summary, date, slot, complaint, fee | 6.11 |
| 6.13 | Buat `BookingSummaryCard` widget | 1 | Read-only detail di bottom sheet | 6.11 |
| 6.14 | Buat `ConfirmationBottomSheet` widget | 2 | Modal: ringkasan + konfirmasi + batal | 6.11 |
| 6.15 | Handle: validation — slot belum dipilih | 1 | Snackbar "Pilih slot dulu" | 6.12 |
| 6.16 | Handle: complaint > 300 chars | 1 | Error counter | 6.12 |
| 6.17 | Handle: API 409 — slot conflict | 1 | Dialog + refresh slot list | 6.12 |

### 6D: Booking Success

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 6.18 | Buat `BookingSuccessPage` | 2 | Animasi sukses + detail + 2 CTA buttons | 6.11 |
| 6.19 | Handle: tap "Kembali ke Home" → `context.go('/home')` | 1 | Clear stack | 6.18 |
| 6.20 | Handle: tap "Lihat Riwayat" → `context.go('/booking-history')` | 1 | | 6.18 |

**Total Fase 6:** 32 jam

---

## Fase 7: Booking History (P2)

> **Prioritas:** P2 (PRD)
> **Estimasi:** 3 hari / 24 jam
> **Dependencies:** Fase 6

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 7.1 | Buat `BookingHistoryCubit` + state | 2 | Load + filter by status + pagination | 6.8 |
| 7.2 | Buat `BookingHistoryPage` | 3 | TabBar (5 tab) + TabBarView + cards | 7.1 |
| 7.3 | Buat `AppointmentCard` widget | 1 | Card reusable: foto, nama, tanggal, status badge | 1.21 |
| 7.4 | Handle: filter tab → refresh list sesuai status | 1 | Cubit.filterByStatus() | 7.2 |
| 7.5 | Handle: empty state per tab | 1 | "Tidak ada appointment dengan status X" | 7.2 |
| 7.6 | Handle: pull to refresh | 1 | RefreshIndicator | 7.2 |
| 7.7 | Handle: pagination infinite scroll | 1 | ScrollController | 7.2 |
| 7.8 | Buat `BookingDetailCubit` + state | 2 | Load detail + cancel | 6.9, 6.10 |
| 7.9 | Buat `BookingDetailPage` | 3 | Layout wireframe 13: timeline, info, cancel button | 7.8 |
| 7.10 | Buat `StatusTimeline` widget | 2 | Timeline: dibuat → dikonfirmasi → selesai | 7.8 |
| 7.11 | Handle: cancel appointment → confirm dialog → API | 2 | `AppConfirmDialog` + loading + redirect | 7.9 |
| 7.12 | Handle: completed appointments — "Beri Ulasan" button (v1.1 placeholder) | 1 | Placeholder | 7.9 |
| 7.13 | Handle: waktu lewat di halaman detail → refresh status | 1 | Dialog: "Appointment sudah lewat" | 7.9 |

**Total Fase 7:** 24 jam

---

## Fase 8: Profile (P2)

> **Prioritas:** P2 (PRD)
> **Estimasi:** 3 hari / 24 jam
> **Dependencies:** Fase 3

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 8.1 | Buat `ProfileEntity` + `ProfileModel` | 1 | `profile/domain/entity/`, `data/model/` | 0.5 |
| 8.2 | Buat `ProfileRepository` interface | 1 | `profile/domain/repository/profile_repository.dart` | 8.1 |
| 8.3 | Buat `ProfileRemoteDataSource` | 1 | Get + update + upload avatar | 1.4 |
| 8.4 | Buat `ProfileLocalDataSource` | 1 | Cache profile | 1.23 |
| 8.5 | Buat `ProfileRepositoryImpl` | 1 | | 8.2, 8.3, 8.4 |
| 8.6 | Buat `GetProfileUseCase` | 1 | | 8.2 |
| 8.7 | Buat `UpdateProfileUseCase` | 1 | | 8.2 |
| 8.8 | Buat `UploadAvatarUseCase` | 1 | | 8.2 |
| 8.9 | Buat `ProfileCubit` | 2 | Load profile + toggle notif + logout | 8.6 |
| 8.10 | Buat `ProfilePage` | 3 | Layout wireframe 14: avatar, menu list, logout | 8.9 |
| 8.11 | Buat `EditProfileCubit` | 1 | Update + avatar upload | 8.7, 8.8 |
| 8.12 | Buat `EditProfilePage` | 2 | Layout wireframe 15 | 8.11 |
| 8.13 | Buat `FavoritePage` (placeholder v1.1) | 1 | "Belum ada dokter favorit" | 0.1 |
| 8.14 | Buat `NotificationPage` | 2 | Toggles + notification inbox list | 8.9 |
| 8.15 | Buat `NotificationRemoteDataSource` | 1 | GET notifications from Supabase | 1.4 |
| 8.16 | Buat `SettingsPage` | 1 | Language, change password, clear cache, version | 0.1 |
| 8.17 | Buat `HelpSupportPage` | 1 | FAQ + contact | 0.1 |
| 8.18 | Buat `TermsAndConditionsPage` | 1 | Static text | 0.1 |
| 8.19 | Handle: logout → confirm dialog → `AppServices.logout()` → redirect | 1 | | 8.10 |

**Total Fase 8:** 24 jam

---

## Fase 9: Location Search (P2)

> **Prioritas:** P2 (PRD)
> **Estimasi:** 4 hari / 32 jam
> **Dependencies:** Fase 5 (reuse DoctorCard, DoctorRepository)

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 9.1 | Add `google_maps_flutter` + `geolocator` dependencies | 1 | `pubspec.yaml` | 0.1 |
| 9.2 | Buat `LocCubit` + state | 2 | Permission, location, filter, load | 5.10 |
| 9.3 | Buat `LocPage` | 4 | Map view + pin markers + doctor list | 9.2, 9.1 |
| 9.4 | Handle: location permission request flow | 2 | Allow → map, deny → city input fallback | 9.3 |
| 9.5 | Handle: map pin markers dari clinic coordinates | 2 | Marker per clinic yang ada dokter | 9.3 |
| 9.6 | Handle: filter chips + sort dropdown | 1 | Spesialisasi + jarak/rating/fee | 9.3 |
| 9.7 | Handle: pull to refresh → reload map markers | 1 | RefreshIndicator | 9.3 |
| 9.8 | Handle: empty state — no doctors in radius | 1 | "Tidak ada dokter di sekitar" | 9.3 |
| 9.9 | Integrasi: tap doctor card → `/doctor/:doctorId` | 1 | Reuse DoctorDetail | 9.3, 5.17 |

**Total Fase 9:** 32 jam

---

## Fase 9.5: Facility — Nearby Medical Centers (P2)

> **Prioritas:** P2 (Home page section)
> **Estimasi:** 2 hari / 16 jam
> **Dependencies:** Fase 0 (Supabase), Fase 4 (Home cubits)
> **Posisi:** Sebelum Push Notification (Fase 10)

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 9.5.1 | Add `geolocator` + `google_maps_flutter` ke pubspec | 1 | Dependencies | 0.1 |
| 9.5.2 | PostgreSQL migration: `get_nearby_clinics` function | 2 | `003_nearby_function.sql` | 0.5 |
| 9.5.3 | Buat `FacilityEntity` + `FacilityModel` | 1 | Entity + Model | 0.1 |
| 9.5.4 | Tambah `getNearby()` ke `HomeRepository` + `HomeRemoteDataSource` | 2 | RPC call | 9.5.3 |
| 9.5.5 | Buat `GetNearbyFacilitiesUseCase` | 1 | Use case | 9.5.4 |
| 9.5.6 | Buat `FacilityCubit` + `FacilityState` | 1 | Sealed state pattern | 9.5.5 |
| 9.5.7 | Buat `NearbyFacilities` widget | 2 | Horizontal list + card | 9.5.6 |
| 9.5.8 | Integrasi ke HomePage | 1 | Tambah section | 9.5.7 |
| 9.5.9 | Route `/facilities/:id` + `FacilityDetailPage` | 3 | Detail page | 9.5.3 |
| 9.5.10 | Handle: location permission request | 1 | Allow/deny flow | 9.5.1 |
| 9.5.11 | Handle: empty state — no clinics in radius | 1 | "Tidak ada klinik di sekitar" | 9.5.7 |

**Total Fase 9.5:** 16 jam

---

## Fase 10: Push Notification (P1)

> **Prioritas:** P1 (PRD — no-show reduction)
> **Estimasi:** 2 hari / 16 jam
> **Dependencies:** Fase 0, Fase 6 (booking untuk trigger)

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 10.1 | Init `FirebaseMessaging` + request permission | 2 | FCM service init di main.dart | 0.7 |
| 10.2 | Get + upsert FCM token ke Supabase | 2 | `FcmService` complete | 1.24 |
| 10.3 | Handle: `onMessage` (foreground) → in-app snackbar | 1 | | 10.1 |
| 10.4 | Handle: `onMessageOpenedApp` (background tap) → route | 2 | Navigasi ke halaman sesuai type | 10.1, 1.16 |
| 10.5 | Handle: `getInitialMessage` (terminated tap) → route | 1 | | 10.1, 1.16 |
| 10.6 | Buat Edge Function `upsert-fcm-token` di Supabase | 3 | SQL + TypeScript function | 0.5 |
| 10.7 | Test: kirim notifikasi manual via Firebase Console | 2 | Verify all 3 states | 10.1-10.6 |
| 10.8 | Test: booking → FCM "Booking berhasil" terkirim | 1 | end-to-end | 10.6, 6.17 |
| 10.9 | Test: reminder h-1, h-0 timing (via Supabase cron) | 2 | Setup pg_cron / Edge Function scheduler | 0.5 |

**Total Fase 10:** 16 jam

---

## Fase 11: Testing (P1)

> **Prioritas:** P1 (quality gate)
> **Estimasi:** 5 hari / 40 jam
> **Dependencies:** Fase 2-8 selesai

| # | Task | Jam | Output | Depends On |
|---|---|---|---|---|
| 11.1 | Unit test: `UserModel`, `AppointmentModel`, `DoctorModel` parsing | 3 | 3 model test files | Fase 2,5,6 |
| 11.2 | Unit test: `ErrorHandler.mapToFailure()` | 2 | Cover all FailureCode types | 1.3 |
| 11.3 | Unit test: `Validators` | 1 | Email, password, empty | 1.6 |
| 11.4 | Unit test: `SignInBloc` — email success + error | 3 | `blocTest` pattern | Fase 2 |
| 11.5 | Unit test: `SignUpBloc` — success + duplicate email | 2 | | Fase 2 |
| 11.6 | Unit test: `SearchCubit` — search + empty + error | 2 | | Fase 5 |
| 11.7 | Unit test: `DoctorDetailCubit` — load + selectDate + selectSlot | 2 | | Fase 5 |
| 11.8 | Unit test: `BookingBloc` — selectSlot + submit + conflict | 3 | | Fase 6 |
| 11.9 | Unit test: `BookingHistoryCubit` — filter by status | 2 | | Fase 7 |
| 11.10 | Unit test: `BookingDetailCubit` — load + cancel | 2 | | Fase 7 |
| 11.11 | Unit test: `HomeCubit` — load banners + upcoming | 2 | | Fase 4 |
| 11.12 | Unit test: `ForgotPasswordCubit` — step transitions | 2 | Email → OTP → NewPassword | Fase 2 |
| 11.13 | Unit test: `AuthRepositoryImpl` — login success + error mapping | 2 | | Fase 2 |
| 11.14 | Unit test: `DoctorRepositoryImpl` — search + detail | 2 | | Fase 5 |
| 11.15 | Widget test: `SignInPage` — form validation error | 2 | `tester.enterText` + `tester.tap` | Fase 2 |
| 11.16 | Widget test: `DoctorDetailPage` — date picker → slot muncul | 2 | | Fase 5 |
| 11.17 | Widget test: `BookAppointmentPage` — complaint counter | 1 | | Fase 6 |
| 11.18 | Widget test: `BookingHistoryPage` — tab filter ubah list | 2 | | Fase 7 |
| 11.19 | Widget test: `HomePage` — upcoming card render | 1 | | Fase 4 |
| 11.20 | Integration test: Auth flow (register → profile → home) | 3 | Full flow | Fase 2,3 |
| 11.21 | Integration test: Booking flow (search → detail → book → success) | 3 | Full core flow | Fase 4-6 |
| 11.22 | Integration test: Cancel flow (history → detail → cancel) | 2 | | Fase 7 |

**Total Fase 11:** 40 jam

---

## Ringkasan Timeline

| Fase | Nama | Jam | Hari | Prioritas |
|---|---|---|---|---|
| 0 | Foundation | 24 | 3 | P0 |
| 1 | Core Infrastructure | 32 | 4 | P0 |
| 2 | Auth Flow | 40 | 5 | **P1** |
| 3 | Main Shell | 8 | 1 | P1 |
| 4 | Home Dashboard | 24 | 3 | **P1** |
| 5 | Doctor Search & Detail | 40 | 5 | **P1** |
| 6 | Booking Flow | 32 | 4 | **P1** |
| 7 | Booking History | 24 | 3 | **P2** |
| 8 | Profile | 24 | 3 | **P2** |
| 9 | Location Search | 32 | 4 | **P2** |
| 10 | Push Notification | 16 | 2 | **P1** |
| 11 | Testing | 40 | 5 | P1 |
| | **Total** | **336** | **42** | |

### Visual Timeline

```
Minggu 1:  Foundation ████████░░░░░░░░░░░░░░░░░░░░░░░░░░
Minggu 2:  Core ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░
Minggu 3-4: Auth ██████████████████░░░░░░░░░░░░░░░░░░░░
Minggu 5:  Shell + Home ██████████████████████░░░░░░░░░░
Minggu 6-7: Doctor Search ████████████████████████████░░
Minggu 8-9: Booking + History ██████████████████████████
Minggu 10: Profile + Location ████████████████████████████
Minggu 11: Notification ████████████████████████████████
Minggu 12-13: Testing █████████████████████████████████████
```

---

## Dependency Graph

```
Fase 0 (Foundation)
  └── Fase 1 (Core Infrastructure)
       ├── Fase 2 (Auth)
       │    └── Fase 3 (Main Shell)
       │         ├── Fase 4 (Home)
       │         │    └── Fase 5 (Doctor Search)
       │         │         └── Fase 6 (Booking)
       │         │              └── Fase 7 (Booking History)
       │         └── Fase 8 (Profile)
       │         └── Fase 9 (Location Search) ── reuse 5
       ├── Fase 10 (Notification) ── parallel
       └── Fase 11 (Testing) ── setelah semua fitur
```

**Critical Path (harus selesai sebelum rilis MVP):**
Fase 0 → 1 → 2 → 3 → 4 → 5 → 6 → 10 → 11

**Bisa dikerjakan paralel:**
- Fase 7 (History) + Fase 8 (Profile) + Fase 9 (Location)
- Fase 10 (Notification) bisa start setelah Fase 6

---

*Dokumen ini adalah living document. Update progress di setiap task saat implementasi.*
