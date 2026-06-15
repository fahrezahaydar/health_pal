# Sprint Roadmap — Health Pal

**Tanggal:** 16 Juni 2026
**Status Sprint Saat Ini:** Sprint 2 CLOSED ✅
**Berdasarkan:** `sprint_2_plan.md` · `home_page_audit.md` · `sprint_progress.md`

---

## Roadmap Overview

| Sprint | Tema | Fitur | Audit di Awal | Estimasi |
|--------|------|-------|--------------|---------|
| Sprint 1 | Foundation | Auth, Home, Doctor, Booking, Profile, Loc, Settings, Notif | — | ✅ DONE |
| Sprint 2 | Home Hardening | Bug fixes, Refactor, UX Polish (Skeletonizer, Pull-to-refresh, Nearby, Photo, Icons, Error UI) | `home_page_audit.md` | ✅ DONE |
| Sprint 3 | Settings + Loc | Settings page audit + polish, Loc tab audit + polish | `settings_audit.md` + `loc_audit.md` | 2 minggu |
| Sprint 4 | Doctor | Doctor Search + Detail audit + polish | `doctor_audit.md` | 2 minggu |
| Sprint 5 | Booking | Booking flow audit + polish (create, history, detail, cancel) | `booking_audit.md` | 2 minggu |
| Sprint 6 | Profile + Auth | Profile/Settings/Onboarding/Auth/FCM audit + polish + icon reference | `profile_audit.md` + `onboarding_auth_fcm_audit.md` | 2 minggu |
| Sprint 7 | Testing Phase | Test coverage ≥ 80% across all features | — | 2 minggu |
| **Beta** | Launch | Final QA, manual testing, README, deploy | — | — |

---

## Kompleksitas Analysis

| Feature | File Count | Wireframe Count | Endpoint Count | Known Bugs | Kompleksitas |
|---------|-----------|----------------|---------------|------------|:---:|
| Onboarding | 2 | 1 | 0 | 0 | **Low** — production-ready ✅ |
| Auth | 18 | 4 | 6 | 2 | **Low-Medium** — BUG-001/004 fixed in Sprint 2 ✅ |
| Settings | 6 | 4 | 0 | 0 | **Low** — mostly static pages, 1 cubit |
| Loc | 12 | 1 | 2 | 0 | **Low-Medium** — geolocation + RPC, small codebase |
| Notification | 7 | 1 | 2 | 0 | **Low** — embedded in profile, production-ready |
| Profile | 22 | 3 | 5 | 2 | **Medium** — BUG-002/003 fixed, needs audit ✅ |
| Doctor | 25 | 2 | 4 | 0 | **Medium** — search + detail with `@freezed` |
| Booking | 25 | 4 | 4 | 0 | **High** — state machine, deep link, 3 screens |
| Home | 40 | 1 | 6 | 28 | **Highest** — Sprint 2 completed ✅ |

### Complexitas Ranking (Simplest → Most Complex)

```
Lowest      Settings (6 files, 0 endpoints)
            Loc (12 files, 2 endpoints)
            Notification (7 files, 2 endpoints)
                ↓
Medium      Doctor (25 files, 4 endpoints)
            Profile (22 files, 5 endpoints)
                ↓
High        Booking (25 files, 4 endpoints, 4 wireframes)
                ↓
Highest     Home (40 files, 6 endpoints) — DONE ✅
```

### Dependency Graph

```
Onboarding ──→ Auth ──→ Home ←── Notification
                │         │
                │         ├──→ Doctor ←── Loc
                │         │       │
                │         │       └──→ Booking
                │         │
                └──→ Profile ←── Settings
```

---

## Sprint 3 — Settings + Loc

**Window:** TBD (2 minggu setelah Sprint 2 closing)
**Tema:** "Quick Wins — Audit + Polish Pages Paling Sederhana"

### Sprint Opening Audit (Day 1-2)
- **D3: Audit Loc Tab** → `docs/progress/loc_audit.md`
- **D4 (partial): Audit Settings** → `docs/progress/settings_audit.md`
- Referensi template: `docs/progress/home_page_audit.md`
- Output: todo list untuk Sprint 3

### Estimated Backlog (Day 3-10)

| Feature | Estimated Tasks | Ringkasan |
|---------|---------------|-----------|
| Settings | 5-10 tasks | Fix findings dari audit: hardcoded text, missing state handling, layout issues, Theme consistency |
| Loc | 8-12 tasks | Fix findings dari audit: loading state, error handling, PermissionDenied UI, Skeletonizer |
| Shared | 2-3 tasks | Generalize ErrorSection (dari Sprint 2 C6) untuk reuse cross-feature, icon consistency pass |

### Definition of Done
- [ ] Audit doc `loc_audit.md` published
- [ ] Audit doc `settings_audit.md` published
- [ ] Semua critical findings dari audit di-fix
- [ ] flutter analyze 0 issues
- [ ] Skeletonizer pattern applied (if loading states missing)
- [ ] ErrorSection pattern applied (if error states missing)
- [ ] `sprint_roadmap.md` updated

---

## Sprint 4 — Doctor

**Window:** TBD (2 minggu setelah Sprint 3)
**Tema:** "Doctor Search & Detail — Core Feature Stabilization"

### Sprint Opening Audit (Day 1-2)
- **D1: Audit Doctor Page** → `docs/progress/doctor_audit.md`
- Referensi template: `docs/progress/home_page_audit.md`

### Estimated Backlog
- Fix findings dari audit Doctor Search + Doctor Detail
- Known gaps (est. from wireframes):
  - Search bar debounce / real-time filter
  - Doctor card layout polish
  - Slot selection UI
  - Empty state ketika no doctors found
  - Error handling untuk network failure

