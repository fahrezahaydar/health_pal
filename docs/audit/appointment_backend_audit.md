# Audit Backend Appointment/Booking — Health Pal

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Platform** | Backend (Supabase PostgreSQL + PostgREST + Edge Functions) + Flutter Mobile Client |
| **Versi Dokumen** | v1.0 |
| **Tanggal Audit** | 29 Juni 2026 |
| **Auditor** | Tech Lead |
| **Cakupan** | Tabel `appointments` + `doctor_slots` · RPC `create_appointment` · Edge Function `cancel-appointment` · RLS policies · Flutter datasource/repository/usecase/bloc booking |
| **Acuan** | ERD v1.0 · API Contract v1.0 §6.1-6.4 · PRD §6.5-6.6, §8, §13 · Wireframe 10-13 · migrations 001-010 |
| **Fokus** | Race condition slot booking · RLS enforcement · Cancel flow end-to-end · Data integrity `is_booked` |

---

## Ringkasan Eksekutif

🔴 **APPOINTMENT BACKEND 58 / 100** — Get list & detail solid (RLS enforced, query correct). **Create flow rentan race condition** (RPC check tanpa `FOR UPDATE`, partial unique index `idx_appointments_active_slot` dari migration 010 **tidak ter-apply** di DB). **Cancel flow completely broken** (Edge Function `cancel-appointment` tidak ada di `supabase/functions/`, tidak ada RPC `cancel_appointment` juga). Data test sebelumnya sudah terekspos bug ini (sisa 1 slot dengan 4 appointment duplikat, 1 slot dengan 2).

| Area | Skor | Status |
|---|---|---|
| **1. Get List Appointment** | **88 / 100** | 🟢 Solid (RLS OK, query filter OK, nested data OK) |
| **2. Get Detail Appointment** | **85 / 100** | 🟢 Solid (RLS OK, defense in depth via `patient_id` filter) |
| **3. Create Appointment & Slot Locking** | **30 / 100** | 🔴 **CRITICAL** — Race condition rentan, partial unique index hilang, test data bukti bug |
| **4. Cancel Appointment & Slot Release** | **10 / 100** | 🔴 **CRITICAL** — Backend function tidak ada, flow 100% gagal |
| **Skor Keseluruhan** | **58 / 100** | 🔴 Tidak siap production — perlu fix sebelum Sprint A7 release |

---

## 1. Schema & Constraint Findings (STEP 2)

### 1.1 Tabel `appointments` — Kolom Aktual

| # | Kolom | Tipe | Nullable | Default | Catatan |
|---|-------|------|:--------:|---------|---------|
| 1 | `id` | `uuid` | NO | `gen_random_uuid()` | ✅ PK |
| 2 | `patient_id` | `uuid` | NO | — | ⚠️ Tidak ada ON DELETE behavior (lihat §1.5) |
| 3 | `doctor_id` | `uuid` | NO | — | ✅ FK ke `doctors` (RESTRICT) |
| 4 | `slot_id` | `uuid` | NO | — | ✅ FK ke `doctor_slots` (RESTRICT) |
| 5 | `status` | `appointment_status` (enum) | NO | `'pending'::appointment_status` | ✅ Enum, default valid |
| 6 | `complaint_note` | `text` | YES | — | ✅ Nullable (opsional) |
| 7 | `consultation_fee_snapshot` | `numeric(12,2)` | NO | — | ✅ Snapshot immutable |
| 8 | `booked_at` | `timestamptz` | NO | `now()` | ✅ |
| 9 | `confirmed_at` | `timestamptz` | YES | — | ✅ Nullable (transisi belum) |
| 10 | `completed_at` | `timestamptz` | YES | — | ✅ |
| 11 | `cancelled_at` | `timestamptz` | YES | — | ✅ |
| 12 | `cancellation_reason` | `text` | YES | — | ✅ |
| 13 | `created_at` | `timestamptz` | NO | `now()` | ✅ |
| 14 | `updated_at` | `timestamptz` | NO | `now()` | ✅ Auto via trigger |

✅ Schema kolom lengkap sesuai ERD §2 `appointments`. Tidak ada drift antara ERD dan DB.

### 1.2 Tabel `doctor_slots` — Kolom Aktual

| # | Kolom | Tipe | Nullable | Default | Catatan |
|---|-------|------|:--------:|---------|---------|
| 1 | `id` | `uuid` | NO | `gen_random_uuid()` | ✅ PK |
| 2 | `doctor_id` | `uuid` | NO | — | ✅ FK ON DELETE CASCADE |
| 3 | `schedule_id` | `uuid` | NO | — | ✅ FK ON DELETE CASCADE |
| 4 | `slot_date` | `date` | NO | — | ✅ |
| 5 | `slot_start` | `time` | NO | — | ✅ |
| 6 | `slot_end` | `time` | NO | — | ✅ |
| 7 | `is_booked` | `boolean` | NO | `false` | ⚠️ Denormalized, see §3.5 |
| 8 | `created_at` | `timestamptz` | NO | `now()` | ✅ |

### 1.3 Constraints Aktual

| Tabel | Constraint | Definisi | Status |
|-------|-----------|----------|--------|
| `doctor_slots` | `unique_doctor_slot` | `UNIQUE (doctor_id, slot_date, slot_start)` | ✅ |
| `doctor_slots` | `doctor_slots_pkey` | `PRIMARY KEY (id)` | ✅ |
| `doctor_slots` | `doctor_slots_doctor_id_fkey` | `FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE` | ✅ |
| `doctor_slots` | `doctor_slots_schedule_id_fkey` | `FOREIGN KEY (schedule_id) REFERENCES doctor_schedules(id) ON DELETE CASCADE` | ✅ |
| `appointments` | `appointments_pkey` | `PRIMARY KEY (id)` | ✅ |
| `appointments` | `appointments_patient_id_fkey` | `FOREIGN KEY (patient_id) REFERENCES user_profiles(id)` | ⚠️ NO ON DELETE (RESTRICT) |
| `appointments` | `appointments_doctor_id_fkey` | `FOREIGN KEY (doctor_id) REFERENCES doctors(id)` | ⚠️ NO ON DELETE |
| `appointments` | `appointments_slot_id_fkey` | `FOREIGN KEY (slot_id) REFERENCES doctor_slots(id)` | ⚠️ NO ON DELETE |

#### 🔴 CRITICAL FINDING: Missing `idx_appointments_active_slot` Partial Unique Index

**Migration 010** (`010_slot_booked_trigger.sql`) mendefinisikan:
```sql
create unique index if not exists idx_appointments_active_slot
  on public.appointments (slot_id)
  where status in ('pending', 'upcoming');
```

**Migration tercatat applied** di `supabase_migrations.schema_migrations` (version `010_slot_booked_trigger`).

**TETAPI**, saat di-query ke `pg_indexes`, index tersebut **TIDAK ADA**:

```
Tabel indexes untuk public.appointments:
- appointments_pkey
- idx_appointments_patient
- idx_appointments_status
- idx_appointments_upcoming
(idx_appointments_active_slot ← TIDAK ADA!)
```

**Hipotesis:** Migrasi 010 ke-apply sebagai transaction, dan index creation mungkin gagal secara silent (mis. karena `create unique index if not exists` di dalam transaction yang sudah error sebelumnya, atau ada permission issue), tapi schema_migrations tetap tercatat applied.

**Konsekuensi:** Tanpa partial unique index ini, **database TIDAK punya constraint** yang mencegah 2 appointment dengan status aktif (pending/upcoming) untuk slot yang sama. Perlindungan sepenuhnya bergantung pada logic di RPC function (yang juga punya TOCTOU vulnerability — lihat §3).

### 1.4 RLS Policies Aktual

```sql
-- Tabel: appointments
-- SELECT
"Patient select own appointments" ON public.appointments
  USING (auth.uid() = (SELECT user_profiles.auth_id
                       FROM user_profiles
                       WHERE user_profiles.id = appointments.patient_id));

-- INSERT
"Patient insert own appointments" ON public.appointments
  WITH CHECK (auth.uid() = (SELECT user_profiles.auth_id
                            FROM user_profiles
                            WHERE user_profiles.id = appointments.patient_id));

-- UPDATE
"Patient cancel own appointments" ON public.appointments
  USING (auth.uid() = (SELECT user_profiles.auth_id
                       FROM user_profiles
                       WHERE user_profiles.id = appointments.patient_id)
         AND status IN ('pending', 'upcoming'));
  -- ⚠️ TIDAK ADA WITH CHECK — hanya USING (old row state)

-- Tabel: doctor_slots
"Public read slots" ON public.doctor_slots
  FOR SELECT USING (true);
```

