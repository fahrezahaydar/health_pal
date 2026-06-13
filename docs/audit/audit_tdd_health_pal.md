# Audit TDD Plan — Health Pal

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Platform** | Mobile (Flutter — Android & iOS) |
| **Versi Dokumen** | v1.0 |
| **Tanggal Audit** | 13 Juni 2026 |
| **Auditor** | Lead QA + Senior Flutter Engineer (TDD Specialist) |
| **Cakupan** | TDD 01–12 (Lengkap) · Wireframe 01–21 · API Contract v1.0 · ERD v1.0 |
| **Fokus** | Test Coverage (Unit/Widget/Integration) · Testability (DI/Mocking) · Edge Cases |

---

## Ringkasan Skor

| Kriteria | Skor | Status |
|---|---|---|
| **1. Test Coverage (Unit / Widget / Integration)** | **65 / 100** | 🟡 Perlu Perhatian |
| **2. Testability (DI + Mocking readiness)** | **78 / 100** | 🟢 Baik |
| **3. Edge Cases (Failure scenarios)** | **60 / 100** | 🔴 Lemah |
| **Skor Keseluruhan** | **68 / 100** | 🟡 Perlu Revisi Sebelum Sprint 1 |

---

## 1. Test Coverage — 65 / 100

### 1.1 Target vs Actual (Cross-Check TDD 10 vs TDD 12)

TDD 10 §5 menyatakan target **75 test** (54 unit + 17 widget + integration).  
TDD 12 Fase 11 hanya mendaftarkan **22 test task** (15 unit + 4 widget + 3 integration).  
**Gap: -53 test (-71%)** ⚠️

| Layer | Target (TDD 10) | Actual (TDD 12) | Gap |
|---|---|---|---|
| Unit Test — Model | 10 | 3 (11.1) | -7 |
| Unit Test — Entity | 5 | 0 | -5 |
| Unit Test — UseCase | 15 | 0 | -15 |
| Unit Test — Cubit/BLoC | 20 | 11 (11.4–11.12, 11.10) | -9 |
| Unit Test — Repository | 5 | 2 (11.13, 11.14) | -3 |
| Unit Test — Utils | 5 | 2 (11.2, 11.3) | -3 |
| Widget Test | 17 | 4 (11.15–11.19) | -13 |
| Integration Test | 3 | 3 (11.20–11.22) | 0 ✅ |
| **Total** | **75** | **22** | **-53** |

### 1.2 Per-Fitur Coverage Gap

| Fitur | Target (TDD 10 §5) | Actual (TDD 12) | Gap |
|---|---|---|---|
| Auth | 16 | 6 (11.4, 11.5, 11.12, 11.13, 11.15) | -10 |
| Onboarding | 3 | 0 | -3 |
| Home | 7 | 2 (11.11, 11.19) | -5 |
| Doctor | 14 | 4 (11.6, 11.7, 11.14, 11.16) | -10 |
| Booking | 16 | 7 (11.8, 11.9, 11.10, 11.17, 11.18, 11.21, 11.22) | -9 |
| Profile | 7 | 0 | -7 |
| Core (utils, model) | 8 | 3 (11.1, 11.2, 11.3) | -5 |
| **Total** | **71** | **22** | **-49** |

### 1.3 Yang Sudah Baik

- **Test pyramid** didefinisikan eksplisit (50–60 unit, 15–20 widget, 2–3 integration).
- **Mock strategy** terdokumentasi di TDD 10 §6: `mockito` + `@GenerateNiceMocks`.
- **File organization** untuk test sudah jelas (TDD 10 §7).
- **Test commands** lengkap (test, coverage, watch mode, integration).
- **Contoh test** BLoC (`blocTest`), Model (`fromJson`), Widget (`pumpWidget`) sudah ada.
- **Target coverage per fitur** ditabulasikan dengan baik di TDD 10 §5.
- **3 integration test** didefinisikan (Auth, Booking, Cancel).

### 1.4 Yang Perlu Diperbaiki (Missing Tests)

#### 🔴 HIGH — Widget Tests Hilang untuk Halaman Kritis

| Halaman / Widget | Penting Karena | Severity |
|---|---|---|
| `OnboardingPage` | First impression user, 3 slide | High |
| `ForgotPasswordPage` | 3 sub-step dalam 1 Cubit — state machine | High |
| `SignUpPage` | Form validation + register flow | High |
| `CreateProfilePage` | Image picker + form + upload | High |
| `ProfilePage` | Toggle notif + logout | Medium |
| `EditProfilePage` | Form + image upload | Medium |
| `LocPage` | Map + permission + fallback | High |
| `AppShell` | Bottom nav state preservation | High |
| `ConfirmationBottomSheet` | Booking flow kritis | High |
| `DatePickerHorizontal` widget | Reusable, 7-day picker | Medium |
| `DoctorCard` widget | Reusable, muncul di 3+ tempat | High |
| `StatusBadge` widget | Reusable, color consistency | Medium |
| `AppointmentCard` widget | Reusable di history + home | High |
| `DoctorInfoCard` widget | Detail page layout | Low |
| `BannerCarousel` widget | Home page | Medium |

