# Audit Arsitektur Data (ERD) — Health Pal

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Platform** | Mobile (Flutter — Android & iOS) |
| **Versi Dokumen** | v1.0 |
| **Tanggal Audit** | 13 Juni 2026 |
| **Auditor** | Database & State Architect |
| **Cakupan** | ERD v1.0 · API Contract v1.0 · TDD 02, 05, 08, 11 · User Flow v2.0 |
| **Fokus** | Offline-first readiness · Model mapping complexity · JSON parsing bottleneck |

---

## Ringkasan Skor

| Kriteria | Skor | Status |
|---|---|---|
| **1. Local vs Remote Data (Offline-first readiness)** | **72 / 100** | 🟡 Perlu Perhatian |
| **2. Model Mapping (Clean Architecture compatibility)** | **80 / 100** | 🟢 Baik |
| **3. JSON Parsing Bottleneck (Main thread performance)** | **78 / 100** | 🟢 Baik |
| **Skor Keseluruhan** | **77 / 100** | 🟢 Layak (dengan revisi minor) |

---

## 1. Local vs Remote Data — 72 / 100

### 1.1 Current State

Sesuai TDD 08 (Caching Strategy):
- **MVP:** SharedPreferences (JSON string) untuk data ringan
- **v2.0:** Migrasi ke Hive untuk cache kompleks
- **Yang di-cache:** onboarding status, auth session, user profile, specializations, banners, recent searches
- **Yang TIDAK di-cache:** doctor list, doctor slots, appointments
- **Total storage/user:** < 30 KB (SharedPreferences cukup)
- **Hive/Isar:** belum diimplementasi, baru rencana v2

### 1.2 Audit: Apakah ERD Aman untuk Replikasi ke Local DB Mobile?

#### ✅ Yang Sudah ERD-Friendly untuk Lokal

| Aspek | Status | Catatan |
|---|---|---|
| Primary key strategy | ✅ | `gen_random_uuid()` UUID universally applicable ke Isar/Hive/Sqflite |
| Foreign key integrity | ✅ | Semua relasi eksplisit dengan constraint |
| Indexes | ✅ | 9 index didefinisikan di ERD §7, optimal untuk mobile query |
| Snapshot pattern | ✅ | `consultation_fee_snapshot` di `appointments` — perfect untuk read-offline |
| Denormalization | ✅ | `doctor_id` di `doctor_slots` — mengurangi JOIN saat offline |
| No BLOBs di tabel utama | ✅ | Gambar di Supabase Storage, hanya URL disimpan |
| Public vs Private data separation | ✅ | `doctors`, `clinics`, `specializations`, `banners` public read RLS |
| Table count reasonable | ✅ | 11 tabel — manageable untuk di-replicate |

#### ⚠️ Masalah High Priority untuk Offline-First

| # | Masalah | Lokasi | Dampak |
|---|---|---|---|
| 1 | **Tidak ada kolom `local_id` / `sync_status` / `dirty_flag`** di semua tabel | ERD semua tabel | Offline create/update tidak bisa dilacak sync-nya |
| 2 | **Tidak ada `client_updated_at` atau version number** untuk optimistic locking | `user_profiles`, `appointments` saja yang punya `updated_at`, tapi API tidak pakai | Edit profil offline → conflict resolution impossible |
| 3 | **Tidak ada `deleted_at` (soft-delete)** di tabel manapun | Semua tabel | User hapus appointment offline → sync tidak bisa detect deletion |
| 4 | **Denormalized `doctor_slots.is_booked`** akan bentrok saat 2 user booking offline slot sama | ERD §4.4 + §2 kolom 117 | Race condition jika ada offline-create booking. Skema trigger-based won't work di local DB |
| 5 | **PostgreSQL-specific types** tidak 1:1 ke mobile | ERD §2 | `NUMERIC(12,2)` → `double`, `TIMETZ` → `DateTime` UTC, `INT2` → `int`, `TIME` → `Duration` (Isar) atau `String` (Hive) |
| 6 | **TDD 08: Hive migration "v2.0"** tanpa migration plan | TDD 08 §1 | Tidak ada strategi: (a) kapan migrasi, (b) schema version, (c) data loss prevention |
| 7 | **Tidak ada sync conflict resolution strategy** | TDD 08 | Last-write-wins? Server-wins? User-prompted? Tidak ada keputusan |
| 8 | **Recent searches** di-cache di SharedPreferences (TDD 08 §2), tapi tidak ada tabel `search_history` di ERD | TDD 08 vs ERD | Inkonsistensi: cache eksplisit, tapi tidak ada sumber data |
| 9 | **No encryption at rest** untuk user profile cache (DOB, gender) | TDD 11 §3.2 | Data pribadi di SharedPreferences plain text, hanya deferred ke v2.0 |
| 10 | **Banner, specialization, clinic** di-cache sebagai JSON string, bukan normalized | TDD 08 | Update parsial tidak mungkin, harus overwrite seluruh list |