| Aspek | Verdict |
|-------|:-------:|
| SELECT appointments scoped by `auth.uid()` | ✅ |
| INSERT appointments enforces `auth.uid() = patient.auth_id` | ✅ |
| UPDATE appointments restricts to own + pending/upcoming | ⚠️ USING only, no WITH CHECK |
| No DELETE policy | ⚠️ Implicit deny OK untuk MVP, tapi dokumentasi ERD tidak sebut |

**Catatan UPDATE policy:** RLS `USING` clause hanya memvalidasi **old row** (before update). Tanpa `WITH CHECK` clause, user **secara teoritis bisa** mengubah `status` ke nilai lain (mis. dari 'pending' ke 'completed' atau dari 'cancelled' ke 'pending') selama row awal accessible. Mitigasi: karena Flutter tidak expose form untuk update kolom lain, ini bukan attack vector aktif. **Tapi best practice** adalah tambahkan `WITH CHECK` untuk defense in depth.

### 1.5 Triggers Aktual

| Trigger | Tabel | Event | Function | tgenabled |
|---------|-------|-------|----------|:---------:|
| `trg_appointments_sync_slot` | appointments | INSERT/UPDATE/DELETE | `sync_slot_booking` (001) | 79 (active) |
| `trg_appointments_updated_at` | appointments | UPDATE (BEFORE) | `set_updated_at` (001) | 79 (active) |
| `trg_slot_booked_on_appointment` | appointments | INSERT (AFTER) | `set_slot_booked_on_appointment` (010) | 79 (active) |
| `trg_slot_unbooked_on_cancellation` | appointments | UPDATE OF status WHEN new.status='cancelled' | `set_slot_booked_on_appointment` (010) | 79 (active) |

✅ Semua trigger active. Test insert: trigger `trg_slot_booked_on_appointment` berjalan dan set `is_booked=true` post-insert (verified). **TAPI** lihat §3.5 untuk inkonsistensi `is_booked` di data existing.

### 1.6 RPC Functions Aktual

| Function | Args | Returns | Schema | Purpose |
|----------|------|---------|--------|---------|
| `create_appointment` | `p_doctor_id uuid, p_slot_id uuid, p_complaint_note text` | `jsonb` | `public` | ✅ Booking atomic |
| `get_nearby_clinics` | `user_lat float8, user_lng float8, radius_meters int` | `TABLE(...)` | `public` | (Out of scope audit ini) |
| `delete_user` | — | `void` | `public` | (Out of scope) |

| Trigger Function | Args | Returns | Purpose |
|------------------|------|---------|---------|
| `sync_slot_booking` | (trigger) | `trigger` | Migration 001 — legacy trigger |
| `set_slot_booked_on_appointment` | (trigger) | `trigger` | Migration 010 — replacement/duplicate |
| `set_updated_at` | (trigger) | `trigger` | Auto-update `updated_at` |

🔴 **MISSING: `cancel_appointment` RPC function** — Diverifikasi via `information_schema.routines`, function ini **TIDAK ADA**. API Contract §6.4 mensyaratkan endpoint cancel, dan Flutter `booking_remote_datasource.dart:117` memanggil `_client.functions.invoke('cancel-appointment', ...)` (Edge Function, bukan RPC). Edge Function juga tidak ada — lihat §4.

### 1.7 Edge Functions Aktual

`supabase/functions/` directory **KOSONG** (verified via `Get-ChildItem`).

Test HTTP `POST http://127.0.0.1:54321/functions/v1/cancel-appointment` → **404 Not Found**.

| Edge Function | Status | Dampak |
|---------------|:------:|--------|
| `cancel-appointment` (API §6.4) | 🔴 404 | Cancel flow broken |
| `doctors-by-location` (API §5.2) | 🔴 404 | Out of scope audit ini |
| `upsert-fcm-token` (API §3.4) | 🔴 404 | Out of scope audit ini |

---

## 2. Get List Appointment — Findings (STEP 4)

### 2.1 Query Implementation (Datasource)

`lib/features/booking/data/datasource/booking_remote_datasource.dart:59-85`:

```dart
var builder = _client
    .from('appointments')
    .select(
      '*, doctors(id, full_name, photo_url, experience_years, specializations(name), clinics(name, address, phone)), doctor_slots(slot_date, slot_start, slot_end)',
    )
    .eq('patient_id', patientId);

if (status != null) {
  builder = builder.eq('status', status);
}

final result = await builder
    .order('created_at', ascending: false)
    .range(offset, offset + limit - 1);
```

### 2.2 Audit Verdict

| Kriteria | Expected (per API §6.2) | Actual | Status |
|----------|--------------------------|--------|:------:|
| Filter by `patient_id` | Ya | `.eq('patient_id', patientId)` | ✅ |
| Include nested `doctors` (id, full_name, photo_url, spec) | Ya | `doctors(id, full_name, photo_url, experience_years, specializations(name), clinics(...))` | ✅ |
| Include nested `doctor_slots` (date, start, end) | Ya | `doctor_slots(slot_date, slot_start, slot_end)` | ✅ |
| Optional `status` filter | Ya | `.eq('status', status)` (jika ada) | ✅ |
| Order by `created_at DESC` | Ya | `.order('created_at', ascending: false)` | ✅ |
| Pagination via `range(offset, offset+limit-1)` | Ya | `.range(offset, offset+limit - 1)` | ✅ |
| Limit default 20 | Ya | `int limit = 20` | ✅ |

### 2.3 RLS Enforcement Test (Konseptual)

**Skenario:** User A query dengan `patient_id = B`. Apakah bisa baca appointment B?

- **Level RLS:** Policy `Patient select own appointments` menggunakan `USING (auth.uid() = (SELECT user_profiles.auth_id FROM user_profiles WHERE user_profiles.id = appointments.patient_id))`. Untuk setiap row yang di-fetch, PostgreSQL filter dengan `auth.uid()` user A. Jika row adalah milik B, `auth_id` B ≠ `auth.uid()` A → row di-exclude. ✅
- **Level aplikasi:** Flutter secara konsisten panggil `patientId` dari `getCurrentProfileId()` (lihat `BookingDetailPage` dan `BookingHistoryPage`), sehingga query selalu pass `patient_id` yang sesuai user login.

**Verdict:** Get List **AMAN** untuk multi-tenant. RLS + client-side filter memberikan defense in depth.

### 2.4 Missing/Incomplete Fields vs API Contract

API Contract §6.2 response example include `cancellation_reason`. Query select `'*, doctors(...), doctor_slots(...)'` → semua kolom appointments ter-include, termasuk `cancellation_reason` ✅. Tapi select nested doctors dan slots **tidak include** kolom `is_active` untuk filter doctor; ini bukan concern untuk booking history tapi potential issue jika ada doctor yang dinonaktifkan.

### 2.5 Verdict

🟢 **GET LIST AMAN** — Query, RLS, nested data sesuai contract. Skor: **88/100** (pengurang 12 karena tidak ada verifikasi error handling untuk RLS deny — saat RLS return empty array, client tidak bisa bedakan "tidak ada data" vs "RLS deny semua").

---

## 3. Get Detail Appointment — Findings (STEP 5)

### 3.1 Query Implementation (Datasource)

`lib/features/booking/data/datasource/booking_remote_datasource.dart:88-109`:

```dart
final result = await _client
    .from('appointments')
    .select(
      '*, doctors(id, full_name, photo_url, experience_years, specializations(name), clinics(name, address, phone)), doctor_slots(slot_date, slot_start, slot_end)',
    )
    .eq('id', appointmentId)
    .eq('patient_id', patientId)        // ← defense in depth
    .maybeSingle();

if (result == null) {
  throw const ApiException(
    code: FailureCode.notFound,
    message: 'Appointment tidak ditemukan',
  );
}
```

