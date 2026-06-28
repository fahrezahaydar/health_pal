# ADR 011: Create Appointment via RPC

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 28 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | Migration SQL baru (010 — function create_appointment + trigger is_booked), API Contract 6.1 (endpoint berubah ke RPC), supabase/functions/create-appointment (dihapus) |

---

## 1. Konteks

Proses booking appointment membutuhkan atomic transaction yang mencakup:
1. Cek double booking (apakah slot_id masih available)
2. Insert row ke tabel ppointments
3. Update doctor_slots.is_booked = true
4. Insert notifikasi ke tabel 
otifications

Proses ini **tidak bisa** dilakukan via PostgREST langsung secara atomic karena:
- PostgREST adalah REST per-tabel — tidak bisa menjamin atomic transaction multi-tabel
- Race condition double booking mungkin terjadi jika Flutter melakukan 2 request terpisah (insert appointment + update slot)

Dua solusi yang dipertimbangkan:

| Solusi | Cara Kerja | Complexity |
|--------|-----------|------------|
| **Edge Function** (Deno) | HTTP call → Deno → SQL transaksi | Wrapper di Deno, maintenance 2 layer |
| **RPC langsung** (PostgreSQL function) | HTTP call → PostgREST → SQL function → atomic transaksi | Zero wrapper, langsung ke DB |

### Kondisi Saat Ini

| Aspek | Kondisi |
|---|---|
| **Tabel appointments** | ✅ Ada di migration 001 |
| **Tabel doctor_slots** | ✅ Ada (kolom is_booked) |
| **Tabel notifications** | ✅ Ada |
| **RLS** | ✅ SELECT/INSERT/UPDATE untuk appointments |
| **Edge Runtime config** | ✅ enabled = true (masih diperlukan untuk fitur future) |

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: PostgreSQL Function via RPC (DIUSULKAN)

Satu PostgreSQL function create_appointment() yang melakukan semua operasi dalam satu transaksi. Flutter cukup call POST /rest/v1/rpc/create_appointment.

**Pro:**
- Zero additional service — langsung call dari Flutter ke PostgREST
- Atomic transaction built-in — FOR UPDATE lock mencegah race condition
- Patient ID dari uth.uid() — tidak perlu dikirim dari client (lebih aman)
- Tidak perlu maintenance Deno/TypeScript
- Lebih cepat — tidak ada hop ke Edge Function (PostgREST langsung)
- RLS tetap berlaku — function berjalan sebagai definer dengan auth context

**Kontra:**
- Error response format PostgREST (bukan envelope {success, error}) — Flutter harus handle di ApiException mapper
- Function sulit dipanggil dari non-authenticated context (tergantung RLS)

### Opsi B: Edge Function + RPC (sebelumnya dipilih)

Edge Function Deno yang validasi input, parsing JWT, lalu call RPC yang sama.

**Pro:**
- Response format bisa dikustom (envelope {success, error})
- Validasi bisa lebih expressif di TypeScript

**Kontra:**
- Maintenance 2 layer (Deno + SQL)
- Latency tambahan (Kong → Edge Runtime → DB vs Kong → PostgREST → DB)
- Perlu manage service_role key di Edge Function
- Deno dependency update

### Opsi C: Multiple PostgREST calls dari Flutter

Flutter melakukan 3 call terpisah: insert appointment, update slot, insert notification.

**Pro:**
- Simplest code — tidak perlu function atau edge function

**Kontra:**
- ❌ **Tidak atomic** — bisa partial failure (appointment terinsert tapi slot tidak terupdate)
- ❌ **Race condition** — 2 user bisa booking slot yang sama sebelum is_booked terupdate

---

## 3. Keputusan

**Pilih Opsi A: PostgreSQL Function via RPC langsung — tanpa Edge Function wrapper.**

### Detail Keputusan

1. **PostgreSQL function**: create_appointment(p_doctor_id, p_slot_id, p_complaint_note):
   - patient_id diambil dari uth.uid() — tidak perlu parameter dari client
   - consultation_fee_snapshot diambil dari doctors.consultation_fee saat eksekusi
   - FOR UPDATE lock pada doctor_slots untuk mencegah race condition
   - Insert appointment → trigger update is_booked → insert notification — semua dalam satu transaksi
   - Return format: jsonb — PostgREST akan serialize ke JSON response

2. **Trigger 	rg_slot_booked_on_appointment**: Defense in depth — jika ada INSERT langsung ke ppointments, is_booked tetap terupdate.

