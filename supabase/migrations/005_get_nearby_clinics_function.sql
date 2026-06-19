-- =============================================================
-- 005_get_nearby_clinics_function.sql
-- PostgreSQL function untuk nearby clinics search (Haversine).
-- Per API Contract §5.5 — `POST /rest/v1/rpc/get_nearby_clinics`.
-- =============================================================

create or replace function public.get_nearby_clinics(
  user_lat double precision,
  user_lng double precision,
  radius_meters double precision default 10000
)
returns table (
  id              uuid,
  name            text,
  address         text,
  city            text,
  latitude        double precision,
  longitude       double precision,
  phone           text,
  image_url       text,
  distance_meters double precision,
  doctor_count    bigint
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
    coalesce(dc.doctor_count, 0) as doctor_count
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
