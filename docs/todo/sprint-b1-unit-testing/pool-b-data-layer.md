# Pool B — Data Layer Tests

> **Sprint**: B1 — Unit Testing Foundation
> **Acuan**: `docs/progress/plans/sprint_b1_unit_testing.md` §4.3 (Pool B)
> **Estimasi Total**: 8.9 jam
> **Target Selesai**: Day 3 (3 Juli 2026) EOD

## Ringkasan

| Metrik | Nilai |
|---|---|
| **Nama Pool** | Pool B — Data Layer Tests |
| **Total Item** | 19 |
| **Selesai** | 19 / 19 |
| **Belum** | 0 / 19 |
| **Skip** | 0 / 19 |
| **Coverage Target** | Data layer ≥ 60% line coverage |
| **Estimasi Total** | 8.9 jam |
| **Target Selesai** | Day 3 (3 Juli 2026) EOD |

## Catatan Pool

Pool B = **business logic tertinggi**. Repository impl = orchestration antara remote + local datasource + error mapping. B.1 (Model) ringan karena tinggal test fromJson/toJson. B.2 (Repository) **paling valuable** — bug di layer ini = silent data corruption. Pakai pattern 3 path: remote success, remote failure + cache hit, remote failure + cache miss.

---

## Sub-Group: B.1 — Data Model (12 items, 3.4 jam)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 1 | `UserModel` (Auth) | `test/features/auth/data/model/user_model_test.dart` | `lib/features/auth/data/model/user_model.dart` | Unit test | [x] | B1. 10 test cases: fromJson (4: happy + null optional + missing email fallback + isProfileComplete default) + toJson roundtrip (2) + toEntity (1) + fromEntity (1). `flutter test` ✅ 10/10 pass. |
| 2 | `BannerModel` (Home) | `test/features/home/data/model/banner_model_test.dart` | `lib/features/home/data/model/banner_model.dart` | Unit test | [x] | B2. 4 test cases: fromJson happy + without optionals (displayOrder default) + toEntity. `flutter test` ✅ 4/4 pass. |
| 3 | `SpecializationModel` (Home) | `test/features/home/data/model/specialization_model_test.dart` | `lib/features/home/data/model/specialization_model.dart` | Unit test | [x] | B3. 5 test cases: fromJson happy + without optionals + toEntity matching + toEntity null optionals. `flutter test` ✅ 5/5 pass. |
| 4 | `UpcomingAppointmentModel` (Home) | `test/features/home/data/model/upcoming_appointment_model_test.dart` | `lib/features/home/data/model/upcoming_appointment_model.dart` | Unit test | [x] | B4. 4 test cases: fromJson nested (doctors + slots + converters) + null nested slots + missing nested defaults + toEntity. `flutter test` ✅ 4/4 pass. |
| 5 | `UserProfileModel` (Home) | `test/features/home/data/model/user_profile_model.dart` | `lib/features/home/data/model/user_profile_model.dart` | Unit test | [x] | B5. 4 test cases: fromJson happy + nickname fallback + defaults for missing + toEntity. `flutter test` ✅ 4/4 pass. |
| 6 | `DoctorModel` (Doctor) | `test/features/doctor/data/model/doctor_model_test.dart` | `lib/features/doctor/data/model/doctor_model.dart` | Unit test | [x] | B6. 3 test cases: fromJson with nested (clinic + specialization) + without nested + toEntity. `flutter test` ✅ 3/3 pass. |
| 7 | `DoctorScheduleModel` (Doctor) | `test/features/doctor/data/model/doctor_schedule_model_test.dart` | `lib/features/doctor/data/model/doctor_schedule_model.dart` | Unit test | [x] | B7. 3 test cases: fromJson + defaults + toEntity. `flutter test` ✅ 3/3 pass. |
| 8 | `DoctorSlotModel` (Doctor) | `test/features/doctor/data/model/doctor_slot_model_test.dart` | `lib/features/doctor/data/model/doctor_slot_model.dart` | Unit test | [x] | B8. 5 test cases: fromJson happy + booked + null slot_date/start throw FormatException + toEntity. `flutter test` ✅ 5/5 pass. |
| 9 | `ClinicModel` (Doctor) | `test/features/doctor/data/model/clinic_model_test.dart` | `lib/features/doctor/data/model/clinic_model.dart` | Unit test | [x] | B9. 5 test cases: fromJson happy + without optionals + toJson + toEntity + fromEntity. `flutter test` ✅ 5/5 pass. |
| 10 | `AppointmentModel` (Booking) + nested models | `test/features/booking/data/model/appointment_model_test.dart` | `lib/features/booking/data/model/appointment_model.dart` | Unit test | [x] | B10. 4 test cases: fromJson deeply nested (doctor+slot+specialization+clinic) + missing nested + status as string + toEntity. `flutter test` ✅ 4/4 pass. |
| 11 | `ClinicModel` (Loc) | `test/features/loc/data/model/clinic_model_test.dart` | `lib/features/loc/data/model/clinic_model.dart` | Unit test | [x] | B11. 3 test cases: fromJson with all fields + defaults for missing + toEntity. `flutter test` ✅ 3/3 pass. |
| 12 | `NotificationModel` (Profile) | `test/features/profile/data/model/notification_model_test.dart` | `lib/features/profile/data/model/notification_model.dart` | Unit test | [x] | B12. 3 test cases: fromJson happy + without optional + toEntity. `flutter test` ✅ 3/3 pass. |