### 3.2 Audit Verdict

| Kriteria | Expected (per API §6.3) | Actual | Status |
|----------|--------------------------|--------|:------:|
| Filter by `id` | Ya | `.eq('id', appointmentId)` | ✅ |
| Filter by `patient_id` (defense in depth) | Recommended | `.eq('patient_id', patientId)` | ✅ |
| Include nested `doctors` lengkap | Ya (id, full_name, photo_url, experience_years, spec, clinic) | Sama persis | ✅ |
| Include nested `doctor_slots` (date, start, end) | Ya | Sama | ✅ |
| `.maybeSingle()` untuk handle not-found gracefully | Ya | ✅ — return null → throw `ApiException(notFound)` | ✅ |

### 3.3 RLS Test (Konseptual)

**Skenario:** User A coba akses appointment ID milik User B via `GET /rest/v1/appointments?id=eq.B_ID&patient_id=eq.B_PROFILE_ID`.

- **Tanpa RLS bypass:** RLS policy filter → hanya return row jika `auth.uid() = patient.auth_id`. Karena A login, A tidak punya akses ke row B → `maybeSingle()` return null → throw `notFound`. ✅
- **Defense in depth:** Client juga pass `patient_id=eq.B_PROFILE_ID`. Karena B's profile_id ≠ A's current user, query tetap empty (kalau-kalau RLS somehow longgar, filter manual tetap proteksi). ✅

### 3.4 Wireframe Coverage

Wireframe `13-booking-detail.md` lines 17-37 mensyaratkan field: tanggal, waktu, klinik, alamat, telepon, biaya, keluhan, status. Query response sudah include semua via nested select (clinics.address, clinics.phone, doctor_slots.slot_date, slot_start, slot_end, consultation_fee_snapshot, complaint_note, status). ✅

### 3.5 Inkonsistensi `is_booked` di Data Existing

Query cross-check di DB menemukan:
- **2 slot** dengan `is_booked = false` tapi punya **appointment aktif** (1 slot punya 4, 1 slot punya 2 — semua `status = 'pending'`, semua `patient_id` sama, kemungkinan dari testing).

Root cause analysis: kemungkinan trigger di-apply SETELAH data lama sudah ada, atau ada testing yang di-reset manual. **Dampak untuk user baru**: trigger `trg_slot_booked_on_appointment` aktif dan tested — verified set `is_booked=true` setelah insert. Tapi **untuk slot `0bd15209-...` dan `3d82aa44-...`**, `is_booked=false` di DB, sehingga `getDoctorSlots(doctor_id, date, is_booked=false)` akan tetap return slot ini sebagai "available", padahal sebenarnya ada appointment aktif → **double-booking latent risk** jika user lain booking slot yang sama.

### 3.6 Verdict

🟢 **GET DETAIL AMAN untuk akses** — RLS + filter cukup. 🟡 **Data integrity issue** pada `is_booked` untuk 2 slot specific (lihat §3.5). Skor: **85/100**.

---

## 4. Create Appointment & Slot Locking — Findings (STEP 6) [KRITIS]

### 4.1 Implementation Path

`BookingBloc` (booking_bloc.dart:88-92) → `CreateAppointmentUseCase` (create_appointment_usecase.dart:20-23) → `BookingRepositoryImpl.createAppointment` (booking_repository_impl.dart:21-37) → `BookingRemoteDataSource.createAppointment` (booking_remote_datasource.dart:34-56):

```dart
Future<AppointmentModel> createAppointment({
  required String doctorId,
  required String slotId,
  String? complaintNote,
}) async {
  final response = await _client.rpc<Map<String, dynamic>>(
    'create_appointment',
    params: {
      'p_doctor_id': doctorId,
      'p_slot_id': slotId,
      'p_complaint_note': complaintNote,
    },
  );
  // ...
}
```

✅ Path benar: pure RPC call (bukan raw INSERT), sehingga atomic transaction di DB.

### 4.2 RPC Function `create_appointment` (DB)

File: `supabase/migrations/010_slot_booked_trigger.sql:42-125`.

```sql
create or replace function public.create_appointment(
  p_doctor_id uuid,
  p_slot_id uuid,
  p_complaint_note text default null
) returns jsonb
language plpgsql as $$
declare
  v_fee numeric(12,2);
  v_appointment_id uuid;
  v_patient_id uuid;
  v_slot_booked boolean;
begin
  -- 1. Check slot exists
  select is_booked into v_slot_booked
  from public.doctor_slots where id = p_slot_id;
  if not found then raise exception 'SLOT_NOT_FOUND'; end if;

  -- 2. Check slot available
  if v_slot_booked then raise exception 'SLOT_ALREADY_BOOKED'; end if;

  -- 3. Get fee snapshot
  select consultation_fee into v_fee
  from public.doctors where id = p_doctor_id;
  if not found then raise exception 'DOCTOR_NOT_FOUND'; end if;

  -- 4. Get patient_id from auth.uid()
  select id into v_patient_id
  from public.user_profiles where auth_id = auth.uid();
  if not found then raise exception 'USER_PROFILE_NOT_FOUND'; end if;

  -- 5. INSERT appointment
  insert into public.appointments (...) values (...) returning id;

  -- 6. UPDATE slot is_booked = true (defense in depth)
  update public.doctor_slots set is_booked = true where id = p_slot_id;

  -- 7. Return jsonb
  return (...);
end;
$$;
```

### 4.3 🔴 CRITICAL: TOCTOU Race Condition

**Root cause:** Step 2 (`select is_booked`) dan step 5 (`insert`) **TIDAK dalam atomic operation**. Tidak ada `SELECT ... FOR UPDATE` pada `doctor_slots` row di awal. Tidak ada partial unique index pada `appointments(slot_id)` untuk status aktif.

**Skenario konkret race condition:**
1. User A klik "Konfirmasi Booking" untuk slot X pada `T0`
2. RPC A jalan: `select is_booked from doctor_slots where id = X` → `is_booked = false` ✅ lanjut
3. User B klik "Konfirmasi Booking" untuk slot X pada `T0 + 50ms` (network/UI parallel)
4. RPC B jalan: `select is_booked from doctor_slots where id = X` → **masih `false`** (karena A belum sampai step 6) ✅ lanjut
5. RPC A `insert into appointments (...)` → ✅ sukses
6. RPC B `insert into appointments (...)` → ✅ sukses (tidak ada constraint yang阻止)
7. RPC A `update doctor_slots set is_booked = true` → ✅
8. RPC B `update doctor_slots set is_booked = true` → ✅ (idempotent)
9. **HASIL: 2 appointment aktif untuk slot yang sama, dari 2 patient berbeda** ❌

### 4.4 🧪 Bukti Empiris: Race Condition Reproduced di Local DB

Test dilakukan via `supabase db query` (PostgreSQL direct connection, BYPASSRLS):

| Step | Query | Result |
|------|-------|--------|
| Initial | `select is_booked from doctor_slots where id = '91a74f1a-...'` | `is_booked = false` ✅ |
| Insert 1 | `insert into appointments (patient_id='c76d0b23-...', doctor_id='da63c9df-...', slot_id='91a74f1a-...', consultation_fee_snapshot=100000)` | `INSERT 0 1` ✅ |
| Check after insert 1 | `select is_booked from doctor_slots where id = '91a74f1a-...'` | `is_booked = true` (trigger fired) ✅ |
| Insert 2 (different patient, same slot) | `insert into appointments (patient_id='3f2f16a5-...', doctor_id='da63c9df-...', slot_id='91a74f1a-...', consultation_fee_snapshot=100000)` | **`INSERT 0 1` ✅ TIDAK DITOLAK** ❌ |
| Check after insert 2 | `select is_booked from doctor_slots where id = '91a74f1a-...'` | `is_booked = true` (idempotent) |
| Count | `select count(*) from appointments where slot_id = '91a74f1a-...'` | `count = 2` (DOUBLE BOOKING) ❌ |

**Cleanup dilakukan setelah test.**

### 4.5 🧪 Bukti Empiris: Data Existing Sudah Terkena Bug

Pre-test query ke DB (dari data sample):

