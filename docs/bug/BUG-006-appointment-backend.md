# BUG-006 — Appointment Backend: Race Condition Slot Booking & Missing Cancel Endpoint

**Tanggal:** 29 Juni 2026
**Feature:** Booking / Appointment (Backend)
**Severity:** 🔴 Critical
**Status:** 🔄 In Progress
**Audit:** `docs/audit/appointment_backend_audit.md` (v1.0)

---

## Ringkasan Audit

Audit komprehensif backend Appointment/Booking menemukan **3 bug Critical** yang memblokir production readiness:

1. **Race condition pada create appointment** — tidak ada DB-level protection (partial unique index missing) + RPC punya TOCTOU flaw. **Bukti empiris: 2 INSERTs untuk slot sama dari patient berbeda keduanya sukses, data existing DB punya 1 slot dengan 4 duplikat dan 1 slot dengan 2.**
2. **Cancel appointment endpoint tidak ada** — `cancel-appointment` Edge Function 404, RPC `cancel_appointment` tidak ada. Cancel flow 100% broken.
3. **Inkonsistensi `is_booked`** — slot dengan appointment aktif tapi `is_booked = false`, akibat test data / trigger timing.

Audit doc terkait:

- `docs/erd/erd_healh_pal.md` §2 tabel `appointments` & `doctor_slots` — schema referensi
- `docs/api_contract/api_contract_health_pal.md` §6.1-6.4 — endpoint contract
- `docs/product/product/prd_health_pal.md` §6.5-6.6, §8, §13 — booking flow requirement
- `docs/wireframe/10-book-appointment.md` & `13-booking-detail.md` — UI contract
- `supabase/migrations/010_slot_booked_trigger.sql` — RPC source (TOCTOU & missing index)
- `lib/features/booking/data/datasource/booking_remote_datasource.dart` — Flutter call sites
- `docs/audit/appointment_backend_audit.md` — full audit findings

---

## Bug List

### BUG-006-A: Race Condition Double-Booking pada Create Appointment (TOCTOU + Missing DB Constraint)

**Deskripsi:**
Dua user (atau user yang sama double-click) yang mengirim `create_appointment` RPC untuk **slot yang sama** secara hampir bersamaan **keduanya akan berhasil**, menghasilkan 2 appointment aktif untuk 1 slot. Hal ini terjadi karena:

1. **Missing DB-level constraint** — Migration 010 (`supabase/migrations/010_slot_booked_trigger.sql`) mendefinisikan partial unique index `idx_appointments_active_slot` untuk mencegah duplikat, **TETAPI index ini tidak ada di DB** (verified via `pg_indexes`). `schema_migrations` table menandai migrasi applied, tapi index tidak tercipta.
2. **TOCTOU di RPC** — `create_appointment` function melakukan `SELECT is_booked` lalu `INSERT` dalam sequence terpisah tanpa `FOR UPDATE` row lock. Window antara check dan insert = race window.

**Bukti Empiris (test di local DB 29 Juni 2026):**

```sql
-- Step 1: Initial state, slot '91a74f1a-...' is_booked=false
-- Step 2: INSERT appointment #1 (patient A) → sukses, is_booked jadi true
-- Step 3: INSERT appointment #2 (patient B, slot SAMA) → SUKSES ❌
-- Step 4: count = 2 active appointments untuk 1 slot
```

**Pre-existing data yang sudah terekspos bug:**

| Slot ID | Active Appointments | Distinct Patient | Slot `is_booked` |
|---------|:-------------------:|:----------------:|:----------------:|
| `0bd15209-cd18-4bc1-8fdc-b8f76bcf36d4` | 4 | 1 (Test User) | `false` ❌ |
| `3d82aa44-2fe8-4af7-96c7-099475990f3b` | 2 | 1 (Test User) | `false` ❌ |

**Root Cause:**

Dua layered缺陷:

- **DB layer:** `create unique index if not exists idx_appointments_active_slot on public.appointments (slot_id) where status in ('pending', 'upcoming')` di migration 010 line 127-130 **gagal/terlewat** saat apply. Mungkin karena transaction roll-back parsial atau permission issue. Hasilnya: tidak ada DB constraint, fully bergantung pada logic RPC.
- **Application layer (RPC):** `create_appointment` function (010:42-125) punya sequence:
  ```sql
  select is_booked into v_slot_booked from public.doctor_slots where id = p_slot_id;
  -- ... fetch fee, patient_id ...
  insert into public.appointments (...) values (...);
  update public.doctor_slots set is_booked = true where id = p_slot_id;
  ```
  Tanpa `FOR UPDATE` di step pertama, 2 transaction concurrent bisa sama-sama baca `is_booked = false` sebelum `UPDATE` di step 4 dieksekusi. Keduanya akan `INSERT` sukses.

