-- Migration: Doctor Avatars Storage Bucket
-- Tujuan: Bucket khusus untuk foto profil dokter, terpisah dari
--         bucket 'avatars' (user/patient) agar lifecycle dan
--         RLS policy bisa dikelola independen.
--
-- Pola konsisten dengan migration 006 (specialization-icons).

-- ============================================================
-- 1. STORAGE BUCKET: doctor-avatars
-- ============================================================

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'doctor-avatars',
  'doctor-avatars',
  true,
  2097152, -- 2 MB (sama dengan bucket avatars user)
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do nothing;

-- ============================================================
-- 2. RLS POLICY: Public read access
-- ============================================================

create policy "Public read doctor avatars"
  on storage.objects for select
  using (bucket_id = 'doctor-avatars');

-- Catatan: Tidak ada policy INSERT/UPDATE/DELETE untuk
-- authenticated user. Upload foto dokter dikelola oleh admin/
-- service role melalui Supabase Studio atau backend admin panel,
-- BUKAN dari aplikasi pasien. Pola ini konsisten dengan bucket
-- 'specialization-icons' (006) dan berbeda dengan bucket
-- 'avatars' (002) yang mengizinkan user upload avatar sendiri.

-- ============================================================
-- 3. SCHEMA DOCUMENTATION (COMMENT)
-- ============================================================
-- Kolom photo_url sudah ada di tabel doctors sejak migration
-- 001. Blok ini hanya menambahkan dokumentasi cara pengisian.

comment on column public.doctors.photo_url is
  'URL foto profil dokter dari Supabase Storage bucket '
  'doctor-avatars. Format: public URL hasil upload admin, '
  'contoh: https://<project>.supabase.co/storage/v1/object/public/'
  'doctor-avatars/<doctor-slug>.jpg. Nullable — fallback ke '
  'placeholder avatar di frontend jika null.';
