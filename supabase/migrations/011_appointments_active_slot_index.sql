-- =============================================================
-- 011_appointments_active_slot_index.sql
-- Partial unique index: mencegah double booking di level database
-- Hanya 1 appointment dengan status active (pending/upcoming)
-- per slot_id.
--
-- Latar belakang: migration 010 berisi index yang sama, tapi
-- gagal ter-apply karena data duplikat sudah ada di DB saat
-- migration dijalankan. FIX #1 (BUG-006) telah cleanup duplikat
-- + reconcile is_booked. Index ini adalah langkah defense-in-depth
-- untuk mencegah race condition TOCTOU di RPC create_appointment.
--
-- Safety: bila masih ada duplikat yang terlewat, create unique index
-- akan error — ini sengaja (fail fast) untuk melindungi integritas data.
-- =============================================================

-- Partial unique index: 1 active appointment per slot
create unique index if not exists idx_appointments_active_slot
  on public.appointments (slot_id)
  where status in ('pending', 'upcoming');

-- Dokumentasi
comment on index public.idx_appointments_active_slot is
  'Mencegah double booking — hanya 1 appointment dengan status pending/upcoming per doctor_slot';