**Dampak:**
- 2 (atau lebih) appointment untuk 1 slot — double booking
- Dokter akan bingung jika 2 pasien datang di slot yang sama
- `is_booked` flag jadi inkonsisten dengan real state
- `getDoctorSlots` (yang filter `is_booked = false`) bisa return slot yang sebenarnya sudah punya banyak appointment aktif

**File yang terkait:**

- `supabase/migrations/010_slot_booked_trigger.sql` line 127-130 — partial unique index creation (missing di DB)
- `supabase/migrations/010_slot_booked_trigger.sql` line 56-58 — TOCTOU source (no FOR UPDATE)
- DB: `public.appointments` table — no constraint preventing duplicate active rows

**Status:** [ ] Open

---

### BUG-006-B: `cancel-appointment` Backend Endpoint Tidak Ada (Cancel Flow 100% Broken)

**Deskripsi:**
Saat user tap "Batalkan Appointment" di halaman Booking Detail, `BookingDetailCubit.cancelAppointment` memanggil `CancelAppointmentUseCase` → `BookingRepositoryImpl.cancelAppointment` → `BookingRemoteDataSource.cancelAppointment` (line 116-122):

```dart
final response = await _client.functions.invoke(
  'cancel-appointment',
  body: { 'appointment_id': ..., 'cancellation_reason': ... },
);
```

Function `cancel-appointment` **TIDAK ADA** di Supabase:

- `supabase/functions/` directory **kosong** (verified via `Get-ChildItem`)
- HTTP `POST /functions/v1/cancel-appointment` → **404 Not Found** (verified via `Invoke-RestMethod`)
- `information_schema.routines` untuk `routine_name = 'cancel_appointment'` → **0 rows** (tidak ada RPC alternative)

**Dampak:**
- User klik "Batalkan" → spinner loading → error generic "An unexpected error occurred" (atau "Server error" via PostgrestException mapping fallback)
- `FunctionException` dari supabase_flutter tidak di-handle di `ErrorHandler._mapFailureCode` (error_handler.dart:45-53) → jatuh ke `_ => FailureCode.unknown`
- Appointment TIDAK jadi cancelled, slot TIDAK ter-release
- User stuck dengan appointment yang sebenarnya masih aktif

**Root Cause:**
- API Contract §6.4 mendokumentasikan endpoint `POST /functions/v1/cancel-appointment` Edge Function, tapi Edge Function **tidak pernah diimplementasikan**.
- Tidak ada fallback RPC `cancel_appointment` di PostgreSQL.
- Sprint A7 (Booking flow implementation) menandai "Done" untuk cancel feature, tapi verifikasi end-to-end cancel tidak dilakukan.

**File yang terkait:**

- `supabase/functions/cancel-appointment/index.ts` — tidak ada (folder & file hilang)
- `lib/features/booking/data/datasource/booking_remote_datasource.dart` line 111-156 — call site yang 100% gagal
- `lib/core/network/error_handler.dart` line 45-53 — tidak handle `FunctionException`
- API Contract `docs/api_contract/api_contract_health_pal.md` §6.4 — endpoint specification

**Status:** [ ] Open

---

### BUG-006-C: Inkonsistensi `doctor_slots.is_booked` vs Real State Appointments

**Deskripsi:**
Cross-check query di DB menemukan **2 slot** yang punya `is_booked = false` padahal memiliki **multiple active appointments**:

| Slot ID | Total Active Appointments | Distinct Patient | `is_booked` |
|---------|:------------------------:|:----------------:|:-----------:|
| `0bd15209-cd18-4bc1-8fdc-b8f76bcf36d4` | 4 | 1 (Test User) | `false` |
| `3d82aa44-2fe8-4af7-96c7-099475990f3b` | 2 | 1 (Test User) | `false` |

**Dampak:**
- `getDoctorSlots` (doctor_remote_datasource.dart:83-100) filter `.eq('is_booked', false)` → return slot ini sebagai "available" ke user lain
- Padahal 4 / 2 user (well, 1 user di kasus ini) sudah punya appointment aktif
- Eksploitasi: User baru bisa "booking" slot ini via RPC `create_appointment` (jika RPC dipanggil, dia akan baca `is_booked = false` dan lanjut insert — sama seperti bug BUG-006-A)