#### 🔴 HIGH — Unit Tests Hilang untuk Komponen Penting

| Komponen | Penting Karena | Severity |
|---|---|---|
| `CacheService` (TDD 08) | Offline behavior | High |
| `AppServices` (TDD 04) | Global state lifecycle | High |
| `AppRouter` redirect logic (TDD 03) | Auth gate, kompleks | High |
| `Debouncer` (TDD 10 §2) | Search debounce, time-based | High |
| `DateFormatter` | Timezone, format consistency | Medium |
| `ErrorHandler.mapToFailure()` (TDD 06) | Error mapping chain | High |
| `FcmService` (TDD 09) | Token lifecycle | High |
| `AuthRemoteDataSource` | Raw API call testing | Medium |
| `BookingRemoteDataSource` | Raw API call + 409/422 handling | High |
| `DoctorRemoteDataSource` | Search + filter + pagination | Medium |
| `OnboardingNotifier` | ChangeNotifier testing | Medium |
| `CreateProfileCubit` | Image upload flow | High |
| `EditProfileCubit` | Save + image update | Medium |
| `ProfileCubit.logout()` | Session cleanup | High |
| `ProfileCubit.toggleNotification()` | Persist preference | Medium |
| `LocCubit` | Permission + fallback | High |
| `CreateProfileUseCase` | Image upload orchestration | High |
| `UpdateProfileUseCase` | Patch + image | Medium |
| `LogoutUseCase` | Session clear | High |
| `GetBannersUseCase` | Caching strategy | Medium |
| `GetUpcomingUseCase` | Composite query | Medium |
| `BookingStatus` enum | Parsing edge cases | Low |
| `AppStatus` enum | State transition | Low |
| `ApiException.fromSupabaseError()` | All 5 error types | High |
| `FailureCode` mapping | All 11 codes | High |

#### 🟡 MEDIUM — Integration Tests Hilang

| Flow | Penting Karena | Severity |
|---|---|---|
| Forgot password end-to-end | OTP + reset (TDD 04 §4.3) | High |
| Profile edit end-to-end | Image upload + save | Medium |
| Logout → redirect | Session cleanup | High |
| FCM tap → deep link navigation | Notification routing (TDD 09 §4) | High |
| Deep link entry (app killed) | Cold start path | High |
| First-time onboarding (cold start) | Onboarding → sign-in redirect | Medium |
| Token refresh mid-flow | 401 → refresh → retry (TDD 06 §4.2) | High |
| Offline scenario | Network down behavior | High |
| Network restored | Re-sync after offline | Medium |
| App killed during submit | Resume state | Medium |
| Sign in with Google OAuth | OAuth flow + callback | High |
| Sign in with Facebook (disabled) | Snackbar fallback | Low |

### 1.5 Coverage Threshold — Tidak Didefinisikan

TDD 10 tidak menentukan:
- Minimum line coverage % (e.g., 80%)
- Minimum branch coverage % (e.g., 70%)
- Coverage gate per file/layer
- Per-file exclusion rules (generated files, dll)

### 1.6 Per-Class Test Gap Detail

#### UseCase — 0 dari 15+ yang di-test

TDD 12 Fase 11 sama sekali **tidak mendaftarkan test untuk UseCase** manapun, padahal TDD 10 §2.1 target 15 UseCase test.

Padahal setiap UseCase punya logic penting:
- `LoginWithEmailUseCase` — input validation
- `CreateAppointmentUseCase` — slot + complaint validation
- `GetBookingHistoryUseCase` — filter + pagination
- `GetNearbyClinicsUseCase` — radius validation
- `UploadAvatarUseCase` — file size + type validation

#### Cubit/BLoC — Hanya 6 dari 14 yang di-test

| BLoC/Cubit | TDD 12 Task | Status |
|---|---|---|
| SignInBloc | 11.4 | ✅ |
| SignUpBloc | 11.5 | ✅ |
| ForgotPasswordCubit | 11.12 | ✅ |
| CreateProfileCubit | ❌ | Missing |
| OnboardingNotifier | ❌ | Missing |
| HomeCubit | 11.11 | ✅ (basic only) |
| SearchCubit | 11.6 | ✅ (basic only) |
| DoctorDetailCubit | 11.7 | ✅ (basic only) |
| LocCubit | ❌ | Missing |
| BookingBloc | 11.8 | ✅ |
| BookingHistoryCubit | 11.9 | ✅ |
| BookingDetailCubit | 11.10 | ✅ |
| ProfileCubit | ❌ | Missing |
| EditProfileCubit | ❌ | Missing |

