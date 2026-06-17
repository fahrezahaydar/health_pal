# Loc Page — Audit Komprehensif

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal Audit** | 16 Juni 2026 |
| **Auditor** | Tech Lead (MiniMax-M3) |
| **Cakupan** | Loc Tab (`/loc` — Shell Tab 1 bottom nav) |
| **Acuan Dokumen** | wireframe/07-location-search.md · erd_healh_pal.md · api_contract_health_pal.md §5.2, §5.5 · USER_FLOW.md · TDD 01-12 · sprint_progress.md |
| **Tujuan** | Membandingkan **state of the docs** ↔ **state of the code** · mengidentifikasi gap, deviation, dan TODO actionable untuk Sprint 4 |

---

## Daftar Isi

1. [Ringkasan Eksekutif](#1-ringkasan-eksekutif)
2. [Wireframe vs Implementasi](#2-wireframe-vs-implementasi)
3. [PRD vs Implementasi](#3-prd-vs-implementasi)
4. [API Contract vs Implementasi](#4-api-contract-vs-implementasi)
5. [ERD vs Implementasi](#5-erd-vs-implementasi)
6. [User Flow vs Implementasi](#6-user-flow-vs-implementasi)
7. [TDD Arsitektur vs Implementasi](#7-tdd-arsitektur-vs-implementasi)
8. [TDD State Management vs Implementasi](#8-tdd-state-management-vs-implementasi)
9. [TDD Data Layer vs Implementasi](#9-tdd-data-layer-vs-implementasi)
10. [TDD Routing vs Implementasi](#10-tdd-routing-vs-implementasi)
11. [TDD Caching vs Implementasi](#11-tdd-caching-vs-implementasi)
12. [TDD Error Handling vs Implementasi](#12-tdd-error-handling-vs-implementasi)
13. [Deviation & Bug Catalog](#13-deviation--bug-catalog)
14. [TODO Sprint 4 (Actionable)](#14-todo-sprint-4-actionable)
15. [Score Card](#15-score-card)

---

## 1. Ringkasan Eksekutif

### 1.1 Verdict

🟡 **LOC TAB 55% LENGKAP** — Arsitektur solid (data → domain → presentation), cubit dengan sealed state, permission flow lengkap. Namun **1 section UI utama hilang** (Map View), **3 komponen wireframe tidak ada** (City Input fallback, Filter Chips, Sort Dropdown), dan **data entity mismatch** (clinic cards vs doctor cards di wireframe). Ada **3 deviation Sprint 2 policy** (Skeletonizer, ErrorSection, Icon Convention).

### 1.2 Skor Per Aspek

| # | Aspek Audit | Skor | Status |
|---|---|---|---|
| 1 | Wireframe coverage (10 components) | **3/10 (30%)** | 🔴 |
| 2 | PRD requirement coverage | **N/A** (Loc tidak di PRD) | 🟢 |
| 3 | API Contract alignment (§5.5) | **✅ 100%** — get_nearby_clinics | 🟢 |
| 4 | API Contract (§5.2 doctors-by-location) | **❌ 0%** — not used | ❌ |
| 5 | ERD mapping (clinics entity) | **✅ 100%** | 🟢 |
| 6 | TDD Clean Architecture compliance | **✅ 100%** — data/domain/presentation | 🟢 |
| 7 | TDD State Management (sealed + pattern) | **✅ 100%** | 🟢 |
| 8 | TDD Data Layer (freezed + JsonKey) | **✅ 100%** | 🟢 |
| 9 | TDD Routing | **✅ 100%** — `/loc` shell tab | 🟢 |
| 10 | TDD Caching | **N/A** (tidak ada cache di loc) | 🟢 |
| 11 | TDD Error Handling | **✅ 100%** — Result<T> + ErrorHandler | 🟢 |
| 12 | Skeletonizer loading (AD-6) | **❌ 0%** (masih DotLoader) | 🔴 |
| 13 | ErrorSection (Sprint 2 C6) | **❌ 0%** (custom `_errorView`) | 🟡 |
| 14 | Icon Convention (Material + TODO) | **❌ 0%** (masih Iconsax langsung) | 🔴 |
| 15 | Code quality (flutter analyze) | **0 issue** | 🟢 |
| | **Rata-rata** | **~58 / 100** | **🟡** |

### 1.3 Visual Heatmap

```
WIREFRAME         ███░░░░░░  30%  🔴
PRD               N/A             🟢
API CONTRACT      █████░░░░  50%  🟡
ERD               ██████████ 100% 🟢
ARCHITECTURE      ██████████ 100% 🟢
STATE MGMT        ██████████ 100% 🟢
DATA LAYER        ██████████ 100% 🟢
ROUTING           ██████████ 100% 🟢
ERROR HANDLING    ██████████ 100% 🟢
SKELETONIZER      ░░░░░░░░░░   0%  🔴
ICON CONVENTION   ░░░░░░░░░░   0%  🔴
────────────────────────────────────
TOTAL             █████░░░░ ~58%  🟡
```

### 1.4 Yang Sudah Benar

✅ Clean Architecture 3-lapis (Data / Domain / Presentation) lengkap.
✅ `@freezed` ClinicModel dengan `@JsonKey` mapping untuk snake_case API.
✅ `LocCubit` dengan sealed state pattern (`Initial / Loading / Loaded / PermissionDenied / Error`).
✅ `LocLoaded` state menyimpan `clinics`, `currentPosition`, `radiusKm`.
✅ `LocPermissionDenied` state distinct dari `LocError` — defense-in-depth.
✅ Permission flow lengkap: service check → permission check → location request → API call.
✅ Radius selector di AppBar (1/3/5/10 km) via `PopupMenuButton`.
✅ Empty state "Tidak Ada Klinik" dengan saran perbesar radius.
✅ RefreshIndicator untuk pull-to-refresh.
✅ `ClinicCard` reusable widget dengan image, name, address, distance, doctor count, "Lihat Peta".
✅ `LocRemoteDataSource` call `get_nearby_clinics` RPC dengan konversi km → meters.
✅ `GetNearbyClinicsUseCase` sebagai domain layer.
✅ `Result<T>` pattern + `ErrorHandler` untuk error handling.
✅ `ClinicEntity` memiliki display helpers: `distanceDisplay`, `doctorCountDisplay`, `distanceKm`.
✅ Reusable `ClinicEntity.mock()` static factory untuk skeleton/testing.
✅ `flutter analyze` 0 issues.

### 1.5 Yang Harus Diperbaiki (Ringkas)

🔴 **KRITIS:**
- K1: **Map View tidak ada** — wireframe 07 primary component: Google Map dengan pin clinic. Implementasi list-only tanpa map.
- K2: **Data entity mismatch** — wireframe menampilkan **Doctor Cards** (dokter), implementasi menampilkan **Clinic Cards** (klinik). Endpoint berbeda: §5.2 (doctors-by-location) vs §5.5 (get_nearby_clinics).

🟡 **MEDIUM:**
- M1: **Loading pakai `DotLoader`** — harus `Skeletonizer` per AD-6.
- M2: **Error state custom** (bukan `ErrorSection`) — duplikasi kode.
- M3: **City Input fallback tidak ada** — wireframe 07 §fallback: input kota manual saat location denied.
- M4: **Filter Chips tidak ada** — wireframe 07: filter spesialisasi horizontal.
- M5: **Sort Dropdown tidak ada** — wireframe 07: sort by jarak/rating/fee.
- M6: **Iconsax langsung** — tanpa Material fallback (Icon Convention Sprint 2+).

🟢 **LOW:**
- L1: **"Lihat Peta" tanpa try-catch** — `_openMaps` di `clinic_card.dart:51-56` tanpa error handling.
- L2: **`ClinicCard.skeleton()` factory tidak dipakai** — ada method `ClinicCard.skeleton()` di file widget tapi tidak digunakan.
- L3: **Wireframe "Filter Chips" bukan specialization —** wireframe 07 menggunakan "Filter Chips" yang mengubah `order` parameter (bukan filter client-side). API mungkin perlu endpoint baru.

---

## 2. Wireframe vs Implementasi

### 2.1 Mapping Komponen

| Wireframe Component | Widget | Data Source | Implementasi | Verdict |
|---|---|---|---|---|
| **Map View** (GoogleMap) | `GoogleMap` widget | `google_maps_flutter` | ❌ **TIDAK ADA** — tidak ada map widget | 🔴 |
| **Pin Marker** | `Marker` | `clinics.lat` + `clinics.lng` | ❌ **TIDAK ADA** — pin membutuhkan map | 🔴 |
| **Location Permission** | `FutureBuilder` | `geolocator` package | ✅ Ada — `LocCubit.requestLocationAndLoad()` | 🟢 |
| **City Input (fallback)** | `AppTextFormField` | Manual input | ❌ **TIDAK ADA** — `_permissionDenied` hanya menampilkan pesan + tombol | 🟡 |
| **Filter Chips** | `ListView` / `Wrap` | `GET /rest/v1/specializations` | ❌ **TIDAK ADA** — tidak ada filter | 🟡 |
| **Sort Dropdown** | `AppDropdownButton` | Jarak / Rating / Fee | ❌ **TIDAK ADA** — hanya radius selector | 🟡 |
| **Doctor Card** | `Container` + `InkWell` | `POST /functions/v1/doctors-by-location` | ❌ **DENTITY MISMATCH** — pakai `ClinicCard` + `get_nearby_clinics` | 🔴 |
| **Scroll View** | `ListView.builder` | 20 items pagination | ✅ Ada — `ListView.separated` tanpa pagination | 🟡 |
| **Pull to refresh** | Swipe | Refresh cubit | ✅ Ada — `RefreshIndicator` | 🟢 |
| **Radius indicator** | Label | State cubit | ✅ Ada — chip di AppBar | 🟢 |

**Wireframe Score:** 4/10 komponen = **40%**

### 2.2 State & Interaction

| Wireframe Interaksi | Implementasi | Verdict |
|---|---|---|
| Tab Loc → request permission | ✅ `create: (_) => getIt<LocCubit>()..requestLocationAndLoad()` | 🟢 |
| Permission Allow → map + pin | ❌ Tidak ada map. Langsung ke list klinik | 🔴 |
| Permission Deny → fallback input kota | ❌ Hanya pesan "Izin Lokasi Diperlukan" + tombol | 🟡 |
| Map drag/zoom → pin reposition | ❌ Map tidak ada | 🔴 |
| Tap pin → info window | ❌ Map tidak ada | 🔴 |
| Filter chip → filter list | ❌ Tidak ada chip | 🟡 |
| Sort dropdown → sort list | ❌ Tidak ada dropdown | 🟡 |
| Tap doctor card → `/doctor/:doctorId` | ❌ Card tap tidak ada navigasi (belum ada route `/doctor/:doctorId` yang sesuai) | 🟡 |
| Pull to refresh → refresh markers + list | ⚠️ RefreshIndicator ada, tapi hanya refresh list (map tidak ada) | 🟡 |

**State & Interaction Score:** 2/9 = **22%**

---

## 3. PRD vs Implementasi

Loc Tab **TIDAK** disebut secara eksplisit di `docs/product/prd_health_pal.md`. PRD hanya menyebut:
- Tab 2 di bottom navigation (PRD §6.1)
- Location-based search (PRD §6.4)

**Kesimpulan:** PRD tidak cukup detail untuk audit meaningful.

---

## 4. API Contract vs Implementasi

### 4.1 Endpoint Coverage

| Endpoint | API § | Digunakan? | Detail | Verdict |
|---|---|---|---|---|
| `POST /rest/v1/rpc/get_nearby_clinics` | §5.5 | ✅ | `LocRemoteDataSource.getNearbyClinics()` — call RPC dengan Haversine | 🟢 |
| `POST /functions/v1/doctors-by-location` | §5.2 | ❌ | **TIDAK DIGUNAKAN** — endpoint untuk Doctor Card per wireframe | 🔴 |

### 4.2 Deviation: Doctors vs Clinics

Wireframe 07 secara eksplisit menampilkan **Doctor Cards** dengan:
- Foto dokter
- Nama + gelar
- Rating (⭐ 4.85)
- Jumlah ulasan
- Nama klinik
- Jarak
- Biaya konsultasi (💰 Rp150,000)

Data ini hanya bisa didapat dari **`POST /functions/v1/doctors-by-location`** (§5.2), bukan dari `get_nearby_clinics` (§5.5).

**Kesimpulan:** Implementasi Loc Tab menggunakan endpoint yang **salah** — harusnya §5.2 (doctors-by-location), bukan §5.5 (get_nearby_clinics). Atau wireframe yang perlu diupdate karena keputusan Sprint 2 C3 sudah memilih clinic-based approach.

### 4.3 Catatan Sprint 2 C3

Sprint 2 C3 (Nearby Medical Centers) memilih menggunakan `get_nearby_clinics` untuk Home Page section. Keputusan ini mungkin perlu direvisit untuk Loc Tab: apakah Loc Tab juga akan pakai clinics, atau memang harus doctors?

---

## 5. ERD vs Implementasi

| ERD Table | Digunakan? | Detail | Verdict |
|---|---|---|---|
| `clinics` | ✅ | `ClinicModel` → `ClinicEntity` — mapping lengkap ke API response | 🟢 |
| `doctors` | ❌ | Tidak digunakan. Wireframe §5.2 butuh data dokter | 🟡 |
| `specializations` | ❌ | Tidak digunakan. Filter chips butuh data spesialisasi | 🟡 |

---

## 6. User Flow vs Implementasi

| Navigation Trigger | Route | Implementasi | Verdict |
|---|---|---|---|
| Bottom nav tab Loc | `/loc` | ✅ `StatefulShellRoute` Tab 1 | 🟢 |
| Tap doctor card → detail | `/doctor/:doctorId` | ❌ Tidak ada — `ClinicCard` tanpa onTap navigasi | 🟡 |
| Pull to refresh | — | ✅ `RefreshIndicator` → `LocCubit.refresh()` | 🟢 |

---

## 7. TDD Arsitektur vs Implementasi

### 7.1 Layer Compliance (TDD 01 §3)

| Layer | Status | Files |
|---|---|---|
| **Data** | ✅ | `loc_remote_datasource.dart` + `clinic_model.dart` (@freezed) + `loc_repository_impl.dart` |
| **Domain** | ✅ | `clinic_entity.dart` + `loc_repository.dart` (abstract) + `get_nearby_clinics_usecase.dart` |
| **Presentation** | ✅ | `loc_cubit.dart` + `loc_state.dart` + `loc_page.dart` |

### 7.2 Dependency Rule

✅ Presentation → Domain → Data — semua dependency arrow benar. `LocCubit` inject `GetNearbyClinicsUseCase`, bukan datasource langsung.

### 7.3 DI Pattern

✅ `@injectable` pada semua class. Constructor injection. Build runner regenerated.

---

## 8. TDD State Management vs Implementasi

### 8.1 Sealed State Pattern

| State | Status | Catatan |
|---|---|---|
| `LocInitial` | ✅ | Initial state |
| `LocLoading` | ✅ | Loading dengan DotLoader |
| `LocLoaded` (clinics, posisi, radius) | ✅ | Data + position lengkap |
| `LocPermissionDenied` | ✅ | Distinct dari Error — defense-in-depth |
| `LocError` | ✅ | Dengan message |

### 8.2 Missing States

- **`LocActionInProgress`** — tidak ada state intermediate untuk operasi seperti changeRadius (langsung loading → loaded).
- **`LocCityFilter`** — tidak ada state untuk city-based fallback search.

---

## 9. TDD Data Layer vs Implementasi

| Aspek | Status | Detail |
|---|---|---|
| @freezed model | ✅ | `ClinicModel` — @freezed + @JsonKey |
| fromJson/toJson | ✅ | Generated + manual mapping |
| Remote DataSource | ✅ | `LocRemoteDataSource` — call RPC |
| Repository | ✅ | `LocRepository` abstract + `LocRepositoryImpl` |
| Use Case | ✅ | `GetNearbyClinicsUseCase` |
| Entity display helpers | ✅ | `distanceDisplay`, `doctorCountDisplay`, `distanceKm` |

---

## 10. TDD Routing vs Implementasi

| Route | app_router.dart | Halaman | Verdict |
|---|---|---|---|
| `/loc` (Shell Tab 1) | ✅ | `LocPage` | 🟢 |

---

## 11. TDD Caching vs Implementasi

Loc Tab tidak memiliki kebutuhan caching (data lokasi selalu fresh). **N/A.**

---

## 12. TDD Error Handling vs Implementasi

| Aspek | Status | Detail |
|---|---|---|
| `Result<T>` pattern | ✅ | `LocRepositoryImpl` → `Result.success` / `Result.failure` |
| `ErrorHandler.map()` | ✅ | `Result.failure(const ErrorHandler().map(e))` |
| Retry button | ✅ | Di error state: `context.read<LocCubit>().requestLocationAndLoad()` |
| Geolocation error handling | ✅ | Service disabled, permission denied, time-out, generic error |

---

## 13. Deviation & Bug Catalog

### 13.1 Kritis (🔴)

| ID | Temuan | File | Severity |
|----|--------|------|----------|
| **K1** | **Map View tidak ada** — wireframe 07 primary component. Google Map + pin marker tidak diimplementasi | `loc_page.dart` | 🔴 Missing Feature |
| **K2** | **Data entity mismatch** — wireframe menampilkan Doctor Cards (dokter dengan foto, rating, fee), implementasi menampilkan Clinic Cards (klinik). Endpoint berbeda (§5.2 vs §5.5) | `loc_page.dart` + `clinic_card.dart` | 🔴 Design Deviation |

### 13.2 Medium (🟡)

| ID | Temuan | File | Severity |
|----|--------|------|----------|
| **M1** | **Loading pakai DotLoader** — harus Skeletonizer per AD-6 | `loc_page.dart:146-149` | 🟡 Violation AD-6 |
| **M2** | **Error state custom `_errorView`** — bukan ErrorSection yang reusable | `loc_page.dart:82-105` | 🟡 Code Duplication |
| **M3** | **City Input fallback tidak ada** — wireframe 07 §fallback: input kota manual saat location denied, implementasi hanya pesan statis | `loc_page.dart:_permissionDenied()` | 🟡 Missing Feature |
| **M4** | **Filter Chips tidak ada** — wireframe 07: filter spesialisasi horizontal | `loc_page.dart` | 🟡 Missing Feature |
| **M5** | **Sort Dropdown tidak ada** — wireframe 07: sort by distance/rating/fee | `loc_page.dart` | 🟡 Missing Feature |
| **M6** | **Iconsax langsung** — tanpa Material fallback per Icon Convention | `loc_page.dart` + `clinic_card.dart` | 🟡 Convention Violation |
| **M7** | **Pagination tidak ada** — wireframe spec 20 items, implementasi infinite list tanpa batas | `loc_page.dart` | 🟡 Missing Feature (v1.1) |

### 13.3 Low (🟢)

| ID | Temuan | File | Severity |
|----|--------|------|----------|
| **L1** | **"Lihat Peta" tanpa try-catch** — `_openMaps` bisa throw jika URL invalid | `clinic_card.dart:51-56` | 🟢 Error Handling |
| **L2** | **`ClinicCard.skeleton()` tidak dipakai** — method factory sudah ada tapi tidak digunakan | `clinic_card.dart:19-21` | 🟢 Dead Code |
| **L3** | **Wireframe "Rating" tidak ada di entity** — `ClinicEntity` tidak punya field rating. API §5.5 juga tidak return rating | `clinic_entity.dart` | 🟢 Wireframe Gap |
| **L4** | **Wireframe "Biaya Konsultasi" tidak ada** — `ClinicEntity` tidak punya fee. Doctor entity punya `consultation_fee` | `clinic_entity.dart` | 🟢 Wireframe Gap |

---

## 14. TODO Sprint 4 (Actionable)

Diurutkan berdasarkan prioritas.

| ID | Task | File Target | Estimasi |
|----|------|-------------|:--------:|
| **K2** | **Clarify data entity decision** — Loc Tab clinic-based atau doctor-based? Jika clinic: update wireframe. Jika doctor: implement ulang dengan §5.2 | `docs/wireframe/07-location-search.md` atau `loc_page.dart` | 2h |
| **M1** | **Skeletonizer untuk loading** — ganti DotLoader | `loc_page.dart` | 1h |
| **M2** | **ErrorSection untuk error** — ganti _errorView | `loc_page.dart` | 0.5h |
| **M3** | **City Input fallback** — input kota manual saat location denied | `loc_page.dart` + `loc_cubit.dart` | 2h |
| **M4** | **Filter Chips** — horizontal chips by specialization | `loc_page.dart` + `loc_cubit.dart` | 3h |
| **M5** | **Sort Dropdown** — sort by distance/doctorCount/name | `loc_page.dart` | 1.5h |
| **M6** | **Icon consistency** — iconsax → Material + TODO | `loc_page.dart` + `clinic_card.dart` | 1.5h |
| **L1** | **"Lihat Peta" try-catch** | `clinic_card.dart` | 0.25h |
| **L2** | **Remove `ClinicCard.skeleton()`** — atau gunakan untuk skeletonizer | `clinic_card.dart` | 0.25h |
| **K1** | **Map View feasibility** — audit + stub (defer implementasi penuh) | `loc_page.dart` + `pubspec.yaml` (?) | 2h |
| | **TOTAL** | | **~14h** |

---

## 15. Score Card

| # | Aspek | Bobot | Nilai | Weighted |
|---|-------|:----:|:-----:|:--------:|
| 1 | Wireframe coverage (10 components) | 20% | 30 | 6.0 |
| 2 | API Contract alignment | 10% | 50 | 5.0 |
| 3 | ERD mapping | 5% | 100 | 5.0 |
| 4 | User Flow compliance | 5% | 67 | 3.3 |
| 5 | TDD Clean Architecture | 15% | 100 | 15.0 |
| 6 | TDD State Management | 10% | 100 | 10.0 |
| 7 | TDD Data Layer | 10% | 100 | 10.0 |
| 8 | TDD Routing | 5% | 100 | 5.0 |
| 9 | TDD Error Handling | 5% | 100 | 5.0 |
| 10 | Skeletonizer (AD-6) | 5% | 0 | 0.0 |
| 11 | ErrorSection (C6) | 5% | 0 | 0.0 |
| 12 | Icon Convention | 5% | 0 | 0.0 |
| | **TOTAL** | **100%** | | **64.3 / 100 🟡** |

### Score Interpretation

| Skor | Status | Arti |
|:----:|:------:|------|
| ≥ 85 | 🟢 | Production-ready, minor polish |
| 50-84 | 🟡 | Fungsional, perlu improvement |
| < 50 | 🔴 | Gap signifikan, perlu refactor |

### Rekomendasi

1. **K2 harus diputuskan dulu** — clinic-based atau doctor-based? Ini menentukan arah Sprint 4. Jika doctor-based, banyak kode perlu diubah.
2. **M1-M2 immediate fix** — Skeletonizer + ErrorSection (follow Sprint 2 AD-6 + C6).
3. **M3-M5 wireframe gap** — City Input, Filter Chips, Sort Dropdown. Sangat dibutuhkan untuk mencapai 85% score.
4. **K1 Map View** — feasibility study di Sprint 4, implementasi penuh di Sprint 5 (Doctor). Map lebih relevan dengan doctor search.
5. **M6 L1 L2** — quick wins, bisa dikerjakan di sela-sela task besar.

### Rekomendasi K2: Clinic-Based vs Doctor-Based

**Rekomendasi Tech Lead:** Tetap **Clinic-Based** untuk Sprint 4.
- Wireframe 07 bisa dianggap "outdated" — dibuat sebelum keputusan Sprint 2 C3.
- C3 sudah memilih clinic-based untuk Home Nearby section.
- Konsistensi: Home page dan Loc tab menggunakan entity sama.
- Doctor-based akan membutuhkan ulang besar Loc tab + Doctor search.
- Doctor detail/search sudah ada di feature terpisah.

**Update wireframe** untuk mencerminkan clinic-based approach.

---

*Dibuat: 16 Juni 2026 · Oleh Tech Lead (MiniMax-M3)*
*Template: `docs/progress/home_page_audit.md`*
*Acuan: `docs/progress/sprint_4_plan.md` · `docs/wireframe/07-location-search.md`*
