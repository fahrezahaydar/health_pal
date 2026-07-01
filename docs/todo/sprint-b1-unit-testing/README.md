# Sprint B1 — Unit Testing Todo Index

> **Sprint**: B1 — Unit Testing Foundation
> **Acuan**: [`docs/progress/plans/sprint_b1_unit_testing.md`](../../progress/plans/sprint_b1_unit_testing.md)
> **Tanggal Mulai**: 30 Juni 2026 (Day 0 — pre-sprint audit)
> **Tanggal Selesai Target**: 7 Juli 2026 (Day 5)
> **Status**: 📋 **PLAN READY — menunggu kick-off**

---

## 📊 Rekap Progress Seluruh Pool

| Metrik | Nilai |
|---|---|
| **Total Item** | **94** |
| **Selesai** | **91 / 94** |
| **Belum** | **0 / 94** |
| **Skip** | **3 / 94** |
| **Estimasi Total** | **~31 jam** |
| **Actual Test Files** | **82 files** |
| **Actual Test Cases** | **320 tests** |
| **flutter test** | **320/320 — 0 failures** ✅ |
| **flutter analyze (test/)** | **0 issues** ✅ |

### Progress per Pool

| Pool | Nama | Total | Selesai | Skip | Estimasi | Status |
|:---:|---|:---:|:---:|:---:|:---:|:---:|
| **0** | Test Infrastructure Setup | 5 | 4 | 1 (bloc_test skip) | 5.2 jam | ✅ |
| **A** | Core Layer Tests | 11 | 11 | 0 | 4.55 jam | ✅ |
| **B** | Data Layer Tests | 19 | 19 | 0 | 8.9 jam | ✅ |
| **C** | Domain Layer Tests | 31 | 31 | 0 | 3.95 jam | ✅ |
| **D** | Presentation Layer Tests | 19 | 18 | 1 (SearchCubit) | 7.9 jam | ✅ |
| **E** | Onboarding + Cache Tests | 2 | 2 | 0 | 1 jam | ✅ |
| **F** | Closing & Coverage | 7 | 6 | 0 | 1 jam | ✅ |
| **Total** | — | **94** | **91** | **3** | **~32.5 jam** | **✅ 97%** |

---

## 📁 Daftar File Pool

| Pool | File | Isi | Item Count |
|:---:|---|---|:---:|
| 0 | [`pool-0-test-infrastructure.md`](./pool-0-test-infrastructure.md) | Setup mocks + factories + `bloc_test` package + regenerate | 5 |
| A | [`pool-a-core-layer.md`](./pool-a-core-layer.md) | Enum + network + utils (pure logic) | 11 |
| B | [`pool-b-data-layer.md`](./pool-b-data-layer.md) | Data Model (12) + Data Repository (7) | 19 |
| C | [`pool-c-domain-layer.md`](./pool-c-domain-layer.md) | Use Case (21) + Domain Entity (10) | 31 |
| D | [`pool-d-presentation.md`](./pool-d-presentation.md) | Cubit / Bloc state machine (16 + 3) | 19 |
| E | [`pool-e-onboarding-cache.md`](./pool-e-onboarding-cache.md) | OnboardingNotifier + CacheService | 2 |
| F | [`pool-f-closing-coverage.md`](./pool-f-closing-coverage.md) | Verification + coverage + commit | 7 |

---

## 🗓️ Daily Schedule (5 Working Days)

| Day | Date | Active Pool | Commit Target |
|:---:|:---:|---|---|
| **0** (pre-sprint) | 30 Jun | T1 (audit) | `docs(audit): test coverage baseline` |
| **1** | 1 Jul | T2-T3b (setup) + A1-A5 (enum + Result) | `test(core): setup mocks + factories + enum/result tests` |
| **2** | 2 Jul | A6-A11 (network + utils) + B1-B12 (12 model) | `test(data): model fromJson/toJson + core utils` |
| **3** | 3 Jul | B13-B19 (7 repository impl) | `test(data): repository impl with mock datasource` |
| **4** | 6 Jul | C1-C31 (21 use case + 10 entity) | `test(domain): 21 use cases + 10 entities` |
| **5** | 7 Jul | D1-D19 + E1-E2 + F1-F7 (cubit + closing) | `test(presentation): ...` + `test(sprint-b1): complete` |

---

## 🎯 Definition of Done — Global

Sprint B1 dianggap DONE jika SEMUA checklist ini tercentang:

- [ ] **Pool 0**: 5/5 setup tasks selesai
- [ ] **Pool A**: 11/11 core test files selesai
- [ ] **Pool B**: 19/19 data test files selesai
- [ ] **Pool C**: 31/31 domain test files selesai
- [ ] **Pool D**: 19/19 presentation test files selesai
- [ ] **Pool E**: 2/2 onboarding + cache test files selesai
- [ ] **Pool F**: 7/7 closing tasks selesai
- [ ] `flutter test` exit code 0 — all tests pass
- [ ] Coverage target tercapai:
  - [ ] **Core layer** ≥ 90% line coverage
  - [ ] **Data layer** ≥ 60% line coverage
  - [ ] **Domain layer** ≥ 70% line coverage
  - [ ] **Presentation layer** ≥ 50% line coverage
- [ ] `flutter analyze` 0 issues
- [ ] `dart run build_runner build --force-jit` sukses
- [ ] `docs/progress/test_coverage_baseline.md` published
- [ ] `docs/progress/sprint_roadmap.md` updated: B1 marked Done
- [ ] 3 BUG regression tests passed (BUG-002-FIX-3, Sprint 2 A2, Sprint 2 A5)

---

## 🐛 BUG Regression Tests (P0)

| BUG | Test File | Pool | Status |
|---|---|---|---|
| BUG-002-FIX-3 (try/catch di `ProfileCubit.loadProfile`) | `D15` profile_cubit_test.dart | D | [ ] |
| Sprint 2 A2 (`getUpcoming` order by `doctor_slots.slot_date.asc`) | `B14` home_repository_impl_test.dart | B | [ ] |
| Sprint 2 A5 (`BookingStatus.fromJson` @JsonValue) | `A1` booking_status_test.dart | A | [ ] |

---

## 📚 Referensi

- **Sprint Plan**: [`docs/progress/plans/sprint_b1_unit_testing.md`](../../progress/plans/sprint_b1_unit_testing.md)
- **TDD 10 (Testing Strategy)**: [`docs/tdd/10-testing.md`](../../tdd/10-testing.md)
- **Sprint Roadmap**: [`docs/progress/sprint_roadmap.md`](../../progress/sprint_roadmap.md)
- **AGENTS.md**: §"Sprint 1 — Testing Policy" (akan di-update post-B1)
- **Test Helpers (existing)**: [`test/helpers/mocks.dart`](../../../test/helpers/mocks.dart) + [`test_helpers.dart`](../../../test/helpers/test_helpers.dart)

---

## 📝 Catatan Update

File ini di-generate dari `sprint_b1_unit_testing.md` (1 Juli 2026, v1.0). Untuk update progress, edit file pool yang relevan (ganti `[ ]` → `[x]` atau `[-]`), lalu update angka di tabel "Rekap Progress Seluruh Pool" dan "Progress per Pool" di file ini.

### Convention Status

| Symbol | Arti |
|---|---|
| `[ ]` | Belum dikerjakan |
| `[x]` | Selesai |
| `[-]` | Skip / dilewati (wajib isi alasan di kolom Catatan) |

---

*Generated: 1 Juli 2026 · Disusun oleh Tech Lead (MiniMax-M3)*
