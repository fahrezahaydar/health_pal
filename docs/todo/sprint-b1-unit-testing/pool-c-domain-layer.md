# Pool C — Domain Layer Tests

> **Sprint**: B1 — Unit Testing Foundation
> **Acuan**: `docs/progress/plans/sprint_b1_unit_testing.md` §4.4 (Pool C)
> **Estimasi Total**: 3.95 jam
> **Target Selesai**: Day 4 (6 Juli 2026) EOD

## Ringkasan

| Metrik | Nilai |
|---|---|
| **Nama Pool** | Pool C — Domain Layer Tests |
| **Total Item** | 31 |
| **Selesai** | 31 / 31 |
| **Belum** | 0 / 31 |
| **Skip** | 0 / 31 |
| **Coverage Target** | Domain layer ≥ 70% line coverage |
| **Estimasi Total** | 3.95 jam |
| **Target Selesai** | Day 4 (6 Juli 2026) EOD |

## Catatan Pool

Pool C = **paling ringan dari semua pool** (3.95 jam total). Use case mostly pass-through delegation ke repository (C1-C21) — pattern seragam, tinggal copy-paste + adjust expectation. Entity test (C22-C31) = `props` (Equatable) + `copyWith` + `mock()` factory + derived getter. Total 31 test files.

---

## Sub-Group: C.Auth — UseCase (4 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 1 | `LoginWithEmailUseCase` | `test/features/auth/domain/usecase/login_with_email_usecase_test.dart` | `lib/features/auth/domain/usecase/login_with_email_usecase.dart` | Unit test | [ ] | C1. call(email, password) → repo.signInWithEmail delegation. Estimasi 0.15h. |
| 2 | `RegisterAndCreateProfileUseCase` | `test/features/auth/domain/usecase/register_and_create_profile_usecase_test.dart` | `lib/features/auth/domain/usecase/register_and_create_profile_usecase.dart` | Unit test | [ ] | C2. call() → repo.registerAndCreateProfile delegation (with photo). Estimasi 0.15h. |
| 3 | `CreateProfileUseCase` | `test/features/auth/domain/usecase/create_profile_usecase_test.dart` | `lib/features/auth/domain/usecase/create_profile_usecase.dart` | Unit test | [ ] | C3. call() → repo.createProfile delegation. Estimasi 0.1h. |
| 4 | `ForgotPasswordUseCase` | `test/features/auth/domain/usecase/forgot_password_usecase_test.dart` | `lib/features/auth/domain/usecase/forgot_password_usecase.dart` | Unit test | [ ] | C4. call() → repo.sendResetPasswordEmail delegation. Estimasi 0.1h. |

## Sub-Group: C.Home — UseCase (4 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 5 | `GetBannersUseCase` | `test/features/home/domain/usecase/get_banners_usecase_test.dart` | `lib/features/home/domain/usecase/get_banners_usecase.dart` | Unit test | [ ] | C5. call() → repo.getBanners. Estimasi 0.1h. |
| 6 | `GetSpecializationsUseCase` | `test/features/home/domain/usecase/get_specializations_usecase_test.dart` | `lib/features/home/domain/usecase/get_specializations_usecase.dart` | Unit test | [ ] | C6. call() → repo.getSpecializations. Estimasi 0.1h. |
| 7 | `GetUpcomingAppointmentUseCase` | `test/features/home/domain/usecase/get_upcoming_appointment_usecase_test.dart` | `lib/features/home/domain/usecase/get_upcoming_appointment_usecase.dart` | Unit test | [ ] | C7. call(profileId) → repo.getUpcoming. Estimasi 0.1h. |
| 8 | `GetUserProfileUseCase` | `test/features/home/domain/usecase/get_user_profile_usecase_test.dart` | `lib/features/home/domain/usecase/get_user_profile_usecase.dart` | Unit test | [ ] | C8. call(authId) → repo.getUserProfile. Estimasi 0.1h. |

