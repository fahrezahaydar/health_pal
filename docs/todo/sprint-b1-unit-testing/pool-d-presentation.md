# Pool D — Presentation Layer Tests

> **Sprint**: B1 — Unit Testing Foundation
> **Acuan**: `docs/progress/plans/sprint_b1_unit_testing.md` §4.5 (Pool D)
> **Estimasi Total**: 7.9 jam
> **Target Selesai**: Day 5 (7 Juli 2026) EOD

## Ringkasan

| Metrik | Nilai |
|---|---|
| **Nama Pool** | Pool D — Presentation Layer Tests (Cubit / Bloc) |
| **Total Item** | 19 |
| **Selesai** | 18 / 19 |
| **Belum** | 0 / 19 |
| **Skip** | 1 / 19 |
| **Coverage Target** | Presentation layer ≥ 50% line coverage |
| **Estimasi Total** | 7.9 jam |
| **Target Selesai** | Day 5 (7 Juli 2026) EOD |

## Catatan Pool

Pool D = **state machine testing** untuk 16 Cubit/Bloc + 3 (detail, history, settings). Pakai `blocTest<>` pattern dari package `bloc_test` (Tambah di T3a). 3 path minimum per cubit: happy (initial → loading → loaded), error (initial → loading → error), critical feature (filter/pagination/refresh/retry). BUG-002-FIX-3 regression test di D15 (P0).

---

## Sub-Group: D.Auth — Cubit (3 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 1 | `SignInCubit` | `test/features/auth/presentation/bloc/sign_in/sign_in_cubit_test.dart` | `lib/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart` | Bloc test (`blocTest`) | [ ] | D1. signInWithEmail: Success path emit [Loading, Success] / Failure path emit [Loading, Failure] / signInWithGoogle: emit [Loading, Failure 'coming soon']. Estimasi 0.5h. |
| 2 | `CreateProfileCubit` | `test/features/auth/presentation/bloc/create_profile/create_profile_cubit_test.dart` | `lib/features/auth/presentation/bloc/create_profile/create_profile_cubit.dart` | Bloc test | [ ] | D2. submit: success/failure. Estimasi 0.4h. |
| 3 | `ForgotPasswordCubit` | `test/features/auth/presentation/bloc/forget_password/forget_password_cubit_test.dart` | `lib/features/auth/presentation/bloc/forget_password/forget_password_state.dart` | Bloc test | [ ] | D3. Step transitions + send reset. Estimasi 0.3h. |

## Sub-Group: D.Home — Cubit (5 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 4 | `GreetingCubit` | `test/features/home/presentation/bloc/greeting/greeting_cubit_test.dart` | `lib/features/home/presentation/bloc/greeting/greeting_cubit.dart` | Bloc test | [ ] | D4. **P0 — paling critical**. loadProfile success emit GreetingLoaded / notFound emit GreetingNoProfile / other failure emit GreetingError / **BUG-002-FIX-3 regression** (try/catch wrapping). Estimasi 0.7h. |
| 5 | `BannerCubit` | `test/features/home/presentation/bloc/banner/banner_cubit_test.dart` | `lib/features/home/presentation/bloc/banner/banner_cubit.dart` | Bloc test | [ ] | D5. loadBanners success/error. Estimasi 0.3h. |
| 6 | `SpecializationCubit` | `test/features/home/presentation/bloc/specialization/specialization_cubit_test.dart` | `lib/features/home/presentation/bloc/specialization/specialization_cubit.dart` | Bloc test | [ ] | D6. loadSpecializations success/error. Estimasi 0.2h. |
| 7 | `UpcomingCubit` | `test/features/home/presentation/bloc/upcoming/upcoming_cubit_test.dart` | `lib/features/home/presentation/bloc/upcoming/upcoming_cubit.dart` | Bloc test | [ ] | D7. loadUpcoming success/null/error. Estimasi 0.3h. |
| 8 | `NearbyCubit` | `test/features/home/presentation/bloc/nearby/nearby_cubit_test.dart` | `lib/features/home/presentation/bloc/nearby/nearby_cubit.dart` | Bloc test | [ ] | D8. loadNearby success/empty/error/permissionDenied. Estimasi 0.4h. |

## Sub-Group: D.Doctor — Cubit (2 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 9 | `SearchCubit` | `test/features/doctor/presentation/bloc/search/search_cubit_test.dart` | `lib/features/doctor/presentation/bloc/search/search_cubit.dart` | Bloc test | [ ] | D9. searchDoctors: initial → debounce → loading → results / empty / error. Estimasi 0.6h. |
| 10 | `DoctorDetailCubit` | `test/features/doctor/presentation/bloc/doctor_detail/doctor_detail_cubit_test.dart` | `lib/features/doctor/presentation/bloc/doctor_detail/doctor_detail_cubit.dart` | Bloc test | [ ] | D10. loadDetail: success/error + loadSlots + loadSchedules. Estimasi 0.5h. |