#### ⚠️ Masalah Medium Priority

| # | Masalah | Rekomendasi |
|---|---|---|
| 11 | `slot_date` + `slot_start` + `slot_end` sebagai 3 kolom terpisah | Untuk mobile, gabung jadi `slot_datetime_start` + `slot_duration` (Duration). Query "next 7 days" lebih efisien |
| 12 | `appointments.consultation_fee_snapshot` diulang untuk setiap booking (immutable) | ✅ Bagus untuk histori, ✅ tapi storage membengkak jika 1000+ booking. Untuk MVP fine |
| 13 | `notifications.appointment_id` nullable + `type` polymorphic | Flutter side perlu strategi: enum mapping + null check |
| 14 | `user_fcm_tokens` 1 user bisa multi-device | ✅ Bagus, tapi `UPSERT` per (user_id, platform) perlu strategi offline-queue |
| 15 | `gender` sebagai TEXT (male/female/other), bukan FK ke `genders` table | Fine untuk MVP, tapi jika ada master data gender nanti, migrasi sulit |
| 16 | Tidak ada tabel `audit_logs` (deferred v2.0 di TDD 11 §6.2) | Untuk compliance UU PDP, audit log ideally ada sejak MVP |
| 17 | `banners.starts_at` / `ends_at` nullable | Flutter harus handle: tampilkan jika null / compare dengan `now()` |

### 1.3 Storage Size Estimation

| Data | Per User | 1000 Users (server) | Cache Strategy |
|---|---|---|---|
| `user_profiles` | 500 B | 500 KB | SharedPref (1 user only) |
| `user_fcm_tokens` | 200 B | 200 KB | SharedPref (1 user only) |
| `appointments` | 1 KB | 1 MB | **Not cached** — risky untuk offline history |
| `notifications` | 500 B | 500 KB | Not cached |
| `specializations` | 5 KB | 5 MB | SharedPref 7 days |
| `banners` | 10 KB | 10 MB | SharedPref 5 min |
| `doctors` (search cache) | 50 KB | 50 MB | Not cached |
| `doctor_slots` (7 days) | 20 KB | 20 MB | Not cached |

**Verdict:** SharedPreferences cukup untuk MVP (< 30 KB/user). Tapi untuk v2 (offline booking history, image cache, recent doctors), **wajib migrasi ke Hive/Isar**.

### 1.4 Verdict Sub-bab 1

**ERD saat ini aman untuk SharedPreferences caching (MVP).**  
**TIDAK siap untuk offline-first Isar/Hive replication (v2).**  
**Skor: 72/100** — perlu tambahan kolom sync metadata + strategi conflict resolution.

---

## 2. Model Mapping Complexity — 80 / 100

### 2.1 Relasi ERD → Flutter Model

#### 1-to-1 Relations

| Parent | Child | Flutter Model | Kompleksitas |
|---|---|---|---|
| `auth_users` | `user_profiles` | `UserModel extends UserEntity` | ✅ Sederhana, 1:1 |

#### 1-to-Many Relations (aman untuk Model)

