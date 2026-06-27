# Doctor Detail Redesign — Implementation Plan

**Tanggal:** 28 Juni 2026
**Referensi:** ADR-009, wireframe v2.0 (`docs/wireframe/09-doctor-detail.md`)

---

## 1. Database Changes (Backend)

| # | Item | SQL | Kategori | Dependency |
|---|------|-----|----------|------------|
| 1 | **Tambah kolom `total_patients`** di tabel `doctors` | `ALTER TABLE doctors ADD COLUMN total_patients INT4 NOT NULL DEFAULT 0;` | C (baru) | None |

**Tidak ada perubahan tabel lain** — `doctor_schedules` sudah ada di ERD sejak awal.

---

## 2. API Contract Update

| # | Item | Detail | Kategori |
|---|------|--------|----------|
| 1 | **Update `GET /rest/v1/doctors` select** | Tambah `doctor_schedules(day_of_week,start_time,end_time,is_active)` di select clause untuk endpoint detail (§5.3). Response jadi include array `doctor_schedules`. | B |
| 2 | **Tambah field `total_patients`** di response Doctor Detail (§5.3) dan Search (§5.1) | Response JSON tambah `"total_patients": 2000`. | C |

---

## 3. Data Layer (Flutter)

### 3.1 Model & Entity Baru

| # | Item | File Target | Kategori |
|---|------|-------------|----------|
| 1 | **Buat `DoctorScheduleModel`** (freezed) | `lib/features/doctor/data/model/doctor_schedule_model.dart` | B |
| 2 | **Buat `DoctorScheduleEntity`** | `lib/features/doctor/domain/entity/doctor_schedule_entity.dart` | B |
| 3 | **Tambah field `totalPatients`** ke `DoctorModel` + `DoctorEntity` | `doctor_model.dart:44`, `doctor_entity.dart:19` | C |
| 4 | **Tambah field `schedules`** (List) ke `DoctorModel` + `DoctorEntity` + computed `workingTimeDisplay` | `doctor_model.dart:57`, `doctor_entity.dart:24` | B |

### 3.2 DataSource Update

| # | Item | File Target | Kategori |
|---|------|-------------|----------|
| 5 | **Update `getDoctorDetail`** — tambah `doctor_schedules(*)` di select | `doctor_remote_datasource.dart:58` | B |
| 6 | **Fallback: parallel query** jika `.single()` tidak support nested array | `doctor_remote_datasource.dart` — method baru `getDoctorSchedules(doctorId)` | B |

### 3.3 UseCase Update (jika ada)

| # | Item | File Target |
|---|------|-------------|
| 7 | Update `GetDoctorDetailUseCase` jika perlu include schedules | `lib/features/doctor/domain/usecase/get_doctor_detail_usecase.dart` |

### 3.4 DI Update

| # | Item | File Target |
|---|------|-------------|
| 8 | `dart run build_runner build --force-jit` — codegen untuk model baru | — |

---

## 4. Presentation Layer (Flutter)

### 4.1 Widget Baru