## Sub-Group: C.Doctor — UseCase (4 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 9 | `GetDoctorsUseCase` | `test/features/doctor/domain/usecase/get_doctors_usecase_test.dart` | `lib/features/doctor/domain/usecase/get_doctors_usecase.dart` | Unit test | [ ] | C9. call(filters) → repo.getDoctors with all params. Estimasi 0.2h. |
| 10 | `GetDoctorDetailUseCase` | `test/features/doctor/domain/usecase/get_doctor_detail_usecase_test.dart` | `lib/features/doctor/domain/usecase/get_doctor_detail_usecase.dart` | Unit test | [ ] | C10. call(doctorId) → repo.getDoctorDetail. Estimasi 0.15h. |
| 11 | `GetDoctorSchedulesUseCase` | `test/features/doctor/domain/usecase/get_doctor_schedules_usecase_test.dart` | `lib/features/doctor/domain/usecase/get_doctor_schedules_usecase.dart` | Unit test | [ ] | C11. call(doctorId) → repo.getDoctorSchedules. Estimasi 0.15h. |
| 12 | `GetDoctorSlotsUseCase` | `test/features/doctor/domain/usecase/get_doctor_slots_usecase_test.dart` | `lib/features/doctor/domain/usecase/get_doctor_slots_usecase.dart` | Unit test | [ ] | C12. call(doctorId, date) → repo.getDoctorSlots. Estimasi 0.15h. |

## Sub-Group: C.Booking — UseCase (4 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 13 | `GetAppointmentHistoryUseCase` | `test/features/booking/domain/usecase/get_appointment_history_usecase_test.dart` | `lib/features/booking/domain/usecase/get_appointment_history_usecase.dart` | Unit test | [ ] | C13. call(patientId, status, limit, offset) → repo.getHistory. Estimasi 0.2h. |
| 14 | `GetAppointmentDetailUseCase` | `test/features/booking/domain/usecase/get_appointment_detail_usecase_test.dart` | `lib/features/booking/domain/usecase/get_appointment_detail_usecase.dart` | Unit test | [ ] | C14. call(appointmentId) → repo.getDetail. Estimasi 0.15h. |
| 15 | `CreateAppointmentUseCase` | `test/features/booking/domain/usecase/create_appointment_usecase_test.dart` | `lib/features/booking/domain/usecase/create_appointment_usecase.dart` | Unit test | [ ] | C15. call(input) → repo.create. Estimasi 0.15h. |
| 16 | `CancelAppointmentUseCase` | `test/features/booking/domain/usecase/cancel_appointment_usecase_test.dart` | `lib/features/booking/domain/usecase/cancel_appointment_usecase.dart` | Unit test | [ ] | C16. call(id, reason) → repo.cancel. Estimasi 0.15h. |

## Sub-Group: C.Loc — UseCase (1 item)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 17 | `GetNearbyClinicsUseCase` | `test/features/loc/domain/usecase/get_nearby_clinics_usecase_test.dart` | `lib/features/loc/domain/usecase/get_nearby_clinics_usecase.dart` | Unit test | [ ] | C17. call(lat, lng, radius) → repo.getNearbyClinics. Estimasi 0.15h. |

## Sub-Group: C.Profile — UseCase (4 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 18 | `GetProfileUseCase` | `test/features/profile/domain/usecase/get_profile_usecase_test.dart` | `lib/features/profile/domain/usecase/get_profile_usecase.dart` | Unit test | [ ] | C18. call() → repo.getProfile. Estimasi 0.1h. |
| 19 | `UpdateProfileUseCase` | `test/features/profile/domain/usecase/update_profile_usecase_test.dart` | `lib/features/profile/domain/usecase/update_profile_usecase.dart` | Unit test | [ ] | C19. call(data) → repo.updateProfile. Estimasi 0.1h. |
| 20 | `GetNotificationsUseCase` + `MarkNotificationAsReadUseCase` | `test/features/profile/domain/usecase/get_notifications_usecase_test.dart` | `lib/features/profile/domain/usecase/get_notifications_usecase.dart` | Unit test | [ ] | C20. call() + MarkNotificationAsReadUseCase (2 use case dalam 1 file). Estimasi 0.15h. |
| 21 | `GetFavoritesUseCase` | `test/features/profile/domain/usecase/get_favorites_usecase_test.dart` | `lib/features/profile/domain/usecase/get_favorites_usecase.dart` | Unit test | [ ] | C21. call() → repo.getFavorites. Estimasi 0.1h. |

---