#### DataSource — 0 di-test

Semua DataSource (Auth, Doctor, Booking, Profile, dll) **tidak punya test** padahal layer ini krusial untuk validasi format request Supabase.

---

## 2. Testability (DI + Mocking) — 78 / 100

### 2.1 Yang Sudah Matang

- **`injectable` + `get_it`** stack (TDD 07) → mature, code-generated DI
- **Repository pattern** dengan abstract interface di domain layer → fully mockable
- **UseCase pattern** sebagai single function class → trivial to mock
- **`@factory` lifecycle** untuk BLoC/Cubit → fresh instance per test (TDD 07 §4.1)
- **`@lazySingleton` untuk Repository** → shared instance, no state pollution
- **`@GenerateNiceMocks`** pattern documented (TDD 10 §6)
- **Environment separation** (`@dev` / `@prod`) untuk swap implementation
- **Contoh test BLoC dengan `blocTest`** sudah idiomatic (TDD 10 §2.2)
- **Mock untuk 5 critical dependency** (Auth/Doctor/Booking Repo, AppServices, SupabaseClient)

### 2.2 Masalah Testability

| # | Masalah | Dampak | Severity |
|---|---|---|---|
| 1 | **SupabaseClient mocking sangat kompleks** — `SupabaseClient` punya 30+ method, generated mock akan sangat besar | Integration test sulit di-swap ke mock | High |
| 2 | **AppServices extends ChangeNotifier** (TDD 04) — bukan abstract | Tidak bisa mock langsung, harus extend atau pakai `MockAppServices` yang return `null` for `notifyListeners()` | Medium |
| 3 | **AppRouter `@lazySingleton`** — susah swap di integration test | Route testing terbatas | High |
| 4 | **FcmService** tanpa abstraction layer (TDD 09) | Test FCM butuh real Firebase atau mock Firebase plugin | High |
| 5 | **TDD 10 §6 mock SupabaseClient** — tidak ada pattern untuk override `getInstance()` | Test boot ulang harus reset global state | High |
| 6 | **No `ProviderScope` / `MultiBlocProvider` override pattern** didokumentasikan | Widget test harus rebuild widget tree | Medium |
| 7 | **No `flutter_test_config.dart`** | Global test setup (timezone, locale) tidak terpusat | Medium |
| 8 | **No `SharedPreferences.setMockInitialValues({})`** pattern didokumentasikan | CacheService test harus setup manual | Medium |
| 9 | **No `connectivity_plus` mock pattern** | Offline test tidak bisa di-trigger | High |
| 10 | **No `FirebaseMessaging` mock** | FCM test harus dependency injection abstraction | High |
| 11 | **No `mocktail` consideration** | TDD 10 hanya mockito — alternatif tanpa code-gen terabaikan | Low |
| 12 | **No `fake_async` for time-based tests** | Debouncer, retry timeout test sulit | Medium |
| 13 | **No `bloc_test` golden state verification** | State machine diagram tidak auto-verify | Medium |
| 14 | **No abstraction untuk `Platform.isAndroid`/`isIOS`** | FCM token test selalu return salah satu | Medium |
| 15 | **No `freezed` testing utility** untuk sealed class | Equality test verbose | Low |
| 16 | **No `golden_toolkit` untuk snapshot test** | Visual regression tidak tertangkap | Low |

### 2.3 Konkret Mock Examples yang Seharusnya Ada di TDD 10

```dart
// ── Mock 1: Repository (sudah ada) ──
@GenerateNiceMocks([MockSpec<AuthRepository>()])
class MockAuthRepository extends Mock implements AuthRepository {}

// ── Mock 2: DataSource (MISSING) ──
@GenerateNiceMocks([MockSpec<AuthRemoteDataSource>()])
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

// ── Mock 3: SupabaseClient wrapper (MISSING) ──
abstract class SupabaseWrapper {
  Future<dynamic> from(String table);
  Future<dynamic> rpc(String name, Map<String, dynamic> params);
  // ... abstract all used methods
}

@Injectable(as: SupabaseWrapper)
class SupabaseWrapperImpl implements SupabaseWrapper {
  final SupabaseClient _client;
  // delegate to _client
}

// In test:
class MockSupabaseWrapper extends Mock implements SupabaseWrapper {}

// ── Mock 4: SharedPreferences (MISSING pattern) ──
SharedPreferences.setMockInitialValues({});
final prefs = await SharedPreferences.getInstance();

// ── Mock 5: FirebaseMessaging (MISSING abstraction) ──
abstract class FcmWrapper {
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
  Future<void> requestPermission();
}

@Injectable(as: FcmWrapper)
class FcmWrapperImpl implements FcmWrapper { /* FirebaseMessaging.instance */ }

// ── Mock 6: Connectivity (MISSING pattern) ──
class MockConnectivity extends Mock implements Connectivity {}
when(() => mockConnectivity.onConnectivityChanged)
    .thenAnswer((_) => Stream.value(ConnectivityResult.none));
```

