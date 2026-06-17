# Sprint 5 Plan — Doctor

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | 16 Juni 2026 |
| **Sprint Window** | TBD (2 minggu) |
| **Tema Sprint** | **"Doctor Search & Detail — Audit & Polish"** |
| **Acuan** | `docs/wireframe/08-doctor-search.md` · `docs/wireframe/09-doctor-detail.md` · `docs/api_contract/api_contract_health_pal.md` §5.1-5.4 · `docs/erd/erd_healh_pal.md` · `home_page_audit.md` (template) |
| **Tech Lead** | MiniMax-M3 |
| **Testing Policy** | ❌ NO TEST FILES (deferred ke Sprint 9) |

---

## 📊 Sprint 5 Progress Tracker

**Last Updated:** 16 Juni 2026
**Overall:** 0/10 tasks (0%)

| Task | Deskripsi | Estimasi | Status | Commit |
|------|-----------|:--------:|--------|--------|
| D1 | Sprint Opening Audit — doctor_audit.md | 3h | ⬜ Not Started | — |
| D2 | Skeletonizer loading state Doctor pages | 1h | ⬜ Not Started | — |
| D3 | ErrorSection untuk error state Doctor | 0.5h | ⬜ Not Started | — |
| D4 | Icon consistency: iconsax → Material + TODO | 1.5h | ⬜ Not Started | — |
| D5 | Search bar debounce + real-time filter | 2h | ⬜ Not Started | — |
| D6 | Doctor card layout polish + empty state | 2h | ⬜ Not Started | — |
| D7 | Slot selection UI polish | 2h | ⬜ Not Started | — |
| D8 | Pull-to-refresh Doctor Search + Detail | 1h | ⬜ Not Started | — |
| D9 | "Lihat Peta" try-catch + clinic map from Loc | 1h | ⬜ Not Started | — |
| D10 | Final QA + flutter analyze + commit | 1h | ⬜ Not Started | — |

**Total:** ~15h

---

## 1. Sprint Opening Audit

### Audit Doc Target

`docs/progress/doctor_audit.md` — mengikuti template `home_page_audit.md`

### Pre-Audit Findings

| # | Temuan | Tingkat | Detail |
|---|--------|---------|--------|
| F1 | Loading state masih CircularProgressIndicator / DotLoader | 🟡 | Perlu Skeletonizer (AD-6) |
| F2 | Error state custom (bukan ErrorSection) | 🟢 | Tidak reusable |
| F3 | iconsax langsung tanpa Material fallback | 🟢 | Icon Convention violation |
| F4 | Search bar mungkin tidak ada debounce | 🟡 | Perlu verifikasi audit |
| F5 | Doctor card layout vs wireframe | 🟡 | Perlu verifikasi audit |
| F6 | Slot selection UI vs wireframe | 🟡 | Perlu verifikasi audit |
| F7 | Pull-to-refresh mungkin tidak ada | 🟡 | Perlu verifikasi audit |
| F8 | "Lihat Peta" di Doctor Detail mungkin tanpa try-catch | 🟢 | Pattern dari Sprint 4 |

---

## 2. Task Details

#### D1 Sprint Opening Audit (3h)
Buat `doctor_audit.md` — 15 sections, verifikasi F1-F8, identifikasi temuan baru.

#### D2 Skeletonizer (1h)
Ganti loading indicator di Doctor Search + Doctor Detail dengan Skeletonizer wrapping production widget.

#### D3 ErrorSection (0.5h)
Ganti custom error widget dengan ErrorSection reusable.

#### D4 Icon Consistency (1.5h)
Ganti `Iconsax.*` → `Icons.*` + `// TODO: change to iconsax` di doctor pages.

#### D5 Search debounce + filter (2h)
Implementasi debounce pada search bar Doctor Search agar tidak terlalu banyak query.

#### D6 Doctor card polish + empty state (2h)
Polish card layout sesuai wireframe, tambah empty state jika 0 hasil.

#### D7 Slot selection UI polish (2h)
Polish slot date picker + time slot grid sesuai wireframe 09.

#### D8 Pull-to-refresh (1h)
Tambahkan RefreshIndicator di Doctor Search + Detail.

#### D9 Lihat Peta try-catch (1h)
Tambahkan try-catch pattern dari Sprint 4 ke Doctor Detail + clinic map.

#### D10 Final QA (1h)
flutter analyze 0 issues + update tracker.

---

## 3. Definition of Done

- [ ] `doctor_audit.md` published
- [ ] Skeletonizer di Doctor Search + Detail
- [ ] ErrorSection di Doctor Search + Detail
- [ ] Icon consistency (Material + TODO)
- [ ] Search bar debounce + real-time filter
- [ ] Doctor card layout sesuai wireframe
- [ ] Empty state untuk 0 hasil
- [ ] Slot selection UI sesuai wireframe
- [ ] Pull-to-refresh di kedua halaman
- [ ] "Lihat Peta" error handling
- [ ] `flutter analyze` 0 issues

---

*Disusun oleh Tech Lead · 16 Juni 2026 · v1.0*
