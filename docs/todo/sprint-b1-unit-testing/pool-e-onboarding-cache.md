# Pool E — Onboarding + Cache Tests

> **Sprint**: B1 — Unit Testing Foundation
> **Acuan**: `docs/progress/plans/sprint_b1_unit_testing.md` §4.6 (Pool E)
> **Estimasi Total**: 1 jam
> **Target Selesai**: Day 5 (7 Juli 2026) EOD

## Ringkasan

| Metrik | Nilai |
|---|---|
| **Nama Pool** | Pool E — Onboarding + Cache Tests |
| **Total Item** | 2 |
| **Selesai** | 0 / 2 |
| **Belum** | 2 / 2 |
| **Skip** | 0 / 2 |
| **Coverage Target** | Onboarding/Cache layer ≥ 70% line coverage |
| **Estimasi Total** | 1 jam |
| **Target Selesai** | Day 5 (7 Juli 2026) EOD |

## Catatan Pool

Pool E = **2 test kecil** sebagai pelengkap. E1 (`OnboardingNotifier`) bukan Cubit — pakai pattern `ChangeNotifier` + `addListener`. E2 (`CacheService`) wrapper untuk `SharedPreferences` — sudah ada setup `SharedPreferences.setMockInitialValues` di `flutter_test_config.dart`, jadi tinggal pakai.

## Checklist Task

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 1 | `OnboardingNotifier` (extends `ChangeNotifier`) | `test/features/onboarding/presentation/bloc/onboarding_notifier_test.dart` | `lib/features/onboarding/presentation/bloc/onboarding_notifier.dart` | Unit test (ChangeNotifier) | [ ] | E1. Test onPageChanged notify + nextPage (last page → appServices.completeOnboarding + route) + nextPage (not last → controller.nextPage) + skip (any page). Pakai `addListener` pattern, BUKAN `blocTest<>` (karena ChangeNotifier, bukan Cubit). Estimasi 0.7h. |
| 2 | `CacheService` (wrapper SharedPreferences) | `test/core/services/cache_service_test.dart` | `lib/core/services/cache_service.dart` | Unit test | [ ] | E2. Test `get`/`set`/`remove`/`clear` dengan `SharedPreferences.setMockInitialValues({})` (sudah di setup di `flutter_test_config.dart`). Estimasi 0.3h. |

---

## Definition of Done Pool E

- [ ] 2/2 test file dibuat
- [ ] `flutter test test/features/onboarding/` exit code 0
- [ ] `flutter test test/core/services/` exit code 0
- [ ] `flutter analyze` 0 issues
- [ ] Conventional commit: `test(onboarding+cache): ChangeNotifier + SharedPreferences wrapper`

## Commit Target

```bash
git add -A
git commit -m "test(onboarding+cache): ChangeNotifier + SharedPreferences wrapper

- E1: OnboardingNotifier (ChangeNotifier) — onPageChanged/nextPage/skip
- E2: CacheService — get/set/remove/clear with mocked SharedPreferences
- Pattern: addListener for ChangeNotifier (NOT blocTest<>)"
```

## Dependencies

- **Blocked by**: Pool 0 selesai (butuh mockito untuk AppServices dependency di E1)
- **Blocks**: Pool F (closing — semua test harus pass)

---

*Generated from `docs/progress/plans/sprint_b1_unit_testing.md` §4.6*
