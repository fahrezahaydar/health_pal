-- Migration: Specialization Icons & Colors
-- Tujuan: Tambah storage bucket untuk SVG icon specialization
--         + kolom color_hex di tabel specializations

-- ============================================================
-- 1. STORAGE BUCKET: specialization-icons
-- ============================================================

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'specialization-icons',
  'specialization-icons',
  true,
  1048576, -- 1 MB
  array['image/svg+xml']
)
on conflict (id) do nothing;

-- RLS Policy: Public read access untuk bucket specialization-icons
create policy "Public read specialization icons"
  on storage.objects for select
  using (bucket_id = 'specialization-icons');

-- Catatan: Tidak ada policy INSERT untuk authenticated user.
-- Upload dikelola oleh admin/service role secara manual
-- via Supabase Studio atau service role key, bukan dari aplikasi.

-- ============================================================
-- 2. EXTEND public.specializations TABLE
-- ============================================================

alter table public.specializations
add column if not exists color_hex text;

alter table public.specializations
add constraint specializations_color_hex_format
check (
  color_hex is null
  or color_hex ~ '^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$'
);

-- ============================================================
-- 3. SCHEMA DOCUMENTATION (COMMENTS)
-- ============================================================

comment on column public.specializations.icon_url is
  'URL SVG icon dari Supabase Storage bucket specialization-icons. '
  'Format: public URL hasil upload admin, contoh: '
  'https://<project>.supabase.co/storage/v1/object/public/specialization-icons/<file>.svg';

comment on column public.specializations.color_hex is
  'Warna utama (primary color) yang dipakai frontend untuk render '
  'specialization card/icon background. Format HEX: #RRGGBB atau '
  '#AARRGGBB (dengan alpha channel). Nullable — fallback ke default '
  'theme color di frontend jika null.';