---

## 3. Edge Cases Coverage — 60 / 100

### 3.1 Edge Cases yang Sudah Tertangani

| Edge Case | Lokasi | Status |
|---|---|---|
| Retry strategy | TDD 06 §6 | ✅ Documented |
| Token auto-refresh | TDD 06 §4.2 + §7 | ✅ Documented |
| State machine transitions | TDD 04 §5 | ✅ Diagrammed |
| Router redirect edge cases | TDD 03 §3.3 | ✅ Documented |
| 401 → logout | TDD 06 §3 + TDD 03 §3.3 | ✅ Documented |
| Invalid credentials | TDD 10 §2.2 | ✅ Test example |
| Slot conflict 409 | TDD 10 §4.1 | ✅ Test example |
| Email/password validation | TDD 04 §4.1 | ⚠️ Partial |
| Empty search result | TDD 04 §5.3 | ✅ Diagram |

### 3.2 Edge Cases yang MISSING (50+ identified)

#### 🔴 HIGH — Critical Failures

| # | Edge Case | Impact | Test Type |
|---|---|---|---|
| 1 | **Network timeout** (10s query, 15s mutation per TDD 06 §6.1) | User stuck di loading, no feedback | Unit + Integration |
| 2 | **401 Unauthorized di tengah flow** (bukan saat initial) | App harus auto-refresh + retry, atau logout | Integration |
| 3 | **Token expired saat edit profile** | Save gagal, harus handle gracefully | Unit |
| 4 | **Slot race condition 409** (user pilih slot yg baru di-booking orang lain) | Booking fail, harus refresh | Unit (already partial) |
| 5 | **GPS permission denied** (LocCubit) | Fallback input kota harus muncul | Unit + Widget |
| 6 | **No internet mid-booking** (saat isi form) | Snackbar + form state preserved | Integration |
| 7 | **App killed saat submit booking** | Resume harus ke state aman | Integration |
| 8 | **FCM token rotation** (TDD 09 §2 step 4) | Token harus re-upsert | Unit |
| 9 | **Push notification arrives while on form** | Form state harus preserved | Integration |
| 10 | **Logout while BLoC loading** | Memory leak risk, BLoC harus di-dispose | Unit |
| 11 | **Token refresh race** (multiple 401 simultaneously) | Multiple refresh calls | Unit |
| 12 | **Booking with very long complaint** (>300 char) | Counter validation | Widget (already partial) |
| 13 | **Special characters in search query** (SQL injection) | PostgREST safe, tapi encoding test | Unit |
| 14 | **Concurrent BLoC state emissions** (race condition) | State tidak konsisten | Unit |

#### 🟡 MEDIUM — UX Edge Cases

| # | Edge Case | Impact | Test Type |
|---|---|---|---|
| 15 | **Empty body response** (204 No Content) | Parser crash risk | Unit |
| 16 | **Malformed JSON** (server bug) | ApiException parsing | Unit |
| 17 | **Database constraint violation** (double-booking at DB) | ERD §4.4 trigger fires | Unit |
| 18 | **Avatar file terlalu besar** (>5MB) | API 400 + UX | Widget |
| 19 | **Image picker cancellation** | State harus preserved | Widget |
| 20 | **Email not confirmed** (sign in) | Dialog flow | Widget |
| 21 | **OAuth cancellation** (user cancel Google) | No error snackbar | Integration |
| 22 | **OTP expired** (5 min default) | Resend flow | Unit |
| 23 | **Wrong OTP multiple times** (lockout?) | Throttling | Unit |
| 24 | **Email already exists** (sign up) | Error display | Widget |
| 25 | **Date in past** for booking | Validation | Widget |
| 26 | **Slot before now** (jam 9 lewat, slot 09:00) | Disable select | Widget |
| 27 | **Unicode in nickname/email** (emoji, aksen) | Encoding | Unit |
| 28 | **Timezone change mid-booking** (user travels) | Slot time confusion | Integration |
| 29 | **DST transition** (jam 02:00 → 03:00) | Slot calculation | Unit |
| 30 | **Very long list pagination** (1000+ items) | Memory + scroll perf | Integration |
| 31 | **Rapid filter changes** (SearchCubit) | Debouncer | Unit |
| 32 | **Filter chip spam click** | State consistency | Unit |
| 33 | **Pull to refresh during loading** | Cancel current request | Unit |
| 34 | **Network restored after offline** | Re-sync behavior | Integration |
| 35 | **Backend sends new enum value** (gender='unknown') | Fallback to .other | Unit |
| 36 | **Backend field removed** (breaking change) | Null safety | Unit |
| 37 | **Supabase project down** | Global error | Integration |
| 38 | **Storage full** (avatar upload) | Error handling | Unit |
| 39 | **Image rotation EXIF** | Upload correct orientation | Unit |