3. **Endpoint**: POST /rest/v1/rpc/create_appointment
   - Headers: pikey, Authorization (sama seperti endpoint PostgREST lain)
   - Body: { "p_doctor_id": "...", "p_slot_id": "...", "p_complaint_note": "..." }
   - No envelope — response langsung dari function return value

4. **Error handling di Flutter**: ApiException mapper handle error dari PostgREST:
   - SLOT_ALREADY_BOOKED → 409
   - SLOT_NOT_FOUND / DOCTOR_NOT_FOUND → 404
   - complaint_note validasi → 400

5. **Edge Function dihapus**: supabase/functions/create-appointment/ tidak dipakai.

---

## 4. Alasan

1. **Eliminasi complexity layer** — Edge Function hanya wrapper tipis yang call SQL yang sama. Langsung call RPC dari Flutter lebih efisien — tidak ada tambahan hop, tidak ada Deno maintenance.

2. **auth.uid() built-in** — PostgreSQL function bisa akses uth.uid() langsung. Tidak perlu parsing JWT di Edge Function. Ini lebih aman karena client tidak bisa memanipulasi patient_id.

3. **Zero infrastructure** — PostgREST sudah running, migration SQL sudah di-apply. Tidak perlu serve Edge Function terpisah.

4. **Atomic transaction native** — PostgreSQL function menjamin atomicity. FOR UPDATE lock mencegah race condition.

5. **Flutter sudah siap** — SupabaseClient.rpc() sudah ada di codebase. Pattern yang sama dengan get_nearby_clinics (lihat LocRemoteDataSource).

---

## 5. Konsekuensi

### Positif

- ✅ Zero new service — cukup migration SQL
- ✅ Atomic transaction — FOR UPDATE lock
- ✅ auth.uid() — client tidak bisa spoof patient_id
- ✅ Reuse pattern pc() — sama seperti get_nearby_clinics
- ✅ Tidak perlu maintain Deno/TypeScript
- ✅ Latency lebih rendah (no Edge Runtime hop)

### Negatif

- ⚠️ Error response PostgREST — Flutter harus parse {code, message, details} bukan envelope {success, error}
- ⚠️ API Contract response example perlu diupdate — format PostgREST bukan envelope
- ⚠️ FCM push notification tidak bisa dikirim dari function (deferred — tetap insert ke tabel notifications)

### Risiko & Mitigasi

| Risiko | Mitigasi |
|--------|----------|
| PostgREST error format tidak konsisten dengan endpoint lain | ApiException mapper di Flutter handle semua format |
| auth.uid() tidak available di function | Pastikan function punya security definer dan RLS policy yang sesuai |
| Validasi complaint_note tidak se-expressif TypeScript regex | Validasi via length() dan char_length() di SQL |
| Trigger is_booked conflict dengan function update | Function dan trigger idempotent — UPDATE is_booked = true dua kali tidak masalah |

---

## 6. Compliance

| Mekanisme | Detail |
|---|---|
| **ERD** | docs/erd/erd_healh_pal.md — tabel ppointments, doctor_slots, 
otifications |
| **API Contract** | docs/api_contract/api_contract_health_pal.md — 6.1 Create Appointment (update ke RPC) |
| **Migration** | supabase/migrations/010_slot_booked_trigger.sql |
| **PRD** | docs/product/prd_health_pal.md — 6.5 Book Appointment |
| **Code Review** | WAJIB cek: (1) FOR UPDATE lock, (2) auth.uid() bukan parameter, (3) consultation_fee snapshot, (4) trigger is_booked |

---

## 7. Referensi

- API Contract: docs/api_contract/api_contract_health_pal.md — 6.1
- ERD: docs/erd/erd_healh_pal.md — appointments, doctor_slots, notifications
- PRD: docs/product/prd_health_pal.md — 6.5 Book Appointment
- Migration: supabase/migrations/010_slot_booked_trigger.sql
- Existing RPC pattern: LocRemoteDataSource.getNearbyClinics() — supabase.rpc()

---

## 8. Out of Scope

1. **FCM Push Notification** — Function hanya insert ke tabel 
otifications. Push FCM via trigger atau job terpisah (sprint mendatang).

2. **cancel-appointment** — Akan diimplementasi di ADR terpisah dengan pola RPC yang sama.

3. **Generate doctor_slots** — Slot sudah ada dari seed. Logika generate otomatis via cron deferred.

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi Superseded jika ADR baru menggantikan keputusan ini.*
