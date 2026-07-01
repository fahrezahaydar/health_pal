# Test Coverage Baseline — Health Pal

| Field | Detail |
|---|---|
| **Tanggal Audit** | 1 Juli 2026 |
| **Auditor** | Tech Lead (MiniMax-M3) |
| **Versi** | v1.0 |
| **Status Post-Audit** | 🔴 **0% test coverage** — `test/` folder kosong (hanya helpers + flutter_test_config + .gitkeep) |
| **Acuan** | `sprint_b1_unit_testing.md` §2.1 (State of Test Layer) · `docs/tdd/10-testing.md` · `AGENTS.md` §"Sprint 1 — Testing Policy" |
| **Target Pasca-Sprint-B1** | Core ≥ 90%, Data ≥ 60%, Domain ≥ 70%, Presentation ≥ 50% |

---

## Ringkasan Eksekutif

🟡 **Project health_pal Post-Sprint A9: 100% fitur MVP complete, 0% test coverage.**

- Total Dart files di `lib/` (excl. generated): **232 files**
- Total test files (`*_test.dart`): **0 files** 🔴
- Test infrastructure: **80% siap** (helpers + flutter_test_config + mocks scaffolding) — hanya butuh extend + regenerate
- Actual unit test = **0** (semua `test/features/**/.gitkeep` adalah placeholder kosong)

**Implikasi:**
- 100+ business logic (use case, repository, cubit) tanpa test safety net
- 0 BUG regression test (BUG-002-FIX-3, Sprint 2 A2, A5 tidak punya jaring pengaman)
- CI/CD belum bisa setup (butuh test stabil dulu)
- Coverage delta unknown sampai Sprint B1 selesai

---

## 1. Snapshot `test/` Folder (Pre-Sprint-B1)

| File | Size | Status | Catatan |
|---|---:|---|---|
| `test/flutter_test_config.dart` | 999 B | ✅ Ready | Setup timezone, locale, SharedPreferences mock. Otomatis dipanggil `flutter test`. |
| `test/helpers/mocks.dart` | 1897 B | ⚠️ Partial | 11 MockSpec (Auth: 3, Home: 3, Doctor: 5). **Belum include** Booking/Loc/Profile/Settings. |
| `test/helpers/mocks.mocks.dart` | 40336 B | ✅ Generated | 1108 baris auto-generated via `build_runner`. Perlu regenerate setelah extend `mocks.dart`. |
| `test/helpers/test_helpers.dart` | 4347 B | ⚠️ Partial | `TestData` factory untuk UserEntity, Banner, Specialization, Upcoming, UserProfile. **Belum include** Doctor, Clinic, Appointment, Notification, DoctorSlot, DoctorSchedule. |
| `test/features/auth/.gitkeep` | 0 B | 🟡 Placeholder | Folder ada tapi kosong. |
| `test/features/home/.gitkeep` | 0 B | 🟡 Placeholder | Folder ada tapi kosong. |
| `test/features/booking/` | — | ❌ Missing | Folder belum dibuat. |
| `test/features/doctor/` | — | ❌ Missing | Folder belum dibuat. |
| `test/features/loc/` | — | ❌ Missing | Folder belum dibuat. |
| `test/features/profile/` | — | ❌ Missing | Folder belum dibuat. |
| `test/features/settings/` | — | ❌ Missing | Folder belum dibuat. |
| `test/features/onboarding/` | — | ❌ Missing | Folder belum dibuat. |
| `test/core/` | — | ❌ Missing | Folder belum dibuat. |

**Actual test files** (`*_test.dart`): **0** 🔴

---

## 2. Testable File Mapping per Layer

### 2.1 `core/enums/` (4 enum — fully testable)

