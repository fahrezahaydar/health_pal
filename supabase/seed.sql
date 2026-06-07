-- =============================================================
-- seed.sql
-- Data dummy untuk development health_pal
-- =============================================================

-- Pastikan ekstensi pgcrypto untuk gen_random_uuid()
create extension if not exists "pgcrypto" with schema "extensions";

-- Spesialisasi
insert into public.specializations (id, name, icon_url) values
  (gen_random_uuid(), 'Umum', null),
  (gen_random_uuid(), 'Anak', null),
  (gen_random_uuid(), 'Kulit & Kelamin', null),
  (gen_random_uuid(), 'Gigi', null),
  (gen_random_uuid(), 'Mata', null),
  (gen_random_uuid(), 'THT', null),
  (gen_random_uuid(), 'Saraf', null),
  (gen_random_uuid(), 'Jantung', null),
  (gen_random_uuid(), 'Kandungan & Ginekologi', null),
  (gen_random_uuid(), 'Ortopedi', null);

-- Klinik (5 klinik di Jakarta)
with clinic_data as (
  select * from (values
    ('Klinik Sehat Keluarga', 'Jl. Sudirman No. 123, Jakarta Pusat', 'Jakarta Pusat', -6.2088, 106.8456, '021-12345678'),
    ('RSIA Bunda Sejahtera', 'Jl. Gatot Subroto No. 45, Jakarta Selatan', 'Jakarta Selatan', -6.2387, 106.8244, '021-87654321'),
    ('Klinik Medika Utama', 'Jl. Kemang Raya No. 78, Jakarta Selatan', 'Jakarta Selatan', -6.2612, 106.8081, '021-23456789'),
    ('Poliklinik Dokter Keluarga', 'Jl. Kelapa Gading Raya No. 15, Jakarta Utara', 'Jakarta Utara', -6.1578, 106.9050, '021-34567890'),
    ('Klinik Prima Husada', 'Jl. Fatmawati No. 200, Jakarta Selatan', 'Jakarta Selatan', -6.2893, 106.7922, '021-45678901')
  ) as t(name, address, city, lat, lng, phone)
)
insert into public.clinics (id, name, address, city, latitude, longitude, phone)
select gen_random_uuid(), name, address, city, lat, lng, phone
from clinic_data;

-- Dokter (2 per spesialisasi = 20 dokter)
-- Note: gunakan subquery untuk mendapatkan ID spesialisasi dan klinik
do $$
declare
  sp_umum_id uuid; sp_anak_id uuid; sp_kulit_id uuid; sp_gigi_id uuid;
  sp_mata_id uuid; sp_tht_id uuid; sp_saraf_id uuid; sp_jantung_id uuid;
  sp_kandungan_id uuid; sp_ortopedi_id uuid;
  klinik1_id uuid; klinik2_id uuid; klinik3_id uuid; klinik4_id uuid; klinik5_id uuid;
begin
  -- Get specialization IDs
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

  -- Get clinic IDs
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
    (gen_random_uuid(), klinik2_id, sp_anak_id, 'dr. Rina Amelia, Sp.A', null, 'Spesialis anak, lulusan FK UI. Berpengalaman menangani tumbuh kembang anak.', 12, 'FK Universitas Indonesia', 200000, 4.9, 200),
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

-- Jadwal dokter (template mingguan)
-- Semua dokter: Senin-Jumat 09:00-17:00, Sabtu 09:00-13:00, slot 30 menit
do $$
declare
  doc record;
  sched_id uuid;
  day int;
begin
  for doc in select id from public.doctors loop
    -- Senin (1) - Jumat (5): 09:00 - 17:00
    for day in 1..5 loop
      insert into public.doctor_schedules (id, doctor_id, day_of_week, start_time, end_time, slot_duration_minutes)
      values (gen_random_uuid(), doc.id, day, '09:00'::time, '17:00'::time, 30);
    end loop;
    -- Sabtu (6): 09:00 - 13:00
    insert into public.doctor_schedules (id, doctor_id, day_of_week, start_time, end_time, slot_duration_minutes)
    values (gen_random_uuid(), doc.id, 6, '09:00'::time, '13:00'::time, 30);
  end loop;
end $$;

-- Banner
insert into public.banners (id, title, image_url, action_url, display_order, is_active)
values
  (gen_random_uuid(), 'Promo Spesial Konsultasi', null, null, 1, true),
  (gen_random_uuid(), 'Cek Kesehatan Gratis', null, null, 2, true),
  (gen_random_uuid(), 'Vaksinasi Anak', null, null, 3, true);