---

## Sub-Group: B.2 — Data Repository (7 items, 5.5 jam)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 13 | `AuthRepositoryImpl` | `test/features/auth/data/repository/auth_repository_impl_test.dart` | `lib/features/auth/data/repository/auth_repository_impl.dart` | Unit test (with mocks) | [ ] | B13. Test signInWithEmail success/failure + registerAndCreateProfile (multipart upload mock) + signOut + getCurrentUser + isLoggedIn. **Pool B.2 paling besar**. Estimasi 1.5h. |
| 14 | `HomeRepositoryImpl` | `test/features/home/data/repository/home_repository_impl_test.dart` | `lib/features/home/data/repository/home_repository_impl.dart` | Unit test (with mocks) | [ ] | B14. Test getBanners (remote → cache fallback via withRetry mock) + getUpcoming + getSpecializations + getUserProfile + handleWithAuthCheck callback on 401. **BUG regression: Sprint 2 A2** (getUpcoming order by doctor_slots.slot_date.asc). Estimasi 1h. |
| 15 | `DoctorRepositoryImpl` | `test/features/doctor/data/repository/doctor_repository_impl_test.dart` | `lib/features/doctor/data/repository/doctor_repository_impl.dart` | Unit test (with mocks) | [ ] | B15. Test getDoctors + getDoctorDetail + getDoctorSchedules + getDoctorSlots + getAvailableSlotCount. Estimasi 0.8h. |
| 16 | `BookingRepositoryImpl` | `test/features/booking/data/repository/booking_repository_impl_test.dart` | `lib/features/booking/data/repository/booking_repository_impl.dart` | Unit test (with mocks) | [ ] | B16. Test getHistory (paginated) + getDetail + create (edge function mock) + cancel. Estimasi 0.8h. |
| 17 | `LocRepositoryImpl` | `test/features/loc/data/repository/loc_repository_impl_test.dart` | `lib/features/loc/data/repository/loc_repository_impl.dart` | Unit test (with mocks) | [ ] | B17. Test getNearbyClinics (PostgREST RPC mock). Estimasi 0.4h. |
| 18 | `ProfileRepositoryImpl` | `test/features/profile/data/repository/profile_repository_impl_test.dart` | `lib/features/profile/data/repository/profile_repository_impl.dart` | Unit test (with mocks) | [ ] | B18. Test getProfile + updateProfile + getNotifications + markAsRead + getFavorites. Estimasi 0.6h. |
| 19 | `SettingsRepositoryImpl` | `test/features/settings/data/repository/settings_repository_impl_test.dart` | `lib/features/settings/data/repository/settings_repository_impl.dart` | Unit test (with mocks) | [ ] | B19. Test getSettings + clearCache + toggleNotification. Estimasi 0.4h. |

---

## Definition of Done Pool B

- [ ] 19/19 test file dibuat (12 model + 7 repository)
- [ ] `flutter test test/features/` exit code 0
- [ ] Data layer coverage ≥ 60% line
- [ ] Semua repository test cover 3 path (remote success, remote failure + cache hit, cache miss)
- [ ] `flutter analyze` 0 issues
- [ ] 2 conventional commits: `test(data): model fromJson/toJson` (Day 2) + `test(data): repository impl with mock datasource` (Day 3)

## Commit Target

### Day 2 (B.1 — Models)
```bash
git add -A
git commit -m "test(data): model fromJson/toJson — 12 test files

- B1: UserModel fromJson + toJson + toEntity
- B2: BannerModel
- B3: SpecializationModel
- B4: UpcomingAppointmentModel (nested + DateOnly + BookingStatus)
- B5: UserProfileModel
- B6: DoctorModel (nested clinic + specialization)
- B7: DoctorScheduleModel
- B8: DoctorSlotModel (isBooked + TimeOnly)
- B9: Doctor ClinicModel
- B10: AppointmentModel (deeply nested + DateOnly + TimeOnly + status)
- B11: Loc ClinicModel
- B12: NotificationModel
- Coverage: data/model layer ~80% (target ≥ 70%)"
```

### Day 3 (B.2 — Repositories)
```bash
git add -A
git commit -m "test(data): repository impl with mock datasource — 7 test files

- B13: AuthRepositoryImpl (signIn/register/signOut/getCurrentUser)
- B14: HomeRepositoryImpl (3 path + BUG regression Sprint 2 A2)
- B15: DoctorRepositoryImpl
- B16: BookingRepositoryImpl
- B17: LocRepositoryImpl
- B18: ProfileRepositoryImpl
- B19: SettingsRepositoryImpl
- Pattern: 3 path (success/cache-fail/cache-miss) per repo
- Coverage: data/repository layer ~65% (target ≥ 60%)"
```

## Dependencies

- **Blocked by**: Pool 0 selesai (butuh mock + factory) + Pool A.6 selesai (butuh ErrorHandler reference)
- **Blocks**: Pool C (usecase test mock repository delegation — pattern sama dengan B.2)

---

*Generated from `docs/progress/plans/sprint_b1_unit_testing.md` §4.3*