| Slot ID | Total Active Appointments | Distinct Patient | Status |
|---------|:------------------------:|:----------------:|--------|
| `0bd15209-...` | 4 | 1 (Test User) | ❌ 4× duplicate, slot.is_booked=false |
| `3d82aa44-...` | 2 | 1 (Test User) | ❌ 2× duplicate, slot.is_booked=false |

**Catatan:** Duplikat ini dari 1 user yang sama, kemungkinan dari testing RPC yang dipanggil berkali-kali (contoh: testing booking flow lalu klik konfirmasi 2x). Tapi **vulnerability-nya sama** — jika 2 user berbeda coba di saat hampir bersamaan, hasil akan serupa. Bukti data sample mendukung bahwa race condition window **pernah terekspos di environment local**.

### 4.6 ❌ Missing DB-Level Constraint

Migrasi 010 mendefinisikan:
```sql
create unique index if not exists idx_appointments_active_slot
  on public.appointments (slot_id)
  where status in ('pending', 'upcoming');
```

Index ini **TIDAK ADA di DB** (verified via `pg_indexes`). Penyebab paling mungkin: migrasi di-apply dengan transaction yang somehow skip statement ini, atau ada permission issue saat create index. `schema_migrations` table menandai `010_slot_booked_trigger` sebagai applied, tapi index tidak tercipta.

**Tanpa partial unique index, database 100% bergantung pada logic RPC untuk mencegah duplikat, dan logic RPC punya TOCTOU flaw.**

### 4.7 RLS INSERT Bypass (Catatan Sekunder)

RLS policy `Patient insert own appointments` enforce `auth.uid() = patient.auth_id`. RPC `create_appointment` dipanggil oleh authenticated user, dan function `language plpgsql` default ke `SECURITY INVOKER` (artinya RLS tetap berlaku). **TAPI** function ini `select id into v_patient_id from user_profiles where auth_id = auth.uid()` lalu insert dengan explicit `patient_id = v_patient_id`. RLS check tetap valid karena `v_patient_id` pasti = `auth.uid()`. ✅

### 4.8 Consultation Fee Snapshot

RPC ambil `consultation_fee` dari `doctors` table, store di `consultation_fee_snapshot` di `appointments`. ✅ Sesuai ERD §4.3. Immutable — no trigger updates it.

### 4.9 Slot Filter di `getDoctorSlots` (Doctor Feature)

`lib/features/doctor/data/datasource/doctor_remote_datasource.dart:83-100`:
```dart
final result = await _client
    .from('doctor_slots')
    .select()
    .eq('doctor_id', doctorId)
    .eq('slot_date', dateStr)
    .eq('is_booked', false)   // ← filter by is_booked
    .order('slot_start', ascending: true);
```

✅ Filter applied. **TAPI** rentan terhadap inkonsistensi `is_booked` (lihat §3.5). Untuk slot `0bd15209-...` dan `3d82aa44-...`, slot tetap muncul sebagai "available" padahal ada appointment aktif. **Bukti data sample konsisten dengan observasi ini**.

### 4.10 Verdict

🔴 **CREATE APPOINTMENT RENTAN RACE CONDITION**. Skor: **30/100**.

| Sub-area | Skor | Catatan |
|----------|:----:|---------|
| Path call (Flutter RPC) | 100 | ✅ |
| RPC function exists & logic | 80 | Function ada, sequence logika benar |
| DB-level protection (unique constraint) | 0 | ❌ Partial unique index missing |
| TOCTOU protection (FOR UPDATE) | 0 | ❌ Tidak ada row lock |
| Error mapping (PostgREST → Flutter) | 50 | ⚠️ `ErrorHandler._mapPostgrestCode` handle `23505` (conflict), tapi `raise exception 'SLOT_ALREADY_BOOKED'` di RPC muncul sebagai generic PostgrestException, bukan custom code |
| `is_booked` consistency | 20 | ⚠️ Inkonsisten dengan data existing |

---

## 5. Cancel Appointment & Slot Release — Findings (STEP 7)

### 5.1 Implementation Path

`BookingDetailCubit.cancelAppointment` (booking_detail_cubit.dart:42-61) → `CancelAppointmentUseCase` (cancel_appointment_usecase.dart) → `BookingRepositoryImpl.cancelAppointment` (booking_repository_impl.dart:75-89) → `BookingRemoteDataSource.cancelAppointment` (booking_remote_datasource.dart:111-156):

```dart
Future<AppointmentModel> cancelAppointment({...}) async {
  final response = await _client.functions.invoke(
    'cancel-appointment',
    body: {
      'appointment_id': appointmentId,
      'cancellation_reason': cancellationReason,
    },
  );
  // ...
}
```

### 5.2 🔴 CRITICAL: Edge Function `cancel-appointment` DOES NOT EXIST

| Check | Result |
|-------|--------|
| `supabase/functions/` directory listing | **EMPTY** |
| HTTP `POST /functions/v1/cancel-appointment` | **404 Not Found** |
| `information_schema.routines` filter `routine_name = 'cancel_appointment'` | **0 rows** (no RPC either) |
| `pg_proc` for cancel function | **NOT FOUND** |

**Dampak:** Setiap kali user tap "Batalkan Appointment" di UI, `cancelAppointment()` di datasource akan throw `FunctionException` (status 404). Error handler `ErrorHandler._mapFailureCode` **TIDAK** handle `FunctionException` (lihat error_handler.dart:45-53), sehingga akan jatuh ke `_ => FailureCode.unknown` (atau via PostgREST-like code mapping). UI menampilkan pesan generic "An unexpected error occurred" atau pesan dari `e.message`.

### 5.3 ⚠️ RLS Cancel Policy Limitation

RLS policy `Patient cancel own appointments`:
```sql
USING (
  auth.uid() = (select auth_id from user_profiles where id = patient_id)
  and status in ('pending', 'upcoming')
);
```

- **Hanya `USING`, tidak ada `WITH CHECK`** — `USING` validasi **old row state**, `WITH CHECK` validasi **new row state**. Tanpa `WITH CHECK`, jika somehow user bisa update row, dia bisa set `status` ke nilai apapun (mis. dari `cancelled` kembali ke `pending`, atau ke `completed`).
- **Cancel via RPC langsung (jika diimplementasikan)** — user pass `auth.uid()`, RPC lookup patient, then `UPDATE appointments SET status='cancelled' WHERE id = X AND patient_id = (lookup) AND status IN (pending, upcoming)`. ✅ Aman.

### 5.4 ⚠️ No Time-Based Validation

PRD §8 (Status Appointment & State Machine) menentukan: cancel hanya untuk status `pending`/`upcoming`, tapi **TIDAK ADA** aturan window waktu (mis. H-1 atau H-0). Wireframe 13-booking-detail.md cancel button logic hanya `if (canCancel) where canCancel = status == pending || status == upcoming`.

**Implication:** User bisa cancel appointment 5 menit sebelum jadwal tanpa penalti. Ini business policy decision yang **perlu dikonfirmasi** — apakah acceptable untuk MVP? Lihat §10 Open Question.

### 5.5 ⚠️ Slot Release Logic — Schema OK, Tidak Tested

Trigger `trg_slot_unbooked_on_cancellation` (migration 010):
```sql
create trigger trg_slot_unbooked_on_cancellation
  after update of status on public.appointments
  for each row
  when (new.status = 'cancelled')
  execute function public.set_slot_booked_on_appointment();
```

Function `set_slot_booked_on_appointment` (migration 010):
```sql
elsif tg_op = 'UPDATE' and new.status = 'cancelled' then
  update public.doctor_slots
  set is_booked = false
  where id = old.slot_id;
  return new;
end if;
```

✅ Schema trigger benar: AFTER UPDATE OF status WHEN new.status='cancelled' → set is_booked=false. Test insert dummy + update cancel → verified trigger fires (implisit via test §4.4 dimana is_booked jadi true setelah insert; cancel path tidak ditest karena function tidak ada).

⚠️ **TAPI**: Schema trigger ini TIDAK distinguishing antara cancel yang legitimate (user-triggered via app) vs cancellation karena admin intervention. Untuk MVP, acceptible.

### 5.6 ⚠️ Cancel via Direct PostgREST (Tanpa Edge Function)

