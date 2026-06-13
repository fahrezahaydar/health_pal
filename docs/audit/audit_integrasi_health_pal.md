# Audit Integrasi User Flow & API Contract — Health Pal

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Platform** | Mobile (Flutter — Android & iOS) |
| **Versi Dokumen** | v1.0 |
| **Tanggal Audit** | 13 Juni 2026 |
| **Auditor** | Senior System Analyst / Mobile Solution Architect |
| **Cakupan** | USER_FLOW v2.0 · API Contract v1.0 · ERD v1.0 · TDD 01, 02, 05, 06 · Wireframe 02, 06–10, 12–15 |
| **Fokus** | State coverage, API compatibility untuk Flutter, DTO/Generator readiness |

---

## Ringkasan Skor

| Kriteria | Skor | Status |
|---|---|---|
| **1. State & Flow Mapping** | **82 / 100** | 🟢 Baik |
| **2. API Compatibility untuk Flutter** | **75 / 100** | 🟡 Perlu Perhatian |
| **3. Flutter Integration (DTO/Generator)** | **78 / 100** | 🟢 Baik |
| **Skor Keseluruhan** | **78 / 100** | 🟢 Layak (dengan revisi minor) |

---

## 1. State & Flow Mapping — 82 / 100

### 1.1 State Coverage Matrix

| Flow / Page | Loading | Empty | Error | Success | Offline | Catatan |
|---|:---:|:---:|:---:|:---:|:---:|---|
| Onboarding (3 slide) | ❌ | — | — | ✅ redirect | ❌ | Tidak ada state eksplisit, langsung render |
| Sign In (02) | ✅ Dialog | — | ✅ Snackbar/Dialog | ✅ → home | ❌ | Network error hanya snackbar, tidak redirect `/no-internet` |
| Sign Up (03) | ✅ Dialog | — | ✅ Inline error | ✅ → create profile | ❌ | Sama, offline handling lemah |
| Create Profile (04) | ✅ Dialog | — | ✅ Snackbar | ✅ → home | ❌ | Upload avatar progress tidak ada |
| Forgot Password (05) | ✅ Per step | — | ✅ Inline + Snackbar | ✅ Popup → pop | ❌ | **Paling lengkap: 3 sub-step dalam 1 Cubit** ✅ |
| Home (06) | ⚠️ Partial | ✅ Upcoming empty + CTA | ❌ | ✅ | ⚠️ Indirect | Loading per section (skeleton) tapi tidak ada global error state |
| Doctor Search (08) | ✅ Shimmer | ✅ "Dokter tidak ditemukan" | ✅ Snackbar | ✅ | ❌ | Network error → snackbar, tidak ke `/no-internet` |
| Doctor Detail (09) | ✅ Shimmer on slot | ✅ "Tidak ada jadwal" | ✅ Snackbar | ✅ | ❌ | Sama, no redirect ke no-internet |
| Book Appointment (10) | ✅ Dialog | — | ✅ Dialog (409/500) | ✅ /booking/success | ❌ | Conflict 409 → refresh slot, **best handled** ✅ |
| Booking Success (11) | — | — | — | ✅ Full screen | — | Sederhana, OK |
| Booking History (12) | ✅ Loading more | ✅ Per-tab empty | ✅ Snackbar | ✅ | ❌ | Pagination loading OK |
| Booking Detail (13) | ✅ | — | ✅ Snackbar | ✅ Timeline update | ❌ | Cancel flow + auto-status update eksplisit ✅ |
| Loc (07) | ❌ | ✅ "Tidak ada dokter" | ❌ | ✅ | ❌ | Loading state tidak ada di wireframe |
| Profile (14) | ❌ | ❌ | ❌ | ✅ | ❌ | **Paling lemah — hampir tidak ada state coverage** |
| Edit Profile (15) | ✅ Dialog | — | ✅ Snackbar | ✅ Pop + snackbar | ❌ | Standar OK |
| No Internet (21) | — | — | — | — | ✅ | Standalone page |

### 1.2 Yang Sudah Matang

