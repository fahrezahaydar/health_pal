# Sprint 4 Plan — Loc (Location Tab)

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | 16 Juni 2026 |
| **Sprint Window** | TBD (2 minggu setelah Sprint 3 closing) |
| **Tema Sprint** | **"Loc Tab Audit & Polish"** |
| **Acuan** | `wireframe/07-location-search.md` · `home_page_audit.md` (template) · `sprint_roadmap.md` · `api_contract_health_pal.md` §5.2, §5.5 · `sprint_2_plan.md` Pool D3 |
| **Tech Lead** | MiniMax-M3 |
| **Testing Policy** | **❌ NO TEST FILES** (deferred ke Sprint 9) |

---

## 📊 Sprint 4 Progress Tracker

**Last Updated:** 16 Juni 2026 (Sprint 4 Planned)
**Overall:** 1/9 tasks (11%) — S4.1 Audit ✅

| Task | Deskripsi | Audit Ref | Estimasi | Status | Commit | Catatan |
|------|-----------|-----------|:--------:|--------|--------|---------|
| S4.1 | Sprint Opening Audit — loc_audit.md | — | 3h | ✅ Done | `<this-commit>` | Verdict: 🟡 64.3/100. Wireframe 30%, Architecture 100%. Rekomendasi: tetap clinic-based (update wireframe) |
| S4.2 | Skeletonizer untuk loading state Loc | M1 | 1h | ⬜ Not Started | — | Ganti `DotLoader` → `Skeletonizer` per AD-6 |
| S4.3 | ErrorSection untuk error state Loc | M2 | 0.5h | ⬜ Not Started | — | Replace custom `_errorView()` → `ErrorSection` |
| S4.4 | Implementasi City Input fallback | K1 | 2h | ⬜ Not Started | — | Wireframe 07 fallback — input kota manual saat location denied |
| S4.5 | Implementasi Filter Chips (spesialisasi) | K2 | 3h | ⬜ Not Started | — | Filter horizontal chips → filter clinic list |
| S4.6 | Implementasi Sort Dropdown | K3 | 2h | ⬜ Not Started | — | Sort by jarak / doctor_count / name |
| S4.7 | Map View: feasibility study + stub | F1 | 2h | ⬜ Not Started | — | google_maps_flutter integration atau defer ke Sprint 5 |
| S4.8 | LocCubit: hapus iconsax + loading polish | L1 | 1h | ⬜ Not Started | — | Icon consistency (Material + TODO) + Skeletonizer |
| S4.9 | "Lihat Peta" error handling | L2 | 0.5h | ⬜ Not Started | — | try-catch di `_openMaps` |

---

## 1. Sprint Opening Audit

### 1.1 Audit Doc Target

`docs/progress/loc_audit.md` — mengikuti template `home_page_audit.md` + `settings_audit.md`

### 1.2 Cakupan Audit

| Area | Sumber | Metode |
|------|--------|--------|
| Wireframe 07-location-search.md vs Code | `docs/wireframe/07-location-search.md` | Section-by-section comparison |
| API Contract §5.2, §5.5 vs Code | `docs/api_contract/api_contract_health_pal.md` | Endpoint usage check |
| ERD clinics/doctors vs Code | `docs/erd/erd_healh_pal.md` | Entity mapping |
| User Flow §5.2 vs Code | `docs/user_flow/USER_FLOW.md` | Navigation triggers |
| TDD Clean Architecture vs Code | TDD 01-12 | Layer compliance |
| Icon Convention | AGENTS.md | Iconsax vs Material |

### 1.3 Pra-Audit Findings (Pre-Sprint)

| # | Temuan | Tingkat | Detail |
|---|--------|---------|--------|
| F1 | **Map View tidak ada** | 🔴 Missing Feature | Wireframe 07 utama: Google Map dengan pin clinic. Implementasi saat ini list-only |
| F2 | **City Input fallback tidak ada** | 🟡 Missing Feature | Wireframe 07 fallback: input kota manual saat location denied. Tidak ada |
| F3 | **Filter Chips tidak ada** | 🟡 Missing Feature | Wireframe 07: filter spesialisasi horizontal. Tidak ada |
| F4 | **Sort Dropdown tidak ada** | 🟡 Missing Feature | Wireframe 07: sort by jarak/rating/fee. Tidak ada |
| F5 | **Doctor Cards tidak ditampilkan** | 🟡 Wireframe Mismatch | Wireframe 07 menampilkan Doctor Card (dokter), implementasi menampilkan Clinic Card (klinik). Endpoint berbeda: §5.2 (doctors-by-location) vs §5.5 (get_nearby_clinics). Perlu verifikasi mana yang benar |
| F6 | **Loading pakai DotLoader** (bukan Skeletonizer) | 🟡 UX Polish | Harus Skeletonizer per AD-6 |
| F7 | **Error state custom** (bukan ErrorSection) | 🟢 UX Polish | Custom _errorView(), tidak reusable |
| F8 | **iconsax langsung** — tanpa Material fallback | 🟢 Icon Convention | Melanggar Icon Convention Sprint 2+ |
| F9 | **"Lihat Peta" tanpa try-catch** | 🟢 Error Handling | `_openMaps` di clinic_card.dart tanpa try-catch |

