# Sprint 2 Plan — Health Pal

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | 15 Juni 2026 |
| **Sprint Window** | 16 Juni 2026 – 27 Juni 2026 (10 hari kerja, 2 minggu) |
| **Tema Sprint** | **"Sprint 1 Hardening + Home MVP Completion"** — stabilkan fondasi Sprint 1, selesaikan 2 section Home yang hilang, refactor arsitektur minor |
| **Acuan** | home_page_audit.md · sprint_progress.md v1.3 · cto_executive_summary.md · BUG-001–004 · TDD 01–12 · AGENTS.md (no-testing policy) |
| **Tech Lead** | MiniMax-M3 |
| **Dependency** | Sprint 1 CLOSED ✅ · Sprint 2 NOT STARTED |
| **Testing Policy** | **❌ NO TEST FILES** per AGENTS.md (deferred ke fase terpisah setelah Sprint 2) |

---

## 📊 Sprint 2 Progress Tracker

**Last Updated:** 16 Juni 2026 (Day 1, end of Day 1)
**Overall:** 3/30 tasks (10%)

### Pool A — Critical Bugs

| Task | Deskripsi | Estimasi | Status | Commit | Catatan |
|------|-----------|---------|--------|--------|---------|
| A1 | Search Bar widget | 4h | ✅ Done | `0b7d603` | Stateless widget, tap → /doctor/search, integrated to HomePage below GreetingSection. `flutter analyze` 0 issues. |
| A2 | Fix getUpcoming order | 1h | ✅ Done | `be9205e` | Filter: `inFilter('status', [pending,upcoming])` (was 2x neq). Order: `slot_date asc, referencedTable: 'doctor_slots'` (was `created_at desc`). Align dengan API Contract §6.5. `flutter analyze` 0 issues. |
| A3 | Fix slot date/time typing | 3h | ✅ Done | `07473d6` | `slotDate: DateTime?` via `DateOnlyJsonConverter`; `slotStart/slotEnd: TimeOfDay?` via `TimeOnlyJsonConverter`. `DateFormatter` + nullable variants. UI: "15 Jun 2026 • 09:00". Fixed test_helpers + preview to match new types. `flutter analyze` 0 issues. |
| A4 | Fix HomePage SupabaseClient import | 1h | ⬜ Not Started | — | — |
| A5 | Fix BookingStatus.firstWhere unsafe | 1h | ⬜ Not Started | — | — |
| A6 | Fix route path :bookingId → :appointmentId | 0.25h | ⬜ Not Started | — | — |
| A7 | BUG-002-FIX-3 try/catch ProfileCubit | 0.5h | ⬜ Not Started | — | — |
| A8 | Notification count from API | 2h | ⬜ Not Started | — | — |
| A9 | Empty state CTA copy fix | 0.1h | ⬜ Not Started | — | — |
| A10 | Postgres delete_user() RPC migration | 1h | ⬜ Not Started | — | — |

**Pool A Progress: 1/10 done (10%)**

### Pool B — Home Refactor

| Task | Deskripsi | Estimasi | Status | Commit | Catatan |
|------|-----------|---------|--------|--------|---------|
| B1 | Refactor Home Models ke @freezed | 4h | ⬜ Not Started | — | — |
| B2 | HomeLocalDataSource @lazySingleton | 0.1h | ⬜ Not Started | — | — |
| B3 | Result.Failure.code ke enum FailureCode | 2h | ⬜ Not Started | — | — |
| B4 | Cache user profile | 1h | ⬜ Not Started | — | — |
| B5 | Use CacheService generic di Home | 2h | ⬜ Not Started | — | — |
| B6 | Cache invalidation hook | 0.5h | ⬜ Not Started | — | — |
| B7 | ErrorHandler.handleWithAuthCheck | 2h | ⬜ Not Started | — | — |
| B8 | Implement withRetry | 0.5h | ⬜ Not Started | — | — |

**Pool B Progress: 0/8 done (0%)**

### Pool C — Home UX Polish

| Task | Deskripsi | Estimasi | Status | Commit | Catatan |
|------|-----------|---------|--------|--------|---------|
| C1 | Skeleton/shimmer loader per section | 4h | ⬜ Not Started | — | — |
| C2 | Pull-to-refresh RefreshIndicator | 2h | ⬜ Not Started | — | — |
| C3 | Nearby Medical Centers section | 16h | ⬜ Not Started | — | — |
| C4 | Profile photo di Greeting | 2h | ⬜ Not Started | — | — |
| C5 | Quick Categories icon mapping | 2h | ⬜ Not Started | — | — |
| C6 | Error UI untuk *Error states | 3h | ⬜ Not Started | — | — |

**Pool C Progress: 0/6 done (0%)**

### Pool D — Cross-Feature Audit

| Task | Deskripsi | Estimasi | Status | Commit | Catatan |
|------|-----------|---------|--------|--------|---------|
| D1 | Audit Doctor page | 2h | ⬜ Not Started | — | — |
| D2 | Audit Booking flow | 2h | ⬜ Not Started | — | — |
| D3 | Audit Loc tab | 1.5h | ⬜ Not Started | — | — |
| D4 | Audit Profile + Settings | 2h | ⬜ Not Started | — | — |
| D5 | Audit Onboarding + Auth + FCM | 2.5h | ⬜ Not Started | — | — |
| D6 | Sprint 2 audit summary | 1h | ⬜ Not Started | — | — |
| D7 | Icon reference table docs/reference/icons.md | 1h | ⬜ Not Started | — | — |

**Pool D Progress: 0/7 done (0%)**

### Pool E — Optional

| Task | Deskripsi | Estimasi | Status | Commit | Catatan |
|------|-----------|---------|--------|--------|---------|
| E1 | Fix BannerCarousel addPostFrameCallback | 1h | ⬜ Not Started | — | — |
| E2 | Validate banner.actionUrl scheme | 1h | ⬜ Not Started | — | — |
| E3 | Fix hardcoded path di app_router.dart | 0.25h | ⬜ Not Started | — | — |
| E4 | Remove home_bloc_index.dart jika redundant | 0.25h | ⬜ Not Started | — | — |
| E5 | Add notif_reminder_enabled ke UserModel | 1h | ⬜ Not Started | — | — |

**Pool E Progress: 0/5 done (0%)**

**Overall Total: 1/30 done (3%)** · **Total estimasi: 95 jam** · **Estimasi selesai: ~4 jam (A1)**

### Status Legend

| Symbol | Meaning |
|---|---|
| ⬜ | Not Started |
| 🔄 | In Progress |
| ✅ | Done |
| ❌ | Blocked |
| ⏭️ | Deferred |

---

## Daftar Isi