- **4 flow offline-handled** eksplisit di USER_FLOW: Home Search, Doctor Detail, Slot, Book Appointment. Redirect ke `/no-internet` terdokumentasi.
- **Booking flow** paling lengkap: 409 conflict → refresh slot, 500 → retry dialog, expired appointment → auto-status update. Edge case minor tertangani.
- **Forgot Password** dengan 1 rute + 3 sub-step dalam Cubit adalah smart pattern (tambah state tanpa tambah navigasi).
- **Error catalog** di API Contract §9 + TDD 06 §2-3 sangat komprehensif: 11 error code dengan Flutter handling suggestion.
- **Booking Detail** memiliki 3 state variant (Pending/Upcoming, Completed, Cancelled) yang berbeda secara UI dan behavior.

### 1.3 Yang Perlu Diperbaiki

| # | Flow | Masalah | Rekomendasi |
|---|---|---|---|
| 1 | **Profile (14)** | Tidak ada loading/empty/error state | Tambah `ProfileLoading`, `ProfileError`, empty state untuk nickname/avatar |
| 2 | **Onboarding (01)** | `Skip` di tengah flow tidak dijelaskan behavior-nya | Tambah state diagram: `Skip` di slide 1/2 → tetap simpan `onboardingDone=true`? |
| 3 | **Edit Profile / Create Profile** | Upload avatar progress tidak ada | Tambah `UploadProgress(0-100%)` state dengan progress bar di dialog |
| 4 | **Sign In / Sign Up** | Network error hanya snackbar, tidak redirect `/no-internet` | Tambah logic: `NetworkException` → redirect ke `/no-internet` |
| 5 | **Home (06)** | Global error state tidak ada; per-section error parsing | Tambah `HomeError` state + retry-all button |
| 6 | **Loc (07)** | Loading state di wireframe hilang | Tambah skeleton + map loading indicator |
| 7 | **Session timeout (idle)** | Tidak ada flow | Tambah state `SessionIdle` setelah 5 menit inaktif → show dialog "Session expired" → re-login |
| 8 | **Token refresh** | Ada di TDD 06 tapi tidak ada di USER_FLOW | Tambah user-facing state: subtle indicator saat token refresh gagal |
| 9 | **Force update / Maintenance** | Tidak ada | Tambah minimal dokumentasi cara handle (FCM silent push atau app version check API) |
| 10 | **Image picker cancellation** | Tidak ada state | Tambah `ImagePickerCanceled` state agar tidak emit error palsu |

---

## 2. API Compatibility untuk Flutter — 75 / 100

### 2.1 Yang Sudah Konsisten

- **snake_case** 100% di seluruh request/response body — sesuai konvensi PostgreSQL.
- **Envelope standard** untuk Edge Function: `{success, data, error}` dengan kode error konsisten (`SLOT_ALREADY_BOOKED`, `VALIDATION_ERROR`, dll).
- **HTTP status code** digunakan sesuai semantic (200/201/204/400/401/403/404/409/422/500).
- **Header standard** (`apikey`, `Authorization`, `Content-Type`) terdokumentasi jelas.
- **Error catalog** (§9) dan Flutter handling example di §9 sudah usable.
- **Composite nested select** di PostgREST (`select=*,clinics(*),specializations(*)`) sesuai standar Supabase.

### 2.2 Masalah Kritis (High Priority)

| # | Masalah | Lokasi | Dampak ke Flutter |
|---|---|---|---|
| 1 | **Pagination tanpa `has_more`/`next_offset`** — semua list endpoint hanya return raw array atau array + `meta.total` | API §5.1, §6.2, §8.1 | Infinite scroll tidak bisa implement; harus fetch semua atau track manual |
| 2 | **Home endpoint tidak ada di API Contract** — wireframe 06 butuh `GET /appointments/upcoming` & `GET /facilities/nearby` | `wireframe/06-home.md` vs `api_contract_health_pal.md` | Implementation blocker untuk Home Page |
| 3 | **`is_profile_complete` tidak di-return** setelah signup/login | API §2.1, §2.2 | User Flow 4.1 butuh extra GET request untuk routing decision |
| 4 | **200 + `[]` untuk "not found"** | API §5.3, §5.4, §6.3 | Flutter harus handle 2 semantic: 404 dan 200+empty. Risk: empty data di-anggap success |
| 5 | **Nested key convention inkonsisten** — 5.1/5.3/6.2 pakai plural (`clinics`, `specializations`, `doctors`, `doctor_slots`); 6.1 pakai singular (`doctor`, `slot`) | API §5 vs §6.1 | Generated DTO untuk entity `Doctor` akan berbeda format antar endpoint. Perlu custom mapper |