#### 🟢 LOW — Polish Edge Cases

| # | Edge Case | Impact | Test Type |
|---|---|---|---|
| 40 | **Battery low, OS kills app** | State persistence | Integration |
| 41 | **Low memory, OS kills background BLoC** | State restore | Integration |
| 42 | **App update while in use** | Migration | Integration |
| 43 | **Time format edge cases** (midnight, 23:59) | Display | Unit |
| 44 | **Booking → FCM arrives → user not on app** | Deep link | Integration |
| 45 | **Multiple device login same user** | Multi-token management | Unit |
| 46 | **Slot already booked saat user buka detail tapi tidak refresh** | Stale data | Integration |
| 47 | **Forgot password rapid click "Send Code"** | Throttle | Unit |
| 48 | **Sign in rapid click "Sign In"** | Disable button | Widget |
| 49 | **Tap notification dari tray, app killed** | Cold start navigation | Integration |
| 50 | **Booking success → user back button instead of CTA** | State consistency | Integration |

### 3.3 TDD 10 Test Examples — Coverage Analysis

| Test | Happy Path | Error Path | Edge Case | Verdict |
|---|:---:|:---:|:---:|---|
| SignInBloc email success | ✅ | — | — | ⚠️ Minimal |
| SignInBloc email error | — | ✅ (invalid_credentials) | — | ⚠️ Only 1 error |
| UserModel.fromJson | ✅ | — | — | ⚠️ No null test |
| UserModel null fields | — | — | ✅ | ✅ |
| SignInPage validation | — | ✅ (empty email) | — | ⚠️ Minimal |
| booking_flow integration | ✅ | — | — | ⚠️ Happy only |

**Pattern:** Tests fokus pada happy path + 1 error. Edge cases 90% tidak ada.

---

## 4. Poin Perbaikan Strategi TDD

### 4.1 HIGH Priority (Blokir Sprint 1)

| ID | Judul | Kategori | File Target | Rekomendasi |
|---|---|---|---|---|
| H1 | **Tambah test untuk AppRouter redirect logic** (TDD 03 §3) | Test Coverage | `test/core/router/app_router_test.dart` | Test 5 skenario: loading, onboarding, unauth, auth, deep link. Gunakan `MockAppServices` |
| H2 | **Tambah test untuk AppServices state lifecycle** | Test Coverage | `test/core/services/app_services_test.dart` | Test `init()`, `login()`, `logout()`, `completeOnboarding()`, `connectivity listener` |
| H3 | **Buat abstract wrapper untuk SupabaseClient** | Testability | `lib/core/network/supabase_wrapper.dart` | Interface tipis yang delegate ke `SupabaseClient`. Mockable di integration test |
| H4 | **Buat abstract wrapper untuk FirebaseMessaging** | Testability | `lib/core/services/fcm_wrapper.dart` | Interface untuk FCM operations. Mockable |
| H5 | **Tambah `flutter_test_config.dart`** untuk global setup | Testability | `test/flutter_test_config.dart` | Setup timezone, locale, suppress logs |
| H6 | **Definisikan coverage threshold** (line + branch) | Test Coverage | TDD 10 | Minimum 80% line, 70% branch per file. Exclude generated |
| H7 | **Tambah unit test untuk semua DataSource** | Test Coverage | TDD 12 Fase 11 expansion | Auth, Doctor, Booking, Profile, Banner, Notification — minimum 1 happy + 1 error each |
| H8 | **Tambah test untuk 5 UseCase kritis** | Test Coverage | TDD 12 | Login, CreateAppointment, GetBookingHistory, UploadAvatar, Logout |
| H9 | **Tambah test untuk error mapping chain** (TDD 06) | Test Coverage | `test/core/network/error_handler_test.dart` | Cover all 11 FailureCode + 5 exception types |
| H10 | **Tambah test untuk Token refresh mid-flow** (TDD 06 §4.2) | Edge Case | Integration test | Mock 401 → SDK refresh → retry → success. Verify no data loss |
| H11 | **Tambah test untuk Network timeout** (TDD 06 §6.1) | Edge Case | Unit + Integration | `Future.delayed(11s)` to trigger timeout. Verify fallback |
| H12 | **Tambah test untuk 5 critical Widget page** | Test Coverage | TDD 12 | Onboarding, ForgotPassword, SignUp, CreateProfile, Loc |

### 4.2 MEDIUM Priority (Sprint 1–2)

