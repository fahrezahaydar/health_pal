-- =============================================================
-- 018_profile_phone_number.sql
-- Add phone_number column to user_profiles for Profile Page v2.0
-- (ADR-013: Profile Page Redesign)
--
-- Keputusan ADR:
-- - Kolom nullable (TEXT) — tidak wajib diisi saat registrasi
-- - Tidak ada constraint unique — satu nomor bisa dipakai
--   banyak akun (keluarga)
-- - Tidak ada NOT NULL — existing data tidak terpengaruh
-- =============================================================

alter table public.user_profiles
add column phone_number text;

comment on column public.user_profiles.phone_number is
  'Nomor telepon pribadi user. Diisi via Edit Profile. (ADR-013)';
