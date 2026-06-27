# BUG-005 — Doctor Search Page Issues

**Tanggal:** 27 Juni 2026
**Feature:** Doctor Search
**Severity:** 🔴 Critical
**Status:** 🔄 In Progress

---

## Bug List

### BUG-005-A: List Doctor Tidak Langsung Muncul Saat Page Dibuka

**Deskripsi:**  
Saat Doctor Search page dibuka, list dokter kosong dan user melihat teks "Cari dokter berdasarkan nama atau spesialisasi" beserta ikon search. User harus mengetik sesuatu di search bar terlebih dahulu sebelum daftar dokter muncul. Wireframe (`08-doctor-search.md` lines 26-46) menunjukkan daftar dokter langsung tampil tanpa perlu input.

**Root Cause:**  
`DoctorSearchView.initState()` (line 90-100) hanya memanggil `loadSpecializations()` untuk filter chips, tapi **tidak memanggil `searchDoctors(null)`** untuk menampilkan semua dokter sebagai default. SearchCubit di-init dengan state `SearchInitial`, dan view menampilkan `EmptyStateView` untuk state ini. User harus mengetik di search bar untuk trigger `_onSearchChanged` → `searchDoctors(value)`.

**File:** `lib/features/doctor/presentation/page/doctor_search_page.dart` line 90-100

**Status:** [ ] Open

---

### BUG-005-B: Filter Chip Specialization Tidak Match Database (ALREADY FIXED)

**Deskripsi:**  
(Sprint 1 legacy issue) Filter chip specialization sebelumnya menggunakan ID hardcoded (`sp1`, `sp2`, `sp3`, `sp4`) yang tidak match dengan UUID asli di tabel `specializations`. Namun, audit pada 27 Juni 2026 menemukan bahwa kode saat ini **sudah menggunakan dynamic loading** dari database melalui `GetSpecializationsUseCase` + `loadSpecializations()`. Filter chip sekarang membaca `SearchCubit.specializations` yang di-load dari database, dan passing UUID asli ke query Supabase.

**Verifikasi:**  
- `grep "_filterSpecs\|sp1\|sp2\|sp3\|sp4\|hardcoded" lib/features/doctor/` → **0 matches**
- `doctor_search_page.dart` line 186: `context.read<SearchCubit>().specializations.length + 1` → dynamic
- `doctor_search_page.dart` line 199: passing `spec.id` (UUID asli dari DB) → match dengan query

**Catatan:**  
BUG-005-B dianggap **ALREADY FIXED** oleh implementasi dynamic loading yang sudah ada. Tidak perlu todo fix.

**Status:** [x] Already Fixed (dynamic loading dari DB)

---

### BUG-005-C: Clinic Name di Card Selalu "Klinik"

**Deskripsi:**  
Semua doctor card di halaman search menampilkan "Klinik" sebagai nama klinik, bukan nama klinik asli dari database. Data di database benar — query `SELECT d.id, d.full_name, c.name FROM doctors d LEFT JOIN clinics c ON c.id = d.clinic_id LIMIT 10` mengembalikan nama klinik asli seperti "Klinik Sehat Keluarga", "RSIA Bunda Sejahtera", dll.

**Root Cause:**  
Mismatch nama field JSON antara response PostgREST dan field Dart di `DoctorModel`.

| Layer | Nama field |
|-------|-----------|
| PostgREST select (datasource line 29) | `'*, clinics(id, name, ...)'` |
| JSON key dari Supabase response | **`clinics`** (plural — nama tabel) |
| Dart field di DoctorModel (line 55) | `ClinicModel? clinic` (singular) |
| `@JsonKey` annotation | ❌ **Tidak ada** |
| Generated `fromJson` mencari | `json['clinic']` → **tidak ditemukan** → `null` |
| `DoctorEntity.clinicName` fallback (entity line 50) | `clinic?.name ?? 'Klinik'` |

PostgREST selalu menggunakan **nama tabel** sebagai key untuk nested object, bukan nama field Dart. Karena tidak ada `@JsonKey(name: 'clinics')`, freezed-generated `fromJson` mencari `clinic` (nama field), yang tidak match dengan `clinics` (key dari PostgREST). Akibatnya `clinic` selalu `null`, dan `clinicName` jatuh ke default `'Klinik'`.