| ID | Judul | Kategori | File Target | Rekomendasi |
|---|---|---|---|---|
| M1 | **Tambah test untuk Profile (3 BLoC + 2 Page)** | Test Coverage | TDD 12 | ProfileCubit (load, logout, toggle), EditProfileCubit, ProfilePage, EditProfilePage |
| M2 | **Tambah test untuk LocCubit** (permission + fallback) | Test Coverage | TDD 12 | Mock geolocator. Test allow, deny, denied permanently |
| M3 | **Tambah test untuk FcmService** (token lifecycle) | Test Coverage | TDD 12 | Mock FcmWrapper. Test init, token refresh, upsert |
| M4 | **Tambah test untuk 7 missing Cubit** | Test Coverage | TDD 12 | CreateProfile, OnboardingNotifier, EditProfile, Profile, Loc, dll |
| M5 | **Tambah integration test: Forgot password E2E** | Test Coverage | TDD 12 | Email input → OTP verify → new password → redirect sign-in |
| M6 | **Tambah integration test: FCM tap navigation** | Test Coverage | TDD 12 | Kill app → tap notification → cold start → route ke detail |
| M7 | **Tambah integration test: Deep link entry** | Test Coverage | TDD 12 | `healthpal://doctor/:id` deep link → open detail page |
| M8 | **Tambah test untuk AppShell branch switching** | Test Coverage | TDD 12 | Tap tab 1 → tab 2 → tab 1. Verify state preserved |
| M9 | **Tambah test untuk Debouncer + DateFormatter** | Test Coverage | TDD 12 | Use `fake_async`. Test 300ms delay, cancel, DST edge case |
| M10 | **Tambah test untuk Connectivity listener** | Test Coverage | TDD 12 | Mock Connectivity. Test online→offline, offline→online |
| M11 | **Tambah test untuk concurrent BLoC emissions** | Edge Case | TDD 12 | Rapid filter changes, race condition with `pumpAndSettle` |
| M12 | **Tambah test untuk offline behavior** | Edge Case | TDD 12 | Mock NetworkException → verify fallback to cache + banner |
| M13 | **Tambah test untuk OAuth flow (Google)** | Edge Case | TDD 12 | Mock OAuth success, cancellation, error |
| M14 | **Tambah test untuk avatar upload** | Edge Case | TDD 12 | File > 5MB, wrong type, network failure |
| M15 | **Tambah test untuk pagination edge cases** | Edge Case | TDD 12 | Empty page, single item, max page, invalid offset |
| M16 | **Tambah test untuk enum fallback** | Edge Case | TDD 12 | Backend returns unknown enum value → fallback to default |
| M17 | **Dokumentasikan `ProviderScope` override pattern** | Testability | TDD 10 | Contoh widget test dengan custom BLoC state |
| M18 | **Tambah SharedPreferences mock pattern** | Testability | TDD 10 | `SharedPreferences.setMockInitialValues({})` example |
| M19 | **Tambah `mocktail` evaluation** | Testability | TDD 10 | Alternatif tanpa code-gen, lebih cepat kompilasi |
| M20 | **Tambah test untuk semua reusable widget** | Test Coverage | TDD 12 | DoctorCard, StatusBadge, AppointmentCard, DatePickerHorizontal |

### 4.3 LOW Priority (Sprint 2–3)

| ID | Judul | Kategori | Rekomendasi |
|---|---|---|---|
| L1 | **Tambah `golden_toolkit` untuk snapshot test** | Test Coverage | Visual regression untuk DoctorCard, StatusBadge |
| L2 | **Tambah property-based testing untuk slot logic** | Edge Case | `package:fast_check` untuk generate random date/slot |
| L3 | **Tambah mutation testing** (`muton` atau `dart_mutant`) | Test Quality | Verifikasi quality of test, bukan hanya coverage |
| L4 | **Tambah performance benchmark test** | Performance | Target: <50ms parsing 100 doctors. Pakai `Stopwatch` di test |
| L5 | **Tambah accessibility test** (semantics) | A11y | Verify semantic label, contrast ratio |
| L6 | **Tambah localization test** (i18n) | Quality | Test semua string di `intl_en.arb` / `intl_id.arb` |
| L7 | **Tambah security test** (token tidak bocor di log) | Security | Verify `print()` tidak print token, error message tidak expose detail |
| L8 | **Tambah CI pipeline** (GitHub Actions) | DevOps | `flutter test` + `flutter analyze` + coverage gate |
| L9 | **Tambah `codecov` integration** | DevOps | Auto coverage report + PR comment |
| L10 | **Pre-commit hook** untuk run test | DevOps | `lefthook` atau `husky` |
| L11 | **Tambah test untuk timezone + DST** | Edge Case | `timezone` package, test region changes |
| L12 | **Tambah test untuk backend field removal** | Edge Case | Mock response tanpa field → expect graceful null |
| L13 | **Tambah test untuk backend new enum value** | Edge Case | Mock response dengan unknown value → fallback |
| L14 | **Tambah test untuk very long list** (1000+ items) | Performance | Memory + scroll perf test |
| L15 | **Dokumentasikan test naming convention** (AAA / GWT) | Quality | Should/Given-When-Then pattern |
| L16 | **Tambah test data factory pattern** | Quality | `factory` class untuk complex object (Doctor with nested Clinic, Specialization) |
| L17 | **Tambah test untuk Supabase project down** | Edge Case | Mock global timeout → graceful error |
| L18 | **Tambah test untuk image EXIF rotation** | Edge Case | Upload rotated image → server receives correct orientation |
| L19 | **Tambah test untuk state persistence** | Edge Case | Refresh page in StatefulShellRoute → state retained |
| L20 | **Tambah test untuk rapid button click** | Edge Case | Throttle CTA, prevent double submit |

