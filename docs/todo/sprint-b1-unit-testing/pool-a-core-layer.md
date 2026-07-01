# Pool A — Core Layer Tests

> **Sprint**: B1 — Unit Testing Foundation
> **Acuan**: `docs/progress/plans/sprint_b1_unit_testing.md` §4.2 (Pool A)
> **Estimasi Total**: 4.55 jam
> **Target Selesai**: Day 2 (2 Juli 2026) EOD

## Ringkasan

| Metrik | Nilai |
|---|---|
| **Nama Pool** | Pool A — Core Layer Tests |
| **Total Item** | 11 |
| **Selesai** | 11 / 11 |
| **Belum** | 0 / 11 |
| **Skip** | 0 / 11 |
| **Coverage Target** | Core layer ≥ 90% line coverage |
| **Estimasi Total** | 4.55 jam |
| **Target Selesai** | Day 2 (2 Juli 2026) EOD |

## Catatan Pool

Pool A = **pure logic** (enum, sealed class, util functions) — **0% excuse** untuk tidak 100% covered per Goal 5. Tidak butuh mock. Paling ringan dari semua pool — bisa selesai dalam 1-2 hari. Wajib selesai sebelum Pool B butuh ErrorHandler reference (A6).

## Sub-Group: A.Enums (3 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 1 | `BookingStatus` enum + `fromJson` safe parser | `test/core/enums/booking_status_test.dart` | `lib/core/enums/booking_status.dart` | Unit test | [x] | A1. **BUG regression: Sprint 2 A5**. 10 test cases: 4 known values + null/unknown/uppercase/empty fallback + values count + containsAll. `flutter test` ✅ 10/10 pass. |
| 2 | `FailureCode` enum | `test/core/enums/failure_code_test.dart` | `lib/core/enums/failure_code.dart` | Unit test | [x] | A2. 2 test cases: 11 values + containsAll. `flutter test` ✅ 2/2 pass. |

| 3 | `Gender` enum (enhanced) | `test/core/enums/gender_test.dart` | `lib/core/enums/gender.dart` | Unit test | [x] | A3. 5 test cases: 3 values + value field for each. `flutter test` ✅ 5/5 pass. |

## Sub-Group: A.Network (4 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 4 | `Result<T>` sealed class (`Success<T>`, `Failure<T>`) | `test/core/network/result_test.dart` | `lib/core/network/result.dart` | Unit test | [x] | A4. 7 test cases: Success.data + Failure.code+message + switch match. `flutter test` ✅ 7/7 pass. |
| 5 | `ApiException` class | `test/core/network/api_exception_test.dart` | `lib/core/network/api_exception.dart` | Unit test | [x] | A5. 6 test cases: constructor + optional fields + toString. `flutter test` ✅ 6/6 pass. |
| 6 | `ErrorHandler` mapper | `test/core/network/error_handler_test.dart` | `lib/core/network/error_handler.dart` | Unit test | [x] | A6. 40 test cases: PostgrestException (7) + P0001 parsing (7) + AuthException (2) + StorageException (7) + FunctionException (8) + Timeout/Socket/HttpException + unknown (2) + handleWithAuthCheck (4). `flutter test` ✅ 40/40 pass. Largest file in Pool A. |
| 7 | `json_converters` (DateOnly/TimeOnly) + formatRupiah | `test/core/network/json_converters_test.dart` | `lib/core/network/json_converters.dart` | Unit test | [x] | A7. 19 test cases: DateOnlyJsonConverter (6) + TimeOnlyJsonConverter (8) + formatRupiah (5). `flutter test` ✅ 19/19 pass. |

## Sub-Group: A.Utils (4 items)

| No | File/Class/Modul yang ditest | Path File (test) | Path Source (lib) | Jenis Test | Status | Catatan |
|---|---|---|---|---|---|---|
| 8 | `Validators` static methods | `test/core/utils/validators_test.dart` | `lib/core/utils/validators.dart` | Unit test | [x] | A8. 20 test cases: email (5) + password (4) + phone (4) + required (5) + maxChars (5). `flutter test` ✅ 20/20 pass. |
| 9 | `DateFormatter` static methods | `test/core/utils/date_formatter_test.dart` | `lib/core/utils/date_formatter.dart` | Unit test | [x] | A9. 13 test cases: toDayMonth/toShortDate/toFullDate (3) + toTimeOfDayFromDateTime + toTimeOfDayString + dayName + 8 nullable OrDash variants. `flutter test` ✅ 13/13 pass. |
| 10 | `Debouncer` class | `test/core/utils/debouncer_test.dart` | `lib/core/utils/debouncer.dart` | Unit test | [x] | A10. 5 test cases: single call + multiple calls (last only) + dispose cancels + re-fire after timer. `flutter test` ✅ 5/5 pass. |
| 11 | `withRetry<T>` function | `test/core/utils/retry_test.dart` | `lib/core/utils/retry.dart` | Unit test | [x] | A11. 5 test cases: success first try + SocketException retry → success + TimeoutException retry → success + SocketException rethrow after max retries + non-retryable error rethrow immediately. `flutter test` ✅ 5/5 pass. (Note: 3s delay due to exponential backoff 1+2s). |

---

## Definition of Done Pool A

- [ ] 11/11 test file dibuat
- [ ] `flutter test test/core/` exit code 0
- [ ] Core layer coverage ≥ 90% line
- [ ] `flutter analyze` 0 issues
- [ ] Conventional commit: `test(core): enum + network + utils — 11 test files`

## Commit Target

```bash
git add -A
git commit -m "test(core): enum + network + utils

- A1: BookingStatus @JsonValue mapping (BUG regression Sprint 2 A5)
- A2: FailureCode enum
- A3: Gender enum
- A4: Result<T> sealed class (Success/Failure + factory)
- A5: ApiException constructor
- A6: ErrorHandler map 7 exception types + handleWithAuthCheck
- A7: json_converters (DateOnly/TimeOnly/DateTime) happy/null/invalid
- A8: Validators (email/password/phone/required/maxChars)
- A9: DateFormatter (toDayMonth/toShortDate/toFullDate + OrDash variants)
- A10: Debouncer (3x fast call → last executes + dispose cancels)
- A11: withRetry (success + SocketException retry + rethrow)
- Coverage: Core layer ~95% (target ≥ 90%)"
```

## Dependencies

- **Blocked by**: Pool 0 selesai (butuh `flutter_test` import + `mockito` mocks already present)
- **Blocks**: Pool B.2 (repository test butuh ErrorHandler reference untuk A6 integration test)

---

*Generated from `docs/progress/plans/sprint_b1_unit_testing.md` §4.2*