| Parent | Children | Estimasi N | Model Strategy |
|---|---|---|---|
| `user_profiles` | `user_fcm_tokens` | 1-3 devices | ✅ List kecil, OK |
| `user_profiles` | `appointments` | 0-100+ | ✅ List, query by `patient_id` |
| `user_profiles` | `notifications` | 0-100+ | ✅ List, query by `user_id` |
| `specializations` | `doctors` | 1-50 each | ✅ Relasi di-load via nested select |
| `clinics` | `doctors` | 1-30 each | ✅ Sama |
| `doctors` | `doctor_schedules` | 1-7 (per day of week) | ✅ List kecil |
| `doctors` | `doctor_slots` | **30 hari × ~16 slot = 480 rows** | ⚠️ **Bisa besar**, perlu filter by date |
| `doctor_schedules` | `doctor_slots` | 1:N generator | ✅ Untuk validasi, tidak selalu di-load |
| `doctor_slots` | `appointments` | 1:0..1 | ✅ 1 slot 0 atau 1 booking |
| `appointments` | `notifications` | 1:N (max ~4) | ✅ List kecil |

#### Many-to-Many Relations

**TIDAK ADA many-to-many di ERD** ✅ — ini nilai plus untuk Clean Architecture (no junction table complexity).

#### ⚠️ Potensi Kompleksitas

| # | Pola ERD | Kompleksitas di Flutter | Severity |
|---|---|---|---|
| 1 | **Doctor → DoctorSlots (1:480)** | Setiap load doctor detail berpotensi memuat 480 slot rows | Medium |
| 2 | **Nested select 3-level**: `appointments → doctors → clinics` | Single query OK, tapi generated JSON 3x size dari flat | Medium |
| 3 | **Dual FK di `appointments`**: `slot_id` + `doctor_id` (denormalized) | Saat update, harus jaga konsistensi 2 FK. Risk: race condition | Low |
| 4 | **Polymorphic `notifications.type`** (string, bukan FK enum) | Flutter side: `enum NotificationType { bookingSuccess, reminderH1, ... }` + try-catch fallback | Low |
| 5 | **Appointment state machine flat** (`booked_at`, `confirmed_at`, `completed_at`, `cancelled_at`, `cancellation_reason`) | 5 nullable fields. Bisa disederhanakan jadi `sealed class Appointment` dengan state-specific data | Low |
| 6 | **No foreign key untuk enum** (`gender`, `status`, `platform`, `notification.type`) | Inkonsistensi data jika API return nilai baru. Flutter harus fallback gracefully | Medium |
| 7 | **`slot_date` (DATE) + `slot_start` (TIME) + `slot_end` (TIME)** = 3 field | Flutter harus buat custom `SlotTime` class atau convert ke `DateTime` + `Duration` | Medium |
| 8 | **`doctors` punya 13 kolom** + nested 2-3 object | `DoctorModel` akan jadi 15+ field. Dengan `@freezed` manageable, manual akan berat | Low |
| 9 | **Circular reference potential** saat generate full graph: `user → appointments → slot → doctor → appointments → ...` | PostgREST nested select harus explicit. Flutter code-gen harus aware | Medium |
| 10 | **No junction table** untuk doctors ↔ clinics (multi-clinic doctors) | Asumsi: 1 dokter = 1 klinik. Jika di v2 dokter bisa multi-klinik, perlu redesign | Low (untuk MVP) |

### 2.3 Generated Model Complexity Estimation

Dengan asumsi `@freezed` + `@JsonSerializable`:

| Model | Fields | Generated Lines (est.) | Kompleksitas |
|---|---|---|---|
| `UserModel` | 11 | ~150 | Sederhana |
| `DoctorModel` | 13 + 2 nested | ~250 | Medium |
| `DoctorSlotModel` | 7 | ~100 | Sederhana |
| `AppointmentModel` | 13 + 3 nested | ~350 | **Kompleks** |
| `NotificationModel` | 9 + 1 nested | ~180 | Medium |
| `BannerModel` | 7 | ~100 | Sederhana |
| `ClinicModel` | 8 | ~120 | Sederhana |
| `SpecializationModel` | 3 | ~80 | Sederhana |
| `ProfileModel` | 11 | ~150 | Sederhana |
| `FcmTokenModel` | 5 | ~80 | Sederhana |
| **Total** | | **~1560 baris generated code** | Manageable |

### 2.4 Clean Architecture Mapping Pattern