---

## 5. Rekomendasi Tambahan

### 5.1 Buat Test Helper Library

```dart
// test/helpers/test_data.dart
class TestData {
  static UserEntity mockUser({String? id, String? email}) => UserEntity(
    id: id ?? 'user-123',
    email: email ?? 'test@example.com',
    fullName: 'Test User',
    nickname: 'Tester',
    gender: Gender.male,
  );
  
  static DoctorEntity mockDoctor({String? id, String? name}) => DoctorEntity(
    id: id ?? 'doc-123',
    fullName: name ?? 'dr. Test',
    clinicId: 'clinic-123',
    specializationId: 'spec-123',
    experienceYears: 5,
    consultationFee: 100000,
    ratingAvg: 4.5,
    ratingCount: 100,
  );
  
  // ... factory untuk semua Entity
}

// test/helpers/mock_factories.dart
class MockFactories {
  static MockAuthRepository mockAuthRepo({required Result<UserEntity> result}) {
    final mock = MockAuthRepository();
    when(() => mock.loginWithEmail(any(), any())).thenAnswer((_) async => result);
    return mock;
  }
  // ... factory untuk semua repo
}
```

### 5.2 Coverage Enforcement

```yaml
# .github/workflows/test.yml
- name: Run tests
  run: flutter test --coverage
- name: Check coverage
  run: |
    COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')
    if (( $(echo "$COVERAGE < 80" | bc -l) )); then
      echo "Coverage $COVERAGE% < 80% — failing build"
      exit 1
    fi
```

### 5.3 Standard Test Pattern

```dart
// ── Test naming: should_xxx_when_yyy ──
void main() {
  group('SignInBloc', () {
    late SignInBloc bloc;
    late MockAuthRepository mockRepo;
    late MockAppServices mockAppServices;
    
    setUp(() {
      mockRepo = MockAuthRepository();
      mockAppServices = MockAppServices();
      bloc = SignInBloc(mockRepo, mockAppServices);
    });
    
    tearDown(() => bloc.close());
    
    blocTest<SignInBloc, SignInState>(
      'should emit [Loading, Success] when login email is valid',
      build: () {
        when(() => mockRepo.loginWithEmail(any(), any()))
            .thenAnswer((_) async => Success(mockUser()));
        when(() => mockAppServices.login()).thenAnswer((_) async {});
        return bloc;
      },
      act: (b) => b.add(SignInEmailSubmitted(email: 'a@b.com', password: 'pass1234')),
      expect: () => [isA<SignInLoading>(), isA<SignInSuccess>()],
      verify: (_) {
        verify(() => mockRepo.loginWithEmail('a@b.com', 'pass1234')).called(1);
        verify(() => mockAppServices.login()).called(1);
      },
    );
    
    // Edge case: network timeout
    blocTest<SignInBloc, SignInState>(
      'should emit [Loading, Error networkError] when API timeout',
      build: () {
        when(() => mockRepo.loginWithEmail(any(), any()))
            .thenAnswer((_) async => Failure(FailureCode.networkError, 'Timeout'));
        return bloc;
      },
      act: (b) => b.add(SignInEmailSubmitted(email: 'a@b.com', password: 'pass1234')),
      expect: () => [isA<SignInLoading>(), isA<SignInError>()],
    );
    
    // ... more test cases
  });
}
```

### 5.4 Buat Dokumen Baru: `docs/tdd/13-testing-conventions.md`

Berisi:
1. Test naming convention (AAA / GWT)
2. Mock generation pattern (`@GenerateNiceMocks`)
3. Coverage threshold per layer
4. Wrapper abstraction pattern (SupabaseWrapper, FcmWrapper, ConnectivityWrapper)
5. Test data factory pattern
6. CI integration (GitHub Actions, codecov)
7. Pre-commit hook setup
8. Common pitfalls (over-mocking, brittle tests, slow tests)