| File | Testable? | Coverage Target | Note |
|---|:---:|:---:|---|
| `core/enums/booking_status.dart` | ✅ | 80% | 5 enum value + @JsonValue (Sprint 2 A5). 4 test case. |
| `core/enums/failure_code.dart` | ✅ | 80% | 11 enum value. 11 test case. |
| `core/enums/gender.dart` | ✅ | 80% | 2 enum value. 2 test case. |
| `core/enums/app_status.dart` | ✅ | 80% | Multi enum (auth/lifecycle status). |

### 2.2 `core/network/` (4 file — pure logic)

| File | Testable? | Coverage Target | Note |
|---|:---:|:---:|---|
| `core/network/result.dart` | ✅ | 90% | Sealed `Result<T>` + factory. |
| `core/network/api_exception.dart` | ✅ | 90% | Exception class. |
| `core/network/error_handler.dart` | ✅ | 90% | **Paling kompleks** — 7 exception type mapping + P0001 message parsing + `handleWithAuthCheck` callback. Estimasi 1.5h. |
| `core/network/json_converters.dart` | ✅ | 90% | `DateOnlyJsonConverter` + `TimeOnlyJsonConverter` + `DateTimeJsonConverter`. |

### 2.3 `core/utils/` (4 file — pure function, 0 dependency)

| File | Testable? | Coverage Target | Note |
|---|:---:|:---:|---|
| `core/utils/validators.dart` | ✅ | 100% | 5 static method (email, password, phone, required, maxChars). |
| `core/utils/date_formatter.dart` | ✅ | 100% | 10+ static method (id_ID locale, Indonesian month names). |
| `core/utils/debouncer.dart` | ✅ | 100% | Class dengan `Timer`. Butuh `fakeAsync`. |
| `core/utils/retry.dart` | ✅ | 100% | Exponential backoff. Butuh `fakeAsync` atau inject Duration. |

### 2.4 `core/services/` (4 file — sebagian testable)

| File | Testable? | Coverage Target | Note |
|---|:---:|:---:|---|
| `core/services/cache_service.dart` | ✅ | 70% | SharedPreferences wrapper. **Mudah di-test** dengan `setMockInitialValues`. |
| `core/services/app_services.dart` | ❌ | — | Singleton + statik. **Butuh refactor ke interface** untuk testability. Defer ke Sprint B2. |
| `core/services/shared_prefs.dart` | ❌ | — | Similar. Defer. |
| `core/services/fcm_service.dart` | ❌ | — | Firebase Messaging integration. Defer. |

### 2.5 `data/datasource/` (7 file — butuh mock SupabaseClient)

| File | Testable? | Note |
|---|:---:|---|
| `data/datasource/auth_remote_datasource.dart` | 🟡 | Butuh mock SupabaseClient `.from().select()...` chain. **Indirect** via repository test. |
| `data/datasource/auth_local_datasource.dart` | 🟡 | Similar. |
| `data/datasource/home_remote_datasource.dart` | 🟡 | 4 method. |
| `data/datasource/home_local_datasource.dart` | 🟡 | Cache layer. |
| `data/datasource/doctor_remote_datasource.dart` | 🟡 | 5 method. |
| `data/datasource/booking_remote_datasource.dart` | 🟡 | Edge function call. |
| `data/datasource/loc_remote_datasource.dart` | 🟡 | PostgREST RPC. |
| `data/datasource/profile_remote_datasource.dart` | 🟡 | Multiple method. |

> **Decision**: DataSource di-test **tidak langsung**. Test dilakukan via Repository (yang mock DataSource) per AD-5 sprint plan. Lebih simple + cover orchestration logic sekaligus.

### 2.6 `data/model/` (12 file — fully testable)

