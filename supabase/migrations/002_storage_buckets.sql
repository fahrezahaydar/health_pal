-- =============================================================
-- 002_storage_buckets.sql
-- Bucket & RLS untuk Supabase Storage
-- =============================================================

-- 1. BUCKET: avatars (public read)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'avatars',
  'avatars',
  true,
  2097152, -- 2 MiB
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do nothing;

-- 2. ENABLE RLS on storage.objects (if not already)
-- Note: storage.objects RLS is enabled by default on new Supabase projects
alter table storage.objects enable row level security;

-- 3. RLS: Public read avatars
create policy "Public read avatars"
  on storage.objects for select
  using (bucket_id = 'avatars');

-- 4. RLS: Authenticated users upload own avatar
create policy "User upload own avatar"
  on storage.objects for insert
  with check (
    bucket_id = 'avatars'
    and auth.role() = 'authenticated'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- 5. RLS: Authenticated users update/delete own avatar
create policy "User manage own avatar"
  on storage.objects for update
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "User delete own avatar"
  on storage.objects for delete
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
