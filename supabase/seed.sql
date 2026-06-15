-- =============================================================================
-- seed.sql — Data dummy untuk Supabase local development
-- =============================================================================
-- Cara pakai:
--   supabase db reset    (migrasi + seed otomatis)
--   supabase db seed     (seed saja, tanpa migrasi)
--
-- Semua data dibuat via SQL murni — tidak perlu script terpisah.
--
-- 🖼️ IMAGES (avatar, foto dokter, banner, dll):
--    1. Upload file ke Supabase Storage (bucket 'avatars')
--       via Studio: http://127.0.0.1:54323/project/default/storage
--       atau via curl:
--         curl -X POST http://127.0.0.1:54321/storage/v1/object/avatars/nama-file.jpg
--           -H "Authorization: Bearer <anon_key>"
--           -H "Content-Type: image/jpeg"
--           --data-binary @path/file.jpg
--    2. Catat public URL:
--       http://127.0.0.1:54321/storage/v1/object/public/avatars/nama-file.jpg
--    3. Isi kolom xxx_url dengan URL tersebut.
-- =============================================================================

create extension if not exists "pgcrypto" with schema "extensions";

-- =============================================================================
-- 1. AUTH USERS (login credentials)
-- =============================================================================
-- Kolom penting:
--   id                 UUID primary key — pakai nilai tetap agar bisa
--                      di-refer oleh tabel lain (user_profiles, dll)
--   email              Login email (unique)
--   encrypted_password Hash bcrypt — dibuat dengan crypt(password, gen_salt('bf'))
--   email_confirmed_at Set now() agar skip konfirmasi email
--   raw_app_meta_data  JSON: {"provider":"email","providers":["email"]}
--   raw_user_meta_data JSON opsional untuk data tambahan
--
-- Cara nambah user baru:
--   1. Generate UUID baru (bisa dari gen_random_uuid() atau online UUID generator)
--   2. Duplikat blok INSERT, ganti id, email, password, meta data
--   3. Tambah user_profiles di section 2 dengan auth_id = UUID tsb
-- =============================================================================
do $$
declare
  uid1 uuid := 'd0e1e2a3-b4c5-6789-abcd-ef0123456789';
  uid2 uuid := 'a1b2c3d4-e5f6-7890-abcd-ef9876543210';
  uid3 uuid := 'f1e2d3c4-b5a6-0987-fedc-ba9876543210';