**Root Cause (2 kemungkinan):**

1. **Trigger timing:** Trigger `trg_appointments_sync_slot` (migration 001) atau `trg_slot_booked_on_appointment` (migration 010) di-apply **setelah** data appointment lama tercipta. Trigger tidak retroactively update existing rows.
2. **Test cleanup tidak konsisten:** Ada sesi testing yang insert appointment, tapi is_booked pernah di-reset manual ke `false` untuk testing ulang tanpa hapus appointment rows.

**File yang terkait:**

- DB: `public.doctor_slots` table — `is_booked` column value
- DB: `public.appointments` table — 6 rows orphaned (4 untuk `0bd15209-...`, 2 untuk `3d82aa44-...`)
- `lib/features/doctor/data/datasource/doctor_remote_datasource.dart` line 83-100 — query yang membaca `is_booked`

**Status:** [ ] Open

---

## Todo Fix List

| # | Item | Kategori | File Target | Severity | Status |
|---|------|----------|-------------|:--------:|:------:|
| 1 | **Reconcile `is_booked` untuk slot existing** — update `is_booked = true` untuk slot yang punya appointment aktif. Cleanup duplicate: untuk slot `0bd15209-...` (4 rows) dan `3d82aa44-...` (2 rows), set semua ke `cancelled` kecuali 1. | Backend (SQL) | One-off `supabase db query` atau migration `011_reconcile_is_booked.sql` | 🔴 Critical | ✅ Fixed (29 Jun) |
| 2 | **Tambah partial unique index** `idx_appointments_active_slot` di tabel `appointments(slot_id) WHERE status IN ('pending', 'upcoming')`. **WAJIB** pakai `create unique index concurrently` untuk avoid blocking writes, dan **HARUS** dijalankan setelah step #1 selesai. | Backend (SQL) | `supabase/migrations/011_appointments_active_slot_index.sql` | 🔴 Critical | ✅ Fixed (29 Jun) |
| 3 | **Tambah `FOR UPDATE` row lock** di RPC `create_appointment` agar atomic check + insert. Ganti `select is_booked into v_slot_booked from public.doctor_slots where id = p_slot_id;` → `... FOR UPDATE;` | Backend (SQL) | `supabase/migrations/012_create_appointment_for_update.sql` (re-create function) | 🔴 Critical | ✅ Fixed (29 Jun) |
| 4 | **Buat RPC `cancel_appointment` — atomic update `appointments.status` + auto-set `cancelled_at` + validasi ownership + cancel window**. Function: (a) `SECURITY DEFINER` dengan `FOR UPDATE` lock row, (b) resolve patient dari `auth.uid()`, (c) validasi ownership + status transition, (d) validasi cancel window default 60 menit, (e) `UPDATE appointments SET status='cancelled', cancelled_at=now(), ...`, (f) trigger `trg_slot_unbooked_on_cancellation` otomatis release slot, (g) return jsonb. | Backend (SQL) | `supabase/migrations/013_cancel_appointment_rpc.sql` + `014_security_definer_rpc.sql` | 🔴 Critical | ✅ Fixed (29 Jun) |
| 5 | **Ganti Flutter `cancelAppointment()` dari non-existent Edge Function ke panggil RPC `cancel_appointment`**. Hapus `_client.functions.invoke('cancel-appointment', ...)` → `_client.rpc('cancel_appointment', params: {...})`. Fix fallback `getAppointmentDetail(patientId: '', ...)` — extract `patient_id` dari response RPC (bukan empty string). Remove dead code `_mapEdgeErrorCode`. | Flutter | `lib/features/booking/data/datasource/booking_remote_datasource.dart` line 111-156 | 🔴 Critical | ✅ Fixed (29 Jun) |
| 6 | **Tambah safety-net trigger `trg_appointments_set_cancelled_at`** yang auto-set `cancelled_at = now()` saat status transisi ke `'cancelled'` dan field masih NULL. **WAJIB** apply sebelum backend cancel jadi online. Idempotent — jika caller sudah explicit set, trigger tidak override. **Tambahan** untuk fix #4 — sebagai jaring pengaman agar `cancelled_at` konsisten walau developer lupa di RPC / pakai raw update. Detail di audit §5.8.6. | Backend (SQL) | Migration `014_auto_set_cancelled_at.sql` | 🔴 Critical | ⬜ |
| 7 | **Tambah `WITH CHECK` clause** di RLS UPDATE policy `appointments` agar new row state juga divalidasi. Saat ini hanya `USING` (old state). | Backend (SQL) | Migration `015_appointments_update_with_check.sql` | 🟡 Medium | ⬜ |
| 8 | **Improve `ErrorHandler`** untuk map `P0001` (RAISE EXCEPTION) ke `FailureCode` yang spesifik berdasarkan substring `e.message` (SLOT_ALREADY_BOOKED, NOT_FOUND, dll). | Flutter | `lib/core/network/error_handler.dart` line 55-61 | 🟡 Medium | ⬜ |
| 9 | **Tambah handling untuk `FunctionException`** di `ErrorHandler` (saat ini tidak ada). Pattern match `final FunctionException e => ...` dengan mapping berdasarkan HTTP status. | Flutter | `lib/core/network/error_handler.dart` line 45-53 | 🟡 Medium | ⬜ |