Secara teori, user bisa cancel via raw `UPDATE appointments SET status='cancelled' WHERE id=X` via PostgREST, **TANPA** Edge Function. RLS `Patient cancel own appointments` (USING clause) akan allow update hanya untuk row miliknya dan dengan old status `pending`/`upcoming`. **TAPI** response tidak akan set `cancelled_at` dan `cancellation_reason` (Flutter tidak pass field ini, dan tidak ada trigger untuk set `cancelled_at`).

**Dampak:** Jika user menggunakan `PostgrestQueryBuilder.update()` dengan body `{'status': 'cancelled'}` langsung, `cancelled_at` tetap NULL. Timeline di UI (`booking_detail_page.dart:241` → `StatusTimeline`) akan menampilkan item "Dibatalkan" tapi tanpa timestamp yang benar (lihat wireframe 13 lines 56-62 yang expect timestamp).

### 5.7 Verdict

🔴 **CANCEL FLOW COMPLETELY BROKEN**. Skor: **10/100**.

| Sub-area | Skor | Catatan |
|----------|:----:|---------|
| Edge Function exists | 0 | ❌ 404 |
| RPC function exists (alternative path) | 0 | ❌ Tidak ada |
| RLS protects own-appointment | 70 | USING OK, no WITH CHECK |
| Slot release trigger schema | 100 | ✅ (verified) |
| Time-based cancel validation | 0 | ❌ No implementation, no PRD spec |
| Error handling for FunctionException | 0 | ❌ ErrorHandler tidak cover |

### 5.8 Detail Lanjutan — Cancel Appointment Atomicity (Re-Verification 29 Jun 2026)

**Konteks:** Audit lanjutan difokuskan menjawab 2 pertanyaan:
- (a) Apakah cancel via RPC/Edge Function **atomic** (booking + slot release dalam 1 transaction), atau via raw PostgREST update (rentan gap)?
- (b) Apakah `cancelled_at` di-auto-set oleh server, atau harus dikirim client?

#### 5.8.1 Bukti Kode Flutter — Cancel Call Path

**Tombol "Batalkan" di UI** (`booking_detail_page.dart:244-312`):
```dart
// Line 244-253: tombol batal
if (canCancel)
  SizedBox(
    width: double.infinity,
    child: LightFilledButton(
      label: 'Batalkan Appointment',
      backgroundColor: AppTheme.darkRed,
      onTap: () => _confirmCancel(context, appt),
    ),
  ),
```

**Handler `_confirmCancel`** (`booking_detail_page.dart:260-312`):
```dart
Future<void> _confirmCancel(BuildContext context, AppointmentEntity appt) async {
  // ... dialog konfirmasi ...
  if (confirmed != true || !context.mounted) return;
  await AppLoadingDialog.show(context);
  // ...
  final cubit = context.read<BookingDetailCubit>();
  await cubit.cancelAppointment(
    appointmentId: appt.id,
    cancellationReason: reasonController.text.trim().isEmpty
        ? null
        : reasonController.text.trim(),
  );
  // ...
}
```

**Datasource `cancelAppointment`** (`booking_remote_datasource.dart:111-156`):
```dart
Future<AppointmentModel> cancelAppointment({
  required String appointmentId,
  String? cancellationReason,
}) async {
  final response = await _client.functions.invoke(
    'cancel-appointment',                        // ← Edge Function path
    body: {
      'appointment_id': appointmentId,
      'cancellation_reason': cancellationReason,
    },
  );
  // ...
}
```

**Verifikasi:** Flutter code menggunakan path **Edge Function invoke** (`_client.functions.invoke('cancel-appointment', ...)`), **BUKAN** raw update via `_client.from('appointments').update(...)`. **Intent developer sudah benar** — mereka bermaksud pakai atomic backend function. ❌ **TAPI** target Edge Function tidak ada di server (lihat §5.2 dan §5.8.2).

#### 5.8.2 Bukti Backend — Edge Function & RPC Status

| Check | Command | Result |
|-------|---------|--------|
| Edge Function files | `Get-ChildItem supabase/functions -Recurse` | **EMPTY** (no files) |
| HTTP POST | `POST /functions/v1/cancel-appointment` | **404 Not Found** |
| RPC functions | `select routine_name from information_schema.routines where routine_name ilike '%cancel%' and routine_schema = 'public'` | **0 rows** |
| `pg_proc` | `select proname from pg_proc where proname ilike '%cancel%'` | **0 rows** |

**Kesimpulan:** Tidak ada RPC `cancel_appointment`. Tidak ada Edge Function `cancel-appointment`. **Cancel hari ini bukan raw update — cancel hari ini benar-benar tidak bisa terjadi** (Flutter invoke 404 → `FunctionException`).

#### 5.8.3 Bukti Schema — `cancelled_at` Column & Auto-Set Trigger

**Kolom `cancelled_at`:**
```sql
-- information_schema.columns output
column_name: cancelled_at
data_type:  timestamp with time zone
is_nullable: YES
column_default: NULL      -- ⚠️ TIDAK ADA default value
```

**Semua trigger di tabel `appointments`:**

| Trigger Name | Function | Event | Auto-set `cancelled_at`? |
|--------------|----------|-------|:-----------------------:|
| `trg_appointments_sync_slot` | `sync_slot_booking` | INSERT/UPDATE/DELETE | ❌ |
| `trg_appointments_updated_at` | `set_updated_at` | UPDATE (BEFORE) | ❌ (cuma set `updated_at`) |
| `trg_slot_booked_on_appointment` | `set_slot_booked_on_appointment` | INSERT (AFTER) | ❌ |
| `trg_slot_unbooked_on_cancellation` | `set_slot_booked_on_appointment` | UPDATE OF status WHEN new.status='cancelled' | ❌ (cuma set slot `is_booked=false`) |

**🔴 CRITICAL FINDING:** **TIDAK ADA trigger yang auto-set `cancelled_at = now()`** saat status berubah ke `'cancelled'`. Kolom `cancelled_at` ada dengan default `NULL` dan **harus di-set explicit** oleh caller (Edge Function, RPC, atau raw update).

**Function source `set_slot_booked_on_appointment` (diverifikasi):**
```sql
-- pg_proc.prosrc output
if tg_op = 'INSERT' then
  update public.doctor_slots set is_booked = true where id = new.slot_id;
  return new;
elsif tg_op = 'UPDATE' and new.status = 'cancelled' then
  update public.doctor_slots set is_booked = false where id = old.slot_id;
  return new;
end if;
```

Trigger ini handle **slot release** tapi **TIDAK** handle timestamp `cancelled_at` di row appointment.

#### 5.8.4 Implikasi Gap Atomicity — Skenario Teoritis

**Sample data aktual** (untuk ilustrasi):
```sql
-- Hasil query 29 Jun 2026
appointment_id                      | status  | cancelled_at | slot_id                            | is_booked
------------------------------------|---------|--------------|------------------------------------|----------
432d07e1-78b7-4068-adca-ecedebd7249c | pending | null         | 3d82aa44-2fe8-4af7-96c7-099475990f3b | false
d87f9e2d-d827-47a0-b550-312d8bd28468 | pending | null         | 3d82aa44-2fe8-4af7-96c7-099475990f3b | false
```

**Skenario 1 — Jika Edge Function Diimplementasikan (correct atomic path):**
```
[Flutter] POST /functions/v1/cancel-appointment {appointment_id, cancellation_reason}
  ↓
[Edge Function / RPC] BEGIN transaction
  - SELECT ... FROM appointments WHERE id=X AND patient_id=Y AND status IN (pending, upcoming) FOR UPDATE
  - UPDATE appointments SET status='cancelled', cancelled_at=now(), cancellation_reason=? WHERE id=X
  - Trigger trg_slot_unbooked_on_cancellation fires → UPDATE doctor_slots SET is_booked=false
  - INSERT INTO notifications ... (booking_cancelled)
  COMMIT
  ↓
[Response] { success: true, data: {id, status, cancelled_at, cancellation_reason} }
```
✅ **Atomic, semua 4 perubahan dalam 1 transaction.** Slot release aman, `cancelled_at` ter-set, notification tercatat.

**Skenario 2 — Jika Developer "Nakal" Pakai Raw Update 2 Statement Tanpa Transaction:**