| File | Testable? | Note |
|---|:---:|---|
| `data/model/auth/user_model.dart` | ✅ | fromJson + toJson + toEntity + fromEntity. Manual (bukan @freezed). |
| `data/model/home/banner_model.dart` | ✅ | @freezed |
| `data/model/home/specialization_model.dart` | ✅ | @freezed |
| `data/model/home/upcoming_appointment_model.dart` | ✅ | @freezed + DateOnlyJsonConverter + BookingStatus enum (BUG regression). |
| `data/model/home/user_profile_model.dart` | ✅ | @freezed |
| `data/model/doctor/doctor_model.dart` | ✅ | @freezed + nested (clinic + specialization). |
| `data/model/doctor/doctor_schedule_model.dart` | ✅ | @freezed + dayOfWeek enum. |
| `data/model/doctor/doctor_slot_model.dart` | ✅ | @freezed + isBooked bool. |
| `data/model/doctor/clinic_model.dart` | ✅ | @freezed |
| `data/model/booking/appointment_model.dart` | ✅ | @freezed + nested deeply (doctor + slot). |
| `data/model/loc/clinic_model.dart` | ✅ | @freezed |
| `data/model/profile/notification_model.dart` | ✅ | @freezed + isRead bool. |

### 2.7 `data/repository/` (7 file — **highest value, P0**)

| File | Testable? | Coverage Target | Note |
|---|:---:|:---:|---|
| `data/repository/auth/auth_repository_impl.dart` | ✅ | 60% | signIn/register/signOut/getCurrentUser. **Paling kompleks** (multipart upload + atomic). 1.5h. |
| `data/repository/home/home_repository_impl.dart` | ✅ | 60% | 4 method. Pattern: remote → cache fallback + `withRetry` + `handleWithAuthCheck`. **BUG regression: Sprint 2 A2**. 1h. |
| `data/repository/doctor/doctor_repository_impl.dart` | ✅ | 60% | 5 method. |
| `data/repository/booking/booking_repository_impl.dart` | ✅ | 60% | 4 method. Edge function call. |
| `data/repository/loc/loc_repository_impl.dart` | ✅ | 60% | PostgREST RPC. |
| `data/repository/profile/profile_repository_impl.dart` | ✅ | 60% | 5 method. |
| `data/repository/settings/settings_repository_impl.dart` | ✅ | 60% | 3 method. |

### 2.8 `domain/entity/` (14 file — pure Equatable)

| File | Testable? | Note |
|---|:---:|---|
| `domain/entity/auth/user_entity.dart` | ✅ | Equatable + copyWith + `mock()` factory. |
| `domain/entity/home/banner_entity.dart` | ✅ | Equatable. |
| `domain/entity/home/specialization_entity.dart` | ✅ | Equatable. |
| `domain/entity/home/upcoming_appointment_entity.dart` | ✅ | Equatable + TimeOfDay field. |
| `domain/entity/home/user_profile_entity.dart` | ✅ | Equatable. |
| `domain/entity/doctor/doctor_entity.dart` | ✅ | Equatable + derived `workingTimeDisplay` getter (logic kompleks). |
| `domain/entity/doctor/doctor_schedule_entity.dart` | ✅ | Equatable. |
| `domain/entity/doctor/doctor_slot_entity.dart` | ✅ | Equatable. |
| `domain/entity/doctor/clinic_entity.dart` | ✅ | Equatable. |
| `domain/entity/booking/appointment_entity.dart` | ✅ | Equatable + 2 nested entity + 9 derived getter. |
| `domain/entity/booking/appointment_doctor_entity.dart` | ✅ | (Nested di appointment_entity). |
| `domain/entity/booking/appointment_slot_entity.dart` | ✅ | (Nested di appointment_entity). |
| `domain/entity/loc/clinic_entity.dart` | ✅ | Equatable. |
| `domain/entity/profile/notification_entity.dart` | ✅ | Equatable. |

### 2.9 `domain/usecase/` (21 file — mostly pass-through)