### 2.3 Masalah Medium Priority

| # | Masalah | Dampak |
|---|---|---|
| 6 | **Date/Time format campuran**: `"2026-06-15"` (date), `"09:00:00"` (time), `"2026-06-07T10:30:00.000Z"` (datetime) | Butuh 3 custom converter di JsonSerializable. `TimeOfDay` tidak ada di Dart core, perlu extend |
| 7 | **Avatar upload 2-step** (upload → PATCH URL) | Race condition: upload sukses tapi PATCH gagal → orphan file di storage |
| 8 | **Bahasa konsultasi** di wireframe 09, PRD §6.4 TIDAK ADA di API/ERD | Field akan null di UI, atau wireframe harus direvisi |
| 9 | **Response format PostgREST vs Edge Function** berbeda (raw array vs envelope) | 2 strategi parsing. Sebaiknya PostgREST list di-wrap envelope juga |
| 10 | **RPC function naming** `get_nearby_clinics` (snake_case) vs Edge Function `cancel-appointment` (kebab-case) | Inkonsistensi konvensi; pilih 1 |
| 11 | **API Contract duplikat Section 7** ("Facility Endpoints" muncul 2x) | Konfusi developer; sumber data mana yang dipakai |
| 12 | **Doctor list `experience_years` & `consultation_fee`** ada di response tapi tidak ditampilkan di wireframe Doctor Search | Either: tambah di wireframe, atau field di-trim dari select |

### 2.4 Missing Endpoint atau Field

| Endpoint / Field | Diperlukan Oleh | Status |
|---|---|---|
| `GET /appointments?status=in.(pending,upcoming)&order=slot.slot_date.asc&limit=1` | Home (Upcoming Card) | ❌ Missing |
| `POST /functions/v1/nearby-facilities` atau alias `get_nearby_clinics` | Home (Nearby Medical Centers) | ⚠️ Duplikat tdk konsisten |
| `is_profile_complete` di response signup/login | User Flow 4.1 routing | ❌ Missing |
| `consultation_fee_snapshot` di select Booking History | Wireframe 12 (tidak ada, tapi PRD sebut) | ❌ Missing di select |
| `doctors.bahasa_konsultasi` | Wireframe 09, PRD §6.4 | ❌ Missing di ERD |
| `appointments` nested `slot` lengkap dengan `slot_date` & `slot_start` | Booking History | ✅ Ada di 6.2 |
| `banners.action_url` → deep link handler | Home (banner tap) | ✅ Ada di API, ❌ belum ada di Flutter |
| Endpoint `GET /me` (current user profile) | Avoid 2-step login | ❌ Tidak ada; pakai GET user_profiles by auth_id |
| Endpoint `PATCH /me/notifications/:id` (mark as read) | Notification inbox | ✅ Ada di §8.2, tapi wireframe Notification Settings belum jelas |

---

## 3. Flutter Integration (DTO/Generator Readiness) — 78 / 100

### 3.1 Yang Matang