> **Catatan cancel window:** Item #4 (cancel RPC) akan diimplementasi dengan parameter `p_min_cancel_minutes int default 60` — **60 menit sebelum jadwal** dipakai sebagai placeholder sampai Product Owner konfirmasi aturan H-1/H-0 yang sebenarnya. Setelah konfirmasi, ubah default atau expose di UI sebagai policy. Implementasi di `cancel_appointment` RPC: `if (extract(epoch from (slot_date + slot_start - now())) / 60 < p_min_cancel_minutes) raise exception 'CANCEL_WINDOW_EXPIRED';`

> **Hasil FIX #1 (29 Jun 2026):**
> - **4 duplikat di-cancel** (3 untuk slot `0bd15209-...`, 1 untuk slot `3d82aa44-...`), **2 original di-keep** (1 per slot, yang paling awal `booked_at`)
> - **`is_booked` di-reconcile** untuk 1936 slot — 0 inkonsistensi tersisa
> - Verifikasi pasca-fix:
>   - `group by slot_id having count(*) > 1 where status IN (pending,upcoming)` → **0 rows** ✅
>   - `count where is_booked != exists(active appointments)` → **0 rows** ✅
> - **Siap untuk FIX #2** (partial unique index).

### Urutan Eksekusi (Dependency)

1. **#1** (cleanup) → **WAJIB sebelum** #2 (unique index)
2. **#2** (partial unique index) → Independent setelah #1
3. **#3** (FOR UPDATE) → Independent, bisa paralel dengan #4
4. **#4** (cancel RPC) → Independent; **WAJIB sebelum** #6 (auto-set trigger) — karena trigger ini safety net for #4
5. **#5** (Flutter update) → Tergantung #4 selesai
6. **#6** (auto-set cancelled_at trigger) → Tergantung #4 (safety net for cancel flow)
7. **#7-#9** → Independent, polish

---

## Skenario Validasi

| # | Skenario | Expected | Status |
|---|----------|----------|:------:|
| 1 | 2 user coba booking slot yang SAMA bersamaan (race condition) | Hanya 1 yang berhasil insert, yang lain dapat error `SLOT_ALREADY_BOOKED` (409) atau unique constraint violation | [ ] |
| 2 | User yang sama double-klik "Konfirmasi Booking" 2x cepat | Hanya 1 appointment tercipta, yang lain dapat error | [ ] |
| 3 | User cancel appointment status `pending` | Status jadi `cancelled`, `cancelled_at` terisi (server-side), slot kembali available untuk user lain | [ ] |
| 4 | User cancel appointment status `upcoming` | Sama seperti #3 | [ ] |
| 5 | User cancel appointment status `completed` | Ditolak dengan error `INVALID_STATUS_TRANSITION` (422) | [ ] |
| 6 | User cancel appointment status `cancelled` (double-cancel) | Ditolak dengan error `INVALID_STATUS_TRANSITION` (422) | [ ] |
| 7 | User A coba cancel appointment milik User B | Ditolak, RLS via RPC function return `NOT_FOUND` (404) | [ ] |
| 8 | User A akses detail appointment milik User B via direct PostgREST | RLS filter, return empty array / 404 | [ ] |
| 9 | User query list appointments (semua status) | Hanya return appointments milik user tersebut, sort by `created_at DESC` | [ ] |
| 10 | `is_booked` di `doctor_slots` sinkron dengan `appointments` active count | Setiap slot dengan appointment aktif punya `is_booked = true`; query `getDoctorSlots` tidak return slot yang sudah booked | [ ] |
| 11 | 2 INSERTs langsung ke `appointments` table (bypass RPC) untuk slot sama | Partial unique index tolak yang ke-2 dengan error `unique_violation` (23505) | [ ] |
| 12 | Cancel RPC dilakukan DAN trigger `trg_appointments_set_cancelled_at` auto-set `cancelled_at` jika NULL | Row `appointments.cancelled_at` selalu non-NULL setelah status jadi `cancelled`, walau caller lupa explicit set | [ ] |
| 13 | User cancel appointment < 60 menit sebelum jadwal (default window) | Ditolak dengan error `CANCEL_WINDOW_EXPIRED` (placeholder — sesuaikan setelah Product Owner konfirmasi) | [ ] |
| 14 | User cancel appointment ≥ 60 menit sebelum jadwal | Sukses, status jadi `cancelled`, `cancelled_at` terisi, slot ter-release | [ ] |

