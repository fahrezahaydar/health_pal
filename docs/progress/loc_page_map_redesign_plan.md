# Location Page Map Redesign — Implementation Plan

**Referensi:** ADR-010, Wireframe v3.0 (docs/wireframe/07-location-search.md)
**Tanggal:** 28 Juni 2026
**Status:** 🟡 Planned

---

## Ringkasan Perubahan

| Aspek | Sebelum (v2.0) | Sesudah (v3.0) |
|-------|----------------|-----------------|
| **Layout** | CustomScrollView (vertical scroll) | Stack (full-screen map + overlays) |
| **Map** | 200px partial (SliverToBoxAdapter) | Full-screen FlutterMap (dominant) |
| **Clinic Display** | Vertical SliverList | Horizontal ClinicCarousel overlay |
| **Filter Chips** | ✅ Ada | ❌ Dihapus |
| **Sort Row** | ✅ Ada | ❌ Dihapus |
| **Search Bar** | AppBar title | ✅ In-page SearchBar overlay |
| **Radius Selector** | AppBar dropdown | ❌ Dihapus (implicit via zoom) |
| **AppBar** | Visible (title + radius) | Minimal/hidden (transparent overlay) |

---

## Dependency Order

### [D-1] Tidak ada dependency baru

✅ lutter_map: ^8.3.0 — sudah ada (ADR-002)
✅ latlong2: ^0.9.1 — sudah ada
✅ geolocator: ^14.0.3 — sudah ada
✅ skeletonizer: ^2.1.3 — sudah ada (ADR-001)
✅ cached_network_image: ^3.4.1 — sudah ada (ADR-006)

Tidak perlu lutter pub add apapun.

---

## Data Layer — Zero Changes

### Database

✅ Tidak ada migration baru — semua field sudah ada di tabel clinics:
- latitude, longitude — untuk map marker (existing)
- image_url — untuk thumbnail marker (existing)
- ating_avg, eview_count, category — untuk ClinicCard (existing sejak ADR-005)
- distance_meters, duration_minutes — dari RPC (existing)

### API Contract

✅ §5.5 get_nearby_clinics — semua field sudah return:
- Response shape tidak berubah (ADR-005 sudah update)
- Tidak perlu update changelog

### Data Source / Repository

✅ LocRemoteDataSource — tidak ada perubahan
✅ LocRepositoryImpl — tidak ada perubahan
✅ ClinicModel — tidak ada perubahan
✅ ClinicEntity — tidak ada perubahan

---

## Presentation Layer — Changes

### [P-1] LocState — Update fields
**File:** lib/features/loc/presentation/bloc/loc_state.dart

| Perubahan | Detail |
|-----------|--------|
| ❌ Hapus selectedSpecialization | Tidak ada filter chips lagi |
| ❌ Hapus sortBy | Tidak ada sort row lagi |
| ➕ Tambah searchKeyword | String? — filter local clinics by name |
| ➕ Tambah selectedClinicId | String? — marker highlight + carousel scroll |

### [P-2] LocCubit — Update methods
**File:** lib/features/loc/presentation/bloc/loc_cubit.dart

| Perubahan | Detail |
|-----------|--------|
| ❌ Hapus setFilter() | Tidak dipakai |
| ❌ Hapus setSortBy() | Tidak dipakai |
| ❌ Hapus _specializations static list | Pindah ke Doctor Search |
| ➕ Tambah setSearchKeyword(String) | Filter list lokal by name (case-insensitive) |
| ➕ Tambah selectClinic(String id) | Set selected clinic → emit state |
| ♻️ Ubah _load() | Apply search filter (jika ada keyword) sebelum emit |

### [P-3] LocMapWidget — Fullscreen + Marker Upgrade
**File:** lib/features/loc/presentation/widget/loc_map_widget.dart

| Perubahan | Detail |
|-----------|--------|
| ♻️ Layout map jadi fullscreen | Hapus constraint height 200px, hapus ClipRRect + orderRadius |
| ➕ Custom marker widget | _ClinicMapMarker — pin background + ClipOval + thumbnail 40x40 |
| ➕ Selected marker state | Parameter selectedClinicId — selected marker scale up + diff color |
| ♻️ onMarkerTap behavior | Center map → set selectedClinicId via callback |
| ➕ User location accuracy circle | Opsional — circle radius sesuai Position.accuracy |
| ♻️ MapController animation | mapController.move() dengan curve + duration untuk smooth transition |

### [P-4] LocPage — Full Layout Rewrite
**File:** lib/features/loc/presentation/page/loc_page.dart

Layout baru:

`dart
Scaffold(
  body: Stack(
    children: [
      // Layer 1: Fullscreen Map
      LocMapWidget(
        clinics: filteredClinics,
        userLat: currentPosition.latitude,
        userLng: currentPosition.longitude,
        selectedClinicId: selectedClinicId,
        onMarkerTap: (clinic) => selectClinic(clinic.id),
      ),

      // Layer 2: SearchBar overlay (top)
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SearchBar(
            hintText: 'Search Clinic / Hospital',
            onChanged: (keyword) => setSearchKeyword(keyword),
          ),
        ),
      ),

      // Layer 3: ClinicCarousel overlay (bottom)
      if (clinics.isNotEmpty)
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: SizedBox(
              height: 200, // ClinicCard height
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: clinics.map((c) => Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: ClinicCard(
                      clinic: c,
                      width: 240,
                      isSelected: c.id == selectedClinicId,
                      onTap: () => navigateToClinicDetail(c.id),
                      onFavoriteTap: () => toggleFavorite(c.id),
                    ),
                  )).toList(),
                ),
              ),
            ),
          ),
        ),
    ],
  ),
)
`