```dart
// ✅ Pattern yang sehat (TDD 05 §3):
class DoctorEntity extends Equatable { /* pure Dart */ }
class DoctorModel extends DoctorEntity { 
  factory DoctorModel.fromJson(Map<String, dynamic> json) {...}
}

// ⚠️ Risiko: nested Model kompleks
class AppointmentModel extends AppointmentEntity {
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      ...
      doctor: json['doctors'] != null 
        ? DoctorModel.fromJson(json['doctors']) 
        : null,
      slot: json['doctor_slots'] != null 
        ? DoctorSlotModel.fromJson(json['doctor_slots']) 
        : null,
    );
  }
}
```

**Verdict:** Mapping manageable dengan `@freezed`. Kompleksitas muncul di:
1. Singular vs plural key (sebelumnya sudah di-flag di audit integrasi)
2. Slot time conversion
3. State machine flat → sealed class (optional refactor)

---

## 3. JSON Parsing Bottleneck — 78 / 100

### 3.1 Nesting Depth Analysis

| Endpoint | Max Depth | Estimated Size | Parsing Time (main thread) | Severity |
|---|---|---|---|---|
| 5.1 Doctor Search (20 doctors) | 2 | 30-50 KB | ~40-60 ms | Medium |
| 5.2 Doctors by Location (20) | 3 | 40-60 KB | ~50-70 ms | Medium |
| 5.3 Doctor Detail (1) | 2 | 3-5 KB | ~3-5 ms | ✅ Safe |
| 5.4 Doctor Slots (40) | 1 | 5-8 KB | ~5-10 ms | ✅ Safe |
| 6.1 Create Appointment (1) | 5 | 4-6 KB | ~5-8 ms | ✅ Safe |
| 6.2 Booking History (20) | 3 | **80-120 KB** | **~100-150 ms** | **High** ⚠️ |
| 6.3 Appointment Detail (1) | 4 | 5-8 KB | ~6-10 ms | ✅ Safe |
| 7.1 Banners (5) | 1 | 3-5 KB | ~3-5 ms | ✅ Safe |
| 8.1 Notifications (30) | 1 | 8-12 KB | ~10-15 ms | ✅ Safe |

### 3.2 Bottleneck Hotspots

#### ⚠️ HIGH: Booking History Response (API 6.2)

**Current:**
```json
[
  {
    "id": "...",
    "doctors": { "id", "full_name", "photo_url", "specializations": {"name"} },
    "doctor_slots": { "slot_date", "slot_start", "slot_end" }
  },
  ... 20 items
]
```

**Masalah:**
- 20 appointments × nested objects = ~100 KB JSON
- `jsonDecode()` di main thread: ~100 ms
- + `Model.fromJson()` mapping: ~50-100 ms (kalau nested)
- **Total: 150-200 ms** — visible jank pada scroll di low-end device

**Rekomendasi:**
1. **Pagination agresif**: `limit=10` default, bukan 20
2. **Isolate parsing**: `compute()` untuk `fromJson` di list besar
3. **Reduce select**: hanya field yang dipakai di card (saat ini sudah ✅)
4. **Pre-parse di DataSource**, simpan Entity, BLoC terima Entity
5. **Lazy nested parse**: untuk list, skip nested `doctors.specializations` (cukup `name` saja)

#### ⚠️ MEDIUM: Doctor Search Response (API 5.1)

**Masalah:**
- 20 doctors + nested clinics + specializations
- Setiap `clinics` punya `id, name, address, city, latitude, longitude, phone, image_url` (8 fields)
- Setiap `specializations` punya `id, name, icon_url` (3 fields)
- Plus `doctors` punya `id, full_name, photo_url, experience_years, consultation_fee, rating_avg, rating_count, clinics{...}, specializations{...}`

**Solusi:**
- Trim select untuk search vs detail
- Search: `select=id,full_name,photo_url,rating_avg,rating_count,clinics(id,name,city),specializations(id,name,icon_url)`
- Detail: full fields

#### ⚠️ MEDIUM: Inconsistent Nested Key Naming

| Endpoint | Key | Convention |
|---|---|---|
| 5.1, 5.3, 6.2 (PostgREST) | `doctors`, `clinics`, `specializations` | Plural |
| 6.1 (Edge Function) | `doctor`, `slot`, `slot_id` | Singular |