begin
  -- User 1: test@example.com / Test123456!
  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, invited_at,
    confirmation_token, confirmation_sent_at,
    recovery_token, recovery_sent_at,
    email_change_token_new, email_change, email_change_sent_at,
    last_sign_in_at,
    raw_app_meta_data, raw_user_meta_data,
    is_super_admin, created_at, updated_at,
    phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at,
    email_change_token_current, email_change_confirm_status,
    banned_until, reauthentication_token, reauthentication_sent_at,
    is_sso_user, deleted_at, is_anonymous
  ) values (
    '00000000-0000-0000-0000-000000000000',
    uid1,
    'authenticated', 'authenticated',
    'test@example.com',
    crypt('Test123456!', gen_salt('bf')),
    now(), null,
    '', null,
    '', null,
    '', '', null,
    null,
    '{"provider":"email","providers":["email"]}',
    '{}',
    false, now(), now(),
    null, null, '', '', null,
    '', 0,
    null, '', null,
    false, null, false
  )
  on conflict (id) do nothing;

  -- User 2: user@example.com / User123456!
  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, invited_at,
    confirmation_token, confirmation_sent_at,
    recovery_token, recovery_sent_at,
    email_change_token_new, email_change, email_change_sent_at,
    last_sign_in_at,
    raw_app_meta_data, raw_user_meta_data,
    is_super_admin, created_at, updated_at,
    phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at,
    email_change_token_current, email_change_confirm_status,
    banned_until, reauthentication_token, reauthentication_sent_at,
    is_sso_user, deleted_at, is_anonymous
  ) values (
    '00000000-0000-0000-0000-000000000000',
    uid2,
    'authenticated', 'authenticated',
    'user@example.com',
    crypt('User123456!', gen_salt('bf')),
    now(), null,
    '', null,
    '', null,
    '', '', null,
    null,
    '{"provider":"email","providers":["email"]}',
    '{}',
    false, now(), now(),
    null, null, '', '', null,
    '', 0,
    null, '', null,
    false, null, false
  )
  on conflict (id) do nothing;

  -- User 3: demo@example.com / Demo123456!
  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, invited_at,
    confirmation_token, confirmation_sent_at,
    recovery_token, recovery_sent_at,
    email_change_token_new, email_change, email_change_sent_at,
    last_sign_in_at,
    raw_app_meta_data, raw_user_meta_data,
    is_super_admin, created_at, updated_at,
    phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at,
    email_change_token_current, email_change_confirm_status,
    banned_until, reauthentication_token, reauthentication_sent_at,
    is_sso_user, deleted_at, is_anonymous
  ) values (
    '00000000-0000-0000-0000-000000000000',
    uid3,
    'authenticated', 'authenticated',
    'demo@example.com',
    crypt('Demo123456!', gen_salt('bf')),
    now(), null,
    '', null,
    '', null,
    '', '', null,
    null,
    '{"provider":"email","providers":["email"]}',
    '{}',
    false, now(), now(),
    null, null, '', '', null,
    '', 0,
    null, '', null,
    false, null, false
  )
  on conflict (id) do nothing;

  -- ── AUTH.IDENTITIES (wajib! tanpa ini user tidak bisa login) ─────
  -- identity_data harus berisi {"sub":"<user_id>","email":"<email>"}
  -- provider = 'email' untuk email/password
  -- provider_id = email (digunakan oleh GoTrue untuk unique constraint)
  insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  values
    (gen_random_uuid(), uid1,
     jsonb_build_object('sub', uid1, 'email', 'test@example.com'),
     'email', 'test@example.com',
     now(), now(), now()),
    (gen_random_uuid(), uid2,
     jsonb_build_object('sub', uid2, 'email', 'user@example.com'),
     'email', 'user@example.com',
     now(), now(), now()),
    (gen_random_uuid(), uid3,
     jsonb_build_object('sub', uid3, 'email', 'demo@example.com'),
     'email', 'demo@example.com',
     now(), now(), now())
  on conflict (provider_id, provider) do nothing;

  -- ── CONTOH: nambah user + identity baru ─────────────────────────
  -- declare
  --   uid4 uuid := 'aabbccdd-eeff-0011-2233-445566778899';
  -- begin
  --   insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, is_sso_user, is_anonymous)
  --   values ('00000000-0000-0000-0000-000000000000', uid4, 'authenticated', 'authenticated', 'sinta@example.com', crypt('Sinta123!', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', false, now(), now(), false, false)
  --   on conflict (id) do nothing;
  --
  --   insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  --   values (gen_random_uuid(), uid4, jsonb_build_object('sub', uid4, 'email', 'sinta@example.com'), 'email', 'sinta@example.com', now(), now(), now())
  --   on conflict (provider_id, provider) do nothing;
  -- end;
end $$;

-- =============================================================================
-- 2. USER PROFILES (data profil pasien, 1:1 dengan auth.users)
-- =============================================================================
-- Kolom:
--   auth_id              FK ke auth.users(id) — WAJIB cocok dengan id di atas
--   full_name            Nama lengkap
--   nickname             Panggilan
--   avatar_url           URL foto profil (upload dulu ke storage)
--   date_of_birth        YYYY-MM-DD
--   gender               'male' | 'female' | 'other'
--   notif_reminder_enabled  Boolean
--   is_profile_complete  Boolean — true jika profil sudah diisi user
--
-- Cara edit:
--   Jika nambah user baru (section 1), tambah baris di sini juga
--   dengan auth_id yang SAMA dengan id di auth.users
-- =============================================================================
do $$
declare
  uid1 uuid := 'd0e1e2a3-b4c5-6789-abcd-ef0123456789';
  uid2 uuid := 'a1b2c3d4-e5f6-7890-abcd-ef9876543210';
  uid3 uuid := 'f1e2d3c4-b5a6-0987-fedc-ba9876543210';
begin
  insert into public.user_profiles (auth_id, full_name, nickname, avatar_url, date_of_birth, gender, notif_reminder_enabled, is_profile_complete)
  values
    (uid1, 'Test User',    'Test', null, '1995-06-15'::date, 'male',   true,  true),
    (uid2, 'Rina Susanti', 'Rina', null, '1992-03-22'::date, 'female', true,  true),
    (uid3, 'Budi Demo',    'Budi', null, '1988-11-01'::date, 'male',   false, false);

  -- ── CONTOH: user dengan avatar dari storage ──────────────────────
  -- Pertama: upload file sinta.jpg ke bucket 'avatars'
  --   Buka Studio → Storage → bucket 'avatars' → Upload
  --   atau via curl (lihat header dokumentasi)
  -- Kedua: dapatkan public URL:
  --   http://127.0.0.1:54321/storage/v1/object/public/avatars/sinta.jpg
  -- Ketiga: insert dengan avatar_url:
  -- insert into public.user_profiles (auth_id, full_name, nickname, avatar_url, date_of_birth, gender, notif_reminder_enabled, is_profile_complete)
  -- values ('aabbccdd-eeff-0011-2233-445566778899', 'Sinta Amelia', 'Sinta',
  --         'http://127.0.0.1:54321/storage/v1/object/public/avatars/sinta.jpg',
  --         '1998-07-12'::date, 'female', true, true);
end $$;

-- =============================================================================
-- 3. SPECIALIZATIONS (master data spesialisasi dokter)
-- =============================================================================
-- Kolom:
--   id        UUID auto — ganti gen_random_uuid() dengan UUID tetap jika perlu
--   name      Nama spesialisasi
--   icon_url  URL ikon dari storage
--               upload → bucket 'avatars/icon-umum.png'
--               URL    → http://127.0.0.1:54321/storage/v1/object/public/avatars/icon-umum.png
-- =============================================================================
insert into public.specializations (id, name, icon_url) values
  (gen_random_uuid(), 'Umum',                        null),
  (gen_random_uuid(), 'Anak',                        null),
  (gen_random_uuid(), 'Kulit & Kelamin',             null),
  (gen_random_uuid(), 'Gigi',                        null),
  (gen_random_uuid(), 'Mata',                        null),
  (gen_random_uuid(), 'THT',                         null),
  (gen_random_uuid(), 'Saraf',                       null),
  (gen_random_uuid(), 'Jantung',                     null),
  (gen_random_uuid(), 'Kandungan & Ginekologi',      null),
  (gen_random_uuid(), 'Ortopedi',                    null);
  -- Contoh nambah spesialisasi baru:
  -- ,(gen_random_uuid(), 'Psikolog', null)

-- =============================================================================
-- 4. CLINICS (klinik / rumah sakit)
-- =============================================================================
-- Kolom:
--   id         UUID auto
--   name       Nama klinik
--   address    Alamat lengkap
--   city       Kota (untuk filter / nearby)
--   latitude   Koordinat (float8)
--   longitude  Koordinat (float8)
--   phone      Nomor telepon
--   image_url  Foto klinik dari storage (sama seperti icon_url)
--
-- Cara edit: tambah/ubah baris di CTE 'clinic_data'
--   ('Nama', 'Alamat', 'Kota', lat, lng, 'telp')
-- =============================================================================
with clinic_data as (
  select * from (values
    ('Klinik Sehat Keluarga',      'Jl. Sudirman No. 123, Jakarta Pusat',      'Jakarta Pusat',  -6.2088, 106.8456, '021-12345678'),
    ('RSIA Bunda Sejahtera',       'Jl. Gatot Subroto No. 45, Jakarta Selatan', 'Jakarta Selatan', -6.2387, 106.8244, '021-87654321'),
    ('Klinik Medika Utama',        'Jl. Kemang Raya No. 78, Jakarta Selatan',   'Jakarta Selatan', -6.2612, 106.8081, '021-23456789'),
    ('Poliklinik Dokter Keluarga', 'Jl. Kelapa Gading Raya No. 15, Jakarta Utara','Jakarta Utara', -6.1578, 106.9050, '021-34567890'),
    ('Klinik Prima Husada',        'Jl. Fatmawati No. 200, Jakarta Selatan',    'Jakarta Selatan', -6.2893, 106.7922, '021-45678901')
  ) as t(name, address, city, lat, lng, phone)
)
insert into public.clinics (id, name, address, city, latitude, longitude, phone)
select gen_random_uuid(), name, address, city, lat, lng, phone
from clinic_data;

-- =============================================================================
-- 5. DOCTORS
-- =============================================================================
-- Kolom:
--   id                 UUID auto
--   clinic_id          FK ke clinics(id)
--   specialization_id  FK ke specializations(id)
--   full_name          Nama dokter
--   photo_url          Foto dokter dari storage
--                       upload → bucket 'avatars/dokter-xxx.jpg'
--                       URL    → http://127.0.0.1:54321/storage/v1/object/public/avatars/dokter-xxx.jpg
--   description        Deskripsi / pengalaman singkat
--   experience_years   Tahun pengalaman
--   education          Riwayat pendidikan
--   consultation_fee   Biaya konsultasi (numeric)
--   rating_avg         Rating (numeric 3,2)
--   rating_count       Jumlah rating
--   is_active          Boolean
--
-- Cara nambah dokter:
--   1. Cari ID spesialisasi: SELECT id FROM specializations WHERE name = 'xxx'
--   2. Cari ID klinik: SELECT id FROM clinics WHERE name = 'xxx'
--   3. Tambah baris VALUES di blok yang sesuai
-- =============================================================================
do $$
declare
  sp_umum_id uuid; sp_anak_id uuid; sp_kulit_id uuid; sp_gigi_id uuid;
  sp_mata_id uuid; sp_tht_id uuid; sp_saraf_id uuid; sp_jantung_id uuid;
  sp_kandungan_id uuid; sp_ortopedi_id uuid;
  klinik1_id uuid; klinik2_id uuid; klinik3_id uuid; klinik4_id uuid; klinik5_id uuid;
begin
  select id into sp_umum_id from public.specializations where name = 'Umum' limit 1;
  select id into sp_anak_id from public.specializations where name = 'Anak' limit 1;
  select id into sp_kulit_id from public.specializations where name = 'Kulit & Kelamin' limit 1;
  select id into sp_gigi_id from public.specializations where name = 'Gigi' limit 1;
  select id into sp_mata_id from public.specializations where name = 'Mata' limit 1;
  select id into sp_tht_id from public.specializations where name = 'THT' limit 1;
  select id into sp_saraf_id from public.specializations where name = 'Saraf' limit 1;
  select id into sp_jantung_id from public.specializations where name = 'Jantung' limit 1;
  select id into sp_kandungan_id from public.specializations where name = 'Kandungan & Ginekologi' limit 1;
  select id into sp_ortopedi_id from public.specializations where name = 'Ortopedi' limit 1;

  select id into klinik1_id from public.clinics where name = 'Klinik Sehat Keluarga' limit 1;
  select id into klinik2_id from public.clinics where name = 'RSIA Bunda Sejahtera' limit 1;
  select id into klinik3_id from public.clinics where name = 'Klinik Medika Utama' limit 1;
  select id into klinik4_id from public.clinics where name = 'Poliklinik Dokter Keluarga' limit 1;
  select id into klinik5_id from public.clinics where name = 'Klinik Prima Husada' limit 1;

  -- Dokter Umum
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik1_id, sp_umum_id, 'dr. Andi Pratama, Sp.PD', null, 'Dokter umum dengan pengalaman di RS Pusat Angkatan Darat.', 10, 'FK Universitas Indonesia', 150000, 4.8, 120),
    (gen_random_uuid(), klinik3_id, sp_umum_id, 'dr. Sari Dewi, M.Kes', null, 'Melayani konsultasi umum dan pemeriksaan kesehatan rutin.', 8, 'FK Universitas Gadjah Mada', 120000, 4.6, 85);

  -- Dokter Anak
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik2_id, sp_anak_id, 'dr. Rina Amelia, Sp.A', null, 'Spesialis anak, lulusan FK UI.', 12, 'FK Universitas Indonesia', 200000, 4.9, 200),
    (gen_random_uuid(), klinik4_id, sp_anak_id, 'dr. Budi Santoso, Sp.A', null, 'Dokter spesialis anak yang ramah dan berpengalaman.', 9, 'FK Universitas Airlangga', 180000, 4.7, 150);

  -- Dokter Kulit
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik5_id, sp_kulit_id, 'dr. Maya Anggraini, Sp.KK', null, 'Spesialis kulit dan kelamin, ahli dalam perawatan kulit wajah.', 7, 'FK Universitas Padjadjaran', 250000, 4.5, 95),
    (gen_random_uuid(), klinik1_id, sp_kulit_id, 'dr. Hendra Wijaya, Sp.KK', null, 'Melayani konsultasi kulit, alergi, dan prosedur laser ringan.', 11, 'FK Universitas Diponegoro', 220000, 4.3, 70);

  -- Dokter Gigi
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik4_id, sp_gigi_id, 'drg. Fitri Handayani', null, 'Dokter gigi umum, berpengalaman dalam perawatan saluran akar.', 6, 'FK Universitas Trisakti', 150000, 4.7, 110),
    (gen_random_uuid(), klinik1_id, sp_gigi_id, 'drg. Arya Kusuma, Sp.BM', null, 'Spesialis bedah mulut, menangani pencabutan gigi bungsu.', 14, 'FK Universitas Indonesia', 300000, 4.8, 180);

  -- Dokter Mata
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik3_id, sp_mata_id, 'dr. Dian Permata, Sp.M', null, 'Spesialis mata, melayani LASIK dan pemeriksaan katarak.', 10, 'FK Universitas Indonesia', 250000, 4.9, 230),
    (gen_random_uuid(), klinik5_id, sp_mata_id, 'dr. Reza Pahlevi, Sp.M', null, 'Dokter spesialis mata ramah dengan pelayanan terbaik.', 8, 'FK Universitas Gadjah Mada', 230000, 4.6, 90);

  -- Dokter THT
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik2_id, sp_tht_id, 'dr. Nina Safitri, Sp.THT-KL', null, 'Spesialis THT, menangani sinusitis dan gangguan pendengaran.', 9, 'FK Universitas Airlangga', 200000, 4.4, 65),
    (gen_random_uuid(), klinik4_id, sp_tht_id, 'dr. Tommy Gunawan, Sp.THT', null, 'Berpengalaman dalam operasi amandel dan sinus.', 13, 'FK Universitas Indonesia', 220000, 4.5, 78);

  -- Dokter Saraf
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik5_id, sp_saraf_id, 'dr. Amelia Putri, Sp.S', null, 'Spesialis saraf, ahli dalam penanganan migrain dan stroke.', 11, 'FK Universitas Indonesia', 350000, 4.8, 140),
    (gen_random_uuid(), klinik1_id, sp_saraf_id, 'dr. Dimas Aryanto, Sp.S', null, 'Konsultan saraf dengan pendekatan diagnostik modern.', 9, 'FK Universitas Gadjah Mada', 320000, 4.6, 55);

  -- Dokter Jantung
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik3_id, sp_jantung_id, 'dr. Fajar Ramadhan, Sp.JP', null, 'Spesialis jantung dan pembuluh darah, lulusan FK UI.', 15, 'FK Universitas Indonesia', 400000, 4.9, 310),
    (gen_random_uuid(), klinik2_id, sp_jantung_id, 'dr. Indah Lestari, Sp.JP', null, 'Ahli kardiologi intervensi, menangani kateterisasi jantung.', 12, 'FK Universitas Diponegoro', 380000, 4.7, 160);

  -- Dokter Kandungan
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik2_id, sp_kandungan_id, 'dr. Ratna Dewi, Sp.OG', null, 'Spesialis kebidanan dan kandungan, melayani persalinan normal dan SC.', 16, 'FK Universitas Indonesia', 350000, 4.9, 420),
    (gen_random_uuid(), klinik5_id, sp_kandungan_id, 'dr. Surya Dharma, Sp.OG', null, 'Dokter spesialis kandungan dengan pelayanan ramah dan profesional.', 10, 'FK Universitas Gadjah Mada', 300000, 4.6, 95);

  -- Dokter Ortopedi
  insert into public.doctors (id, clinic_id, specialization_id, full_name, photo_url, description, experience_years, education, consultation_fee, rating_avg, rating_count)
  values
    (gen_random_uuid(), klinik3_id, sp_ortopedi_id, 'dr. Agus Wijaya, Sp.OT', null, 'Spesialis ortopedi, menangani cedera olahraga dan patah tulang.', 13, 'FK Universitas Airlangga', 300000, 4.7, 175),
    (gen_random_uuid(), klinik1_id, sp_ortopedi_id, 'dr. Lisa Kartika, Sp.OT', null, 'Ahli ortopedi dengan fokus pada rehabilitasi cedera sendi.', 8, 'FK Universitas Padjadjaran', 280000, 4.5, 60);