| Item Perubahan | Detail |
|----------------|--------|
| ❌ Hapus AppBar | Ganti dengan SearchBar overlay |
| ❌ Hapus _specializations | Pindah ke Doctor Search |
| ❌ Hapus filter chips builder | Tidak ada di wireframe baru |
| ❌ Hapus sort row builder | Tidak ada di wireframe baru |
| ❌ Hapus info banner | Tidak ada di wireframe baru |
| ❌ Hapus RefreshIndicator | Ganti dengan map long-press atau button |
| ❌ Hapus SliverList | Ganti dengan ClinicCarousel |
| ➕ Stack + LocMapWidget fullscreen | Layer 1 |
| ➕ SafeArea + SearchBar | Layer 2 — search overlay |
| ➕ Align + ClinicCarousel | Layer 3 — carousel overlay |
| ♻️ _loaded() → simplify | Hanya handling untuk map-based layout |
| ♻️ Loading state tetap Skeletonizer | Skeletonizer wrap production widget (ADR-001) |
| ♻️ Permission denied state retain | Fallback input kota tetap dipertahankan |

### [P-5] ClinicCard — Tambah isSelected (Minor)
**File:** lib/widgets/card/clinic_card.dart

| Perubahan | Detail |
|-----------|--------|
| ➕ Tambah isSelected parameter | ool isSelected = false — highlight card saat marker dipilih |
| ➕ Selected visual | Border AppTheme.blue 2px atau slight scale |

### [P-6] SearchBar widget — Optional
**File:** New — lib/widgets/shared/search_bar.dart atau inline di LocPage

Opsi lebih sederhana: inline TextField di LocPage (tidak perlu widget baru). Jika SearchBar dipakai di feature lain di masa depan, extract ke shared widget.

### [P-7] Hapus unused imports
**File:** lib/features/loc/presentation/page/loc_page.dart

Hapus import yang tidak terpakai setelah refactor:
- AppIcons (jika tidak dipakai langsung)
- PrimaryButton (jika tidak dipakai di _loaded)
- ErrorSection (retain — masih dipakai untuk LocError state)

---

## Files Affected

| # | File | Perubahan |
|---|------|-----------|
| 1 | lib/features/loc/presentation/bloc/loc_state.dart | Hapus selectedSpecialization, sortBy. Tambah searchKeyword, selectedClinicId |
| 2 | lib/features/loc/presentation/bloc/loc_cubit.dart | Hapus setFilter, setSortBy, _specializations. Tambah setSearchKeyword, selectClinic. Update _load. |
| 3 | lib/features/loc/presentation/widget/loc_map_widget.dart | Fullscreen layout, custom marker widget, selected state, smooth animation |
| 4 | lib/features/loc/presentation/page/loc_page.dart | Full rewrite — Stack layout, hapus slivers, tambah SearchBar + Carousel |
| 5 | lib/widgets/card/clinic_card.dart | Tambah isSelected parameter + visual highlight |

---

## Verifikasi

| # | Item | Command / Metode |
|---|------|------------------|
| 1 | lutter analyze | 0 issues |
| 2 | dart run build_runner build --force-jit | Regenerate .g.dart (tidak ada perubahan di model, hanya safety) |
| 3 | Visual test — map fullscreen | Map menempati seluruh layar, tidak ada gap putih |
| 4 | Visual test — marker | Setiap klinik punya marker dengan thumbnail |
| 5 | Visual test — carousel | Horizontal scroll, card tampil benar (cover image, name, address, rating, distance) |
| 6 | Interaction — marker tap | Center map ke lokasi klinik + highlight card di carousel |
| 7 | Interaction — carousel scroll | Scroll antar card, marker highlight tetap sync |
| 8 | Interaction — search | Filter klinik by name, marker di map terfilter |
| 9 | Interaction — favorite toggle | Heart icon toggle di ClinicCard (local state) |
| 10 | Edge — location denied | Fallback input kota muncul (retain from v2.0) |
| 11 | Edge — empty result | Carousel empty state "Tidak ada klinik" |
| 12 | Loading state | Skeletonizer wrap LocMapWidget + dummy ClinicCard |

---

## Blast Radius

| Area | Dampak | Mitigasi |
|------|--------|----------|
| **LocPage only** | ✅ Terisolasi — tidak ada consumer lain dari LocCubit selain LocPage | — |
| **ClinicCard** | ⚠️ Tambah isSelected — backward compatible (default false) | Consumer existing (Home Nearby) tidak terpengaruh |
| **Home Nearby** | ❌ Tidak terpengaruh — beda data source | — |
| **Doctor Search** | ❌ Tidak terpengaruh | — |
| **Doctor Detail** | ❌ Tidak terpengaruh | — |
| **LocCubit** | ⚠️ Hapus method + field — cuma dipakai LocPage | Breaking change hanya di 1 file |

---

## Effort Estimate

| Task | File | Est. (jam) |
|------|------|------------|
| LocState update | loc_state.dart | 0.25 |
| LocCubit update | loc_cubit.dart | 0.5 |
| LocMapWidget fullscreen + markers | loc_map_widget.dart | 2 |
| LocPage full layout rewrite | loc_page.dart | 3 |
| ClinicCard isSelected | clinic_card.dart | 0.25 |
| lutter analyze + fix | — | 0.5 |
| Visual verification | — | 0.5 |
| **Total** | | **7 jam** |

---

*Referensi: ADR-010, docs/wireframe/07-location-search.md v3.0, docs/adr/010_location_page_map_redesign.md*