**Dampak ke Parsing:**
- 2 generated `DoctorModel` (plural vs singular key)
- Manual mapping: extra conditional
- Bukan bottleneck, tapi code smell

#### ✅ SAFE: Single-Object Endpoints

- Doctor Detail: 5 ms — fine
- Appointment Detail: 8 ms — fine
- Create Appointment Response: 8 ms — fine

### 3.3 Date/Time Format Overhead

| Field | Format | Length | Parse Cost |
|---|---|---|---|
| `slot_date` | `"2026-06-15"` | 10 chars | `DateTime.parse()` → 0.01 ms |
| `slot_start` | `"09:00:00"` | 8 chars | Custom converter → 0.02 ms |
| `booked_at` | `"2026-06-07T10:30:00.000Z"` | 24 chars | `DateTime.parse()` → 0.01 ms |

**Per-row overhead:** ~0.04 ms × 20 = ~1 ms. Tidak signifikan.

### 3.4 Missing Optimizations

| # | Optimization | Rekomendasi |
|---|---|---|
| 1 | **Tidak ada gzip header** dari Supabase | Cek `Accept-Encoding: gzip`. Supabase PostgREST support, tapi perlu di-set client-side |
| 2 | **Tidak ada ETag/Last-Modified** | Selalu fetch full data. Tambah `If-None-Match` di subsequent calls |
| 3 | **Tidak ada batch endpoint** | Home butuh 5+ API calls. Bisa 1 RPC return composite object |
| 4 | **Offset pagination** (bukan cursor) | `?offset=1000` jadi O(n). Untuk v2, pakai `?after_id=` |
| 5 | **Tidak ada materialized view** | "Upcoming appointment per patient" query setiap kali Home load. Cache di server side |
| 6 | **Tidak ada streaming response** | `jsonDecode` blocking. `Stream<List<Doctor>>` dengan chunked processing = lebih baik untuk UX |
| 7 | **No `compute()` usage** didokumentasikan | Untuk list > 10 items, parse di isolate |

### 3.5 Mitigation Strategies (Recommended)

```dart
// PATTERN 1: Isolate parsing untuk list besar
Future<List<DoctorEntity>> parseDoctorsList(List<dynamic> jsonList) {
  return compute(_parseDoctorsListIsolate, jsonList);
}

List<DoctorEntity> _parseDoctorsListIsolate(List<dynamic> jsonList) {
  return jsonList
      .map((j) => DoctorModel.fromJson(j as Map<String, dynamic>))
      .toList();
}

// PATTERN 2: Pre-parse di DataSource, simpan Entity
class DoctorRemoteDataSource {
  Future<List<DoctorEntity>> searchDoctors(String query) async {
    final response = await supabase
      .from('doctors')
      .select('id, full_name, photo_url, rating_avg, rating_count, clinics(id, name, city), specializations(id, name, icon_url)')
      .ilike('full_name', '%$query%')
      .limit(20);
    return compute(_parseDoctorsListIsolate, response as List<dynamic>);
  }
}

// PATTERN 3: Lazy nested (untuk list) — minimal nested
class DoctorSearchModel {
  final String id;
  final String fullName;
  final String? photoUrl;
  final double ratingAvg;
  final int ratingCount;
  final String? clinicName;     // Flat
  final String? clinicCity;     // Flat
  final String? specializationName;  // Flat
  final String? specializationIcon;  // Flat
}
```

---

## 4. Poin Perbaikan Arsitektur Data

### 4.1 HIGH Priority (Blokir Sprint 1)