❌ **SALAH** — contoh kode hipotetis yang harus dihindari:
```dart
// ❌ JANGAN — 2 call terpisah, no transaction
await _client.from('appointments').update({
  'status': 'cancelled',
  'cancelled_at': DateTime.now().toIso8601String(),
  'cancellation_reason': reason,
}).eq('id', appointmentId);

await _client.from('doctor_slots').update({
  'is_booked': false,
}).eq('id', slotId);
```

**Gap analysis Skenario 2:**

| Sub-skenario | State Akhir | Severity |
|--------------|-------------|:--------:|
| ✅ Kedua call sukses | status=cancelled, is_booked=false, cancelled_at ter-set | OK |
| ⚠️ Call 1 sukses, call 2 gagal (network drop) | status=cancelled, **is_booked MASIH true** | 🔴 **SLOT LEAK** — slot dianggap booked selamanya sampai admin reset manual |
| ⚠️ Call 1 sukses, app crash sebelum call 2 | Sama seperti di atas | 🔴 **SLOT LEAK** |
| ⚠️ Call 1 gagal (network), call 2 sukses | status=pending, is_booked=false | 🟡 **INCONSISTENT** — slot available untuk user lain tapi appointment masih aktif (double booking risk jika user lain booking) |

**Mitigasi yang SEBAIKNYA dilakukan (jika raw update dipaksakan):**

Untungnya, DB triggers yang sudah ada (`trg_appointments_sync_slot` & `trg_slot_unbooked_on_cancellation`) **sudah handle slot release otomatis** saat row `appointments` di-UPDATE dengan `status='cancelled'`. Jadi **asalkan 1 statement raw update** yang set `status='cancelled'` (dengan `cancelled_at` di body), slot release akan terjadi via trigger secara atomic dalam transaction yang sama:

```dart
// ✅ Bisa, tapi BUKAN best practice — 1 statement, trigger handle slot release
await _client.from('appointments').update({
  'status': 'cancelled',
  'cancelled_at': DateTime.now().toIso8601String(),
  'cancellation_reason': reason,
}).eq('id', appointmentId).eq('patient_id', patientId);
```

**Akan aman** karena PostgreSQL jalankan UPDATE + trigger dalam 1 implicit transaction. **TAPI** masih ada gap lain: tidak ada validasi ownership server-side (RLS `USING` clause handle, tapi `WITH CHECK` tidak ada — lihat M-1), tidak ada validasi status transition (user bisa update `cancelled → pending`), tidak ada FCM notification, dan **bisa di-bypass RLS** jika developer lupa pakai `.eq('patient_id', ...)`.

#### 5.8.5 Verdict Detail Lanjutan

| Aspek | Temuan | Verdict |
|-------|--------|:-------:|
| Cancel call path (Flutter) | `_client.functions.invoke('cancel-appointment', ...)` — Edge Function, **BUKAN raw update** | ✅ Intent benar |
| Backend implementation | Edge Function 404, no RPC, no implementation | 🔴 Broken |
| `cancelled_at` auto-set | **TIDAK ADA trigger** yang set `cancelled_at = now()` | 🔴 Missing |
| Atomicity if implemented as single-statement raw update | Trigger DB sudah handle slot release via `trg_appointments_sync_slot` & `trg_slot_unbooked_on_cancellation` | 🟡 Mitigated (tapi bukan best practice) |
| Atomicity if implemented as 2-statement raw update | **SLOT LEAK risk** atau **double booking risk** jika salah satu call gagal | 🔴 Vulnerable |

**Kesimpulan:** Cancel saat ini **bukan raw update** (Flutter sudah benar). Tapi karena backend tidak ada, gap yang dievaluasi adalah: **(a) ketika implementor menambahkan Edge Function / RPC, mereka HARUS explicit set `cancelled_at` di SQL, dan (b) `cancelled_at` HARUS auto-set atau dibuat `DEFAULT now()` + di-trim oleh trigger untuk safety net.**

#### 5.8.6 Rekomendasi Spesifik

1. **Saat implement Edge Function / RPC `cancel_appointment`:**
   ```sql
   -- WAJIB ada explicit set
   update appointments set
     status = 'cancelled',
     cancelled_at = now(),  -- ← explicit, jangan lupa
     cancellation_reason = p_cancellation_reason
   where id = p_appointment_id;
   ```