end $$;

-- =============================================================================
-- 6. DOCTOR SCHEDULES (template jadwal mingguan)
--    Senin-Jumat 09:00-17:00, Sabtu 09:00-13:00, slot 30 menit
-- =============================================================================
do $$
declare
  doc record;
begin
  for doc in select id from public.doctors loop
    for day in 1..5 loop
      insert into public.doctor_schedules (id, doctor_id, day_of_week, start_time, end_time, slot_duration_minutes)
      values (gen_random_uuid(), doc.id, day, '09:00'::time, '17:00'::time, 30);
    end loop;
    insert into public.doctor_schedules (id, doctor_id, day_of_week, start_time, end_time, slot_duration_minutes)
    values (gen_random_uuid(), doc.id, 6, '09:00'::time, '13:00'::time, 30);
  end loop;
end $$;

-- =============================================================================
-- 7. DOCTOR SLOTS (slot konkret — di-generate 7 hari ke depan)
-- =============================================================================
do $$
declare
  sched record;
  target_date date;
  v_start time;
  v_end time;
  day_offset int;
begin
  for day_offset in 0..6 loop
    target_date := current_date + day_offset;
    for sched in
      select ds.id as schedule_id, ds.doctor_id,
             ds.start_time, ds.end_time, ds.slot_duration_minutes
      from public.doctor_schedules ds
      where ds.day_of_week = extract(dow from target_date)::int
        and ds.is_active = true
    loop
      v_start := sched.start_time;
      while v_start + (sched.slot_duration_minutes || ' minutes')::interval <= sched.end_time loop
        v_end := v_start + (sched.slot_duration_minutes || ' minutes')::interval;
        insert into public.doctor_slots (doctor_id, schedule_id, slot_date, slot_start, slot_end, is_booked)
        values (sched.doctor_id, sched.schedule_id, target_date, v_start, v_end, false)
        on conflict (doctor_id, slot_date, slot_start) do nothing;
        v_start := v_end;
      end loop;
    end loop;
  end loop;