| ID | Judul | Kategori | File Target | Rekomendasi |
|---|---|---|---|---|
| H1 | **Tambah kolom sync metadata**: `local_id`, `sync_status`, `client_updated_at`, `version` di tabel yang akan di-cache offline (appointments, user_profiles) | Offline-first | `erd_healh_pal.md` | Tambah di ERD §2.7 (appointments) dan §2.2 (user_profiles). Default: `version=1`, `sync_status='synced'` |
| H2 | **Tambah `deleted_at` soft-delete** di `appointments` dan `notifications` | Offline-first | `erd_healh_pal.md` §2.7, §2.10 | Tambah kolom nullable + index. Sync bisa detect delete via `deleted_at IS NOT NULL` |
| H3 | **Pisahkan `slot_date` + `slot_start` jadi `slot_datetime_start` (TIMESTAMPTZ) + `slot_duration` (INTERVAL)** | Model Mapping + Performance | `erd_healh_pal.md` §2.6 | Query "slot antara jam X-Y" lebih efisien, Flutter parsing lebih simple |
| H4 | **Tambah materialized view** `mv_upcoming_appointment_per_patient` | Performance | ERD + Supabase migration | Pre-compute untuk Home Page, kurangi 3-table JOIN setiap load |
| H5 | **Tambah `compacted` / `minimal` select untuk list endpoint** | Performance | `api_contract_health_pal.md` | Definisikan 2 tier: `compact` (untuk list) dan `full` (untuk detail) |
| H6 | **Standarkan nested key convention (selalu plural)** | Model Mapping | `api_contract_health_pal.md` §6.1 | Ubah `doctor` → `doctors[0]` atau `doctor: { ... }` tapi single. Pilih 1 |
| H7 | **Dokumentasikan strategi conflict resolution** untuk offline sync | Offline-first | `tdd/08-caching.md` | Pilih: Last-write-wins (default), User-prompted (untuk payment), atau Server-wins (untuk admin) |

### 4.2 MEDIUM Priority (Sprint 1–2)

| ID | Judul | Kategori | File Target | Rekomendasi |
|---|---|---|---|---|
| M1 | **Tambah index di `appointments` composite `(patient_id, status, slot_date)`** | Performance | `erd_healh_pal.md` §7 | Untuk filter Booking History per status dengan order tanggal |
| M2 | **Tambah index di `doctor_slots (slot_date, is_booked)`** | Performance | ERD §7 | Untuk query "slot available di 7 hari ke depan" |
| M3 | **Buat helper `SlotTime` class** untuk handle date+time+duration | Model Mapping | `tdd/05-data-layer.md` | Converter: `SlotTime.fromJson({date, start, end})` |
| M4 | **Implementasi `compute()` untuk parsing list** > 10 items | Performance | `tdd/05-data-layer.md` §3 | Document pattern + benchmark |
| M5 | **Tambah `Etag` / `Last-Modified` di response header** | Performance | API Contract + Supabase config | Conditional GET untuk cache invalidation |
| M6 | **Buat RPC `get_home_data(user_id)`** yang return composite (banner + upcoming + categories + nearby) | Performance | ERD + API Contract | 1 round-trip untuk Home, bukan 5 |
| M7 | **Refactor `AppointmentModel` ke sealed class per status** | Model Mapping | `tdd/05-data-layer.md` | `sealed class Appointment` dengan `PendingAppointment`, `UpcomingAppointment`, dll. Hilangkan 5 nullable fields |
| M8 | **Tambah tabel `genders` / `notification_types` / `appointment_statuses`** sebagai lookup table | Model Mapping | ERD | Untuk konsistensi + future i18n |
| M9 | **Tambah `audit_logs` table** (untuk UU PDP compliance) | Offline-first | ERD | Tambah trigger di `appointments` dan `user_profiles` |
| M10 | **Dokumentasikan limit pagination per endpoint** (5/10/20/50) | Performance | API Contract | Standarkan: search=20, history=10, notification=30, doctor detail slots=40 |
| M11 | **Tambah strategi lazy parse untuk nested objects** | Performance | TDD 05 | Optional nested: `@JsonKey(includeIfNull: false)` atau custom |
| M12 | **Buat benchmark untuk parsing 100 doctors** | Performance | TDD 10 (testing) | Validasi: target < 50 ms di main thread, atau wajib isolate |

### 4.3 LOW Priority (Sprint 2–3)