---

## Catatan Implementasi

### Rekomendasi Stack untuk Cancel

**Opsi A (RPC, recommended):**
- ✅ Atomic transaction built-in
- ✅ Type-safe parameters (uuid, text)
- ✅ No deploy Edge Function (lebih simpel, tidak perlu service-role key)
- ✅ Konsisten dengan `create_appointment` (juga RPC)
- ⚠️ Auth.uid() resolution di dalam function (bukan via JWT claim di Edge Function)

**Opsi B (Edge Function):**
- ✅ Lebih flexible untuk add logic kompleks (mis. FCM trigger, refund, dll)
- ✅ Easier versioning
- ⚠️ Butuh deploy step tambahan (`supabase functions deploy cancel-appointment`)
- ⚠️ Butuh `service_role` key untuk bypass RLS jika perlu

Untuk MVP dengan atomic transaction priority, **Opsi A lebih disarankan**.

### Rekomendasi Urutan Rollout

1. **Phase 1 (Immediate):** Apply migration #1, #2, #3 — fix race condition. Test dengan concurrent booking.
2. **Phase 2 (Same release):** Apply migration #4 + Flutter fix #5 — enable cancel flow. Test full cancel cycle.
3. **Phase 3 (Polish sprint):** Apply #6, #7, #8 — improve RLS + error handling.

### Cleanup SQL (untuk step #1)

```sql
-- 1. Reconcile is_booked untuk SEMUA slot
update public.doctor_slots s
set is_booked = exists (
  select 1 from public.appointments a
  where a.slot_id = s.id and a.status in ('pending', 'upcoming')
);

-- 2. Untuk duplicate di slot 0bd15209-... (4 rows), keep 1, cancel 3
-- CATATAN: pilih yang booked_at paling awal sebagai "original"
with ranked as (
  select id, row_number() over (partition by slot_id order by booked_at asc, created_at asc) as rn
  from public.appointments
  where slot_id in (
    '0bd15209-cd18-4bc1-8fdc-b8f76bcf36d4',
    '3d82aa44-2fe8-4af7-96c7-099475990f3b'
  ) and status in ('pending', 'upcoming')
)
update public.appointments set status = 'cancelled', cancelled_at = now()
where id in (select id from ranked where rn > 1);
```

### Verifikasi step #2 setelah apply

```sql
-- Seharusnya ada 1 row
select indexname, indexdef from pg_indexes
where schemaname = 'public' and indexname = 'idx_appointments_active_slot';
```

### Verifikasi step #3 setelah apply

Cek function source:
```sql
select prosrc from pg_proc where proname = 'create_appointment';
-- Seharusnya ada "FOR UPDATE" di query SELECT is_booked
```

### Verifikasi step #4

```sql
select routine_name from information_schema.routines
where routine_schema = 'public' and routine_name = 'cancel_appointment';
-- Seharusnya return 1 row
```

---

## Referensi

- `docs/audit/appointment_backend_audit.md` §4 (Create Appointment), §5 (Cancel), §1.3 (Missing Index), §1.6 (RPC list), §1.7 (Edge Functions)
- `docs/erd/erd_healh_pal.md` §2 `appointments`, `doctor_slots`; §4.4 `is_booked` design
- `docs/api_contract/api_contract_health_pal.md` §6.1-6.4 endpoint contracts
- `supabase/migrations/010_slot_booked_trigger.sql` (RPC + trigger source, BUG-006-A source)
- `lib/features/booking/data/datasource/booking_remote_datasource.dart:111-156` (BUG-006-B source)
- `docs/bug/BUG-001-auth-routing.md` (audit format reference)

---

*Dibuat: 29 Juni 2026 · Tech Lead · v1.0*