| Feature | Use Case Count | Total | Note |
|---|:---:|---|---|
| Auth | 4 | login, registerAndCreateProfile, createProfile, forgotPassword | |
| Home | 4 | getBanners, getSpecializations, getUpcomingAppointment, getUserProfile | |
| Doctor | 4 | getDoctors, getDoctorDetail, getDoctorSchedules, getDoctorSlots | |
| Booking | 4 | getAppointmentHistory, getAppointmentDetail, createAppointment, cancelAppointment | |
| Loc | 1 | getNearbyClinics | |
| Profile | 5 | getProfile, updateProfile, getNotifications, markNotificationAsRead, getFavorites | |
| **Total** | **22** | — | Catatan: Profile `update_profile_usecase.dart` punya inner class `UploadAvatarUseCase` — 22 use case dalam 21 file. |

### 2.10 `domain/repository/` (6 file — interface, no impl)

| File | Note |
|---|---|
| `domain/repository/auth_repository.dart` | Interface. Tidak perlu test. |
| `domain/repository/home_repository.dart` | Interface. |
| `domain/repository/doctor_repository.dart` | Interface. |
| `domain/repository/booking_repository.dart` | Interface. |
| `domain/repository/loc_repository.dart` | Interface. |
| `domain/repository/profile_repository.dart` | Interface. |
| `domain/repository/settings_repository.dart` | Interface. |

> **Decision**: Interface abstract TIDAK di-test. Yang di-test = repository **impl**. Tapi `settings_repository.dart` di Pool B2 punya impl langsung (bukan interface) — beda pattern.

### 2.11 `presentation/cubit|bloc|notifier/` (17 file — state machine)

| File | Testable? | Note |
|---|:---:|---|
| `auth/presentation/bloc/sign_in/sign_in_cubit.dart` | ✅ | 2 method (signInWithEmail, signInWithGoogle). |
| `auth/presentation/bloc/create_profile/create_profile_cubit.dart` | ✅ | submit. |
| `auth/presentation/bloc/forget_password/forget_password_state.dart` (contains ForgotPasswordCubit) | ✅ | step transitions. |
| `home/presentation/bloc/greeting/greeting_cubit.dart` | ✅ | **P0 — most critical**. BUG-002-FIX-3 regression. 4 state. |
| `home/presentation/bloc/banner/banner_cubit.dart` | ✅ | loadBanners. |
| `home/presentation/bloc/specialization/specialization_cubit.dart` | ✅ | loadSpecializations. |
| `home/presentation/bloc/upcoming/upcoming_cubit.dart` | ✅ | loadUpcoming. |
| `home/presentation/bloc/nearby/nearby_cubit.dart` | ✅ | 5 state (Initial/Loading/Loaded/Empty/LocationDenied/Error). |
| `doctor/presentation/bloc/search/search_cubit.dart` | ✅ | searchDoctors + debounce. |
| `doctor/presentation/bloc/doctor_detail/doctor_detail_cubit.dart` | ✅ | loadDetail + loadSlots + loadSchedules. |
| `booking/presentation/bloc/booking/booking_bloc.dart` | ✅ | **P0** create appointment event. |
| `booking/presentation/bloc/detail/booking_detail_cubit.dart` | ✅ | loadDetail + cancel. |
| `booking/presentation/bloc/history/booking_history_cubit.dart` | ✅ | **P0 — pagination**. loadMore + filterByStatus + refresh. |
| `loc/presentation/bloc/loc_cubit.dart` | ✅ | requestLocationAndLoad + city fallback. |
| `profile/presentation/bloc/profile/profile_cubit.dart` | ✅ | **P0 — BUG-002-FIX-3 regression**. |
| `profile/presentation/bloc/edit_profile/edit_profile_cubit.dart` | ✅ | submit + uploadAvatar. |
| `profile/presentation/bloc/notification/notification_cubit.dart` | ✅ | load + markAsRead. |
| `profile/presentation/bloc/favorite/favorite_cubit.dart` | ✅ | loadFavorites. |
| `settings/presentation/bloc/settings/settings_cubit.dart` | ✅ | loadSettings + toggle + clearCache. |
| `onboarding/presentation/bloc/onboarding_notifier.dart` | ✅ | **ChangeNotifier** (bukan Cubit). Test pakai `addListener` pattern. |