- **Clean Architecture** folder structure feature-first (TDD 02) siap di-scale.
- **Naming convention** eksplisit dan lengkap (TDD 02 §4): file, class, route names.
- **Sealed class pattern** untuk `Result<T>`, `ApiException`, state per-fitur (Booking, dll) — Dart 3.0 ready.
- **DataSource strategy** (TDD 05 §4) terdokumentasi jelas: cache first vs remote first per data type.
- **Snake→camel mapping** sudah ada strategi di ERD §5.5 dan TDD 05 §3.2 (manual `json['full_name']`).
- **Repository pattern** dengan `Result<T>` return type — testable dan functional.
- **Injectable + get_it** untuk DI (TDD 01, 02 §1) — siap di-codegen.
- **Timeout & retry strategy** (TDD 06 §6) terdokumentasi lengkap.
- **Folder structure** migrasi plan sudah ada (TDD 02 §3).

### 3.2 Masalah Kritis untuk Generator

| # | Masalah | Lokasi | Dampak |
|---|---|---|---|
| 1 | **Tidak ada `@JsonSerializable` / `@JsonKey` examples** — semua dariJson/toJson di TDD 05 manual | `tdd/05-data-layer.md` §3.2 | Developer akan tulis boilerplate manual 100+ baris, tidak scalable |
| 2 | **Snake↔camel mapping strategy tidak eksplisit** | TDD 05 | Pilih: `@JsonKey(name: 'full_name')` atau global converter. Belum diputuskan |
| 3 | **Enum naming inkonsistensi** — ERD pakai `other`, TDD 02 pakai `notSpecified` | `erd_healh_pal.md` §2.2 vs `tdd/02-folder-structure.md` baris 36 | Generated `Gender.values.byName()` akan throw runtime error |
| 4 | **Pagination wrapper tidak standar** | API §5.1, §6.2 | Tidak bisa reuse `PaginatedResponse<T>` DTO |

### 3.3 Masalah Medium Priority

| # | Masalah | Rekomendasi |
|---|---|---|
| 5 | **Date/Time converter tidak terdefinisi** | Tambah custom `@JsonKey(fromJson: dateFromJson, toJson: dateToJson)` di tiap Model. Untuk time, custom class `SlotTime` |
| 6 | **Nested polymorphic mapping** — di API 6.1 key singular (`doctor`), di 5.1 plural (`doctors`) | Pilih 1 konvensi. Saran: selalu plural mengikuti PostgREST select convention |
| 7 | **Tidak ada `@freezed` vs manual `Equatable` decision** | Pilih satu. Saran: `@freezed` untuk Model (immutable + copyWith + fromJson), manual `Equatable` untuk Entity (zero dep) |
| 8 | **Tidak ada `@injectable` annotation examples** | Tambah 1-2 contoh `@LazySingleton(as: AuthRepository)`, `@injectable` di AuthRepositoryImpl |
| 9 | **Edge Function naming inkonsistensi** — `get_nearby_clinics` (snake) vs `cancel-appointment` (kebab) | Pilih 1: Saran kebab-case untuk semua Edge Function |
| 10 | **DataSource inkonsistensi** — `notification_datasource.dart` ada di profile (TDD 02 §3.2) tapi `NotificationModel` ada di notification (TDD 05 §5) | Tambah folder `features/notification/` atau pindahkan ke `features/profile/data/` |
| 11 | **Tidak ada strategi DTO version migration** — kalau API tambah field, Model tidak auto-handle unknown fields | `json_serializable` sudah handle by default, tapi perlu didokumentasikan |
| 12 | **Custom converter untuk status enums** belum ada | Misal: `status: AppointmentStatus.values.byName(json['status'])` — jika API return enum value baru, throw runtime. Saran: default fallback |

### 3.4 Quick Wins untuk Codegen

```dart
// CONTOH PATTERN YANG SEBAIKNYA DIDOKUMENTASIKAN DI TDD 05:

// 1. Snake→camel dengan @JsonKey (RECOMMENDED)
@freezed
class DoctorModel with _$DoctorModel {
  const factory DoctorModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'experience_years') required int experienceYears,
    @JsonKey(name: 'consultation_fee') required double consultationFee,
    @JsonKey(name: 'rating_avg') required double ratingAvg,
    @JsonKey(name: 'rating_count') required int ratingCount,
    ClinicModel? clinic,
    SpecializationModel? specialization,
  }) = _DoctorModel;
  
  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
}

// 2. Date/Time converter
@JsonKey(fromJson: _dateOnlyFromJson, toJson: _dateOnlyToJson)
final DateTime slotDate;

DateTime? _dateOnlyFromJson(dynamic value) =>
    value == null ? null : DateTime.parse(value as String);

// 3. Enum dengan @JsonValue
enum Gender {
  @JsonValue('male') male,
  @JsonValue('female') female,
  @JsonValue('other') other,  // HARUS sinkron dengan ERD
}
```