## Sub-Group: C.Entity — Domain Entity (10 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 22 | `UserEntity` | `test/features/auth/domain/entity/user_entity_test.dart` | `lib/features/auth/domain/entity/user_entity.dart` | Unit test | [ ] | C22. Test props + copyWith + mock factory. Estimasi 0.15h. |
| 23 | `BannerEntity` | `test/features/home/domain/entity/banner_entity_test.dart` | `lib/features/home/domain/entity/banner_entity.dart` | Unit test | [ ] | C23. Test props. Estimasi 0.1h. |
| 24 | `SpecializationEntity` | `test/features/home/domain/entity/specialization_entity_test.dart` | `lib/features/home/domain/entity/specialization_entity.dart` | Unit test | [ ] | C24. Test props. Estimasi 0.1h. |
| 25 | `UpcomingAppointmentEntity` | `test/features/home/domain/entity/upcoming_appointment_entity_test.dart` | `lib/features/home/domain/entity/upcoming_appointment_entity.dart` | Unit test | [ ] | C25. Test props. Estimasi 0.1h. |
| 26 | `UserProfileEntity` | `test/features/home/domain/entity/user_profile_entity_test.dart` | `lib/features/home/domain/entity/user_profile_entity.dart` | Unit test | [ ] | C26. Test props. Estimasi 0.1h. |
| 27 | `DoctorEntity` | `test/features/doctor/domain/entity/doctor_entity_test.dart` | `lib/features/doctor/domain/entity/doctor_entity.dart` | Unit test | [ ] | C27. Test props + `workingTimeDisplay` derived getter (logic kompleks: sort, group consecutive days). Estimasi 0.2h. |
| 28 | `DoctorScheduleEntity` | `test/features/doctor/domain/entity/doctor_schedule_entity_test.dart` | `lib/features/doctor/domain/entity/doctor_schedule_entity.dart` | Unit test | [ ] | C28. Test props. Estimasi 0.1h. |
| 29 | `DoctorSlotEntity` | `test/features/doctor/domain/entity/doctor_slot_entity_test.dart` | `lib/features/doctor/domain/entity/doctor_slot_entity.dart` | Unit test | [ ] | C29. Test props. Estimasi 0.1h. |
| 30 | `ClinicEntity` (Doctor) | `test/features/doctor/domain/entity/clinic_entity_test.dart` | `lib/features/doctor/domain/entity/clinic_entity.dart` | Unit test | [ ] | C30. Test props. Estimasi 0.1h. |
| 31 | `AppointmentEntity` (Booking) + nested `AppointmentDoctorEntity` + `AppointmentSlotEntity` | `test/features/booking/domain/entity/appointment_entity_test.dart` | `lib/features/booking/domain/entity/appointment_entity.dart` | Unit test | [ ] | C31. Test props + nested entity + derived getters (doctorName, timeRangeDisplay, dll). Estimasi 0.3h. |

> **Catatan C32-C34 (sisa entity)** — `ClinicEntity` (Loc) + `NotificationEntity` (Profile) tidak masuk Sprint B1 plan. Test ter-cakup via file test masing-masing entity (Loc, Profile) yang belum di-list secara eksplisit di plan tapi implicit di §4.4 "Entity tests (14 entities)". **Jika plan strict, item ini di luar scope B1**. Tanyakan ke Tech Lead apakah akan di-include.

---

## Definition of Done Pool C

- [ ] 31/31 test file dibuat (21 use case + 10 entity, per plan)
- [ ] `flutter test test/features/*/domain/` exit code 0
- [ ] Domain layer coverage ≥ 70% line
- [ ] `flutter analyze` 0 issues
- [ ] Conventional commit: `test(domain): 21 use cases + 10 entities`

## Commit Target

```bash
git add -A
git commit -m "test(domain): 21 use cases + 10 entities

- Auth: 4 use cases (login/register/createProfile/forgotPassword)
- Home: 4 use cases (banners/specializations/upcoming/userProfile)
- Doctor: 4 use cases (getDoctors/detail/schedules/slots)
- Booking: 4 use cases (history/detail/create/cancel)
- Loc: 1 use case (getNearbyClinics)
- Profile: 4 use cases (getProfile/update/notifications/favorites)
- Entities: 10 (User/Banner/Spec/Upcoming/UserProfile/Doctor/DoctorSchedule/DoctorSlot/Clinic/Appointment)
- Coverage: domain layer ~75% (target ≥ 70%)"
```

## Dependencies

- **Blocked by**: Pool 0 selesai (butuh mock untuk use case) + Pool B selesai (butuh repository mock sebagai dependency)
- **Blocks**: Pool D (cubit test mock use case — pattern dari Pool C)

---

*Generated from `docs/progress/plans/sprint_b1_unit_testing.md` §4.4*
