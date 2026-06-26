-- Migration: Clinic Card v2 — rating, review, category, duration
-- ADR-005: redesign Clinic Card dengan informasi lebih kaya
-- ============================================================

-- ============================================================
-- 1. EXTEND public.clinics TABLE
-- ============================================================

alter table public.clinics
add column if not exists rating_avg numeric(2,1) not null default 0;

alter table public.clinics
add column if not exists review_count int not null default 0;

alter table public.clinics
add column if not exists category text;

comment on column public.clinics.rating_avg is
  'Rating rata-rata klinik (0.0 – 5.0). Denormalized — di-update via '
  'trigger saat ada review baru (future). Default 0 untuk MVP.';

comment on column public.clinics.review_count is
  'Jumlah review yang masuk untuk klinik ini. Denormalized. Default 0 untuk MVP.';

comment on column public.clinics.category is
  'Jenis fasilitas: Hospital, Clinic, Laboratory, Pharmacy, dll. '
  'Digunakan untuk badge di Clinic Card v2.0. Nullable — fallback ke Clinic.';

-- ============================================================
-- 2. UPDATE RPC get_nearby_clinics
-- ============================================================
-- Menambahkan: rating_avg, review_count, category, duration_minutes
-- duration_minutes = estimasi waktu tempuh dengan asumsi 30 km/jam
-- NOTE: DROP dulu karena PostgreSQL tidak izinkan ALTER return type
-- via CREATE OR REPLACE FUNCTION.

drop function if exists public.get_nearby_clinics;

create or replace function public.get_nearby_clinics(
  user_lat double precision,
  user_lng double precision,
  radius_meters double precision default 10000
)
returns table (
  id                uuid,
  name              text,
  address           text,
  city              text,
  latitude          double precision,
  longitude         double precision,
  phone             text,
  image_url         text,
  distance_meters   double precision,
  doctor_count      bigint,
  rating_avg        numeric(2,1),
  review_count      int,
  category          text,
  duration_minutes  int
)
language sql
stable
as $$
  select
    c.id,
    c.name,
    c.address,
    c.city,
    c.latitude,
    c.longitude,
    c.phone,
    c.image_url,
    (
      6371000 * acos(
        cos(radians(user_lat)) * cos(radians(c.latitude)) *
        cos(radians(c.longitude) - radians(user_lng)) +
        sin(radians(user_lat)) * sin(radians(c.latitude))
      )
    ) as distance_meters,
    coalesce(dc.doctor_count, 0) as doctor_count,
    c.rating_avg,
    c.review_count,
    c.category,
    (
      round(
        (6371000 * acos(
          cos(radians(user_lat)) * cos(radians(c.latitude)) *
          cos(radians(c.longitude) - radians(user_lng)) +
          sin(radians(user_lat)) * sin(radians(c.latitude))
        ) / 1000.0) / 30.0 * 60
      )
    )::int as duration_minutes
  from clinics c
  left join (
    select clinic_id, count(*) as doctor_count
    from doctors
    where is_active = true
    group by clinic_id
  ) dc on c.id = dc.clinic_id
  where (
    6371000 * acos(
      cos(radians(user_lat)) * cos(radians(c.latitude)) *
      cos(radians(c.longitude) - radians(user_lng)) +
      sin(radians(user_lat)) * sin(radians(c.latitude))
    )
  ) <= radius_meters
  order by distance_meters asc;
$$;

grant execute on function public.get_nearby_clinics
  to authenticated, anon;
