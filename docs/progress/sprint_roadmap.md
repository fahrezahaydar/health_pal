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
| Sprint 3 | Settings | Settings pages — audit + polish | `settings_audit.md` | 2 minggu |
| Sprint 4 | Loc | Location tab — audit + polish | `loc_audit.md` | 2 minggu |
| Sprint 5 | Doctor | Doctor Search + Detail — audit + polish | `doctor_audit.md` | 2 minggu |
| Sprint 6 | Booking | Booking flow (create, history, detail, cancel) — audit + polish | `booking_audit.md` | 2 minggu |
| Sprint 7 | Profile | Profile, Edit Profile, Favorites — audit + polish | `profile_audit.md` | 2 minggu |
| Sprint 8 | Auth + FCM | Auth, Onboarding, FCM — audit + polish + icon reference | `onboarding_auth_fcm_audit.md` | 2 minggu |
| Sprint 9 | Testing | Test coverage ≥ 80% across all features | — | 2 minggu |
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

## Sprint 3 — Settings

**Window:** TBD (2 minggu setelah Sprint 2 closing)
**Tema:** "Quick Win — Settings Page Audit & Polish"
**Plan:** `docs/progress/sprint_3_plan.md`

### Pra-Audit Findings (Identified Pre-Sprint)

| # | Temuan | Tingkat | Detail |
|---|--------|---------|--------|
| F1 | Missing "Data & Cache" section | 🔴 | Wireframe 18 §Data & Cache — tidak ada di implementasi |
| F2 | Missing "Telepon Darurat" field | 🟡 | Wireframe 18 catatan kaki — tidak ada |
| F3 | SettingsCubit pakai SupabaseClient langsung | 🟡 | Architecture violation (sama seperti K4 di Sprint 2) |
| F4 | Tidak ada data/domain layer | 🟡 | Hanya presentation layer |
| F5 | Loading state pakai CircularProgressIndicator | 🟡 | Harus Skeletonizer (AD-6) |
| F6 | Error state custom (bukan ErrorSection) | 🟢 | Tidak reusable |
| F7 | iconsax langsung tanpa Material fallback | 🟢 | Melanggar Icon Convention |
| F8 | NoInternetPage inline connectivity_plus | 🟡 | Logic di widget langsung |
| F9 | Dark Mode toggle adalah stub | 🟢 | Tidak menyimpan preferensi |

### Sprint Opening Audit (Day 1-2)
- **Audit Settings** → `docs/progress/settings_audit.md`
- Referensi template: `docs/progress/home_page_audit.md`
- Verifikasi F1-F9 + cari temuan baru

### Backlog (Day 3-10)

| Task | Deskripsi | Estimasi |
|------|-----------|:--------:|
| S3.1 | Sprint Opening Audit (settings_audit.md) | 4h |
| S3.2 | Skeletonizer untuk loading state Settings | 2h |
| S3.3 | ErrorSection untuk error state Settings | 1h |
| S3.4 | Refactor SettingsCubit — data layer (repository pattern) | 3h |
| S3.5 | Implement "Data & Cache" section (Hapus Cache, Hapus Data Lokal) | 2h |
| S3.6 | Implement "Telepon Darurat" field | 1h |
| S3.7 | Help & Support — audit + polish | 2h |
| S3.8 | Terms & Conditions — audit + polish | 1h |
| S3.9 | No Internet page — refactor connectivity logic | 2h |
| S3.10 | Icon consistency pass (iconsax → Material + TODO comments) | 2h |
| | **Total** | **~20h** |

### Definition of Done
- [ ] `settings_audit.md` published
- [ ] Semua findings di-fix
- [ ] Loading: Skeletonizer · Error: ErrorSection · Icon: Material + TODO
- [ ] SettingsCubit tidak langsung inject SupabaseClient
- [ ] "Data & Cache" + "Telepon Darurat" terimplementasi
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Sprint 4 — Loc (Location Tab)

**Window:** TBD (2 minggu setelah Sprint 3)
**Tema:** "Location — Nearby Clinics Map & List"