### 5.5 Tambah Test Utilities

```dart
// test/helpers/test_helpers.dart

// ── Async helper ──
Future<void> pumpAndExpect<S>(WidgetTester tester, Stream<S> stream, Matcher matcher) async {
  await tester.pumpAndSettle();
  expect(stream, emitsThrough(matcher));
}

// ── Network exception helper ──
NetworkException timeoutException() => 
    NetworkException('Timeout after 10s');

// ── Sealed class matcher ──
Matcher isLoading<S>() => isA<S>().having((s) => s, 'state', isA<dynamic>());
```

---

## 6. Verdict

**TDD Plan Health Pal punya fondasi testing yang cukup (68/100) tapi ada gap signifikan yang harus ditutup.**

### Positif
- ✅ Strategi mock mature (mockito + injectable)
- ✅ 3 integration test didefinisikan
- ✅ Test pyramid jelas
- ✅ Coverage target per fitur ditabulasikan
- ✅ Folder structure test terorganisir

### Perlu Diperkuat
- ⚠️ **TDD 12 actual tasks hanya 22 dari 75 target** — gap 53 test (-71%)
- ⚠️ **Halaman kritis tanpa widget test**: Onboarding, ForgotPassword, SignUp, CreateProfile, Loc
- ⚠️ **5 UseCase kritis tanpa unit test** (Login, CreateAppointment, dll)
- ⚠️ **Semua DataSource tanpa test**
- ⚠️ **8 BLoC/Cubit tanpa test** (CreateProfile, Profile, EditProfile, Loc, Onboarding)
- ⚠️ **Tidak ada wrapper untuk Supabase/Firebase** → integration test terbatas
- ⚠️ **50+ edge cases missing** (network timeout, 401 mid-flow, race condition, timezone, OAuth, dll)
- ⚠️ **Tidak ada coverage threshold enforcement**

### Setelah 12 High Priority di-address
- Test Coverage: 65 → **88** (50+ test baru)
- Testability: 78 → **90** (wrappers + patterns)
- Edge Cases: 60 → **80** (timeout, 401, race, OAuth, DST, dll)
- **Keseluruhan: 68 → 86/100**

### Risiko Jika Tidak Di-address
- 🔴 **Regression risk tinggi** untuk Profil, Edit Profile, Onboarding (no test)
- 🔴 **Integration risk** untuk deep link, FCM navigation, OAuth (no test)
- 🔴 **Edge case bug** untuk network timeout, 401 mid-flow, race condition (no test)
- 🟡 **CI/CD tidak ada test gate** → bug bisa lolos ke production

---

## 7. Action Items Ringkas

| # | ID | Tindakan | Owner | Target |
|---|---|---|---|---|
| 1 | H1, H2 | Test AppRouter + AppServices | QA Lead | Sebelum Sprint 1 |
| 2 | H3, H4 | Buat SupabaseWrapper + FcmWrapper | Tech Lead | Sebelum Sprint 1 |
| 3 | H5, H6 | flutter_test_config.dart + coverage threshold | QA Lead | Sebelum Sprint 1 |
| 4 | H7, H8, H9 | Test semua DataSource + 5 UseCase + ErrorHandler | Backend QA | Sprint 1 |
| 5 | H10, H11 | Test token refresh + network timeout | QA Lead | Sprint 1 |
| 6 | H12 | Test 5 critical widget page | Frontend QA | Sprint 1 |
| 7 | M1–M4 | Test Profile, Loc, FcmService, 7 missing Cubit | QA | Sprint 2 |
| 8 | M5, M6, M7 | Integration: Forgot password, FCM tap, Deep link | QA Lead | Sprint 2 |
| 9 | M8–M10 | Test AppShell, Debouncer, DateFormatter, Connectivity | QA | Sprint 2 |
| 10 | M11–M16 | Test concurrent, offline, OAuth, avatar, pagination, enum | QA | Sprint 2 |
| 11 | M17–M19 | Dokumentasi patterns (ProviderScope, SharedPref mock, mocktail) | Tech Lead | Sprint 2 |
| 12 | M20 | Test semua reusable widget | Frontend QA | Sprint 2 |
| 13 | L1, L2, L4 | Golden test + property-based + perf benchmark | QA | Sprint 3 |
| 14 | L8, L9, L10 | Setup CI + codecov + pre-commit hook | DevOps | Sprint 3 |
| 15 | L11–L20 | Polish & advanced edge cases | QA | Sprint 3+ |

---

*Dokumen ini merupakan audit snapshot untuk TDD Plan. Setiap perubahan strategi testing, penambahan UseCase/BLoC baru, atau lib dependency harus memicu re-audit untuk menjaga alignment skor di atas 80/100.*
