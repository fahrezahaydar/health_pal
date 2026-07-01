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
| **B1** | **Unit Testing Foundation — 320 tests, ~400 test cases** | ✅ **Done** |
| **B2** | Widget Test Phase — UI rendering (per-page, skeleton, error, empty states) | ⬜ Planned |
| **B3** | Integration Test + CI/CD — full flows + GitHub Actions + codecov | ⬜ Planned |

> *Sprint B1 completed — 94 task items, 82 test files, 320 tests, 0 failing. Next: Widget test phase.*

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
