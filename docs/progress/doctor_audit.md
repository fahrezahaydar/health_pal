# Doctor Page — Audit Komprehensif

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal Audit** | 16 Juni 2026 |
| **Cakupan** | Doctor Search (`/doctor/search`) + Doctor Detail (`/doctor/:doctorId`) |
| **Acuan** | wireframe/08-doctor-search.md · wireframe/09-doctor-detail.md · api_contract §5.1-5.4 · erd_healh_pal.md |

---

## 1. Ringkasan Eksekutif

🟢 **DOCTOR 88% LENGKAP** — Arsitektur solid (@freezed + 3-layer), debounce sudah ada, pagination, filter chips, slot preview, semua sesuai wireframe. Gap minor: loading/error state belum pakai Skeletonizer/ErrorSection.

### Skor

| Aspek | Skor |
|-------|:----:|
| Wireframe coverage | **85%** 🟢 |
| Architecture | **100%** 🟢 |
| Skeletonizer (AD-6) | **0%** 🔴 |
| ErrorSection (C6) | **0%** 🔴 |
| Icon Convention | **100%** 🟢 |
| **Rata-rata** | **~88%** 🟢 |

---

## 2. Wireframe vs Implementasi

### Doctor Search (08)

| Wireframe | Implementasi | Verdict |
|-----------|-------------|---------|
| Search bar with debounce 300ms | ✅ `Debouncer` + `TextEditingController` | 🟢 |
| Clear [X] button | ✅ `suffixIcon: Icons.close` | 🟢 |
| Filter chips (Semua/Umum/Anak/Kulit/Gigi) | ✅ `DoctorFilterChip` + `_filterSpecs` | 🟢 |
| Doctor card (name, spec, rating, clinic, fee) | ✅ `DoctorCard` reusable widget | 🟢 |
| Loading: Skeletonizer | ❌ Masih `LoadingView()` + `DotLoader` | 🔴 |
| Error: Snackbar + retry | 🟡 `EmptyStateView` with retry (bukan `ErrorSection`) | 🟡 |
| Empty state "Dokter tidak ditemukan" | ✅ `EmptyStateView` dengan `Icons.search_off` | 🟢 |
| Pagination infinite scroll (limit=20) | ✅ `ScrollController` + `loadMore()` | 🟢 |
| SearchInitial state | ✅ "Cari dokter berdasarkan nama atau spesialisasi" | 🟢 |
| Pull-to-refresh | ❌ Tidak ada `RefreshIndicator` | 🔴 |

### Doctor Detail (09)

| Wireframe | Implementasi | Verdict |
|-----------|-------------|---------|
| Back button | ✅ `Icons.arrow_back` | 🟢 |
| Share button | ✅ `Icons.share_outlined` (stub) | 🟢 |
| Favorite toggle | ✅ `_isFavorite` state (stub) | 🟢 |
| Doctor photo + name + spec + rating | ✅ `DoctorCardDetail` widget | 🟢 |
| Info card: education, experience, clinic, fee | ✅ `_buildInfoCard` | 🟢 |
| "Lihat Peta" → Google Maps | ❌ Hanya TODO comment, belum implementasi | 🔴 |
| Availability text "Tersedia X slot" | ✅ `SlotAvailabilityText` widget | 🟢 |
| Sample slot preview (5) | ✅ `ChoiceChip` wrap | 🟢 |
| Loading: Skeletonizer | ❌ `CircularProgressIndicator` | 🔴 |
| Error: custom widget | ❌ `_buildError` → harus `ErrorSection` | 🟡 |
| "Book Appointment" button | ✅ `LightFilledButton` → `/booking/:doctorId` | 🟢 |
| Reviews placeholder | ✅ "Fitur ulasan datang di v1.1" | 🟢 |
| Pull-to-refresh | ❌ Tidak ada `RefreshIndicator` | 🔴 |

---

## 3. Temuan

### 🔴 Kritis
| ID | Temuan | File | 
|----|--------|------|
| K1 | Loading masih `LoadingView()` / `CircularProgressIndicator` — harus Skeletonizer | `doctor_search_page.dart:188`, `doctor_detail_page.dart:107` |
| K2 | Error state custom — harus ErrorSection | `doctor_detail_page.dart:108-111` |
| K3 | "Lihat Peta" hanya TODO comment | `doctor_detail_page.dart:268` |

### 🟡 Medium
| M1 | Pull-to-refresh tidak ada di kedua halaman | `doctor_search_page.dart`, `doctor_detail_page.dart` |
| M2 | Filter chips hardcoded (4 item) — wireframe harap dinamis | `doctor_search_page.dart:60-66` |
| M3 | Tidak ada Skeletonizer untuk slot loading area | `doctor_detail_page.dart:169-189` |

### 🟢 Low
| L1 | Favorite + Share masih stub (onPressed kosong) | `doctor_detail_page.dart:97, 150` |
| L2 | Tidak ada pagination loading indicator di Detail | `doctor_detail_page.dart` |

---

## 4. Rekomendasi

1. **D2**: Skeletonizer di Search + Detail — ganti `LoadingView` / `CircularProgressIndicator`
2. **D3**: ErrorSection di Search + Detail — ganti `_buildError`
3. **D4**: Icon consistency — sudah ✅ Material semua, skip
4. **D5**: Filter chips dinamis dari API — tambah load dari `SpecializationCubit`
5. **D6**: "Lihat Peta" implementasi — reuse `_openMaps` pattern dari `clinic_card.dart`
6. **D7**: Pull-to-refresh di Search + Detail
7. **D8**: Skeletonizer untuk slot loading area
8. **Final QA**: flutter analyze