### 1.4 Scope Decision: Map View

**Map View (F1)** adalah feature terbesar. Estimasi: ~8-12h untuk integrasi `google_maps_flutter` + marker + pin clustering.

**Keputusan:** Map View akan di-scope sebagai **feasibility study + stub** di Sprint 4 (S4.7). Jika google_maps_flutter kompatibel dengan Flutter SDK saat ini, implementasi penuh akan didefer ke **Sprint 5 (Doctor)** karena mapping lebih relevan dengan Doctor Search "by location".

Jika tidak kompatibel, alternatif: static map image via URL API (Google Static Maps) sebagai fallback.

---

## 2. Sprint Backlog

### 2.1 Task Details

#### S4.1 Sprint Opening Audit (3h)

Buat `docs/progress/loc_audit.md`:
- 15 sections (Executive Summary, Wireframe vs Code, PRD vs Code, API vs Code, ERD vs Code, User Flow vs Code, TDD Compliance x 6, Bug Catalog, TODO, Score Card)
- Verifikasi pra-audit findings F1-F9
- Identifikasi temuan baru

**Output:** todo list final untuk Sprint 4
**Files:** `docs/progress/loc_audit.md` (new)

#### S4.2 Skeletonizer untuk Loading State (1h) — Ref: F6

Ganti `DotLoader` di `_LoadingView` dengan `Skeletonizer` pattern:
- Wrap `_loaded()` widget dengan Skeletonizer + mock ClinicEntity list
- `ClinicEntity.mock()` sudah ada (static method) — reuse langsung

**Pattern:**
```dart
LocLoading() => Skeletonizer(
  enabled: true,
  child: _loaded(
    context,
    ClinicEntity.mock(),
    state is LocLoaded ? state.radiusKm : 10,
  ),
),
```

**Files:**
- `lib/features/loc/presentation/page/loc_page.dart` (modify)

#### S4.3 ErrorSection untuk Error State (0.5h) — Ref: F7

Replace custom `_errorView()` dengan `ErrorSection` dari `lib/widgets/loader/error_section.dart`:
```dart
LocError(:final message) => Center(
  child: ErrorSection(
    message: message,
    onRetry: () => context.read<LocCubit>().requestLocationAndLoad(),
  ),
),
```

**Files:**
- `lib/features/loc/presentation/page/loc_page.dart` (modify)

#### S4.4 City Input Fallback (2h) — Ref: F2

**Wireframe:** 07-location-search.md §"Fallback (izin lokasi ditolak)"

**Spec:**
- Saat `LocPermissionDenied`, tampilkan input teks untuk nama kota
- User input kota → geocode via API (atau lookup table)
- Tampilkan daftar klinik berdasarkan kota

**Implementation (lightweight):**
- Tambah `TextEditingController` di `_permissionDenied` state
- Simpan nama kota di state cubit
- Filter/query klinik berdasarkan kota (jika endpoint support) atau tampilkan pesan "fitur tersedia segera" untuk MVP

**Files:**
- `lib/features/loc/presentation/page/loc_page.dart` (modify)
- `lib/features/loc/presentation/bloc/loc_cubit.dart` (modify — tambah city-based search method)

#### S4.5 Filter Chips (3h) — Ref: F3

**Wireframe:** 07-location-search.md §"Filter Chips"

**Spec:**
- Horizontal scrollable chip list di atas daftar klinik
- Chip = specialization name
- Tap chip → filter clinic list by specialization

**Implementation:**
- Load specialization list dari `SpecializationCubit` (existing dari Home)
- Atau buat endpoint call sendiri (GET /rest/v1/specializations)
- Filter clinic list by specialization name

**Files:**
- `lib/features/loc/presentation/page/loc_page.dart` (modify)
- `lib/features/loc/presentation/bloc/loc_cubit.dart` (modify — tambah filter state)
- `lib/features/loc/presentation/bloc/loc_state.dart` (modify — tambah selectedSpecialization)

#### S4.6 Sort Dropdown (2h) — Ref: F4

**Wireframe:** 07-location-search.md §"Sort Dropdown"

**Spec:**
- Dropdown dengan opsi: "Jarak Terdekat", "Dokter Terbanyak", "Nama A-Z"
- Sort clinic list accordingly