### Sprint Opening Audit (Day 1-2)
- **Audit Loc Tab** → `docs/progress/loc_audit.md`
- Referensi template: `docs/progress/home_page_audit.md`

### Estimated Backlog (Day 3-10)
- Fix findings dari audit Loc tab
- Known gaps:
  - Location permission flow (sudah ada di LocCubit, audit UX)
  - Loading state + skeleton (Skeletonizer)
  - Error handing + retry (ErrorSection)
  - "Lihat Peta" URL launcher
  - Radius filter UI
  - Clinic card polish (image placeholder, distance display)

**Total estimasi:** ~6-8 hari kerja

### Definition of Done
- [ ] `loc_audit.md` published
- [ ] Semua critical findings di-fix
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Sprint 5 — Doctor

**Window:** TBD (2 minggu setelah Sprint 4)
**Tema:** "Doctor Search & Detail — Core Feature Stabilization"

### Sprint Opening Audit (Day 1-2)
- **Audit Doctor Page** → `docs/progress/doctor_audit.md`
- Referensi template: `docs/progress/home_page_audit.md`

### Estimated Backlog
- Fix findings dari audit Doctor Search + Doctor Detail
- Known gaps (est. from wireframes):
  - Search bar debounce / real-time filter
  - Doctor card layout polish
  - Slot selection UI
  - Empty state ketika no doctors found
  - Error handling untuk network failure

**Dependency:** None (independent feature)

### Definition of Done
- [ ] `doctor_audit.md` published
- [ ] Semua critical findings di-fix
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Sprint 6 — Booking

**Window:** TBD (2 minggu setelah Sprint 5)
**Tema:** "Booking Flow — Most Complex Feature"

### Sprint Opening Audit (Day 1-2)
- **Audit Booking Flow** → `docs/progress/booking_audit.md`
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

**Dependency:** Doctor (search dokter → booking — butuh Doctor selesai)

### Definition of Done
- [ ] `booking_audit.md` published
- [ ] Semua critical findings di-fix
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Sprint 7 — Profile

**Window:** TBD (2 minggu setelah Sprint 6)
**Tema:** "Profile & Favorites — User Identity Polish"

### Sprint Opening Audit (Day 1-2)
- **Audit Profile** → `docs/progress/profile_audit.md`
- Referensi template: `docs/progress/home_page_audit.md`

### Estimated Backlog
- Profile page: avatar upload, data display, loading states
- Edit Profile: form validation, save flow
- Favorites page: list, remove, empty state

### Definition of Done
- [ ] `profile_audit.md` published
- [ ] Semua critical findings di-fix
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Sprint 8 — Auth + Onboarding + FCM

**Window:** TBD (2 minggu setelah Sprint 7)
**Tema:** "Auth Ecosystem — Final Audit & Icon Reference"

### Sprint Opening Audit (Day 1-2)
- **Audit Onboarding + Auth + FCM** → `docs/progress/onboarding_auth_fcm_audit.md`
- **Icon reference table** → `docs/reference/icons.md`

### Estimated Backlog
- Auth: session handling, token refresh, edge cases (BUG-001/004 sudah fix, verify)
- Onboarding: final polish, review
- FCM: notification settings page integration
- Icon reference: mapping semua Iconsax → Material Icons

**Catatan:** Semua feature ini sudah production-ready ✅ di Sprint 1. Sprint 8 mostly audit + verification + dokumentasi.

### Definition of Done
- [ ] `onboarding_auth_fcm_audit.md` published
- [ ] `docs/reference/icons.md` published
- [ ] Semua critical findings di-fix
- [ ] flutter analyze 0 issues
- [ ] `sprint_roadmap.md` updated

---

## Sprint 9 — Testing Phase

**Window:** TBD (2 minggu setelah Sprint 8)
**Tema:** "Test Coverage ≥ 80%"

### Scope
- Setup test infrastructure (test/helpers, test/flutter_test_config.dart)
- Unit test semua UseCase
- BLoC test semua Cubit (event/state)
- Widget test halaman utama:
  - Home Page (6 sections)
  - Doctor Search + Detail
  - Booking History + Detail + Create
  - Profile + Settings + Loc
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