| # | Item | File Target | Estimasi |
|---|------|-------------|----------|
| 1 | **Buat `DoctorInfoCard`** — foto 2:3, nama, divider, spesialisasi, hospital row | `lib/widgets/card/doctor_info_card.dart` | 20 menit |
| 2 | **Buat `DoctorStatsRow`** — 4 StatItem horizontal (Patients, Experience, Rating, Reviews) | `lib/widgets/card/doctor_stats_row.dart` | 15 menit |
| 3 | **Buat `StatItem`** — CircleAvatar + icon, value, label | (include di #2 atau terpisah) | — |
| 4 | **Buat `AboutSection`** — section title, description, ViewMore expandable | `lib/widgets/card/about_section.dart` | 15 menit |
| 5 | **Buat `WorkingTimeSection`** — section title, schedule text dari `workingTimeDisplay` | `lib/widgets/card/working_time_section.dart` | 10 menit |
| 6 | **Buat `ReviewsHeader`** — "Reviews" title + "See All" button (content placeholder) | `lib/widgets/card/reviews_header.dart` | 10 menit |

### 4.2 Page Rewrite

| # | Item | File Target | Estimasi |
|---|------|-------------|----------|
| 7 | **Rewrite `DoctorDetailPage`** — ganti layout total sesuai wireframe v2.0 | `doctor_detail_page.dart` | 30 menit |

### 4.3 Update Existing Widgets

| # | Item | File Target | Estimasi |
|---|------|-------------|----------|
| 8 | **Hapus atau adaptasi `DoctorCardDetail`** — jika masih dipakai, update; jika tidak, hapus | `lib/widgets/card/doctor_card_detail.dart` | 5 menit |

### 4.4 State & Bloc Update

| # | Item | File Target | Estimasi |
|---|------|-------------|----------|
| 9 | **Update `DoctorDetailLoaded` state** — tambah schedule data jika perlu | `doctor_detail_state.dart` | 5 menit |
| 10 | **Update `DoctorDetailCubit.loadDetail`** — fetch schedules parallel jika tidak bisa via single query | `doctor_detail_cubit.dart` | 10 menit |

---

## 5. Dependency Order & Urutan Implementasi

```text
1. Database Migration (tambah total_patients)
       │
       ▼
2. Model + Entity baru (DoctorScheduleModel, DoctorScheduleEntity)
   Update DoctorModel/Entity (tambah totalPatients, schedules)
       │
       ▼
3. Codegen (build_runner)
       │
       ▼
4. DataSource update (getDoctorDetail + parallel schedule query)
   UseCase update (jika perlu)
       │
       ▼
5. Widget baru (DoctorInfoCard, DoctorStatsRow, AboutSection,
   WorkingTimeSection, ReviewsHeader)
       │
       ▼
6. Page rewrite (DoctorDetailPage)
   Update/hapus DoctorCardDetail
       │
       ▼
7. State + Cubit update (fetch schedules, passing data)
       │
       ▼
8. flutter analyze (verifikasi 0 issue)
```

---

## 6. Verifikasi

| # | Item | Status |
|---|------|--------|
| 1 | `dart run build_runner build --force-jit` — 0 error | ⬜ |
| 2 | `flutter analyze` — 0 issues | ⬜ |
| 3 | Visual match dengan wireframe v2.0 | ⬜ |
| 4 | DoctorInfoCard: foto 2:3, nama, divider, spesialisasi, hospital row | ⬜ |
| 5 | DoctorStatsRow: 4 stat value + label muncul benar | ⬜ |
| 6 | AboutSection: expandable View More berfungsi | ⬜ |
| 7 | WorkingTimeSection: tampilkan schedule dari data `doctor_schedules` | ⬜ |
| 8 | ReviewsHeader: title + See All button (content empty/deferred) | ⬜ |
| 9 | Book Appointment button di bottom bar — navigasi benar | ⬜ |
| 10 | Favorite toggle berfungsi (local state) | ⬜ |
| 11 | Skeletonizer loading state — reuse DoctorInfoCard + StatsRow + sections | ⬜ |
| 12 | Pull-to-refresh masih berfungsi | ⬜ |
| 13 | AppBar title "Detail Dokter" dengan back + favorite button | ⬜ |

---

## 7. Blast Radius

| Consumer | File | Perubahan |
|----------|------|-----------|
| ✅ Doctor Detail Page | `doctor_detail_page.dart` | Rewrite total — layout baru |
| ⬜ `DoctorCardDetail` | `lib/widgets/card/doctor_card_detail.dart` | Dihapus atau diadaptasi |
| ⬜ `DoctorModel` | `doctor_model.dart` | + `totalPatients`, + `schedules` |
| ⬜ `DoctorEntity` | `doctor_entity.dart` | + `totalPatients`, + `schedules`, + `workingTimeDisplay` |
| ⬜ `DoctorRemoteDataSource` | `doctor_remote_datasource.dart` | + schedule query |
| ⬜ `DoctorDetailCubit` | `doctor_detail_cubit.dart` | + fetch schedules |
| ⬜ `DoctorDetailState` | `doctor_detail_state.dart` | Mungkin perlu tambah field |
| ❌ Doctor Search Page | — | Tidak tersentuh |
| ❌ Favorite Page | — | Tidak tersentuh |
| ❌ DoctorCard | — | Tidak tersentuh |

---

## 8. Deferred — Reviews Feature

Fitur **Reviews (daftar review individual)** sengaja tidak masuk dalam scope plan ini. Ini mencakup:

- Migration tabel `reviews` ke database
- Endpoint API `GET /rest/v1/reviews?doctor_id=eq.<id>`
- Data layer: `ReviewModel`, `ReviewEntity`, `ReviewRemoteDataSource`
- UI: `ReviewCard` widget (avatar, nama, rating bintang, teks review), infinite scroll/pagination
- Trigger update `rating_avg` dan `rating_count` di tabel `doctors`
- "See All" di ReviewsHeader → navigasi ke halaman/daftar semua review

Fitur ini akan direncanakan di sprint mendatang dengan ADR terpisah. Hanya Reviews header (title + "See All" button) yang masuk scope implementasi saat ini — sebagai placeholder visual yang siap diisi kontennya nanti.

---

*Dibuat: 28 Juni 2026 · Referensi: ADR-009, Wireframe v2.0*