**File:**
- `lib/features/doctor/data/model/doctor_model.dart` line 55 — field `clinic` tanpa `@JsonKey(name: 'clinics')`
- `lib/features/doctor/domain/entity/doctor_entity.dart` line 50 — fallback `'Klinik'`

**Status:** [ ] Open

---

### BUG-005-D: Specialization di Card Selalu "Umum"

**Deskripsi:**  
Semua doctor card menampilkan "Umum" sebagai spesialisasi, padahal database menyimpan spesialisasi asli (Anak, Kulit, Gigi, dll.). Data di database benar — query `SELECT d.id, d.full_name, s.name FROM doctors d LEFT JOIN specializations s ON s.id = d.specialization_id LIMIT 10` mengembalikan spesialisasi asli.

**Root Cause:**  
Identik dengan BUG-005-C. Mismatch nama field JSON antara response PostgREST dan field Dart.

| Layer | Nama field |
|-------|-----------|
| PostgREST select (datasource line 29) | `'*, ..., specializations(id, name, ...)'` |
| JSON key dari Supabase response | **`specializations`** (plural — nama tabel) |
| Dart field di DoctorModel (line 56) | `SpecializationModel? specialization` (singular) |
| `@JsonKey` annotation | ❌ **Tidak ada** |
| Generated `fromJson` mencari | `json['specialization']` → **tidak ditemukan** → `null` |
| `DoctorEntity.specializationName` fallback (entity line 47) | `specialization?.name ?? 'Umum'` |

PostgREST nested select `specializations(id, name, icon_url, color_hex)` menghasilkan JSON key `specializations` (nama tabel), tapi field Dart di `DoctorModel` bernama `specialization` (singular). Tanpa `@JsonKey(name: 'specializations')`, freezed selalu menghasilkan `specialization` sebagai key lookup, yang tidak pernah match.

**File:**
- `lib/features/doctor/data/model/doctor_model.dart` line 56 — field `specialization` tanpa `@JsonKey(name: 'specializations')`
- `lib/features/doctor/domain/entity/doctor_entity.dart` line 47 — fallback `'Umum'`

**Status:** [ ] Open

---

## Todo Fix List

- [ ] **FIX-1**: Tambah initial `searchDoctors(null)` call di `DoctorSearchView.initState()` agar list dokter default tampil
  - File: `lib/features/doctor/presentation/page/doctor_search_page.dart` line 90-100
  - Tambah `context.read<SearchCubit>().searchDoctors(null)` setelah `loadSpecializations()`
  - Pertimbangan: pastikan tidak double-load karena `loadSpecializations()` juga async. Bisa di-chain: setelah `loadSpecializations()` selesai, baru `searchDoctors(null)`.

- [ ] **FIX-2**: Tambah `@JsonKey(name: 'clinics')` di field `clinic` pada `DoctorModel`
  - File: `lib/features/doctor/data/model/doctor_model.dart` line 55
  - Ubah: `ClinicModel? clinic` → `@JsonKey(name: 'clinics') ClinicModel? clinic`
  - Regenerate: `dart run build_runner build --force-jit`

- [ ] **FIX-3**: Tambah `@JsonKey(name: 'specializations')` di field `specialization` pada `DoctorModel`
  - File: `lib/features/doctor/data/model/doctor_model.dart` line 56
  - Ubah: `SpecializationModel? specialization` → `@JsonKey(name: 'specializations') SpecializationModel? specialization`
  - Regenerate: `dart run build_runner build --force-jit`

---

## Skenario Validasi

| Skenario | Expected | Status |
|----------|----------|--------|
| Buka Doctor Search page | List semua dokter tampil tanpa perlu ketik | [ ] FIX-1 |
| Lihat clinic name di card | Nama klinik asli sesuai database | [ ] FIX-2 |
| Lihat specialization di card | Nama spesialisasi asli sesuai database | [ ] FIX-3 |

---

## Referensi

- `lib/features/doctor/data/datasource/doctor_remote_datasource.dart` line 29 — PostgREST select dengan `clinics(...)` dan `specializations(...)`
- `lib/features/doctor/data/model/doctor_model.dart` line 54-56 — field nested object tanpa `@JsonKey`
- `lib/features/doctor/domain/entity/doctor_entity.dart` line 47, 50 — fallback default values
- `docs/wireframe/08-doctor-search.md` — wireframe menunjukkan list default
- BUG-005-B: dynamic loading sudah ada di `SearchCubit.loadSpecializations()` (line 117-125)

---
*Dibuat: 27 Juni 2026*