# Sprint Roadmap — Health Pal

**Tanggal:** 16 Juni 2026
**Status Sprint Saat Ini:** Sprint I CLOSED ✅ (All features implemented)

---

## Sprint A — Completed (Sprint A through Sprint I)

| Sprint | Tema | Fitur | Status |
|--------|------|-------|--------|
| **A1** | Foundation | Auth, Home, Doctor, Booking, Profile, Loc, Settings, Notif | ✅ Done |
| **A2** | Home Hardening | Bug fixes (2A), Refactor (2B), UX Polish (2C), Audit (2D), Optional (2E) | ✅ Done |
| **A3** | Settings | Settings pages — audit + polish | ✅ Done |
| **A4** | Loc | Location tab — audit + polish + filter/sort/city fallback | ✅ Done |
| **A5** | Map View | flutter_map implementation (Loc tab — split map + list) | ✅ Done |
| **A6** | Doctor | Doctor Search + Detail — audit + polish | ✅ Done |
| **A7** | Booking | Booking flow (create, history, detail, cancel) — audit + polish | ✅ Done |
| **A8** | Profile | Profile, Edit Profile, Favorites, Notification — audit + polish | ✅ Done |
| **A9** | Auth + FCM | Auth, Onboarding, FCM — audit + polish + icon reference | ✅ Done |

**Total: 9 sprint (A1-A9) — Semua fitur inti selesai ✅**

---

## Sprint B+ — Sprint Berikutnya (TBD)

| Sprint | Fokus | Status |
|--------|-------|--------|
| **B1** | **Unit Testing Foundation — 332 tests, 66 test files, 50.4% tracked coverage** | ✅ **Done** (2 Jul 2026) |
| **B2** | Widget Test Phase — UI rendering (per-page, skeleton, error, empty states) | ⬜ Planned |
| **B3** | Integration Test + CI/CD — full flows + GitHub Actions + codecov | ⬜ Planned |

> *Sprint B1 closed — 332/332 tests pass, 50.4% coverage tracked, 3 BUG regression tests verified, 0 production code change. Audit: `docs/progress/audits/sprint_b1_audit.md`.*

---

## Sprint C — UI Framework Migration (ADR 014) — TBD

> **Strategic Initiative:** Migrasi inkremental dari Material UI ke internal `HP*` UI Framework per `docs/adr/014-ui-framework-foundation.md` (Accepted Juli 2026). 9-layer framework, 12-phase migration (P0–P12), zero downtime.

| Sprint | Fokus | Layer | Phase | Status |
|--------|-------|:---:|:---:|--------|
| **C1** | **UI Foundation + Theme Tokens** — `lib/framework/` (Layer 1+2) + 11 token class + backward-compat facade | 1–2 | P0+P1 | 📋 Plan Ready |
| **C2** | Primitives + Interaction — `HPText`, `HPIcon`, `HPContainer`, `HPCard`, `HPGestureDetector`, `HPInkRipple` | 3–4 | P2+P3 | ⬜ Planned |
| **C3** | Layout + Navigation — `HPScaffold`, `HPListView`, `HPAppBar`, `HPBottomNavBar` + `Legacy*` adapter | 5–6 | P4+P5 | ⬜ Planned |
| **C4** | Input + Feedback — `HPTextField`, `HPForm`, `HPDatePicker`, `HPSnackbar`, `HPProgressIndicator` + reuse `AppInputField`/`AppForm` | 7–8 | P6+P7 | ⬜ Planned |
| **C5** | HP Components + Root Widget — `HPDoctorCard`, `HPAppointmentCard`, `HPApp` (ganti `MaterialApp.router`) | 9 | P8+P9 | ⬜ Planned |
| **C6** | Per-Feature Migration (Bagian 1) — Onboarding + Settings + Auth | — | P10.1 | ⬜ Planned |
| **C7** | Per-Feature Migration (Bagian 2) — Home + Doctor + Loc + Profile | — | P10.2 | ⬜ Planned |
| **C8** | Per-Feature Migration (Bagian 3) — Booking + Pubspec Cleanup (hapus `flex_color_scheme`) | — | P10.3+P11 | ⬜ Planned |
| **C9** | Legacy Deprecation — `@Deprecated` annotation di `lib/widgets/`, linter warning, hapus total | — | P12 | ⬜ Planned |