**Implementation:**
- Tambah enum `LocSortBy` (distance, doctorCount, name)
- Sort clinic list di presentasi layer (list sudah di memory)

**Files:**
- `lib/features/loc/presentation/page/loc_page.dart` (modify)

#### S4.7 Map View Feasibility Study (2h) — Ref: F1

**Objective:** Tentukan apakah Map View bisa diimplementasi di versi Flutter saat ini.

**Scope:**
1. Cek kompatibilitas `google_maps_flutter` dengan Flutter SDK `^3.10.4`
2. Jika kompatibel: buat stub Map widget dengan 1 marker (tanpa pin clustering)
3. Jika tidak kompatibel: ganti dengan static map image (Google Static Maps API)

**Output:** Keputusan → dokumentasi di loc_audit.md atau defer decision

**Files:**
- `lib/features/loc/presentation/widget/loc_map.dart` (new — stub)
- `pubspec.yaml` (modify — jika google_maps_flutter ditambah)

#### S4.8 Icon Consistency Pass (1h) — Ref: F8

Replace `Iconsax.*` dengan `Icons.*` + `// TODO: change to iconsax` di:
- `loc_page.dart` — icon di AppBar, error, empty, permission states
- `clinic_card.dart` — icon hospital, location, people, map
- Hapus import `iconsax_latest` dari file yang sudah full Material

**Files:**
- `lib/features/loc/presentation/page/loc_page.dart` (modify)
- `lib/widgets/card/clinic_card.dart` (modify)

#### S4.9 "Lihat Peta" Error Handling (0.5h) — Ref: F9

**Problem:** `_openMaps` di `clinic_card.dart` menggunakan `canLaunchUrl` + `launchUrl` tanpa try-catch.

**Fix:**
```dart
Future<void> _openMaps() async {
  try {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${clinic.latitude},${clinic.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  } catch (_) {}
}
```

**Files:**
- `lib/widgets/card/clinic_card.dart` (modify)

---

## 3. Timeline

| Day | Tasks | Detail |
|:---:|-------|--------|
| Day 1 | S4.1 — Audit | `loc_audit.md` — verifikasi F1-F9 |
| Day 2 | S4.1 — Audit lanjutan | Finalisasi, publish, alignment |
| Day 3 | S4.2 + S4.3 — Skeletonizer + ErrorSection | Polish loading/error |
| Day 4 | S4.7 — Map View feasibility | google_maps_flutter check, stub |
| Day 5 | S4.4 — City Input fallback | Wireframe fallback |
| Day 6 | S4.5 — Filter Chips | Horizontal chips + filter logic |
| Day 7 | S4.6 — Sort Dropdown | Enum sorting |
| Day 8 | S4.8 — Icon consistency | iconsax → Material + TODO |
| Day 9 | S4.9 — Error handling + buffer | `_openMaps` try-catch |
| Day 10 | Flutter analyze + Final Commit | 0 issues |

---

## 4. Definition of Done

- [ ] `docs/progress/loc_audit.md` published ✅
- [ ] Semua critical findings dari audit di-fix
- [ ] Loading: Skeletonizer (bukan DotLoader)
- [ ] Error: ErrorSection (bukan custom widget)
- [ ] City input fallback: user bisa cari klinik via kota (walau terbatas)
- [ ] Filter chips: filter klinik by specialization
- [ ] Sort dropdown: urut berdasarkan jarak/nama/dokter count
- [ ] Map View: feasibility decided + stub (atau defer documented)
- [ ] Icon consistency: Material + TODO (bukan Iconsax langsung)
- [ ] "Lihat Peta" error handling: try-catch + silent fail
- [ ] `flutter analyze` 0 issues
- [ ] `sprint_roadmap.md` updated

---

## 5. Risk & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| R1 — Map View terlalu besar untuk Sprint 4 | Sprint over-capacity | Defer ke Sprint 5 (Doctor). Focus on list + filter + sort |
| R2 — google_maps_flutter incompatible | Blocker | Fallback: Google Static Maps image URL |
| R3 — City input fallback butuh geocoding API | Extra scope | MVP: lookup table (kota besar Indonesia) atau defer |
| R4 — Filter chips butuh specialization data dari Home | Cross-feature dependency | Home `SpecializationCubit` sudah ada. Inject via use case atau panggil ulang endpoint |

---

*Disusun oleh Tech Lead (MiniMax-M3) · 16 Juni 2026 · v1.0*

**Status:** 📋 **PLAN READY — menunggu kick-off Sprint 4**

**Next Actions:**
1. `git add docs/`
2. Mulai Day 1: Sprint Opening Audit → `loc_audit.md`