| ID | Judul | Kategori | Rekomendasi |
|---|---|---|---|
| L1 | **Migrasi ke Hive (v2.0)** — tulis migration plan | Offline-first | Tulis `tdd/12-migration-plan.md` dengan schema versioning |
| L2 | **Gunakan cursor-based pagination** (`?after_id=`) menggantikan offset | Performance | Untuk dataset besar (v2) |
| L3 | **Tambah kolom `bahasa_konsultasi` di `doctors`** (TEXT[]) | ERD | Sinkronkan dengan PRD §6.4 |
| L4 | **Compression header** (`Accept-Encoding: gzip`) | Performance | Supabase support by default, verify di client |
| L5 | **Streaming response** dengan `Stream<List<Doctor>>` | Performance | Untuk search dengan 100+ hasil |
| L6 | **Tambah `bahasa` (TEXT[]) array support** untuk Isar (List<String>) | Model Mapping | Dokumentasikan cara mapping di TDD 05 |
| L7 | **Buat generator helper** untuk OpenAPI → Dart models | Codegen | `openapi_generator` atau `swagger_dart_code_generator` |
| L8 | **Tambah E2E test untuk offline scenario** | Testing | TDD 10 — airplane mode → booking tetap attempted → sync queue |
| L9 | **Pertimbangkan IsarLinks** untuk relasi 1:N | Offline-first | Jika migrasi ke Isar, gunakan `IsarLink<Clinic>` daripada manual join |
| L10 | **Pertimbangkan Drift** untuk type-safe SQL di mobile | Offline-first | Alternatif dari Isar/Hive dengan relational model |

---

## 5. Rekomendasi Strategis

### 5.1 Pilih Local DB Stack (v2.0)

| Opsi | Pro | Kontra | Rekomendasi |
|---|---|---|---|
| **Hive** | Cepat, no native dep, no SQL | Manual relasi, tidak ada query kuat | ✅ Untuk MVP+ (simple cache) |
| **Isar** | Relasi built-in, query cepat, NoSQL | Lebih besar dari Hive, less mature | ✅ Untuk v2 dengan relasi |
| **Drift (SQLite)** | Type-safe SQL, relasi kuat | SQL boilerplate, lebih lambat | ✅ Untuk app dengan relasi kompleks |
| **Sqflite** | Mature, SQL lengkap | Raw SQL, no type-safety | ❌ Tidak direkomendasikan untuk Flutter modern |
| **ObjectBox** | Sangat cepat, relasi otomatis | Native lib, less popular | ⚠️ Alternatif bagus tapi tim harus belajar |

**Saran:** **Mulai Hive untuk MVP, migrasi ke Isar untuk v2.0** (atau langsung Isar jika tim sudah familiar).

### 5.2 Sync Strategy Pattern (untuk v2.0)

```
┌──────────────────────────────────────────────┐
│  Local DB (Isar)                            │
│  ┌──────────────┐    ┌──────────────────┐  │
│  │ appointments │    │  sync_queue       │  │
│  │ +sync_status │    │  +operation       │  │
│  │ +local_id    │    │  +payload         │  │
│  │ +version     │    │  +retry_count     │  │
│  └──────────────┘    └──────────────────┘  │
└──────────────────────────────────────────────┘
         │                       │
         ▼                       ▼
   Read dari local         Connectivity listener
   (instant)              (online → drain queue)
                                │
                                ▼
                        ┌──────────────┐
                        │  Supabase    │
                        │  (server)    │
                        └──────────────┘
```

**3 status sync:**
- `synced` — data sama dengan server
- `pending_upload` — ada perubahan lokal, belum terkirim
- `pending_download` — ada perubahan server, belum ter-pull

### 5.3 Data Flow Pattern untuk Deep Nested Response

```dart
// ❌ Anti-pattern: parse semaunya di BLoC
class BookingHistoryCubit {
  Future<void> load() async {
    final response = await supabase.from('appointments').select('...');
    final list = (response as List).map((j) => AppointmentModel.fromJson(j));
    emit(BookingHistoryLoaded(list.toList()));
  }
}

// ✅ Pattern: pre-parse di DataSource dengan compute()
class BookingRemoteDataSource {
  Future<List<AppointmentEntity>> getHistory(String patientId) async {
    final response = await supabase
      .from('appointments')
      .select('id, status, doctors(id, full_name, photo_url, specializations(name)), doctor_slots(slot_date, slot_start, slot_end)')
      .eq('patient_id', patientId)
      .order('created_at', ascending: false)
      .limit(10);  // ← aggressive pagination
    
    return compute(_parseAppointmentsIsolate, response as List<dynamic>);
  }
}

List<AppointmentEntity> _parseAppointmentsIsolate(List<dynamic> jsonList) {
  return jsonList
      .map((j) => AppointmentModel.fromJson(j as Map<String, dynamic>))
      .toList(growable: false);
}
```

