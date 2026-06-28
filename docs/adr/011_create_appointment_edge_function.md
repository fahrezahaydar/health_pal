# ADR 011: Create Appointment Edge Function

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 28 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | Edge Function baru (supabase/functions/create-appointment), migration SQL (trigger is_booked), API Contract (live), config.toml (edge_runtime enabled) |

---

## 1. Konteks

Proses booking appointment membutuhkan atomic transaction yang mencakup:
1. Cek double booking (apakah slot_id masih available)
2. Insert row ke tabel ppointments
3. Update doctor_slots.is_booked = true
4. Insert notifikasi ke tabel 
otifications
5. Kirim FCM push notification ke pasien

Proses ini **tidak bisa** dilakukan via PostgREST langsung karena:
- Atomic transaction tidak bisa dijamin oleh multiple REST calls
- Race condition double booking mungkin terjadi jika Flutter melakukan 2 request terpisah (insert appointment + update slot)
- FCM push notification tidak bisa di-trigger dari PostgREST

Solusi: **Edge Function** (Deno + TypeScript) di Supabase — satu HTTP call, satu transaksi database, notifikasi FCM terkirim sebagai side effect.

### Kondisi Saat Ini

| Aspek | Kondisi |
|---|---|
| **Tabel appointments** | ✅ Ada di migration 001_initial_schema (semua kolom sesuai ERD) |
| **Tabel doctor_slots** | ✅ Ada (termasuk kolom is_booked) |
| **Tabel notifications** | ✅ Ada (termasuk FK ke appointments) |
| **RLS appointments** | ✅ Ada untuk SELECT, INSERT, UPDATE (cancel) |
| **Trigger is_booked** | ❌ **Belum ada** — ERD §4.4 menyebut trigger perlu diimplementasi |
| **Edge Function create-appointment** | ❌ **Belum ada** |
| **FCM integration** | ❌ **Belum ada** — FCM token tersimpan di user_fcm_tokens tapi Edge Function belum kirim notifikasi |
| **Edge Runtime** | ✅ **Baru di-enable** (config.toml sebelumnya disabled) |

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: Edge Function + Trigger (DIUSULKAN)

Edge Function create-appointment di Deno + SQL trigger update_slot_is_booked untuk defense in depth.

**Pro:**
- Atomic transaction dari satu HTTP call.
- Trigger is_booked sebagai safety net — jika ada direct insert ke appointments tanpa Edge Function, is_booked tetap ter-update.
- FCM notification bisa dikirim dari Edge Function via Supabase Management API atau Firebase Admin SDK.

**Kontra:**
- Perlu maintenance 2 layer logika (Edge Function + DB trigger).
- FCM integration perlu service account key.

### Opsi B: Trigger-only

Cukup SQL trigger create_appointment di PostgreSQL yang handle insert ke appointments, update slot, dan insert notification. Flutter call PostgREST langsung.

**Pro:**
- Tidak perlu Edge Function — latency lebih rendah (no HTTP gateway).
- Tidak perlu Deno/TypeScript maintenance.

**Kontra:**
- FCM push notification tidak bisa dikirim dari PostgreSQL trigger.
- Sulit handle error response kustom untuk Flutter.
- Tidak sesuai API Contract yang sudah mendefinisikan POST /functions/v1/create-appointment.

### Opsi C: Edge Function only — without trigger

Semua logika di Edge Function. Tidak ada trigger di database.

**Pro:**
- Single source of truth — logika booking hanya di Edge Function.
- Lebih mudah di-debug (test via curl/Postman).

**Kontra:**
- Jika ada direct insert ke appointments (misal dari Supabase dashboard), is_booked tidak ter-update.
- Double booking mungkin terjadi jika admin insert langsung ke database.

---

## 3. Keputusan

**Pilih Opsi A: Edge Function + Trigger (defense in depth).**

### Detail Keputusan

1. **Edge Function: supabase/functions/create-appointment/index.ts**
   - Bahasa: TypeScript (Deno)
   - Method: POST
   - Auth: Wajib Authorization: Bearer <access_token> (Supabase Auth)
   - Validasi:
     - doctor_id dan slot_id wajib UUID valid
     - complaint_note maksimal 300 karakter
   - Transaksi:
     `sql
     -- Dalam satu transaksi:
     SELECT is_booked FROM doctor_slots WHERE id =  FOR UPDATE;  -- lock row
     IF is_booked THEN raise 'SLOT_ALREADY_BOOKED';
     INSERT INTO appointments (patient_id, doctor_id, slot_id, 
       consultation_fee_snapshot, complaint_note) VALUES (...);
     UPDATE doctor_slots SET is_booked = true WHERE id = ;
     INSERT INTO notifications (user_id, appointment_id, type, title, body) 
       VALUES (...);
     COMMIT;
     `
   - Response: Mengikuti format API Contract §6.1 (Success 201, Error sesuai kode)
   - FCM: Deferred — tidak diimplementasi di MVP (lihat Out of Scope)