> Total: **19 cubit/bloc/notifier** (16 cubit/bloc + 1 onboarding notifier + 2 misc).

### 2.12 `presentation/page|widget/` (36+ file — **DEFERRED ke Sprint B2**)

Per AD-1 sprint plan: widget test di-defer. Total 36+ file page+widget tidak masuk Sprint B1.

---

## 3. Testable Unit Count per Layer

| Layer | File Count | Testable Unit | Test File Count Target |
|---|:---:|:---:|:---:|
| `core/enums` | 4 | 4 enum | 3 (app_status tidak masuk B1 plan) |
| `core/network` | 4 | 4 class | 4 |
| `core/utils` | 4 | 4 class/fn | 4 |
| `core/services` (testable portion) | 1 | 1 (CacheService) | 1 |
| `data/model` | 12 | 12 model | 12 |
| `data/repository` | 7 | 7 impl | 7 |
| `domain/entity` | 14 | 14 entity | 10 (per B1 plan — 4 entity nested di-exclude) |
| `domain/usecase` | 21 | 22 use case | 21 (1 file = 2 use case test) |
| `presentation/cubit|bloc|notifier` | 19 | 19 state mgmt | 19 |
| `presentation/page|widget` | 36+ | DEFERRED | 0 (B2) |
| **Total Sprint B1 Scope** | — | — | **~82 test files** |
| **Sprint B1 Plan** | — | — | **~90 test files** (per `sprint_b1_unit_testing.md` §4) |

> **Catatan**: Angka 82 vs 90 ada gap ~8 karena B1 plan include beberapa file yang di-mapping layer berbeda (mis. json_converters, onboarding, settings). Total aktual bisa ±5 tergantung cara hitung.

---

## 4. Baseline Coverage per Layer (Pre-Sprint-B1)

| Layer | Baseline (Pre-B1) | Target Pasca-B1 | Gap |
|---|:---:|:---:|:---:|
| `core/enums` | 0% | 80% | -80% |
| `core/network` | 0% | 90% | -90% |
| `core/utils` | 0% | 90% | -90% |
| `core/services` (CacheService) | 0% | 70% | -70% |
| `data/model` | 0% | 70% | -70% |
| `data/repository` | 0% | 60% | -60% |
| `domain/entity` | 0% | 70% | -70% |
| `domain/usecase` | 0% | 70% | -70% |
| `presentation/cubit|bloc` | 0% | 50% | -50% |
| `presentation/page|widget` | 0% | (deferred B2) | — |
| **Aggregate** | **0%** | **~60% (realistic)** | **-60%** |

---

## 5. Testable Unit Type Breakdown

| Jenis Test | Target Count | Pattern |
|---|:---:|---|
| **Unit test — pure function/enum** | 15 | `test('description', () { ... })` — no mock |
| **Unit test — fromJson/toJson** | 12 | Mock data Map<String, dynamic> |
| **Unit test — Equatable props + copyWith** | 14 | Assertion `expect(entityA, entityB)` |
| **Unit test — Use case delegation** | 21 | `MockRepository` + verify call |
| **Unit test — Repository (3 path pattern)** | 7 | `MockRemoteDataSource` + `MockLocalDataSource` + `MockAppServices` |
| **Bloc test (`blocTest<>`)** | 18 | `blocTest('emit [Loading, Loaded]', build: ..., act: ..., expect: () => [...])` |
| **ChangeNotifier test** | 1 | `addListener` callback verify |
| **Total Sprint B1** | **88** | — |

---

## 6. Action Items (Sprint B1)