### 5.4 Buat Dokumen Baru: `docs/tdd/14-data-architecture.md`

Berisi:
1. Pilih local DB (Hive vs Isar vs Drift) — eksplisit
2. Sync metadata schema (local_id, sync_status, version)
3. Conflict resolution strategy per entity
4. Performance budget per endpoint (target ms)
5. List endpoint → compact select pattern
6. `compute()` pattern untuk parsing
7. Migration plan v1 (SharedPref) → v2 (Hive) → v3 (Isar)

---

## 6. Verdict

**ERD Health Pal sudah mature untuk MVP (77/100) — fondasi relational design solid, denormalization strategy tepat, indexes optimal.**

### Positif
- ✅ Denormalization strategy clear (doctor_id di slots, fee snapshot)
- ✅ Snapshot pattern bagus untuk histori (consultation_fee_snapshot)
- ✅ Tidak ada many-to-many (Clean Architecture friendly)
- ✅ 1:1 dan 1:N mapping kebanyakan sederhana
- ✅ Index komprehensif
- ✅ UUID PK universally applicable
- ✅ Single-object endpoints aman untuk main thread

### Perlu Diperkuat
- ⚠️ **Offline-first belum siap**: tidak ada sync metadata, conflict resolution, atau soft-delete
- ⚠️ **JSON parsing bottleneck** untuk list endpoint besar (Booking History 100-200 ms)
- ⚠️ **Date/Time format terpisah** (3 field) menyulitkan Flutter mapping
- ⚠️ **Hive migration v2.0 tanpa migration plan**
- ⚠️ **Tidak ada materialized view** untuk query yang sering dipanggil
- ⚠️ **Inkonsistensi nested key** (singular vs plural) dari audit sebelumnya

### Setelah 7 High Priority di-address
- Skor Offline-first: 72 → **88** (sync metadata + soft-delete)
- Skor Model Mapping: 80 → **85** (SlotTime class + sealed Appointment)
- Skor JSON Parsing: 78 → **90** (materialized view + isolate + pagination)
- **Keseluruhan: 77 → 88/100**

---

## 7. Action Items Ringkas

| # | ID | Tindakan | Owner | Target |
|---|---|---|---|---|
| 1 | H1, H2, H7 | Tambah sync metadata + soft-delete + conflict strategy | DB Architect + Tech Lead | Sebelum Sprint 1 |
| 2 | H3 | Refactor slot_date + slot_start jadi TIMESTAMPTZ + INTERVAL | DB Architect | Sprint 1 (minggu 1) — migration |
| 3 | H4, M6 | Buat materialized view + RPC get_home_data | Backend Lead | Sprint 1 (minggu 2) |
| 4 | H5, M10 | Definisikan compact/full select + pagination limit per endpoint | Backend Lead | Sprint 1 (minggu 1) |
| 5 | H6 | Standarkan nested key (selalu plural) | Backend Lead | Sprint 1 (minggu 1) |
| 6 | M1, M2 | Tambah composite index | DB Architect | Sprint 1 (minggu 1) |
| 7 | M3 | Buat SlotTime class | Tech Lead | Sprint 1 (minggu 2) |
| 8 | M4, M11, M12 | compute() pattern + lazy parse + benchmark | Tech Lead | Sprint 2 |
| 9 | M5 | ETag/Last-Modified header | Backend Lead | Sprint 2 |
| 10 | M7 | Refactor Appointment ke sealed class | Tech Lead | Sprint 2 |
| 11 | M8 | Lookup tables (genders, statuses) | DB Architect | Sprint 2 |
| 12 | M9 | Tambah audit_logs table | DB Architect | Sprint 2 |
| 13 | L1, L2 | Tulis migration plan Hive/Isar + cursor pagination | Tech Lead | Sprint 3 |
| 14 | L3–L10 | Polish & optimization | Frontend Dev | Sprint 3+ |

---

*Dokumen ini merupakan audit snapshot untuk ERD + arsitektur data. Setiap perubahan skema database (migration) atau penambahan endpoint list harus memicu re-audit untuk menjaga alignment skor di atas 85/100.*