end $$;

-- =============================================================================
-- 8. BANNERS (carousel home)
-- =============================================================================
-- image_url: upload file ke storage DULU, lalu isi URL-nya di sini.
--
-- 🖼️ Workflow banner dengan gambar:
--   1. Taruh file banner-promo.jpg di supabase/seed-assets/
--   2. Upload ke storage:
--        cd supabase
--        powershell -File seed-assets.ps1
--   3. Hasil: file tersimpan di bucket 'avatars' dengan public URL:
--        http://127.0.0.1:54321/storage/v1/object/public/avatars/banner-promo.jpg
--   4. Di seed.sql, isi image_url dengan URL tersebut (lihat contoh di bawah)
--   5. Jalankan: supabase db seed
--
-- ⚠️ Storage files persist walau db di-reset. Upload cukup sekali.
-- =============================================================================
insert into public.banners (id, title, image_url, action_url, display_order, is_active)
values
  (gen_random_uuid(), 'Promo Spesial Konsultasi', null, null, 1, true),
  (gen_random_uuid(), 'Cek Kesehatan Gratis',     null, null, 2, true),
  (gen_random_uuid(), 'Vaksinasi Anak',           null, null, 3, true);

-- -- CONTOH: Banner dengan gambar dari storage
-- -- Prasyarat: jalankan dulu: cd supabase && powershell -File seed-assets.ps1
-- -- (File banner-promo.jpg harus ada di seed-assets/)
-- insert into public.banners (id, title, image_url, action_url, display_order, is_active, starts_at, ends_at)
-- values (
--   gen_random_uuid(),
--   'Promo Bulan Ini',
--   'http://127.0.0.1:54321/storage/v1/object/public/avatars/banner-promo.jpg',
--   'https://healthpal.app/promo',
--   4, true,
--   now(),
--   now() + interval '30 days'
-- );

