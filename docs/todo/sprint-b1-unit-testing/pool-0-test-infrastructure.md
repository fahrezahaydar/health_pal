# Pool 0 — Test Infrastructure Setup

> **Sprint**: B1 — Unit Testing Foundation
> **Acuan**: `docs/progress/plans/sprint_b1_unit_testing.md` §4.1 (Pool 0)
> **Estimasi Total**: 5.2 jam
> **Target Selesai**: Day 1 (1 Juli 2026)

## Ringkasan

| Metrik | Nilai |
|---|---|
| **Nama Pool** | Pool 0 — Test Infrastructure Setup |
| **Total Item** | 5 |
| **Selesai** | 4 / 5 |
| **Belum** | 0 / 5 |
| **Skip** | 1 / 5 |
| **Coverage Target** | Setup wajib selesai sebelum Pool A+B+C+D+E bisa jalan |
| **Estimasi Total** | 5.2 jam |
| **Target Selesai** | Day 1 (1 Juli 2026) EOD |

## Catatan Pool

Pool ini adalah **prerequisite** untuk semua pool lain. Item T2 (extend mocks) dan T3 (extend factories) WAJIB selesai di Day 1 agar Pool A bisa tulis test dengan factory + mock yang tersedia. T1 (audit) bisa di-kerjain pre-sprint (Day 0 = 30 Juni 2026).

## Checklist Task

| No | Task | File Target | Jenis Task | Status | Catatan |
|---|---|---|---|---|---|
| 1 | T1 — Test Coverage Baseline Audit | `docs/progress/test_coverage_baseline.md` (new) | Documentation | [x] | Bikin mapping 98 testable file, hitung baseline % per layer. Pre-sprint (Day 0 = 30 Jun 2026). Tech Lead. **Done 1 Jul 2026** — file 232 dart, 0 test, 88 testable units teridentifikasi. |
| 2 | T2 — Extend `mocks.dart` (+17 mock class) | `test/helpers/mocks.dart` (modify) | Setup | [x] | Tambah MockSpec: BookingRepository, BookingRemoteDataSource, LocRepository, LocRemoteDataSource, ProfileRepository, ProfileRemoteDataSource, SettingsRepository, GetAppointmentHistoryUseCase, GetAppointmentDetailUseCase, CreateAppointmentUseCase, CancelAppointmentUseCase, GetNearbyClinicsUseCase, GetProfileUseCase, UpdateProfileUseCase, GetNotificationsUseCase, GetFavoritesUseCase, AppServices (for Onboarding + Repository logout callback). Estimasi 1h. **Done 1 Jul 2026** — total 28 mock class (11 existing + 17 new). `mocks.mocks.dart` regenerated 40336 → 85100 bytes. `flutter analyze` 0 issues. |
| 3 | T3 — Extend `test_helpers.dart` (entity factories) | `test/helpers/test_helpers.dart` (modify) | Setup | [x] | Tambah `TestData.mock*()`: DoctorEntity, ClinicEntity, DoctorSlotEntity, DoctorScheduleEntity, AppointmentEntity (with nested Doctor + Slot), NotificationEntity, AppointmentDoctorEntity, AppointmentSlotEntity, mockDoctorList, mockNotificationList, mockAppointmentList. Estimasi 2h. **Done 1 Jul 2026** — 4347 → 10772 bytes. 11 new factory methods. `flutter analyze` 0 issues. |
| 4 | T3a — Tambah `bloc_test` ke pubspec | `pubspec.yaml` (modify) | Setup | [-] | `bloc_test: ^10.0.0` di dev_dependencies. **SKIP**: version conflict dengan `injectable_generator ^3.0.2` + `json_serializable ^6.14.0` di SDK ^3.10.4. Fallback manual `test` + `expect` + `emit` verification per AD-3. |
| 5 | T3b — Regenerate `mocks.mocks.dart` | `test/helpers/mocks.mocks.dart` (regen) | Setup | [x] | Run `dart run build_runner build --force-jit`. **Done 1 Jul 2026** — regenerated in 26s (0 outputs, sudah current dari T2). `test/helpers/mocks.mocks.dart` = 85100 bytes. |

---

## Definition of Done Pool 0

- [ ] `docs/progress/test_coverage_baseline.md` published (T1)
- [ ] `mocks.dart` punya 18+ MockSpec class (existing 11 + 7 new repo + use case tambahan)
- [ ] `test_helpers.dart` punya factory untuk Doctor/Clinic/Appointment/Notification/DoctorSlot/DoctorSchedule
- [ ] `mocks.mocks.dart` regenerated tanpa error
- [ ] `flutter test test/helpers/` exit code 0 (valid mock compile)
- [ ] `pubspec.yaml` punya `bloc_test: ^10.0.0`
- [ ] `flutter pub get` clean
- [ ] Conventional commit: `test(sprint-b1): setup test infrastructure — mocks + factories + bloc_test`

## Commit Target

```bash
git add -A
git commit -m "test(sprint-b1): setup test infrastructure

- T1: docs/progress/test_coverage_baseline.md (0% baseline)
- T2: extend mocks.dart (18 MockSpec classes)
- T3: extend test_helpers.dart (8 new entity factories)
- T3a: add bloc_test ^10.0.0 to dev_dependencies
- T3b: regenerate mocks.mocks.dart (~2200 lines)"
```

## Dependencies

- **Blocked by**: Sprint A9 CLOSED (sudah) + `test/helpers/mocks.dart` existing pattern (sudah)
- **Blocks**: Pool A (butuh factory + mock) + Pool B (butuh mock datasource) + Pool C (butuh mock usecase) + Pool D (butuh bloc_test)

---

*Generated from `docs/progress/plans/sprint_b1_unit_testing.md` §4.1*