2. **SQL Trigger: update_slot_is_booked** (migration 010)
   - Trigger function: set_slot_booked_on_appointment()
   - Event: AFTER INSERT ON appointments
   - Action: UPDATE doctor_slots SET is_booked = true WHERE id = NEW.slot_id
   - Event: AFTER UPDATE OF status ON appointments
   - Action: Jika status = 'cancelled' → UPDATE doctor_slots SET is_booked = false WHERE id = OLD.slot_id
   - Rationale: Defense in depth — jika ada insert langsung ke tabel appointments (dashboard admin), slot tetap terblokir.

3. **Snapshoot consultation_fee**: Edge Function me-LOOKUP doctors.consultation_fee saat booking dibuat
   `sql
   SELECT consultation_fee FROM doctors WHERE id = ;
   `
   Hasilnya disimpan di ppointments.consultation_fee_snapshot — pattern immutable snapshot (ERD §4.3).

4. **Edge Runtime config**: supabase/config.toml → [edge_runtime] enabled = true (sudah di-commit)

---

## 4. Alasan

1. **Atomic transaction** — Satu Edge Function menjamin bahwa insert appointment, update slot, dan insert notification terjadi dalam satu transaksi. Tidak ada partial failure.

2. **Defense in depth** — Trigger is_booked memastikan integritas data bahkan jika ada direct insert ke appointments tanpa Edge Function (misal dari Supabase dashboard atau migration).

3. **API Contract compliance** — Endpoint POST /functions/v1/create-appointment sudah didefinisikan di API Contract §6.1. Implementasi Edge Function membuat API Contract jadi live.

4. **FCM readiness** — Edge Function bisa ditambahkan FCM push notification tanpa perubahan arsitektur. Cukup tambah Firebase Admin SDK call di dalam function yang sama setelah transaksi sukses.

5. **Snapshoot consultation_fee** — Memastikan histori transaksi immutable (ERD §4.3). Perubahan tarif dokter di masa depan tidak mengubah data booking lama.

---

## 5. Konsekuensi

### Positif

- ✅ Satu HTTP call untuk booking — Flutter tidak perlu multiple request.
- ✅ Atomic transaction — tidak ada race condition double booking.
- ✅ Defense in depth — trigger sebagai safety net.
- ✅ Immutable fee snapshot — histori transaksi akurat.
- ✅ API Contract jadi live — Flutter bisa integrasi.

### Negatif

- ⚠️ **Edge Function baru** — perlu maintenance Deno/TypeScript.
- ⚠️ **Migration SQL baru** — trigger update_slot_is_booked.
- ⚠️ **FCM deferred** — push notification belum terkirim otomatis (MVP).
- ⚠️ **Edge Runtime dependency** — booking tidak bisa dibuat jika Edge Runtime down.

### Risiko & Mitigasi

| Risiko | Mitigasi |
|--------|----------|
| Double booking race condition | SELECT ... FOR UPDATE lock + trigger defense in depth |
| Edge Function timeout (10s default) | Optimasi query — semua dalam satu transaksi, < 1s |
| Invalid UUID format crash | Validasi input di awal function |
| consultation_fee berubah antara booking flow | Fee diambil saat booking (snapshot), bukan dari state Flutter |
| FCM tidak terkirim | Deferred — MVP tidak handle push notif. Notifikasi tersimpan di tabel 
otifications |

---

## 6. Compliance

| Mekanisme | Detail |
|---|---|
| **ERD** | docs/erd/erd_healh_pal.md — tabel ppointments, doctor_slots, 
otifications |
| **API Contract** | docs/api_contract/api_contract_health_pal.md — §6.1 Create Appointment |
| **ADR ini** | Dokumen keputusan arsitektur |
| **PRD** | docs/product/prd_health_pal.md — §6.5 Book Appointment |
| **Code Review** | WAJIB cek: (1) atomic transaction dengan FOR UPDATE, (2) trigger is_booked, (3) consultation_fee_snapshot dari DB bukan dari request, (4) validasi complaint_note max 300 chars, (5) error response sesuai API Contract |

---

## 7. Referensi

- API Contract: docs/api_contract/api_contract_health_pal.md — §6.1
- ERD: docs/erd/erd_healh_pal.md — ppointments, doctor_slots, 
otifications, doctor_schedules
- PRD: docs/product/prd_health_pal.md — §6.5 Book Appointment
- Existing Migration: supabase/migrations/001_initial_schema.sql — appointments, doctor_slots, notifications tables
- User Flow: docs/user_flow/USER_FLOW.md — Booking flow
- ADR 009: Doctor Detail Redesign — slot selection pattern

---

## 8. Out of Scope

1. **FCM Push Notification** — Edge Function hanya insert ke tabel 
otifications. Push FCM via Firebase Admin SDK ditambahkan di sprint mendatang. Flutter tetap bisa menampilkan notifikasi in-app dari tabel 
otifications.

2. **Edge Function cancel-appointment** — API Contract §6.4 mendefinisikan POST /functions/v1/cancel-appointment. Akan diimplementasikan di ADR terpisah.

3. **Generate doctor_slots** — Slot di-generate via terpisah (Supabase cron / Edge Function). Ada di tabel doctor_slots dari migration 001, tapi logika generate-nya belum diimplementasi.

4. **Validasi slot_date di masa lalu** — Edge Function tidak cek apakah slot_date sudah lewat. Flutter diharapkan hanya menampilkan slot masa depan.

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi Superseded jika ADR baru menggantikan keputusan ini.*