### Definition of Done
- [ ] `doctor_audit.md` published
- [ ] Semua critical findings di-fix
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Sprint 5 — Booking

**Window:** TBD (2 minggu setelah Sprint 4)
**Tema:** "Booking Flow — Most Complex Feature"

### Sprint Opening Audit (Day 1-2)
- **D2: Audit Booking Flow** → `docs/progress/booking_audit.md`
- Referensi template: `docs/progress/home_page_audit.md`

### Estimated Backlog
- Fix findings dari audit Booking flow
- Known gaps (est. from wireframes + API contract):
  - Booking creation flow validation
  - Booking history pagination
  - Booking detail page completeness
  - Cancel booking confirmation dialog
  - Deep link handling untuk notif → booking detail
  - Success page after booking
  - Skeletonizer + ErrorSection patterns

### Definition of Done
- [ ] `booking_audit.md` published
- [ ] Semua critical findings di-fix
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Sprint 6 — Profile + Auth + Onboarding + FCM

**Window:** TBD (2 minggu setelah Sprint 5)
**Tema:** "User Management — Final Feature Polish"

### Sprint Opening Audit (Day 1-2)
- **D4 (partial): Audit Profile** → `docs/progress/profile_audit.md`
- **D5: Audit Onboarding + Auth + FCM** → `docs/progress/onboarding_auth_fcm_audit.md`
- **D7: Icon reference table** → `docs/reference/icons.md`

### Estimated Backlog
Sprint paling ringan (sebagian besar feature sudah production-ready). Fokus pada:
- Profile: avatar upload flow polish, Skeletonizer loading, ErrorSection
- Auth: race condition handling, session timeout UI
- Onboarding: review + final polish
- FCM: notification settings page
- Icon reference: mapping semua Iconsax → Material Icons

### Definition of Done
- [ ] `profile_audit.md` published
- [ ] `onboarding_auth_fcm_audit.md` published
- [ ] `docs/reference/icons.md` published
- [ ] Semua critical findings di-fix
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Sprint 7 — Testing Phase

**Window:** TBD (2 minggu setelah Sprint 6)
**Tema:** "Test Coverage ≥ 80%"

### Scope
- Setup test infrastructure (test/helpers, test/flutter_test_config.dart)
- Unit test semua UseCase
- BLoC test semua Cubit (event/state)
- Widget test halaman utama:
  - Home Page (6 sections)
  - Doctor Search + Detail
  - Booking History + Detail + Create
  - Profile + Settings
  - Loc
- Integration test flow kritis:
  - Auth flow (sign-up → create-profile → home)
  - Booking flow (search doctor → book → confirmation)
  - Settings navigation
- Target: **≥ 80% line coverage**

### Definition of Done
- [ ] Test coverage ≥ 80%
- [ ] Integration test untuk flow kritis
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Beta Launch Checklist

- [ ] Semua sprint selesai
- [ ] flutter analyze 0 issues
- [ ] Test coverage ≥ 80%
- [ ] Manual testing semua feature
- [ ] No critical bugs open
- [ ] README.md updated
- [ ] AGENTS.md final
- [ ] Semua audit docs published (home, settings, loc, doctor, booking, profile, auth)
- [ ] Icon reference `docs/reference/icons.md` published

---

## Detail Kompleksitas per Feature

### Settings (6 files)
```
lib/features/settings/
├── presentation/
│   ├── bloc/
│   │   └── settings_bloc.dart
│   ├── page/
│   │   ├── help_support_page.dart
│   │   ├── settings_page.dart
│   │   ├── terms_and_conditions_page.dart
│   │   └── no_internet_page.dart
│   └── bloc/
│       └── settings_state.dart
```
- **4 wireframes** (18-settings, 19-help-support, 20-tnc, 21-no-internet)
- **0 API endpoints** — fully offline/local
- **0 known bugs**
- **High wireframe-to-code ratio** → risk: wireframe spec mungkin tidak fully implemented

### Loc (12 files)
```
lib/features/loc/
├── data/ (5 files) — model, datasource, repository
├── domain/ (3 files) — entity, repository, usecase
└── presentation/ (4 files) — cubit, state, page
```
- **1 wireframe** (07-location-search)
- **2 API endpoints** (5.2 doctors-by-location, 5.5 get_nearby_clinics)
- **0 known bugs**
- **Sudah ada implementasi** — reuse untuk C3 Nearby Medical Centers

### Doctor (25 files)
```
lib/features/doctor/
├── data/ (8 files) — 4 freezed models + datasource + repository
├── domain/ (5 files) — 3 entities + repository + usecase
└── presentation/ (12 files) — 2 cubits, 2 pages, 4 widgets
```
- **2 wireframes** (08-doctor-search, 09-doctor-detail)
- **4 API endpoints** (search, by-location, detail, slots)
- **0 known bugs** — belum ada audit
- **@freezed + Bloc pattern** — well-structured, easy to audit

### Booking (25 files)
```
lib/features/booking/
├── data/ (5 files) — 2 freezed models
├── domain/ (5 files) — 3 entities + repository + usecase
└── presentation/ (15 files) — 3 blocs/cubits, 4 pages, 2 widgets
```
- **4 wireframes** (book-appointment, success, history, detail)
- **4 API endpoints** (create, history, detail, cancel)
- **0 known bugs** — belum ada audit
- **Event-driven Bloc** — kompleks, perlu test yang matang

---

*Dibuat: 16 Juni 2026 · Oleh Tech Lead (MiniMax-M3)*
*Berdasarkan: Sprint 2 closing + codebase analysis*