| # | Action | Owner | Target |
|---|---|---|---|
| 1 | Extend `mocks.dart` (Tambah 10+ MockSpec) | Frontend | T2 (Day 1) |
| 2 | Extend `test_helpers.dart` (Tambah 8 entity factory) | Frontend | T3 (Day 1) |
| 3 | Add `bloc_test: ^10.0.0` ke pubspec | Frontend | T3a (Day 1) |
| 4 | Regenerate `mocks.mocks.dart` via build_runner | Frontend | T3b (Day 1) |
| 5 | Verify `flutter test` exit 0 baseline (sebelum tambah test baru) | Tech Lead | T3b (Day 1) |
| 6 | Setup `coverage/` folder untuk `--coverage` output | Tech Lead | F2 (Day 5) |

---

## 7. Post-Sprint-B1 Target

| Layer | Target | Rationale |
|---|:---:|---|
| `core/utils/` | **≥ 90%** | Pure function, 0 dependency — **no excuse**. |
| `core/network/` | **≥ 90%** | Pure logic + enum mapping. |
| `core/enums/` | **≥ 80%** | Enum value test. |
| `data/repository/` | **≥ 60%** | 3 path minimum per repo. |
| `domain/usecase/` | **≥ 70%** | 1 success + 1 failure per usecase. |
| `domain/entity/` | **≥ 60%** | Equatable + copyWith. |
| `presentation/cubit/` | **≥ 50%** | State machine 3 path minimum. |
| `data/model/` | **≥ 70%** | fromJson/toJson roundtrip. |
| **Aggregate** | **≥ 60%** | Realistic untuk MVP. |

---

## 8. Files NOT in Sprint B1 Scope (Defer ke B2+)

| Kategori | File Count | Defer To |
|---|:---:|---|
| `presentation/page/` (UI page) | 22+ | Sprint B2 (widget test) |
| `presentation/widget/` di `features/*/presentation/widget/` | 10+ | Sprint B2 |
| `widgets/` (shared widget: badge, card, button, form, dialog) | 40+ | Sprint B2 |
| `core/services/app_services.dart` (singleton + statik) | 1 | Sprint B2 (perlu refactor) |
| `core/services/fcm_service.dart` (Firebase integration) | 1 | Sprint B2 (perlu refactor) |
| `core/services/shared_prefs.dart` (singleton) | 1 | Sprint B2 (perlu refactor) |
| `core/router/app_router.dart` (GoRouter config) | 1 | Sprint B2 |
| `core/theme/*` (theme + icons + text style) | 3 | Sprint B2 |

**Total Defer**: **~80 file** — 1.5-2x Sprint B1 scope.

---

## 9. Kesimpulan & Rekomendasi

🟢 **Mulai Sprint B1**:
1. Pool 0 (setup) **WAJIB** Day 1 — tanpa ini, semua pool lain blocked.
2. Pool A (Core) **P0** — paling ringan + paling cepat selesai. Set baseline `flutter test` exit 0.
3. Pool B (Data) **P0** — model dulu (1 hari), repository kemudian (1 hari).
4. Pool C (Domain) **P0** — paling ringan dari pool substantial (21 use case + 10 entity = 4 jam).
5. Pool D (Presentation) **P1** — bisa di-potong jika overtime (prioritas 6 critical cubit).
6. Pool E (Onboarding + Cache) **P2** — pelengkap.
7. Pool F (Closing) **P0** — verify DoD tercapai + coverage report.

🟡 **Risk Highlight**:
- 0% → 60% coverage = **huge delta**. Butuh disiplin tracking per file.
- `bloc_test` package mungkin ada conflict dengan `flutter_bloc 9.1.1` — fallback ke `test` manual jika ada.
- Mock setup untuk 10+ repository = 1-2 jam setup time, bukan testing time.

🟢 **Quick Win** (jika overtime):
- Pool 0 + A + B = **35 test files** dalam 3 hari = baseline kuat.
- Tunda Pool D (presentation) ke B2 = lebih sustainable.

---

*Disusun oleh Tech Lead (MiniMax-M3) · 1 Juli 2026 · v1.0*
*Refs: `sprint_b1_unit_testing.md` §2.1, `docs/tdd/10-testing.md`, `AGENTS.md`*