## Sub-Group: D.Booking — Cubit/Bloc (3 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 11 | `BookingBloc` | `test/features/booking/presentation/bloc/booking/booking_bloc_test.dart` | `lib/features/booking/presentation/bloc/booking/booking_bloc.dart` | Bloc test | [ ] | D11. **P0**. create appointment event → [Loading, Success] / [Loading, Error]. Estimasi 0.6h. |
| 12 | `BookingDetailCubit` | `test/features/booking/presentation/bloc/detail/booking_detail_cubit_test.dart` | `lib/features/booking/presentation/bloc/detail/booking_detail_cubit.dart` | Bloc test | [ ] | D12. loadDetail + cancel. Estimasi 0.4h. |
| 13 | `BookingHistoryCubit` | `test/features/booking/presentation/bloc/history/booking_history_cubit_test.dart` | `lib/features/booking/presentation/bloc/history/booking_history_cubit.dart` | Bloc test | [ ] | D13. **P0 — pagination**: loadHistory + filterByStatus + loadMore (anti-spam guard) + refresh. Estimasi 0.7h. |

## Sub-Group: D.Loc — Cubit (1 item)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 14 | `LocCubit` | `test/features/loc/presentation/bloc/loc_cubit_test.dart` | `lib/features/loc/presentation/bloc/loc_cubit.dart` | Bloc test | [ ] | D14. requestLocationAndLoad: success/permissionDenied/empty/error + city fallback. Estimasi 0.5h. |

## Sub-Group: D.Profile — Cubit (4 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 15 | `ProfileCubit` | `test/features/profile/presentation/bloc/profile/profile_cubit_test.dart` | `lib/features/profile/presentation/bloc/profile/profile_cubit.dart` | Bloc test | [ ] | D15. **P0 — BUG-002-FIX-3 regression**: loadProfile try/catch ensures terminal state (Loaded/Error). Estimasi 0.4h. |
| 16 | `EditProfileCubit` | `test/features/profile/presentation/bloc/edit_profile/edit_profile_cubit_test.dart` | `lib/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart` | Bloc test | [ ] | D16. submit + uploadAvatar success/failure. Estimasi 0.4h. |
| 17 | `NotificationCubit` | `test/features/profile/presentation/bloc/notification/notification_cubit_test.dart` | `lib/features/profile/presentation/bloc/notification/notification_cubit.dart` | Bloc test | [ ] | D17. load + markAsRead. Estimasi 0.3h. |
| 18 | `FavoriteCubit` | `test/features/profile/presentation/bloc/favorite/favorite_cubit_test.dart` | `lib/features/profile/presentation/bloc/favorite/favorite_cubit.dart` | Bloc test | [ ] | D18. loadFavorites. Estimasi 0.3h. |

## Sub-Group: D.Settings — Cubit (1 item)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 19 | `SettingsCubit` | `test/features/settings/presentation/bloc/settings/settings_cubit_test.dart` | `lib/features/settings/presentation/bloc/settings/settings_cubit.dart` | Bloc test | [ ] | D19. loadSettings + toggleNotification + clearCache. Estimasi 0.3h. |

---

## BUG Regression Test Summary (P0)

| BUG | Test File | Status |
|---|---|---|
| **BUG-002-FIX-3** (try/catch di `ProfileCubit.loadProfile`) | D15 | [ ] |
| **Sprint 2 A2** (`getUpcoming` order by `doctor_slots.slot_date.asc`) | B14 (Pool B) | [ ] |
| **Sprint 2 A5** (`BookingStatus.fromJson` @JsonValue) | A1 (Pool A) | [ ] |

## Definition of Done Pool D

- [ ] 19/19 test file dibuat (16 cubit/bloc + 3 detail/history/settings)
- [ ] `flutter test test/features/*/presentation/` exit code 0
- [ ] Presentation layer coverage ≥ 50% line
- [ ] 3 critical cubit (Greeting, SignIn, BookingHistory) punya advanced test (pagination, BUG regression)
- [ ] `flutter analyze` 0 issues
- [ ] Conventional commit: `test(presentation): 19 cubit/bloc`

## Commit Target

```bash
git add -A
git commit -m "test(presentation): 19 cubit/bloc

- Auth: SignInCubit + CreateProfileCubit + ForgotPasswordCubit (3)
- Home: GreetingCubit (BUG-002-FIX-3) + Banner + Specialization + Upcoming + Nearby (5)
- Doctor: SearchCubit (debounce) + DoctorDetailCubit (2)
- Booking: BookingBloc + BookingDetailCubit + BookingHistoryCubit (pagination) (3)
- Loc: LocCubit (permission flow) (1)
- Profile: ProfileCubit (BUG-002-FIX-3) + EditProfile + Notification + Favorite (4)
- Settings: SettingsCubit (1)
- Pattern: blocTest<> with 3 path (happy/error/critical)
- Coverage: presentation layer ~55% (target ≥ 50%)"
```

## Dependencies

- **Blocked by**: Pool 0 selesai (butuh `bloc_test` package) + Pool C selesai (butuh use case mock sebagai dependency cubit)
- **Blocks**: Pool E (onboarding notifier) + Pool F (closing verify semua test pass)

---

*Generated from `docs/progress/plans/sprint_b1_unit_testing.md` §4.5*