-- =============================================================================
-- CATATAN: TABEL LAIN (seed via SQL manual)
-- =============================================================================

-- ── APPOINTMENTS ─────────────────────────────────────────────────────────────
-- insert into public.appointments (patient_id, doctor_id, slot_id, status, complaint_note, consultation_fee_snapshot)
-- select
--   up.id, ds.doctor_id, ds.id, 'upcoming',
--   'Batuk dan pilek sejak 3 hari',
--   d.consultation_fee
-- from public.doctor_slots ds
-- join public.doctors d on d.id = ds.doctor_id
-- join public.user_profiles up on up.auth_id = (select id from auth.users where email = 'test@example.com')
-- where ds.is_booked = false
-- limit 1;

-- ── NOTIFICATIONS ────────────────────────────────────────────────────────────
-- insert into public.notifications (user_id, appointment_id, type, title, body)
-- select up.id, a.id, 'booking_success', 'Janji Temu Berhasil', 'Janji temu dengan dr. xxx telah dibuat.'
-- from public.user_profiles up
-- join public.appointments a on a.patient_id = up.id
-- where up.auth_id = (select id from auth.users where email = 'test@example.com');

-- ── USER FCM TOKENS ──────────────────────────────────────────────────────────
-- insert into public.user_fcm_tokens (user_id, fcm_token, platform)
-- values (
--   (select id from user_profiles where auth_id = (select id from auth.users where email = 'test@example.com')),
--   'fcm-token-dari-perangkat',
--   'android'
-- );
