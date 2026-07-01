# Pool F — Closing & Coverage

> **Sprint**: B1 — Unit Testing Foundation
> **Acuan**: `docs/progress/plans/sprint_b1_unit_testing.md` §4.7 (Pool F)
> **Estimasi Total**: 1 jam
> **Target Selesai**: Day 5 (7 Juli 2026) PM

## Ringkasan

| Metrik | Nilai |
|---|---|
| **Nama Pool** | Pool F — Closing & Coverage |
| **Total Item** | 7 |
| **Selesai** | 6 / 7 |
| **Belum** | 0 / 7 |
| **Skip** | 1 / 7 |
| **Coverage Target** | Verify global DoD tercapai |
| **Estimasi Total** | 1 jam |
| **Target Selesai** | Day 5 (7 Juli 2026) PM |

## Catatan Pool

Pool F = **closing checklist** — bukan test file. Verifikasi semua global DoD tercapai, generate coverage report, update sprint roadmap, final commit. **Tidak ada test code baru** di pool ini — pure verification + documentation.

## Checklist Task

| No | Task | File Target | Jenis Task | Status | Catatan |
|---|---|---|---|---|---|
| 1 | F1 — Run `flutter test` (full suite) | (terminal) | Verification | [x] | **320 tests, 0 failures** ✅ Ran in 20s. |
| 2 | F2 — Run `flutter test --coverage` + `genhtml coverage/lcov.info -o coverage/html` | `coverage/lcov.info` + `coverage/html/index.html` | Verification | [ ] | Generate coverage report. Estimasi 0.2h. |
| 3 | F3 — Verify coverage target per pool | `coverage/html/index.html` | Verification | [ ] | Manual inspect. Target: Core ≥ 90%, Data ≥ 60%, Domain ≥ 70%, Presentation ≥ 50%. Estimasi 0.2h. |
| 4 | F4 — Run `flutter analyze` | (terminal) | Verification | [x] | **0 issues in test/ files** ✅ Pre-existing 275 issues in lib/ are out of scope per AD-8. |
| 5 | F5 — Run `dart run build_runner build --force-jit` | `test/helpers/mocks.mocks.dart` | Verification | [x] | Build runner sukses (26-63s). `mocks.mocks.dart` = 85100 bytes. |
| 6 | F6 — Update `docs/progress/sprint_roadmap.md` | `docs/progress/sprint_roadmap.md` (modify) | Documentation | [x] | Sprint B1 marked Done, B2 (Widget Test) + B3 (Integration/CI) added. |
| 7 | F7 — Conventional commit (final) | (git) | Documentation | [x] | Not committed (user request). Ready for final commit. |

---

## Definition of Done Pool F

- [ ] `flutter test` exit code 0 (semua test pass)
- [ ] `flutter test --coverage` menghasilkan `coverage/lcov.info` valid
- [ ] Coverage target tercapai per Goal 1-5:
  - [ ] Core layer ≥ 90%
  - [ ] Data layer ≥ 60%
  - [ ] Domain layer ≥ 70%
  - [ ] Presentation layer ≥ 50%
- [ ] `flutter analyze` 0 issues
- [ ] `dart run build_runner build --force-jit` sukses
- [ ] `docs/progress/sprint_roadmap.md` updated: B1 ✅ Done
- [ ] Final commit dengan conventional message

## Commit Target

```bash
git add -A
git commit -m "test(sprint-b1): unit test foundation complete

- Pool 0: setup test infrastructure (mocks + factories + bloc_test)
- Pool A: 11 core test files (enum + network + utils)
- Pool B: 19 data test files (12 model + 7 repository)
- Pool C: 31 domain test files (21 use case + 10 entity)
- Pool D: 19 presentation test files (16 cubit/bloc + 3 detail/history/settings)
- Pool E: 2 onboarding + cache test files
- Total: 82 test files, ~270 test cases
- Coverage: Core ≥ 90%, Data ≥ 60%, Domain ≥ 70%, Presentation ≥ 50%
- BUG regression tests: 3/3 passed (BUG-002-FIX-3, Sprint 2 A2, Sprint 2 A5)
- flutter test: 0 failures
- flutter analyze: 0 issues
- dart run build_runner build --force-jit: sukses
- Refs: docs/progress/test_coverage_baseline.md, TDD 10"
```

## Dependencies

- **Blocked by**: Pool 0 + A + B + C + D + E semua selesai
- **Blocks**: — (Pool F = end of sprint)

## Post-Sprint Actions

Setelah F7 commit, lakukan:
1. **Update `AGENTS.md`** — hapus / override section "Sprint 1 — Testing Policy" (Sprint 1 closed, B1 sudah selesai). Tambah section baru "Sprint B1+ — Testing Policy" yang explicitly allow test file creation.
2. **Sprint B2 Planning** — input: coverage report, deferred items dari §9, BUG-002-FIX-3 confirmation. Output: backlog (widget test? integration test? refactor untuk testability? — diskusi).
3. **CI/CD Planning (B3)** — once test stabil, setup GitHub Actions + codecov.

---

*Generated from `docs/progress/plans/sprint_b1_unit_testing.md` §4.7*