---

## 4. Poin Perbaikan Integrasi

### 4.1 HIGH Priority (Blokir Sprint 1)

| ID | Judul | Kategori | File Target | Rekomendasi |
|---|---|---|---|---|
| H1 | **Tambah endpoint Home yang hilang**: `GET /appointments/upcoming` & `GET /facilities/nearby` | API | `api_contract_health_pal.md` | Tambah §6.5 `GET /rest/v1/appointments?status=in.(pending,upcoming)&order=slot.slot_date.asc&limit=1`. Tambah §7 `POST /functions/v1/nearby-facilities` atau rename RPC `get_nearby_clinics` → `nearby-clinics` |
| H2 | **Fix duplikat Section 7 API Contract** | Dokumentasi | `api_contract_health_pal.md` baris 1536+ | Hapus duplikat; konsolidasi Facility → Clinic (sesuai ERD) |
| H3 | **Tambah `is_profile_complete` di response login/signup** | API + Flow | `api_contract_health_pal.md` §2.1, §2.2 | Tambah field di `user` object atau bikin endpoint `GET /me` |
| H4 | **Standarkan nested key convention (plural)** | API | `api_contract_health_pal.md` §6.1 | Ubah `data.doctor` → `data.doctors[0]` atau konsisten. Pilih 1. Saran: selalu plural (PostgREST style) |
| H5 | **Fix enum Gender inkonsistensi**: ERD `other` vs TDD `notSpecified` | API + Flutter | `erd_healh_pal.md` §2.2, `tdd/02-folder-structure.md` baris 36 | Pilih satu. Saran: `other` (sesuai PostgreSQL convention) dan update TDD 02 + API §3.2 example |
| H6 | **Tambah `@JsonKey` / `@JsonSerializable` examples di TDD 05** | Codegen | `tdd/05-data-layer.md` §3 | Tambah minimal 1 Model lengkap dengan `@JsonKey(name: 'snake_case')` + `@freezed` |
| H7 | **Definisikan snake↔camel mapping strategy** | Codegen | `tdd/05-data-layer.md` | Pilih: global JsonConverter vs per-field `@JsonKey`. Saran: `@JsonKey` per-field untuk eksplisit |

### 4.2 MEDIUM Priority (Sprint 1–2)

