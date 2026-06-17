# Sprint Roadmap — Health Pal

**Tanggal:** 16 Juni 2026
**Status Sprint Saat Ini:** Sprint I CLOSED ✅ (All features implemented)

---

## Sprint A — Completed (Sprint A through Sprint I)

| Sprint | Letter | Tema | Fitur | Status |
|--------|--------|------|-------|--------|
| 1 | **A** | Foundation | Auth, Home, Doctor, Booking, Profile, Loc, Settings, Notif | ✅ Done |
| 2 | **B** | Home Hardening | Bug fixes, Refactor, UX Polish (Skeletonizer, Pull-to-refresh, Nearby, Photo, Icons, Error UI) | ✅ Done |
| 3 | **C** | Settings | Settings pages — audit + polish | ✅ Done |
| 4 | **D** | Loc | Location tab — audit + polish + filter/sort/city fallback | ✅ Done |
| 4.5 | **E** | Map View | flutter_map implementation (Loc tab — split map + list) | ✅ Done |
| 5 | **F** | Doctor | Doctor Search + Detail — audit + polish | ✅ Done |
| 6 | **G** | Booking | Booking flow (create, history, detail, cancel) — audit + polish | ✅ Done |
| 7 | **H** | Profile | Profile, Edit Profile, Favorites, Notification — audit + polish | ✅ Done |
| 8 | **I** | Auth + FCM | Auth, Onboarding, FCM — audit + polish + icon reference | ✅ Done |

**Total: 9 sprints — Semua fitur inti selesai ✅**

---

## Sprint B+ — Sprint Berikutnya (TBD)

| Sprint | Fokus | Status |
|--------|-------|--------|
| **J** | TBD — Review, Refactor, Optimization | ⬜ Planned |
| **K** | TBD — Additional Features | ⬜ Planned |
| ... | ... | ⬜ |

> *Testing Phase akan direncanakan sebagai Sprint C/D (Sprint K/L) setelah review kebutuhan.*

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

### Plan Files (per sprint letter)

| File | Sprint |
|------|--------|
| `plans/sprint_b_plan.md` | Sprint B — Home Hardening |
| `plans/sprint_c_plan.md` | Sprint C — Settings |
| `plans/sprint_d_plan.md` | Sprint D — Loc |
| `plans/sprint_e_plan.md` | Sprint E — Map View |
| `plans/sprint_f_plan.md` | Sprint F — Doctor |
| `plans/sprint_g_plan.md` | Sprint G — Booking |
| `plans/sprint_h_plan.md` | Sprint H — Profile |
| `plans/sprint_i_plan.md` | Sprint I — Auth + FCM |

### Audit Files (per sprint letter)

| File | Sprint |
|------|--------|
| `audits/sprint_a_audit.md` | Sprint A — Home Page |
| `audits/sprint_c_audit.md` | Sprint C — Settings |
| `audits/sprint_d_audit.md` | Sprint D — Loc |
| `audits/sprint_f_audit.md` | Sprint F — Doctor |
| `audits/sprint_g_audit.md` | Sprint G — Booking |
| `audits/sprint_h_audit.md` | Sprint H — Profile |
| `audits/sprint_i_audit.md` | Sprint I — Auth + FCM |

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