1. [Verdict & Sprint Theme](#1-verdict--sprint-theme)
2. [State of the Codebase (Post-Sprint 1)](#2-state-of-the-codebase-post-sprint-1)
3. [Sprint 2 Goals — SMART](#3-sprint-2-goals--smart)
4. [Sprint Backlog — Prioritized](#4-sprint-backlog--prioritized)
5. [Weekly Schedule (10 Working Days)](#5-weekly-schedule-10-working-days)
6. [Sprint 2 Architecture Decisions](#6-sprint-2-architecture-decisions)
7. [Definition of Done — Sprint 2](#7-definition-of-done--sprint-2)
8. [Risiko & Mitigasi](#8-risiko--mitigasi)
9. [Deferred to Sprint 3+](#9-deferred-to-sprint-3)
10. [Carry-over dari Sprint 1](#10-carry-over-dari-sprint-1)
11. [Items to Audit di Sprint 2](#11-items-to-audit-di-sprint-2)
12. [Sprint Ceremonies](#12-sprint-ceremonies)
13. [Score Card Template](#13-score-card-template)

---

## 1. Verdict & Sprint Theme

### 1.1 Verdict (Tech Lead)

🟡 **Sprint 1 TIDAK 100% seperti diklaim `sprint_progress.md`.** Audit independen Home Page (15 Juni 2026) menemukan:
- Home: **80%** (bukan 100%) — 2 section UI hilang, 3 PRD behavior hilang, 4 critical bugs, 17 medium issues, 12 polish.
- 4 BUG-001..004 tercatat "Resolved" tapi **BUG-002-FIX-3 deferred**, **BUG-004-D blocked by SQL migration** (cleanup task belum selesai).
- 0% test coverage (per AGENTS.md policy — accepted).
- Tidak ada audit per-feature lain (Doctor, Booking, Loc, Profile, Settings, Onboarding) — kemungkinan ada gap serupa.

### 1.2 Sprint 2 Theme

> **"Selesaikan apa yang seharusnya selesai di Sprint 1, plus refactor fondasi."**

Sprint 2 BUKAN sprint untuk fitur besar. Sprint 2 adalah **sprint stabilisasi**:
1. **Hardening** — fix 4 critical bugs Home + BUG-002-FIX-3.
2. **Completion** — implement 2 section Home yang hilang (Search Bar, Nearby Medical Centers).
3. **Refactor** — standarisasi Home Models ke `@freezed`, fix arsitektur violations.
4. **Polish** — pull-to-refresh, skeleton loader, error UI.
5. **Cross-feature Audit** — audit 5 fitur lain (bukan Home) untuk catch bug sebelum release.

### 1.3 Sprint 2 Anti-Scope (Penting)

❌ **TIDAK** menambah fitur baru di luar Sprint 1 backlog.
❌ **TIDAK** test files (per AGENTS.md).
❌ **TIDAK** ubah API Contract (kalau butuh → escalate ke Backend Lead, defer ke Sprint 3).
❌ **TIDAK** refactor besar (mis. ganti state management, ganti DI library).

---

## 2. State of the Codebase (Post-Sprint 1)

### 2.1 Snapshot dari Audit (15 Juni 2026)

| Aspek | Status | Sumber |
|---|---|---|
| `flutter analyze` | 0 issues ✅ | sprint_progress.md v1.3 §5 |
| Build runner | OK ✅ | sprint_progress.md v1.3 §5 |
| Total Dart files | ~120+ | sprint_progress.md v1.3 §1 |
| Home Page | 80% 🟡 | home_page_audit.md §1.2 |
| Test coverage | 0% 🔴 (per policy) | sprint_progress.md v1.3 §1 |
| Sprint 1 commits | 9 (7d2e85b → 50386f8) | sprint_progress.md v1.3 §6 |
| Branch state | master, 29 ahead of origin | `git status` (15 Jun 2026) |
| Untracked | `docs/progress/home_page_audit.md` | `git status` |
| Modified | `lib/features/profile/data/datasource/profile_remote_datasource.dart` | `git status` |

### 2.2 BUG Status (Post-Sprint 1)

| BUG | Severity | Status | Catatan |
|---|---|---|---|
| BUG-001 (auth routing) | Critical | ✅ Resolved (FIX-1..8) | Termasuk FIX-7 v2 (GreetingNoProfile) + FIX-8 (race condition) |
| BUG-002-A (`.from('me')`) | Critical | ✅ Resolved (FIX-1, commit 98a2888) | Query diganti ke `user_profiles` |
| BUG-002-B (logout di error state) | Critical | ✅ Resolved (FIX-2) | Tambah tombol logout di `_errorState` |
| **BUG-002-FIX-3** (try/catch ProfileCubit) | Low | ❌ **DEFERRED ke Sprint 2** | Defense-in-depth, theoretical |
| BUG-003 (storage RLS) | Critical | ✅ Resolved (FIX-2 + re-fix, commit 24d9a25) | 2 bug simultan: UUID salah + double-prefix path |
| BUG-004-A..C (sign up) | Critical | ✅ Resolved (FIX-1..8) | Atomic registerAndCreateProfile |
| **BUG-004-D** (cleanup) | Critical | 🟡 **Code-complete, BLOCKED by SQL migration** | Butuh `delete_user()` RPC function di Supabase DB |

### 2.3 Home Page — Kritis dari Audit

| # | Issue | Severity | Reference |
|---|---|:---:|---|
| **K1** | Search Bar tidak ada | 🔴 | home_page_audit.md §13.1, PRD §6.2, Wireframe 06 §2 |
| **K2** | `getUpcoming` order wrong (`created_at` vs `doctor_slots.slot_date`) | 🔴 | home_page_audit.md §13.1, API Contract §6.5 |
| **K3** | Slot date/time sebagai `String` (harusnya `DateTime` + `TimeOfDay`) | 🔴 | home_page_audit.md §13.1, TDD 05 §3.2 |
| **K4** | HomePage import `supabase_flutter` langsung (TDD 01 §3.3 violation) | 🔴 | home_page_audit.md §7.2 |

### 2.4 Sprint 1 Cleanup Tasks (Outstanding)

| # | Task | Source | Status |
|---|---|---|---|
| 1 | Postgres migration `delete_user()` RPC function | BUG-004-D, sprint_progress.md action item | 🚧 **BLOCKER** (belum di-deploy) |
| 2 | Profile + Notification folder refactor | sprint_progress.md action item #4 | 🟡 Defer to Sprint 3 |
| 3 | Icon reference table `docs/reference/icons.md` | sprint_progress.md action item #2 | 🟡 Sprint 2 (low priority) |
| 4 | RoutePaths consistency (`:bookingId` → `:appointmentId`) | sprint_progress.md action item #3 + home audit M2 | 🟢 Sprint 2 P0 |

---

## 3. Sprint 2 Goals — SMART

### Goal 1 — Stabilization (P0)
**Home Page tidak boleh ada critical bugs** di akhir Sprint 2. Semua 4 issue `K1-K4` di fix dan verified via `flutter analyze` + manual test + log inspection.

### Goal 2 — Completion (P0)
**Home Page 100% match Wireframe 06 + PRD §6.2.** 2 section hilang (Search Bar, Nearby Medical Centers) implemented sesuai spec.

### Goal 3 — Architectural Consistency (P1)
**Home Models menggunakan `@freezed` + `@JsonKey`** seperti Doctor + Booking (TDD 05 §3.0 compliance). Dependency rule violations (K4) di-fix.

### Goal 4 — UX Polish (P1)
**Skeleton loader + Pull-to-refresh + Error UI** di seluruh section Home, supaya user tidak stuck di blank state.

### Goal 5 — Cross-Feature Audit (P1)
**Audit 5 fitur lain** (Doctor, Booking, Loc, Profile, Settings/Onboarding) mengikuti template `home_page_audit.md`. Tujuannya catch bug sebelum release.

### Goal 6 — No Regression
- `flutter analyze` tetap 0 issues.
- `flutter pub get` & `dart run build_runner build --force-jit` tetap sukses.
- Tidak ada breaking change ke API Contract.

---

## 4. Sprint Backlog — Prioritized

Total: **30 task items, ~95 jam kerja** (10 hari × ~9.5 jam/hari). Dipecah jadi 4 sprint pool.

### 4.1 Pool A — Critical Bugs (Wajib Sprint 2) — ~14 jam

| # | Task | File Target | Sumber | Estimasi | Owner | Sprint Day |
|---|---|---|---|:---:|---|:---:|
| A1 | **Fix K1: Search Bar widget** — placeholder/visual only, tanpa logic search dulu (logic di-search page sudah ada per TDD Fase 5) | `lib/features/home/presentation/widget/search_bar.dart` (new) + `home_page.dart` | home audit K1, Wireframe 06 §2 | 4h | Frontend | Day 1-2 |
| A2 | **Fix K2: `getUpcoming` order** — fix query jadi `order=doctor_slots.slot_date.asc` atau fallback sort di Dart | `lib/features/home/data/datasource/home_remote_datasource.dart:30-44` | home audit K2, API §6.5 | 1h | Frontend | Day 1 |
| A3 | **Fix K3: Slot date/time typing** — convert ke `DateTime` + `TimeOfDay` dengan `@DateOnlyJsonConverter` + `@TimeOnlyJsonConverter`; update formatter | `upcoming_appointment_model.dart` + `upcoming_appointment_entity.dart` + `date_formatter.dart` | home audit K3, TDD 05 §3.2 | 3h | Frontend | Day 2 |
| A4 | **Fix K4: HomePage SupabaseClient import violation** — refactor: inject `GreetingCubit` baca `currentSession` sendiri, atau pakai `AppServices.currentAuthId` getter | `home_page.dart` + `greeting_cubit.dart` + `app_services.dart` | home audit K4, TDD 01 §3.3 | 1h | Frontend | Day 1 |
| A5 | **Fix `BookingStatus.firstWhere` unsafe fallback** — pakai `@JsonValue` di enum + custom converter | `booking_status.dart` + `upcoming_appointment_model.dart` + `upcoming_card.dart` | home audit M3 | 1h | Frontend | Day 2 |
| A6 | **Fix route path param mismatch** `:bookingId` → `:appointmentId` di `route_paths.dart` | `lib/core/router/route_paths.dart:22` | home audit M2, sprint_progress action #3 | 0.25h | Frontend | Day 1 |
| A7 | **BUG-002-FIX-3: Try/catch di `ProfileCubit.loadProfile`** — defense-in-depth | `lib/features/profile/presentation/bloc/profile/profile_cubit.dart:24-34` | BUG-002-FIX-3 | 0.5h | Frontend | Day 1 |
| A8 | **Notification count from API** (replace hardcoded 5) — tambah `getUnreadCount` atau reuse `NotificationCubit` | `greeting_section.dart` + `notification_cubit.dart` | home audit M1 | 2h | Frontend | Day 2 |
| A9 | **Empty state CTA copy** "Book Appointment" → "Cari Dokter" | `upcoming_card.dart:173` | home audit M6, PRD §6.2 | 0.1h | Frontend | Day 1 |
| A10 | **Postgres migration `delete_user()` RPC function** — unblock BUG-004-D | `supabase/migrations/004_delete_user_rpc.sql` (new) | BUG-004-D, sprint_progress action | 1h | Backend | Day 1 |

**Subtotal Pool A: 13.85 jam (~1.7 hari kerja)**

### 4.2 Pool B — Home Refactor (P1) — ~12 jam

| # | Task | File Target | Sumber | Estimasi | Owner | Sprint Day |
|---|---|---|---|:---:|---|:---:|
| B1 | **Refactor Home Models ke `@freezed` + `@JsonKey`** — 4 file (BannerModel, SpecializationModel, UpcomingAppointmentModel, UserProfileModel) | 4 files di `lib/features/home/data/model/` | home audit M4, TDD 05 §3.4 | 4h | Frontend | Day 3-4 |
| B2 | **HomeLocalDataSource `@lazySingleton`** (was `@injectable`/factory) | `home_local_datasource.dart:9` | home audit M8, TDD 07 | 0.1h | Frontend | Day 3 |
| B3 | **`Result.Failure.code` ke enum `FailureCode`** (TDD 01 compliance) | `lib/core/network/result.dart` + 4 usecase files | home audit M7, TDD 01 §4.3 | 2h | Frontend | Day 3 |
| B4 | **Cache user profile** (TDD 08 §2 compliance) | `home_local_datasource.dart` | home audit M10 | 1h | Frontend | Day 3 |
| B5 | **Use `CacheService` generic** instead of `HomeLocalDataSource` impl ulang (refactor duplication) | refactor 2 files | home audit M12 | 2h | Frontend | Day 3 |
| B6 | **Cache invalidation hook** — panggil `clearAll()` dari logout/booking success | wiring | home audit M13 | 0.5h | Frontend | Day 3 |
| B7 | **Implement `ErrorHandler.handleWithAuthCheck`** + wire to repositories (auto-logout on 401) | `error_handler.dart` + 4 repositories | home audit M15, TDD 06 §3 | 2h | Frontend | Day 4 |
| B8 | **Implement `withRetry<T>`** + apply to Home remote calls | `lib/core/utils/retry.dart` (new) + 4 use cases | home audit M16, TDD 06 §6 | 0.5h | Frontend | Day 4 |

**Subtotal Pool B: 12.1 jam (~1.5 hari kerja)**

### 4.3 Pool C — Home UX Polish (P1) — ~12 jam

| # | Task | File Target | Sumber | Estimasi | Owner | Sprint Day |
|---|---|---|---|:---:|---|:---:|
| C1 | **Add skeleton/shimmer loader** per section (4 widget) | 4 widget files | home audit L2, TDD 12 §4.17 | 4h | Frontend | Day 5 |
| C2 | **Add pull-to-refresh** dengan `RefreshIndicator` di HomePage | `home_page.dart` | home audit L1, Wireframe 06 §Pull | 2h | Frontend | Day 5 |
| C3 | **Implement Nearby Medical Centers section** (use `get_nearby_clinics` RPC) | `home/data/model/clinic_model.dart` (new) + `home/data/datasource/home_remote_datasource.dart` + `home/domain/usecase/get_nearby_clinics_usecase.dart` (new) + `NearbyFacilities` widget (new) + 1 cubit (new) | home audit M5, Wireframe 06 §6, TDD 12 Fase 9.5 | 16h ⚠️ OVER CAPACITY | Frontend + Backend | Day 6-8 |
| C4 | **Profile photo di Greeting** (PRD §6.2 compliance) — tambah `photoUrl` ke UserProfileEntity + render | `greeting_section.dart` + `user_profile_entity.dart` | home audit L3, PRD §6.2 | 2h | Frontend | Day 5 |
| C5 | **Quick Categories icon mapping** — replace `_getIcon(name)` hardcoded dengan lookup table atau pakai `icon_url` exclusively | `quick_categories.dart:110-121` | home audit M9 | 2h | Frontend | Day 5 |
| C6 | **Error UI untuk `*Error` states** — snackbar/dialog/retry per section | `home_page.dart` + 4 widget files | home audit M14 | 3h | Frontend | Day 8 |

**Subtotal Pool C: 13 jam (Nearby Centers = 16 jam over)**

### 4.4 Pool D — Cross-Feature Audit (P1) — ~10 jam

| # | Task | File Target | Sumber | Estimasi | Owner | Sprint Day |
|---|---|---|---|:---:|---|:---:|
| D1 | **Audit Doctor Page** (search + detail) — template `home_page_audit.md` | `docs/progress/doctor_page_audit.md` (new) | home audit lesson | 2h | Tech Lead | Day 9 |
| D2 | **Audit Booking Flow** (history + detail + create) | `docs/progress/booking_page_audit.md` (new) | home audit lesson | 2h | Tech Lead | Day 9 |
| D3 | **Audit Loc Tab** (nearby clinics) | `docs/progress/loc_page_audit.md` (new) | home audit lesson | 1.5h | Tech Lead | Day 9 |
| D4 | **Audit Profile + Settings** | `docs/progress/profile_page_audit.md` + `docs/progress/settings_page_audit.md` (new) | home audit lesson | 2h | Tech Lead | Day 9 |
| D5 | **Audit Onboarding + Auth + FCM** | `docs/progress/onboarding_auth_fcm_audit.md` (new) | home audit lesson | 2.5h | Tech Lead | Day 10 |
| D6 | **Consolidated Sprint 2 audit report** — rangkuman semua D1-D5 + Sprint 3 backlog | `docs/progress/sprint_2_audit_summary.md` (new) | synthesis | 1h | Tech Lead | Day 10 |
| D7 | **Icon reference table `docs/reference/icons.md`** | `docs/reference/icons.md` (new) | sprint_progress action #2 | 1h | Frontend | Day 10 |

**Subtotal Pool D: 12 jam**

### 4.5 Pool E — Optional / Nice-to-Have (jika ada sisa waktu)

| # | Task | Estimasi | Catatan |
|---|---|:---:|---|
| E1 | Fix `WidgetsBinding.instance.addPostFrameCallback` anti-pattern di BannerCarousel | 1h | home audit L12 |
| E2 | Validate `banner.actionUrl` scheme (http:// vs internal) | 1h | home audit L8 |
| E3 | Use `RoutePaths.bookingDetail` di `app_router.dart:310, 312` (instead of hardcoded) | 0.25h | home audit L5 |
| E4 | Remove atau justify `home_bloc_index.dart` redundant re-export | 0.25h | home audit L6 |
| E5 | Add `notif_reminder_enabled` ke UserModel/UserEntity (sprint_progress deviation #4) | 1h | sprint_progress §10 |

---

## 5. Weekly Schedule (10 Working Days)

### Week 1 — Stabilization + Refactor + Start UX Polish

| Day | Date | Pool A (P0) | Pool B (Refactor) | Pool C (UX) | Pool D (Audit) | Commit Target |
|---|:---:|---|---|---|---|---|
| **1** | 16 Jun (Selasa) | A2, A4, A6, A7, A9 (4h) | — | — | — | `fix(home): P0 critical bugs (K2/K4/M2/BUG-002-FIX-3/M6)` |
| **2** | 17 Jun (Rabu) | A1 (4h), A3 (3h), A5 (1h), A8 (2h — jika Search Bar selesai) | — | — | — | `feat(home): search bar widget + slot date typing` |
| **3** | 18 Jun (Kamis) | A10 (1h — backend coordination) | B1 (4h — @freezed), B2, B3, B4 (3.1h) | — | — | `refactor(home): @freezed models + Result.Failure enum + cache profile` |
| **4** | 19 Jun (Jumat) | — | B1 (lanjut jika belum), B5, B6, B7, B8 (5h) | — | — | `refactor(core): CacheService + ErrorHandler.handleWithAuthCheck + withRetry` |
| **5** | 22 Jun (Senin) | — | — | C1 (4h — skeleton), C2 (2h), C4 (2h) | — | `feat(home): skeleton loader + pull-to-refresh + profile photo` |

**Week 1 total: 36 jam target**

### Week 2 — Nearby Medical Centers + Cross-Feature Audit

| Day | Date | Pool C (UX) | Pool D (Audit) | Commit Target |
|---|:---:|---|---|---|
| **6** | 23 Jun (Selasa) | C3 step 1: ClinicModel + HomeRemoteDataSource + GetNearbyClinicsUseCase (5h) | — | `feat(home): nearby clinics data layer` |
| **7** | 24 Jun (Rabu) | C3 step 2: NearbyFacilities widget + NearbyCubit + 1 empty state (5h) | — | `feat(home): nearby facilities widget + cubit` |
| **8** | 25 Jun (Kamis) | C3 step 3: integrasi ke HomePage + lihat peta URL (4h), C5 (2h) | — | `feat(home): nearby medical centers integrated + category icons` |
| **9** | 26 Jun (Jumat) | C6 (3h) | D1, D2, D3, D4 (8h) | `docs(audit): doctor/booking/loc/profile/settings audit` |
| **10** | 29 Jun (Senin) | — | D5, D6, D7 (4.5h) | `docs(sprint): audit summary + icon reference + sprint_2_audit_summary` |

**Week 2 total: 30 jam target**

### Timeline Visual

```
Sprint 2: Stabilization + Completion + Audit
Week 1:  ████████░░░░░░░░░░░░░░░░░  Stabilization + Refactor
Week 2:  ░░░░░░░░░░░░████████████  Completion + Audit
────────────────────────────────────
Day:    1  2  3  4  5 │ 6  7  8  9  10
Theme:  P0  P0  R   R   U │ N  N  N  A  A
         ↑  ↑  ↑   ↑   ↑   ↑  ↑  ↑  ↑  ↑
        A  A  B   B   C   C  C  C  D  D
```

Keterangan: P0=Pool A, R=Pool B Refactor, U=Pool C UX, N=Nearby, A=Audit

---

## 6. Sprint 2 Architecture Decisions

### 6.1 AD-1: Search Bar MVP (Stateless Wrapper)
**Decision:** Search Bar di Sprint 2 adalah **stateless widget** yang navigate ke `/doctor/search` saat tap. Logic search (debounce, query, filter) tetap di `DoctorSearchPage` per Fase 5. Sprint 3+ baru consider inline search dengan debounce.

**Rationale:**
- Mengurangi scope Sprint 2.
- Konsisten dengan pattern "Home adalah entry point, detail logic di page lain".
- Mempertahankan separation of concerns.

**Alternative considered:** Inline search dengan debounce. Rejected karena ~16h work tambahan (debounce + query state + search history).

### 6.2 AD-2: Nearby Medical Centers — Reuse Home Pattern
**Decision:** Nearby Medical Centers pakai 1 cubit + 1 horizontal list widget, parallel dengan existing `BannerCarousel` / `QuickCategories` pattern. TIDAK buat folder baru `lib/features/facility/`.

**Rationale:**
- Konsisten dengan Sprint 1 keputusan "fold facility ke Home, jangan split folder" (per sprint_progress.md §10).
- Single-purpose cubit cukup.
- TDD Fase 9.5 sudah plan ini (1 cubit per section).

**Alternative considered:** Pisah folder `lib/features/facility/`. Rejected karena inkonsisten dengan Sprint 1, dan TDD Fase 9.5 sudah merge ke Home.

### 6.3 AD-3: Refactor Home Models — `@freezed` + `@JsonKey`
**Decision:** Convert 4 Home Models (Banner, Specialization, Upcoming, UserProfile) ke `@freezed` class dengan `@JsonKey(name: 'snake_case')` per field. Generate `.freezed.dart` + `.g.dart`.

**Rationale:**
- Konsisten dengan Doctor (`doctor_model.dart`) + Booking (`appointment_model.dart`) yang sudah pakai `@freezed`.
- Kurangi boilerplate (currently ~30 baris per model manual `fromJson/toJson`).
- Type-safe copyWith, ==, hashCode.

**Migration strategy:** Ganti satu model per commit. Test via `dart run build_runner build --force-jit` + `flutter analyze` per commit.

### 6.4 AD-4: Result.Failure.code — Revert ke `FailureCode` Enum
**Decision:** Ubah `Result.Failure.code` dari `String` (current) ke `FailureCode` (enum). Update semua call site (4 use cases) dari `FailureCode.notFound.name` jadi `FailureCode.notFound`.

**Rationale:**
- TDD 01 §4.3 + TDD 06 §3 spec: `code: FailureCode` (enum).
- Lebih type-safe, no string comparison.
- Menghilangkan magic string di cubit (current `greeting_cubit.dart:32` pakai `code == FailureCode.notFound.name`).

**Migration:** Low risk. 4 file use case. 1 line change per call site.

### 6.5 AD-5: Error UI Pattern
**Decision:** Setiap section Home yang punya `*Error` state render inline error placeholder (icon + message + "Coba lagi" button) **instead of** silently fallback ke empty default. Trigger via `BlocSelector` (cek `state` dengan switch pattern).

**Rationale:**
- Saat ini `*Error` diemit tapi tidak ada widget yang listen.
- User silent failure → confusion.
- Inline error lebih konsisten dengan PRD §11 (offline indicator).

**Implementation:** Wrap `BlocSelector` dengan `BlocBuilder` + `buildWhen: (prev, curr) => curr is *Error`. Atau pakai `MultiBlocListener`.

### 6.6 AD-6: Skeleton Loader — Shimmer Package
**Decision:** Pakai `shimmer: ^3.0.0` (sudah di pubspec) untuk skeleton loader. Setiap section (Banner, Upcoming, Categories, Greeting, Nearby) punya skeleton variant-nya.

**Rationale:**
- Package sudah ada, no new dependency.
- Konsisten dengan design system (animated placeholder).
- Implementasi cepat (~1h per section).

### 6.7 AD-7: Pull-to-Refresh — Single RefreshIndicator
**Decision:** Wrap `ListView` di HomePage dengan single `RefreshIndicator`. Trigger 4 cubit re-load (Greeting, Banner, Specialization, Upcoming) — note: Upcoming akan re-trigger via Greeting loaded, jadi cukup 3 explicit calls.

**Rationale:**
- Wireframe 06 §"Pull To Refresh" eksplisit.
- Single RefreshIndicator lebih clean dari per-section.

**Caveat:** Jangan trigger `loadProfile` (yang sensitif — BUG-001/FIX-7). Cukup `BannerCubit.loadBanners()` + `SpecializationCubit.loadSpecializations()` + (optional) `UpcomingCubit.loadUpcoming(profileId)`.

---

## 7. Definition of Done — Sprint 2

### 7.1 Per-Item DoD

Setiap task di Pool A/B/C/D harus memenuhi:

- [ ] Code complete sesuai task description
- [ ] `dart run build_runner build --force-jit` sukses (untuk perubahan @freezed/JsonSerializable)
- [ ] `flutter analyze` 0 issues
- [ ] Commit dengan conventional commit message (`feat:`, `fix:`, `refactor:`, `docs:`)
- [ ] Inline comment untuk logic non-obvious (existing pattern)
- [ ] Trace doc updated jika architectural change

### 7.2 Sprint 2 Global DoD

- [ ] **Pool A**: 10/10 task selesai (semua P0)
- [ ] **Pool B**: minimal 6/8 task selesai (refactor fondasi)
- [ ] **Pool C**: minimal 5/6 task selesai (UX polish + Nearby Centers)
- [ ] **Pool D**: 7/7 audit doc published
- [ ] `flutter analyze` 0 issues
- [ ] `flutter pub get` clean
- [ ] `dart run build_runner build --force-jit` sukses
- [ ] Manual smoke test: Home → Search → Doctor Detail → Book → Home shows upcoming
- [ ] Sprint 2 audit summary published di `docs/progress/sprint_2_audit_summary.md`
- [ ] Sprint 3 backlog updated berdasarkan audit findings
- [ ] Conventional commit messages untuk semua perubahan
- [ ] Sprint progress updated ke v1.4

### 7.3 Sprint 2 NOT DoD (Explicit)

- ❌ Test coverage (per AGENTS.md policy)
- ❌ CI/CD pipeline setup
- ❌ New API endpoints (kalau butuh → escalate, defer ke Sprint 3)
- ❌ Multi-bahasa (i18n)
- ❌ Dark mode
- ❌ Major architecture refactor (e.g. ganti state management)

---

## 8. Risiko & Mitigasi

| # | Risiko | Probabilitas | Dampak | Severity | Mitigasi |
|---|---|:---:|---|:---:|---|
| **R1** | **Nearby Medical Centers terlalu besar (16h)** — bisa overflow Week 2 | 🟡 High | Sprint slip | 🔴 Critical | Buffer: cut C4/C5/C6 ke Pool E (optional). Minimum viable: clinic data + widget + 1 cubit. Empty state, distance display, "Lihat Peta" → Sprint 3. |
| **R2** | **Postgres `delete_user()` migration** — butuh SQL deploy & verifikasi (out of Flutter dev scope) | 🟢 Medium | BUG-004-D tetap blocked | 🟡 Medium | Coordinate dengan Backend Lead Day 1. Jika tidak selesai Day 1, mark sebagai known issue + defer runtime safety ke Sprint 3. |
| **R3** | **Home Models @freezed refactor** bisa break imports across 4 widget files | 🟡 Medium | Regress | 🟡 Medium | Migrate 1 model at a time. Setelah setiap model, run `flutter analyze` + smoke test Home page. |
| **R4** | **Search Bar** tanpa logic — bisa dikritik "MVP tidak useful" | 🟢 Low | UX confusion | 🟢 Low | Tambah inline subtitle "Cari dokter, klinik, atau spesialisasi" supaya user tahu ini input field. Logic di doctor search page sudah ada. |
| **R5** | **Cross-feature audit reveal critical bugs** di Doctor/Booking/Loc | 🟡 Medium | Sprint 2 scope expand | 🟡 Medium | Cap audit scope: 2h per feature, 1 page audit. Critical bugs found → add ke Sprint 3 backlog, JANGAN fix di Sprint 2. |
| **R6** | **Dependency rule K4 fix** bisa conflict dengan BUG-001/FIX-7 v2 logic (HomePage guard) | 🟡 Medium | Regression di race condition | 🟡 Medium | Pertahankan FIX-7 v2 behavior (GreetingNoProfile → setProfileIncomplete). Hanya refactor WHERE `authId` dibaca (Page → Cubit), bukan WHAT dilakukan dengan `authId`. |
| **R7** | **Skeleton loader** + **Error UI** + **Pull-to-refresh** = banyak state transition → bug race | 🟡 Medium | Loading flicker | 🟢 Low | State pattern sudah sealed (Initial/Loading/Loaded/Error). Tambah state `Refreshing` di cubit jika perlu, atau reuse `Loading`. |
| **R8** | **Time tracking tidak disiplin** → Sprint 2 molor | 🟡 High | Delivery delay | 🟡 Medium | Daily standup 15 menit. Update `sprint_progress.md` setiap commit. Jika Day 5 belum 50% Pool A+B → potong scope. |

---

## 9. Deferred to Sprint 3+

| # | Item | Sumber | Alasan Defer |
|---|---|---|---|
| 1 | **Test layer (unit + widget + bloc)** | AGENTS.md, cto_executive_summary §3.4 | Per policy, fase terpisah. Sprint 3 atau setelahnya. |
| 2 | **Booking Review (rating + comment)** Fase 7 task 7.12 | sprint_progress.md | Placeholder sudah ada. Implementasi butuh design review (PRD §12 out of MVP). |
| 3 | **Favorites backend** Fase 8 task 8.13 | sprint_progress.md | Butuh schema `favorites` table baru. Diskusi dengan Backend Lead. |
| 4 | **Email/SMS notification toggle** Fase 10 | sprint_progress.md | Disabled placeholders sudah ada. Butuh service baru (SendGrid/Twilio). |
| 5 | **Dark mode full impl** | sprint_progress.md | UI shell ada, state persist belum. v2. |
| 6 | **Language i18n (en/id)** | sprint_progress.md | v1.1. Butuh `intl` + l10n setup. |
| 7 | **Advanced filter di Loc** Fase 9 | sprint_progress.md | Filter chips basic sudah ada (sprint Loc). Advanced: range slider, multi-select, sort. |
| 8 | **Image picker di Create Profile** Fase 2 task 2.5 | sprint_progress.md | AppImagePicker widget sudah ada. Wire ke create profile page. |
| 9 | **Offline-first Hive/Isar** | cto_executive_summary §3.3 | v2.0. SharedPref cukup untuk MVP. |
| 10 | **CI/CD pipeline (GitHub Actions + codecov)** | TDD 10 §6, cto_executive_summary §3.4 | Butuh test dulu. |
| 11 | **Major refactor** (e.g. ganti BLoC library, restructure folder Profile+Notification) | sprint_progress.md retrospective | Risk tinggi, value unclear. |
| 12 | **Pagination `has_more`** di semua list | cto_executive_summary §3.2 | API contract change required. Defer ke Sprint 3. |
| 13 | **50+ edge case scenarios** (network timeout, 401, race, OAuth, timezone) | cto_executive_summary §3.4 | Test-driven discovery. Butuh test layer dulu. |
| 14 | **Materialized view `mv_upcoming_appointment_per_patient`** | cto_executive_summary §5.8 | Backend optimization. Defer. |
| 15 | **Slot date refactor (TIMESTAMPTZ + INTERVAL)** | cto_executive_summary §5.9 | DB migration + API change. |

---

## 10. Carry-over dari Sprint 1

### 10.1 BUG-001 to BUG-004 — Open Items

| BUG | Item | Status | Sprint 2 Disposition |
|---|---|---|---|
| BUG-002 | FIX-3: Try/catch di `ProfileCubit.loadProfile` | ❌ Deferred | **Pool A task A7** |
| BUG-004-D | Postgres `delete_user()` migration | 🚧 Blocker | **Pool A task A10** + coordinate with Backend |
| BUG-003 | Lessons learned (path prefix SDK) | ✅ Resolved | Tidak ada carry-over, tapi catat di `docs/reference/storage_sdk_path.md` |

### 10.2 Sprint 1 Action Items (sprint_progress.md §"Action items untuk Sprint 2")

| # | Action Item | Status | Sprint 2 Disposition |
|---|---|---|---|
| 1 | 🔴 Test layer | Deferred | **Sprint 3+** (per AGENTS.md) |
| 2 | 🟡 Icon reference table | Open | **Pool D task D7** |
| 3 | 🟡 Refactor RoutePaths | Open | **Pool A task A6** (`:bookingId` → `:appointmentId`) |
| 4 | 🟡 Decision: notification folder | Open | Defer ke Sprint 3 — saat ini workable, refactor bukan prioritas |
| 5 | 🟢 Dark mode | Deferred | Sprint 3+ |
| 6 | 🟢 Booking review | Deferred | Sprint 3+ |
| 7 | 🟢 Favorites backend | Deferred | Sprint 3+ |
| 8 | 🟢 Image picker Create Profile | Open | **Pool C task C3** (Nearby Centers includes this scope creep — evaluate) |
| 9 | 🟢 Email/SMS notification | Deferred | Sprint 3+ |

### 10.3 sprint_progress.md §"Sprint 2 — Recommended Backlog"

| Feature | Phase | Estimate | Sprint 2 Disposition |
|---|---|:---:|---|
| Test layer | Fase 11 | 3-5 hari | ❌ **EXCLUDE** (per AGENTS.md) |
| Booking Review | Fase 7.12 | 2 hari | ❌ Sprint 3+ |
| Location Search advanced filter | Fase 9 | 2 hari | ❌ Sprint 3+ |
| Favorites backend | Fase 8.13 | 1 hari | ❌ Sprint 3+ |
| Email/SMS notification | Fase 10 | 1 hari | ❌ Sprint 3+ |
| Dark mode | v2 | 1 hari | ❌ Sprint 3+ |
| Language i18n | v1.1 | 3 hari | ❌ Sprint 3+ |

**Verdict:** Tidak ada item dari sprint_progress.md §"Sprint 2 Backlog" yang di-include di Sprint 2 actual plan (semua di-defer ke Sprint 3+). Sprint 2 fokus ke **stabilization + completion Sprint 1**, bukan fitur baru.

---

## 11. Items to Audit di Sprint 2

### 11.1 Audit Scope (Pool D)

| # | Feature | Wireframe Ref | File yang diaudit | Output Doc |
|---|---|---|---|---|
| D1 | Doctor | `08-doctor-search.md`, `09-doctor-detail.md` | `lib/features/doctor/**` + wireframe vs implementation | `docs/progress/doctor_page_audit.md` |
| D2 | Booking | `10-book-appointment.md`, `11-booking-success.md`, `12-booking-history.md`, `13-booking-detail.md` | `lib/features/booking/**` | `docs/progress/booking_page_audit.md` |
| D3 | Loc | `07-location-search.md` | `lib/features/loc/**` | `docs/progress/loc_page_audit.md` |
| D4 | Profile | `14-profile.md`, `15-profile-edit.md`, `16-favorite.md`, `17-notification-settings.md` | `lib/features/profile/**` | `docs/progress/profile_page_audit.md` |
| D5 | Settings + Onboarding + Auth + FCM | `18-settings.md`, `19-help-support.md`, `20-tnc.md`, `21-no-internet.md`, `01-onboarding.md`, `02-sign-in.md`, `03-sign-up.md`, `04-create-profile.md`, `05-forgot-password.md` | `lib/features/settings/**`, `lib/features/onboarding/**`, `lib/features/auth/**`, `lib/core/services/fcm_service.dart` | `docs/progress/onboarding_auth_fcm_audit.md` |
| D6 | **Sprint 2 Audit Summary** | — | All 5 audit docs | `docs/progress/sprint_2_audit_summary.md` |

### 11.2 Audit Template (reuse home_page_audit.md)

Setiap audit doc mengikuti struktur:

1. Ringkasan Eksekutif (Verdict + Skor + Heatmap)
2. Wireframe vs Implementasi
3. PRD vs Implementasi
4. API Contract vs Implementasi
5. ERD vs Implementasi
6. User Flow vs Implementasi
7. TDD Arsitektur vs Implementasi
8. TDD State Management vs Implementasi
9. TDD Data Layer vs Implementasi
10. TDD Routing vs Implementasi
11. TDD Caching vs Implementasi
12. TDD Error Handling vs Implementasi
13. Deviation & Bug Catalog
14. TODO Sprint 3+ (Actionable)
15. Score Card

### 11.3 Audit Goals

- **Catch bug sebelum release** — pattern yang ditemukan di Home (K1-K4) kemungkinan ada di fitur lain.
- **Update `sprint_progress.md`** dengan realitas (seperti Home 100% → 80%).
- **Build Sprint 3 backlog** yang akurat.

---

## 12. Sprint Ceremonies

### 12.1 Daily Standup (15 menit, 09:00 WIB)

Format: Kemarin / Hari ini / Blockers. Asinkron via Slack/Discord (tim kecil).

### 12.2 Sprint Review (Day 10, 29 Juni, 14:00 WIB)

Demo:
- Home Page new sections (Search Bar + Nearby Medical Centers)
- Refactor showcase (@freezed Models, Result.Failure enum)
- Audit summary (5 audit doc published)
- Bug list closed (Pool A 10/10)

### 12.3 Sprint Retrospective (Day 10, 29 Juni, 15:30 WIB)

Format: What went well / What didn't / Action items.

### 12.4 Sprint 3 Planning (Day 10, 29 Juni, 16:30 WIB)

Input: Sprint 2 audit summary, BUG-001..004 status, deferred items.
Output: Sprint 3 backlog (prioritas: test layer? dark mode? favorites? booking review? — diskusi tim).

---

## 13. Score Card Template

### Sprint 2 Self-Score (akan diisi Day 10)

| Aspek | Target | Actual | Verdict |
|---|---|---|---|
| **Pool A selesai** | 10/10 | ?/10 | 🟢/🟡/🔴 |
| **Pool B selesai** | 6/8 (75%) | ?/8 | 🟢/🟡/🔴 |
| **Pool C selesai** | 5/6 (83%) | ?/6 | 🟢/🟡/🔴 |
| **Pool D selesai** | 7/7 (100%) | ?/7 | 🟢/🟡/🔴 |
| `flutter analyze` | 0 issues | ? | 🟢/🟡/🔴 |
| `flutter pub get` | clean | ? | 🟢/🟡/🔴 |
| `dart run build_runner` | sukses | ? | 🟢/🟡/🔴 |
| Total jam | ≤ 95 jam | ? jam | 🟢/🟡/🔴 |
| Sprint velocity | — | ? task/hari | 🟢/🟡/🔴 |
| Cross-feature audit published | 5/5 | ?/5 | 🟢/🟡/🔴 |
| Bug kritis di-handle | 5/5 (K1-K4 + BUG-002-FIX-3) | ?/5 | 🟢/🟡/🔴 |

### Definition of Success

🟢 **SUCCESS** — Pool A 10/10 + Pool B ≥6/8 + Pool C ≥5/6 + Pool D 7/7 + `flutter analyze` clean
🟡 **PARTIAL** — Pool A 10/10 tapi Pool B/C/D < 75%
🔴 **FAIL** — Pool A < 10/10 ATAU critical regression

---

## Lampiran A — Sprint 2 File Touch List (Predicted)

### Files Created (Estimated 8 new)

```
lib/features/home/presentation/widget/search_bar.dart                    (A1)
lib/features/home/presentation/widget/banner_skeleton.dart               (C1)
lib/features/home/presentation/widget/upcoming_skeleton.dart             (C1)
lib/features/home/presentation/widget/categories_skeleton.dart          (C1)
lib/features/home/presentation/widget/nearby_facilities.dart             (C3)
lib/features/home/presentation/bloc/nearby/nearby_cubit.dart             (C3)
lib/features/home/presentation/bloc/nearby/nearby_state.dart             (C3)
lib/features/home/domain/usecase/get_nearby_clinics_usecase.dart        (C3)
lib/core/utils/retry.dart                                                (B8)
supabase/migrations/004_delete_user_rpc.sql                             (A10)
docs/progress/doctor_page_audit.md                                      (D1)
docs/progress/booking_page_audit.md                                     (D2)
docs/progress/loc_page_audit.md                                         (D3)
docs/progress/profile_page_audit.md                                     (D4)
docs/progress/onboarding_auth_fcm_audit.md                              (D5)
docs/progress/sprint_2_audit_summary.md                                  (D6)
docs/reference/icons.md                                                 (D7)
docs/progress/sprint_2_plan.md                                           (this file)
```

### Files Modified (Estimated 20 modified)

```
lib/core/router/route_paths.dart                                          (A6)
lib/core/router/app_router.dart                                            (multiple audit findings)
lib/core/network/result.dart                                               (B3)
lib/core/network/error_handler.dart                                       (B7)
lib/core/services/app_services.dart                                        (A4, audit B findings)
lib/core/enums/booking_status.dart                                        (A5)
lib/core/utils/date_formatter.dart                                        (A3)

lib/features/home/data/datasource/home_remote_datasource.dart            (A2, C3)
lib/features/home/data/datasource/home_local_datasource.dart             (B2, B4, B5, B6)
lib/features/home/data/model/banner_model.dart                            (B1)
lib/features/home/data/model/specialization_model.dart                    (B1)
lib/features/home/data/model/upcoming_appointment_model.dart              (A3, A5, B1)
lib/features/home/data/model/user_profile_model.dart                      (B1)
lib/features/home/data/repository/home_repository_impl.dart              (B5, B7, B8)
lib/features/home/presentation/page/home_page.dart                        (A1, A4, C1, C2, C3, C4, C6)
lib/features/home/presentation/widget/greeting_section.dart               (A8, C4)
lib/features/home/presentation/widget/banner_carousel.dart                (C6)
lib/features/home/presentation/widget/upcoming_card.dart                   (A5, A9, C6)
lib/features/home/presentation/widget/quick_categories.dart               (C5, C6)
lib/features/home/presentation/bloc/greeting/greeting_cubit.dart          (A4)
lib/features/home/presentation/bloc/upcoming/upcoming_cubit.dart          (C2)

lib/features/profile/presentation/bloc/profile/profile_cubit.dart         (A7)

lib/features/doctor/data/datasource/doctor_remote_datasource.dart        (audit)
lib/features/booking/data/datasource/booking_remote_datasource.dart      (audit)
```

---

## Lampiran B — Daily Commit Pattern

```bash
# Day 1 — P0 critical bugs
git add -A
git commit -m "fix(home): P0 critical bugs

- Fix K2: getUpcoming order by doctor_slots.slot_date.asc
- Fix K4: remove SupabaseClient import from HomePage (TDD 01 §3.3)
- Fix M2: route path :bookingId → :appointmentId consistency
- Fix BUG-002-FIX-3: try/catch in ProfileCubit.loadProfile
- Fix M6: empty state CTA copy 'Book Appointment' → 'Cari Dokter'"

# Day 2 — Search Bar + slot date typing
git add -A
git commit -m "feat(home): search bar widget + slot date/time typing

- A1: Add SearchBar widget (placeholder tap → /doctor/search)
- A3: Convert slot_date/slot_start/slot_end to DateTime/TimeOfDay
  with @DateOnlyJsonConverter + @TimeOnlyJsonConverter
- A5: BookingStatus enum @JsonValue mapping (replaces firstWhere)
- A8: Notification count from API (replaces hardcoded 5)"

# Day 3 — @freezed refactor + Result.Failure enum
git add -A
git commit -m "refactor(home): @freezed models + Result.Failure enum

- B1: Convert 4 Home Models to @freezed with @JsonKey per-field
- B2: HomeLocalDataSource @lazySingleton
- B3: Result.Failure.code: String → FailureCode enum (TDD 01 §4.3)
- B4: Cache user profile (TDD 08 §2 compliance)"

# Day 4 — Cache + Error + Retry
git add -A
git commit -m "refactor(core): CacheService + ErrorHandler.handleWithAuthCheck + withRetry

- B5: Home uses CacheService generic (removes duplication)
- B6: Cache invalidation hook (logout/booking success)
- B7: ErrorHandler.handleWithAuthCheck + auto-logout on 401
- B8: withRetry<T> with exponential backoff"

# Day 5 — Skeleton + Pull-to-refresh + Profile photo
git add -A
git commit -m "feat(home): skeleton loader + pull-to-refresh + profile photo

- C1: Shimmer skeleton per section (4 widgets)
- C2: RefreshIndicator with 3-cubit reload
- C4: Profile photo in Greeting (user_profiles.avatar_url)"

# Day 6-8 — Nearby Medical Centers
git add -A
git commit -m "feat(home): nearby medical centers section

- C3: ClinicModel, GetNearbyClinicsUseCase, NearbyCubit
- C3: NearbyFacilities widget (horizontal list, image + name + distance)
- C3: 'Lihat Peta' URL launcher integration
- C3: Empty state when no nearby clinics
- C3: 'See All' → /facilities (TBD route, document as Sprint 3 backlog)"

# Day 9-10 — Audits
git add -A
git commit -m "docs(audit): cross-feature audit per-template

- D1-D5: 5 audit docs (doctor, booking, loc, profile, settings/auth/fcm)
- D6: Sprint 2 audit summary
- D7: docs/reference/icons.md

Refs: home_page_audit.md template"
```

---

## Lampiran C — Decision Log (yang mungkin berubah mid-Sprint)

| # | Decision | Trigger untuk revisit |
|---|---|---|
| AD-1 | Search Bar = stateless wrapper | Jika user feedback "tidak useful tanpa inline search" |
| AD-2 | Nearby Centers reuse Home pattern (no separate folder) | Jika Sprint 3 butuh facility sebagai entitas terpisah (e.g. facility detail page berdiri sendiri) |
| AD-3 | @freezed refactor 1-by-1 | Jika ditemukan dependency cycle antar models |
| AD-4 | Result.Failure.code: String → enum | Jika ada breaking change downstream (mis. 5+ call site yang resist) |
| AD-7 | Single RefreshIndicator | Jika section butuh independent refresh (e.g. user wants to refresh banner only) |

---

*Disusun oleh Tech Lead (MiniMax-M3) · 15 Juni 2026 · v1.0*

**Status:** 🟡 **PLAN READY — menunggu kick-off Sprint 2 (16 Juni 2026)**

**Next Actions:**
1. Update `sprint_progress.md` ke v1.4 (close Sprint 1 + setup Sprint 2)
2. `git add docs/progress/` + commit conventional message
3. Share `sprint_2_plan.md` ke tim untuk alignment
4. Sprint 2 kick-off: 16 Juni 2026