| ID | Judul | Kategori | File Target | Rekomendasi |
|---|---|---|---|---|
| M1 | **Pagination wrapper standar** | API + Flutter | `api_contract_health_pal.md` | Wrap semua list: `{data: [...], meta: {total, limit, offset, has_more}}`. Update PostgREST responses juga |
| M2 | **200+[] vs 404** | API | `api_contract_health_pal.md` §5.3, §5.4, §6.3 | Return 404 untuk resource not found; 200+[] hanya untuk valid empty list |
| M3 | **Date/Time converter** | Flutter | `tdd/05-data-layer.md` | Tambah helper `_dateFromJson`, `_timeFromJson` dengan custom class `SlotTime` |
| M4 | **Avatar upload atomic** | API | `api_contract_health_pal.md` §3.3 | Tambah `POST /functions/v1/upload-avatar` yang return URL siap-pakai |
| M5 | **Tambah field `bahasa_konsultasi`** di `doctors` | ERD + API | `erd_healh_pal.md` §2, `api_contract_health_pal.md` §5.1, §5.3 | Tambah `TEXT bahasa_konsultasi[]` atau hapus dari PRD/wireframe |
| M6 | **Tambah endpoint `GET /me`** | API | `api_contract_health_pal.md` §3.1 | Hindari 2-step query `user_profiles?auth_id=` setelah login |
| M7 | **Edge Function naming** konsisten kebab-case | API | `api_contract_health_pal.md` | Rename RPC `get_nearby_clinics` → `nearby-clinics` (kebab-case) |
| M8 | **Tambah `@freezed` vs `Equatable` decision** | Flutter | `tdd/05-data-layer.md` | Saran: `@freezed` untuk Model (Data layer), manual `Equatable` untuk Entity (Domain layer) |
| M9 | **Tambah `@injectable` annotation examples** | Flutter | `tdd/05-data-layer.md` §2 | Tambah 1-2 contoh `@LazySingleton(as: Repository)` dan `@injectable` |
| M10 | **Response format PostgREST di-wrap envelope** | API | `api_contract_health_pal.md` | Konsistensi: semua response pake `{success, data}` atau raw. Pilih 1 |
| M11 | **Profile Page state coverage** | UX | `wireframe/14-profile.md` | Tambah loading/empty/error state eksplisit |
| M12 | **Session idle timeout flow** | Flow | `user_flow/USER_FLOW.md` | Tambah: idle 5 menit → dialog "Session expired" → re-login |
| M13 | **Upload avatar progress** | UX | `wireframe/15-profile-edit.md` | Tambah progress bar 0-100% di dialog upload |
| M14 | **Onboarding Skip behavior** | Flow | `user_flow/USER_FLOW.md` §3 | Eksplisitkan: `Skip` di slide 1/2/3 → `onboardingDone = true` → redirect ke `/sign-in` (sama seperti Get Started) |
| M15 | **Notification DataSource location** | Struktur | `tdd/02-folder-structure.md` | Tambah folder `features/notification/` atau pindahkan ke `features/profile/data/` |
| M16 | **Network error → `/no-internet` redirect** | Flow | `user_flow/USER_FLOW.md` | Standarkan: semua flow dengan network error → redirect ke `/no-internet`, bukan snackbar saja |

### 4.3 LOW Priority (Sprint 2–3)

| ID | Judul | Kategori | Rekomendasi |
|---|---|---|---|
| L1 | **Force update / Maintenance flow** | Flow | Tambah FCM silent push atau app version check API. Wireframe tidak perlu detail |
| L2 | **Image picker cancellation state** | Flow | Tambah state `ImagePickerCanceled` di CreateProfileCubit agar tidak emit error palsu |
| L3 | **Custom enum fallback untuk backward compat** | Flutter | `Gender.values.byName(json['gender'])` → wrap try-catch dengan fallback `Gender.other` |
| L4 | **DTO version migration strategy** | Flutter | Dokumentasikan: tambah field baru di API aman karena `json_serializable` skip unknown. Hapus field butuh major version bump |
| L5 | **API deprecation header** | API | Tambah header `Sunset` dan `Deprecation` saat akan deprecate endpoint lama |
| L6 | **Loading state di Loc (07)** | UX | Tambah skeleton + map loading indicator |
| L7 | **Empty state di Profile (14)** | UX | Tambah placeholder saat nickname/avatar null |
| L8 | **Token refresh UX indicator** | UX | Subtle snackbar "Sesi diperpanjang" saat auto-refresh berjalan |
| L9 | **Doctor list response trim** | API | Trim `experience_years`, `consultation_fee` dari `select` jika tidak dipakai di wireframe, atau tampilkan di UI |
| L10 | **Nested convention helper** | Flutter | Tulis `DoctorMapper.fromApi(Map json)` static class untuk handle singular vs plural |

---

## 5. Rekomendasi Tambahan untuk Sprint 1

### 5.1 Buat Dokumen Baru: `docs/tdd/13-codegen-conventions.md`

Berisi:
1. `@freezed` + `@JsonSerializable` decision matrix
2. Snake↔camel mapping strategy
3. Custom converter list (DateTime, Time, Enum, Nullable, Nested)
4. Naming convention untuk generated files (`*.freezed.dart`, `*.g.dart`)
5. Contoh 3 Model lengkap (Doctor, Appointment, Profile)
6. Pagination wrapper pattern