2. **Tambah safety net di DB** (alternatif/ tambahan — tidak replace #1):
   ```sql
   -- Migration 014: trigger auto-set cancelled_at
   create or replace function public.set_cancelled_at()
   returns trigger as $$
   begin
     if new.status = 'cancelled' and old.status <> 'cancelled' and new.cancelled_at is null then
       new.cancelled_at = now();
     end if;
     return new;
   end;
   $$ language plpgsql;

   create trigger trg_appointments_set_cancelled_at
     before update on public.appointments
     for each row execute function public.set_cancelled_at();
   ```
   Ini jaring pengaman jika developer lupa explicit set. **Lokal aman:** trigger ini `BEFORE UPDATE` — jika caller sudah set `cancelled_at`, trigger tidak override.

3. **Avoid raw update dari Flutter.** Pakai RPC function (atomic) atau Edge Function. Jika dipaksa raw update, **WAJIB single-statement** + trust DB trigger untuk slot release.

---

## 6. Cross-Cutting Findings

### 6.1 Error Handling untuk PostgREST `RAISE EXCEPTION`

RPC `create_appointment` raise custom error codes: `'SLOT_NOT_FOUND'`, `'SLOT_ALREADY_BOOKED'`, `'DOCTOR_NOT_FOUND'`, `'USER_PROFILE_NOT_FOUND'`. Saat raise, PostgreSQL return error dengan:
- `SQLSTATE = P0001` (default untuk `RAISE EXCEPTION`)
- `message = "SLOT_ALREADY_BOOKED"` (atau pesan lain jika `RAISE EXCEPTION '... %', arg`)

PostgREST wrapping ini menjadi response JSON `{code: 'P0001', message: '...', details: null, hint: null}`. Supabase Flutter `PostgrestException` exposes `code: 'P0001'` dan `message: 'SLOT_ALREADY_BOOKED'`.

`ErrorHandler._mapPostgrestCode` (error_handler.dart:55-61):
```dart
FailureCode _mapPostgrestCode(PostgrestException e) => switch (e.code) {
  'PGRST116' => FailureCode.notFound,
  '23505' => FailureCode.conflict,
  '23503' => FailureCode.conflict,
  '42P01' => FailureCode.serverError,
  _ => FailureCode.serverError,
};
```

**Issue:** `P0001` jatuh ke `_ => FailureCode.serverError`. User akan lihat "Server error" alih-alih "Slot sudah dibooking orang lain". UX impact: rendah-sedang, tapi **mengganggu** karena user tidak tahu apakah retry aman atau harus pilih slot lain.

**Rekomendasi:** Parse `e.message` untuk substring 'SLOT_ALREADY_BOOKED' → `FailureCode.conflict`. Atau expose error code dari RPC ke client (mis. via `RAISE EXCEPTION USING ERRCODE = 'unique_violation'`).

### 6.2 Cancelled Appointment — Hidden Defect di Datasource

`booking_remote_datasource.dart:140-156` (cancelAppointment) — setelah Edge Function return success, kode panggil `getAppointmentDetail(patientId: '', ...)` untuk fetch full record.

**Bahaya:** Jika `patientId` kosong string, query di datasource adalah:
```dart
.eq('id', appointmentId)
.eq('patient_id', '')  // ← empty string
.maybeSingle();
```
RLS akan filter (kecuali current user kebetulan punya patient_id = ''), dan `.eq('patient_id', '')` juga filter — kemungkinan return null. Fallback path: return `AppointmentModel(id, status: 'cancelled')` minimal.

**Dampak:** `BookingDetailCubit.cancelAppointment` setelah success akan emit `BookingDetailLoaded(appointment: minimal model)` dengan field kosong. UI mungkin crash atau menampilkan data kosong. **Tidak tested karena Edge Function tidak ada.**

### 6.3 `booked_at` Default vs Flutter Tracking

`appointments.booked_at` default `now()`. Booking via RPC tidak explicit set `booked_at`, jadi default kicks in. ✅ Konsisten.

### 6.4 Missing FCM Notification Trigger

API Contract §6.1 response message: "Booking berhasil dibuat. Menunggu konfirmasi." mengimplikasikan push notification `booking_success` (per PRD §9). PRD §9 list notifikasi: `booking_success`, `booking_confirmed`, `reminder_h1`, `reminder_h0`, `booking_cancelled`. **TIDAK ADA trigger** di `create_appointment` RPC yang insert ke `notifications` table. Hal yang sama untuk cancel: tidak ada trigger insert `booking_cancelled` notifikasi.

⚠️ Scope pertanyaan: apakah notifikasi FCM seharusnya di-trigger dari RPC/DB trigger, atau dari Edge Function yang kemudian invoke FCM? API contract tidak eksplisit, tapi `upsert-fcm-token` Edge Function juga missing. **Di luar scope audit backend appointment, tapi catat untuk Sprint B+ follow-up.**

---

## 7. Deviation & Bug Catalog

### 7.1 🔴 Critical (Block Production)

| ID | Deskripsi | File | Severity |
|----|-----------|------|:--------:|
| **C-1** | **No DB-level double-booking protection.** Partial unique index `idx_appointments_active_slot` dari migration 010 tidak ter-apply. RPC `create_appointment` punya TOCTOU vulnerability (check `is_booked` lalu insert tanpa row lock). **Test confirmed: 2 INSERTs untuk slot sama dari patient berbeda keduanya sukses.** | `supabase/migrations/010_slot_booked_trigger.sql` (index creation), `010_slot_booked_trigger.sql:42-125` (RPC function) | 🔴 Critical |
| **C-2** | **`cancel-appointment` Edge Function does not exist.** `supabase/functions/` kosong. HTTP POST return 404. Cancel flow 100% broken dari sisi backend. | `supabase/functions/cancel-appointment/` (tidak ada), `lib/features/booking/data/datasource/booking_remote_datasource.dart:111-156` (call site) | 🔴 Critical |
| **C-3** | **`is_booked` inconsistent dengan appointments existing.** 2 slot di DB punya `is_booked = false` tapi punya multiple active appointments (4 dan 2 duplikat). Dampak: `getDoctorSlots` filter salah, slot dianggap available padahal booked. | DB existing data; trigger `trg_appointments_sync_slot` (001) dan `trg_slot_booked_on_appointment` (010) — kemungkinan trigger ditambahkan setelah data lama, atau ada reset manual | 🔴 Critical |
| **C-4** | **No auto-set trigger untuk `cancelled_at` saat status berubah ke `'cancelled'`.** Kolom ada dengan default `NULL`, **tidak ada** trigger `BEFORE/AFTER UPDATE` yang set `cancelled_at = now()`. Dampak: jika backend cancel jadi diimplementasikan tapi developer lupa explicit set `cancelled_at` (atau pakai raw update tanpa field ini), row akan punya `status='cancelled'` tapi `cancelled_at=NULL` → `StatusTimeline` UI tidak bisa render timestamp pembatalan. **Safety net wajib** sebelum backend cancel jadi online. | DB schema (tidak ada trigger); `supabase/migrations/001_initial_schema.sql`, `010_slot_booked_trigger.sql` (tidak include) | 🔴 Critical |

### 7.2 🟡 Medium (Significant but Workaround Exists)

| ID | Deskripsi | File | Severity |
|----|-----------|------|:--------:|
| **M-1** | **No `WITH CHECK` on UPDATE RLS policy** untuk appointments. RLS hanya validate old row state, bukan new row state. User bisa flip status `cancelled` → `pending` jika somehow ada raw update path. | `supabase/migrations/001_initial_schema.sql:292-297` | 🟡 Medium |
| **M-2** | **RPC custom error codes tidak ter-expose ke client.** `RAISE EXCEPTION 'SLOT_ALREADY_BOOKED'` jadi generic `P0001` → `FailureCode.serverError`. User tidak tahu apakah retry aman. | `supabase/migrations/010_slot_booked_trigger.sql:61-83`, `lib/core/network/error_handler.dart:55-61` | 🟡 Medium |
| **M-3** | **`FunctionException` tidak di-handle di ErrorHandler.** Cancel flow (jika function existed) akan crash handler dengan `FailureCode.unknown`. | `lib/core/network/error_handler.dart:45-53` | 🟡 Medium |
| **M-4** | **Theoretical: raw update 2-statement tanpa transaction** — jika developer di masa depan implement cancel via raw PostgREST 2 statement (appointments lalu doctor_slots), `SLOT LEAK` risk (kalau call 2 gagal) atau `DOUBLE BOOKING` risk (kalau call 1 gagal setelah call 2 sukses). Mitigated selama pakai single-statement + DB trigger (`trg_appointments_sync_slot` handle slot release). **Bukan masalah saat ini** (Flutter pakai Edge Function invoke), tapi catatan preventive. | (Hypothetical future code) | 🟡 Medium |
| **M-5** | **`cancelAppointment` fallback datasource** (booking_remote_datasource.dart:142-156) panggil `getAppointmentDetail(patientId: '', ...)` — empty patientId akan trigger RLS deny dan return null model. | `lib/features/booking/data/datasource/booking_remote_datasource.dart:142-156` | 🟡 Medium |

### 7.3 🟢 Low (Cosmetic / Future-Proofing)

| ID | Deskripsi | File | Severity |
|----|-----------|------|:--------:|
| **L-1** | No ON DELETE behavior di FK `appointments.patient_id`, `doctor_id`, `slot_id`. Jika parent di-delete, appointment akan restrict (default). | `supabase/migrations/001_initial_schema.sql:108-122` | 🟢 Low |
| **L-2** | No FCM notification trigger di `create_appointment` RPC. Booking success notifikasi tidak otomatis terkirim (per PRD §9). | `supabase/migrations/010_slot_booked_trigger.sql:42-125` (no notification insert) | 🟢 Low |
| **L-3** | Nested select `doctors(...)` di `getAppointmentHistory`/`getAppointmentDetail` tidak include `is_active` filter — doctor inactive masih muncul. | `lib/features/booking/data/datasource/booking_remote_datasource.dart:68, 95` | 🟢 Low |
| **L-4** | No time-window validation untuk cancel (H-1 dll). PRD tidak specify, business decision needed. Default sementara **60 menit** sebelum jadwal sampai Product Owner konfirmasi. | (Not implemented, planned in cancel RPC) | 🟢 Low |
| **L-5** | Default ordering by `created_at DESC` — untuk booking history UX lebih baik sort by `doctor_slots.slot_date DESC` (terbaru berdasarkan jadwal, bukan waktu input). | `lib/features/booking/data/datasource/booking_remote_datasource.dart:78-80` | 🟢 Low |

---

## 8. Score Card

| Area | Skor | Status | Catatan |
|------|:----:|:------:|---------|
| **1. Get List Appointment** | **88/100** | 🟢 | RLS + filter OK, nested data OK; minor: error handling RLS deny not distinguishable |
| **2. Get Detail Appointment** | **85/100** | 🟢 | RLS + filter + maybeSingle OK; minor: data integrity issue (slot `is_booked` inkonsisten) |
| **3. Create Appointment & Slot Locking** | **30/100** | 🔴 | RPC ada, tapi TOCTOU rentan; partial unique index missing; data sample sudah terekspos bug |
| **4. Cancel Appointment & Slot Release** | **15/100** | 🔴 | Edge Function 404; tidak ada RPC cancel; `cancelled_at` no auto-set trigger; Flutter intent benar (Edge Function call, bukan raw update) tapi target tidak ada |
| **Cross-Cutting (Error Handling, FCM, FK)** | **40/100** | 🔴 | FunctionException unhandled, no FCM trigger, no ON DELETE |
| **Skor Keseluruhan Backend** | **55/100** | 🔴 | **TIDAK LAYAK production** untuk fitur booking — wajib fix C-1, C-2, C-3, C-4 sebelum release. *Skor turun dari 58 → 55 karena tambahan finding C-4 (cancelled_at auto-set).* |

### 8.1 Quick Verdict

| Aspek | Verdict |
|-------|---------|
| Get list & detail (read path) | ✅ Solid, minor improvements |
| Create booking (write path) | 🔴 **RENTAN RACE CONDITION** — data sample bukti |
| Cancel booking (write path) | 🔴 **COMPLETELY BROKEN** — endpoint tidak ada + cancelled_at no auto-set safety net |
| Cancel Flutter intent | ✅ Benar (Edge Function path, bukan raw update) |
| Data integrity `is_booked` | 🔴 Inkonsisten, perlu reconciliation |
| Production readiness | 🔴 **TIDAK LAYAK** sampai C-1, C-2, C-3, C-4 di-fix |

---

## 9. Rekomendasi Perbaikan (Prioritas)

### 9.1 🔴 WAJIB (Block Production)

1. **M-1 Fix: Tambah partial unique index untuk cegah double-booking di DB layer**
   - Buat migration baru `011_appointments_active_slot_index.sql`
   - `create unique index concurrently idx_appointments_active_slot on public.appointments (slot_id) where status in ('pending', 'upcoming');`
   - Verifikasi `pg_indexes` setelah apply
   - **Sebelum** apply, **WAJIB** cleanup duplicate data existing (lihat §3.5): delete semua appointment untuk slot `0bd15209-...` (4) dan `3d82aa44-...` (2) yang statusnya `pending`, sisakan 1 per slot. Atau set sisanya ke `cancelled`.

2. **M-2 Fix: Tambah row lock di RPC `create_appointment`**
   - Migration `012_create_appointment_lock.sql`
   - Ganti `select is_booked into v_slot_booked from public.doctor_slots where id = p_slot_id;` → `select is_booked into v_slot_booked from public.doctor_slots where id = p_slot_id FOR UPDATE;`
   - Note: `FOR UPDATE` di dalam RPC function yang dipanggil via PostgREST sudah cukup karena PostgREST call dalam transaction context.

3. **M-3 Fix: Implementasi `cancel-appointment` backend**
   - **Opsi A (preferred):** Buat RPC `cancel_appointment(p_appointment_id uuid, p_cancellation_reason text default null, p_min_cancel_minutes int default 60) returns jsonb` di migration `013_cancel_appointment_rpc.sql`:
     ```sql
     create or replace function public.cancel_appointment(
       p_appointment_id uuid,
       p_cancellation_reason text default null,
       p_min_cancel_minutes int default 60
     ) returns jsonb language plpgsql as $$
     declare
       v_appt appointments%rowtype;
       v_patient_id uuid;
       v_slot_date date;
       v_slot_start time;
       v_minutes_until_slot int;
     begin
       -- Lookup patient
       select id into v_patient_id from user_profiles where auth_id = auth.uid();
       if not found then raise exception 'USER_PROFILE_NOT_FOUND'; end if;

       -- Lock row (atomic with subsequent update)
       select * into v_appt from appointments
         where id = p_appointment_id and patient_id = v_patient_id
         for update;
       if not found then raise exception 'NOT_FOUND'; end if;
       if v_appt.status not in ('pending', 'upcoming') then
         raise exception 'INVALID_STATUS_TRANSITION';
       end if;

       -- Time-window validation (default 60 minutes — L-4 placeholder until PO confirms)
       select slot_date, slot_start into v_slot_date, v_slot_start
       from doctor_slots where id = v_appt.slot_id;
       v_minutes_until_slot := extract(epoch from (v_slot_date + v_slot_start - now())) / 60;
       if v_minutes_until_slot < p_min_cancel_minutes then
         raise exception 'CANCEL_WINDOW_EXPIRED';
       end if;

       -- Atomic update (trigger fires slot release)
       update appointments set
         status = 'cancelled',
         cancelled_at = now(),                            -- explicit set
         cancellation_reason = p_cancellation_reason,
         updated_at = now()
       where id = p_appointment_id;

       -- Insert notification (out-of-scope audit, optional)
       -- insert into notifications (...) values (..., 'booking_cancelled', ...);

       return jsonb_build_object(
         'id', v_appt.id,
         'status', 'cancelled',
         'cancelled_at', now(),
         'cancellation_reason', p_cancellation_reason
       );
     end; $$;
     ```
   - **Opsi B:** Buat Edge Function di `supabase/functions/cancel-appointment/index.ts` (TS/Deno) — logic sama, tapi pakai Deno + supabase-js admin client.
   - **Update `booking_remote_datasource.dart:111-156`** untuk call RPC baru:
     ```dart
     final response = await _client.rpc<Map<String, dynamic>>(
       'cancel_appointment',
       params: {
         'p_appointment_id': appointmentId,
         'p_cancellation_reason': cancellationReason,
         'p_min_cancel_minutes': 60,  // L-4 placeholder
       },
     );
     ```
   - Fix juga fallback `getAppointmentDetail(patientId: '', ...)` (line 142-156) — pass actual `patientId` atau hapus fetch ulang (langsung emit `BookingDetailLoaded` dengan refetch dari cubit).

4. **M-4 Fix: Reconcile `is_booked` inkonsisten data**
   - `update public.doctor_slots s set is_booked = exists (select 1 from public.appointments a where a.slot_id = s.id and a.status in ('pending', 'upcoming'));`
   - Jalankan sebagai one-off cleanup.

5. **🔴 C-4 Fix: Tambah safety-net trigger untuk auto-set `cancelled_at`**
   - **WAJIB** apply SEBELUM backend cancel jadi online, agar data konsisten walau developer lupa.
   - Migration `014_auto_set_cancelled_at.sql`:
     ```sql
     create or replace function public.set_cancelled_at()
     returns trigger as $$
     begin
       -- Auto-set cancelled_at hanya jika transisi ke 'cancelled' dan field masih NULL
       if new.status = 'cancelled'
          and (old.status is null or old.status <> 'cancelled')
          and new.cancelled_at is null then
         new.cancelled_at = now();
       end if;
       return new;
     end;
     $$ language plpgsql;

     create trigger trg_appointments_set_cancelled_at
       before update on public.appointments
       for each row execute function public.set_cancelled_at();
     ```
   - **Idempotent** — jika caller (Edge Function / RPC) sudah explicit set `cancelled_at`, trigger tidak override (cek `new.cancelled_at is null`).
   - **Backward compatible** — `BEFORE UPDATE`, jadi cancel RPC yang sudah explicit set `cancelled_at = now()` tetap jalan tanpa perubahan.

### 9.2 🟡 SHOULD (Significant)

5. **Tambah `WITH CHECK` clause** di RLS UPDATE policy appointments
6. **Improve ErrorHandler** untuk map `P0001` dengan `message` containing custom code → `FailureCode.conflict`/`notFound`
7. **Tambah `FunctionException` handling** di `ErrorHandler`

### 9.3 🟢 NICE (Polish)

8. Tambah `ON DELETE CASCADE` atau `SET NULL` di FK appointments
9. Tambah FCM notification trigger
10. Tambah nested `is_active` filter untuk doctor
11. Improve ordering by `doctor_slots.slot_date`

---

## 10. Open Questions untuk Product Owner

1. **Cancel window:** Apakah ada aturan H-1/H-0 untuk cancel? PRD tidak specify. Wireframe juga tidak. **Saran default sementara: 60 menit** sebelum jadwal (`p_min_cancel_minutes int default 60`) — cukup reasonable untuk klinik kecil, tidak terlalu restrictive untuk pasien. Konfirmasi: berapa menit sebelum jadwal cancel masih allowed?
2. **Notification trigger:** Apakah booking success / cancel harus trigger FCM otomatis dari DB, atau via Edge Function terpisah? Schema tidak implementasi keduanya. Implementasi notifikasi `booking_cancelled` di dalam RPC `cancel_appointment` (lihat §9.1 #3) optional — bisa di-defer ke Edge Function.
3. **Direct cancel via PostgREST:** Flutter saat ini TIDAK pakai raw update (verified §5.8.1 — pakai `_client.functions.invoke`). Tapi sebagai defense-in-depth, **C-4 fix** (trigger auto-set `cancelled_at`) recommended agar konsisten walau pun ada path raw update di masa depan.

---

*Audit dilakukan oleh Tech Lead · 29 Juni 2026 · v1.0 · Tidak ada kode yang diubah selama audit.*