> **Catatan:** Sequence C6–C8 (P10 Per-Feature Migration) bisa di-adjust per sprint capacity. Sequence C1–C5 (P0–P9 framework build) **strict** karena ada dependency layer. C9 (P12) wajib setelah 1 sprint stabil tanpa warning.

**Dokumen terkait:**
- [`docs/adr/014-ui-framework-foundation.md`](../adr/014-ui-framework-foundation.md) — ADR utama
- [`docs/progress/plans/sprint_c1_ui_foundation.md`](plans/sprint_c1_ui_foundation.md) — Sprint C1 plan detail

---

## Beta Launch Checklist

- [ ] Semua sprint inti selesai ✅
- [ ] flutter analyze 0 issues ✅
- [ ] Manual testing semua feature
- [ ] No critical bugs open
- [ ] README.md updated
- [ ] AGENTS.md final
- [ ] Icon reference `docs/reference/icons.md` published ✅

---

## File Reference

| Path | Deskripsi |
|------|-----------|
| `docs/progress/plans/` | Sprint plan files (Sprint B-I) |
| `docs/progress/audits/` | Audit result files |
| `docs/progress/sprint_progress.md` | Complete progress tracker |
| `docs/reference/icons.md` | Icon mapping table |

### Plan Files

| File | Sprint |
|------|--------|
| `plans/sprint_a2_plan.md` | A2 — Home Hardening |
| `plans/sprint_a3_plan.md` | A3 — Settings |
| `plans/sprint_a4_plan.md` | A4 — Loc |
| `plans/sprint_a5_plan.md` | A5 — Map View |
| `plans/sprint_a6_plan.md` | A6 — Doctor |
| `plans/sprint_a7_plan.md` | A7 — Booking |
| `plans/sprint_a8_plan.md` | A8 — Profile |
| `plans/sprint_a9_plan.md` | A9 — Auth + FCM |
| `plans/sprint_b1_unit_testing.md` | B1 — Unit Testing Foundation |
| `audits/sprint_b1_audit.md` | B1 — Closing Report (332 tests, 50.4% coverage) |
| `plans/sprint_c1_ui_foundation.md` | C1 — UI Foundation + Theme Tokens |

### Audit Files

| File | Sprint |
|------|--------|
| `audits/sprint_a1_audit.md` | A1 — Home Page |
| `audits/sprint_a3_audit.md` | A3 — Settings |
| `audits/sprint_a4_audit.md` | A4 — Loc |
| `audits/sprint_a6_audit.md` | A6 — Doctor |
| `audits/sprint_a7_audit.md` | A7 — Booking |
| `audits/sprint_a8_audit.md` | A8 — Profile |
| `audits/sprint_a9_audit.md` | A9 — Auth + FCM |

---

## Kompleksitas Analysis

| Feature | File Count | Wireframe Count | Endpoint Count | Kompleksitas |
|---------|:---------:|:---------------:|:--------------:|:------------:|
| Onboarding | 2 | 1 | 0 | **Low** ✅ |
| Auth | 18 | 4 | 6 | **Low-Medium** ✅ |
| Settings | 6 | 4 | 0 | **Low** ✅ |
| Loc | 12 | 1 | 2 | **Low-Medium** ✅ |
| Notification | 7 | 1 | 2 | **Low** ✅ |
| Profile | 22 | 3 | 5 | **Medium** ✅ |
| Doctor | 25 | 2 | 4 | **Medium** ✅ |
| Booking | 25 | 4 | 4 | **High** ✅ |
| Home | 40 | 1 | 6 | **Highest** ✅ |

---

*Dibuat: 16 Juni 2026 · Updated: Struktur Sprint Letter-based*