### 5.2 Tambah API Contract Appendix

- **Appendix A: Error Code → Flutter FailureCode mapping table** (versi ringkas dari TDD 06 §2)
- **Appendix B: Common Query Parameters** (limit, offset, order, select)
- **Appendix C: Date/Time Format Reference** (date only, time only, ISO 8601, epoch)
- **Appendix D: Enum Value Catalog** (Gender, BookingStatus, NotificationType)

### 5.3 File Naming untuk Generated

```
features/doctor/data/model/
├── doctor_model.dart                    # source
├── doctor_model.freezed.dart            # generated
├── doctor_model.g.dart                  # generated
├── doctor_slot_model.dart
├── doctor_slot_model.freezed.dart
└── doctor_slot_model.g.dart
```

Build runner config:
```yaml
# build.yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          field_rename: snake
          explicit_to_json: true
          create_factory: true
          create_to_json: true
```

---

## 6. Verdict

**Health Pal punya fondasi integrasi API ↔ Flow yang kuat (78/100) untuk lanjut ke implementasi.**

- State coverage 80% — flow kritis tertangani, profile & session timeout perlu diperkuat.
- API Contract solid di struktur & error handling, tapi **5 blocker High** untuk codegen (H1, H3, H4, H5, H6, H7).
- Folder structure dan naming convention siap di-scale, tapi **belum ada codegen examples** — ini wajib ada sebelum Sprint 1.

Setelah 7 poin High di-address:
- **State coverage naik ke ~90%** (cukup 2-3 sprint polish)
- **API compatibility naik ke ~88%** (cukup pagination wrapper + 1 endpoint atomic)
- **Codegen readiness naik ke ~92%** (cukup TDD 05 update + convention doc)

Estimasi skor keseluruhan akan mencapai **90/100** yang siap untuk development dengan risiko teknis rendah.

---

## 7. Action Items Ringkas

| # | ID | Tindakan | Owner | Target |
|---|---|---|---|---|
| 1 | H1, H2 | Tambah endpoint Home + fix duplikat API | Backend Lead | Sebelum Sprint 1 |
| 2 | H3 | Tambah `is_profile_complete` di login response | Backend Lead | Sebelum Sprint 1 |
| 3 | H4 | Standarkan nested key convention | Backend Lead + Tech Lead | Sebelum Sprint 1 |
| 4 | H5 | Fix enum Gender (other vs notSpecified) | Backend Lead + Tech Lead | Sebelum Sprint 1 |
| 5 | H6, H7 | Tulis TDD 13 (codegen conventions) | Tech Lead | Sebelum Sprint 1 |
| 6 | M1, M10 | Pagination wrapper + response envelope | Backend Lead | Sprint 1 (minggu 2) |
| 7 | M2 | 404 untuk not found | Backend Lead | Sprint 1 (minggu 1) |
| 8 | M3, M8, M9 | Custom converter + freezed decision | Tech Lead | Sprint 1 (minggu 2) |
| 9 | M4 | Avatar upload atomic Edge Function | Backend Lead | Sprint 2 |
| 10 | M5, M6 | Tambah bahasa_konsultasi + endpoint /me | Backend Lead | Sprint 2 |
| 11 | M7 | Rename RPC ke kebab-case | Backend Lead | Sprint 2 |
| 12 | M11–M14 | Profile & onboarding state coverage | UI/UX Designer | Sprint 1–2 |
| 13 | M15 | Notification DataSource reorganization | Tech Lead | Sprint 1 |
| 14 | M16 | Network error → /no-internet standard | Tech Lead | Sprint 1 |
| 15 | L1–L10 | Polish & backward compat | Frontend Dev | Sprint 2–3 |

---

*Dokumen ini merupakan audit snapshot untuk User Flow + API Contract + Flutter Integration. Perubahan signifikan pada salah satu dari ketiganya harus memicu re-audit untuk menjaga alignment skor di atas 85/100.*
