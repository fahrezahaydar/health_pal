-- =============================================================
-- 001_initial_schema.sql
-- Schema migration untuk health_pal
-- Berdasarkan ERD v1.0
-- =============================================================

-- 1. EXTENSION
create extension if not exists "pgcrypto" with schema "extensions";

-- 2. CUSTOM ENUMS
create type gender_type as enum ('male', 'female', 'other');
create type appointment_status as enum ('pending', 'upcoming', 'completed', 'cancelled');
create type notif_type as enum ('booking_success', 'booking_confirmed', 'reminder_h1', 'reminder_h0', 'booking_cancelled');
create type fcm_platform as enum ('android', 'ios');

-- 3. TABLES

-- User profiles (one-to-one with auth.users)
create table public.user_profiles (
  id            uuid primary key default gen_random_uuid(),
  auth_id       uuid not null unique references auth.users(id) on delete cascade,
  full_name     text not null,
  nickname      text,
  avatar_url    text,
  date_of_birth date,
  gender        gender_type,
  notif_reminder_enabled boolean not null default true,
  is_profile_complete    boolean not null default false,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- FCM tokens per device per user
create table public.user_fcm_tokens (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.user_profiles(id) on delete cascade,
  fcm_token  text not null,
  platform   fcm_platform not null,
  updated_at timestamptz not null default now()
);

-- Specializations (master data)
create table public.specializations (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  icon_url   text,
  created_at timestamptz not null default now()
);

-- Clinics
create table public.clinics (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  address    text,
  city       text,
  latitude   float8,
  longitude  float8,
  phone      text,
  image_url  text,
  created_at timestamptz not null default now()
);

-- Doctors
create table public.doctors (
  id                uuid primary key default gen_random_uuid(),
  clinic_id         uuid not null references public.clinics(id),
  specialization_id uuid not null references public.specializations(id),
  full_name         text not null,
  photo_url         text,
  description       text,
  experience_years  int2,
  education         text,
  consultation_fee  numeric(12,2) not null default 0,
  rating_avg        numeric(3,2) not null default 0.00,
  rating_count      int4 not null default 0,
  is_active         boolean not null default true,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

-- Doctor schedules (template — weekly pattern)
create table public.doctor_schedules (
  id                  uuid primary key default gen_random_uuid(),
  doctor_id           uuid not null references public.doctors(id) on delete cascade,
  day_of_week         int2 not null check (day_of_week between 0 and 6),
  start_time          time not null,
  end_time            time not null,
  slot_duration_minutes int2 not null default 30,
  is_active           boolean not null default true,
  created_at          timestamptz not null default now()
);

-- Doctor slots (concrete instances generated from schedules)
create table public.doctor_slots (
  id          uuid primary key default gen_random_uuid(),
  doctor_id   uuid not null references public.doctors(id) on delete cascade,
  schedule_id uuid not null references public.doctor_schedules(id) on delete cascade,
  slot_date   date not null,
  slot_start  time not null,
  slot_end    time not null,
  is_booked   boolean not null default false,
  created_at  timestamptz not null default now(),
  constraint unique_doctor_slot unique (doctor_id, slot_date, slot_start)
);

-- Appointments
create table public.appointments (
  id                       uuid primary key default gen_random_uuid(),
  patient_id               uuid not null references public.user_profiles(id),
  doctor_id                uuid not null references public.doctors(id),
  slot_id                  uuid not null references public.doctor_slots(id),
  status                   appointment_status not null default 'pending',
  complaint_note           text,
  consultation_fee_snapshot numeric(12,2) not null,
  booked_at                timestamptz not null default now(),
  confirmed_at             timestamptz,
  completed_at             timestamptz,
  cancelled_at             timestamptz,
  cancellation_reason      text,
  created_at               timestamptz not null default now(),
  updated_at               timestamptz not null default now()
);

-- Banners (for home carousel)
create table public.banners (
  id            uuid primary key default gen_random_uuid(),
  title         text not null,
  image_url     text,
  action_url    text,
  display_order int2 not null default 0,
  is_active     boolean not null default true,
  starts_at     timestamptz,
  ends_at       timestamptz,
  created_at    timestamptz not null default now()
);

-- Notifications (in-app inbox + audit log)
create table public.notifications (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references public.user_profiles(id),
  appointment_id uuid references public.appointments(id),
  type           notif_type not null,
  title          text not null,
  body           text,
  is_read        boolean not null default false,
  sent_at        timestamptz not null default now(),
  created_at     timestamptz not null default now()
);

-- 4. TRIGGER: auto-update updated_at

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_user_profiles_updated_at
  before update on public.user_profiles
  for each row execute function public.set_updated_at();

create trigger trg_doctors_updated_at
  before update on public.doctors
  for each row execute function public.set_updated_at();

create trigger trg_appointments_updated_at
  before update on public.appointments
  for each row execute function public.set_updated_at();

-- 5. TRIGGER: sync is_booked on appointment changes

create or replace function public.sync_slot_booking()
returns trigger as $$
begin
  if tg_op = 'INSERT' then
    update public.doctor_slots set is_booked = true where id = new.slot_id;
  elsif tg_op = 'UPDATE' and new.status = 'cancelled' then
    update public.doctor_slots set is_booked = false where id = new.slot_id;
  elsif tg_op = 'DELETE' then
    update public.doctor_slots set is_booked = false where id = old.slot_id;
  end if;
  return new;
end;
$$ language plpgsql;

create trigger trg_appointments_sync_slot
  after insert or update or delete on public.appointments
  for each row execute function public.sync_slot_booking();

-- 6. INDEXES

-- Doctors
create index idx_doctors_specialization on public.doctors(specialization_id);
create index idx_doctors_clinic on public.doctors(clinic_id);
create index idx_doctors_active on public.doctors(is_active) where is_active = true;

-- Clinics
create index idx_clinics_city on public.clinics(city);

-- Slots
create index idx_slots_doctor_date on public.doctor_slots(doctor_id, slot_date);
create index idx_slots_available on public.doctor_slots(doctor_id, slot_date, is_booked) where is_booked = false;

-- Appointments
create index idx_appointments_patient on public.appointments(patient_id);
create index idx_appointments_status on public.appointments(patient_id, status);
create index idx_appointments_upcoming on public.appointments(patient_id, status) where status in ('pending', 'upcoming');

-- Notifications
create index idx_notifications_user on public.notifications(user_id, sent_at desc);

-- FCM tokens (unique per user + platform for UPSERT)
create unique index idx_fcm_user_platform on public.user_fcm_tokens(user_id, platform);

-- 7. ENABLE RLS

-- Public read tables
alter table public.specializations enable row level security;
alter table public.clinics enable row level security;
alter table public.doctors enable row level security;
alter table public.doctor_schedules enable row level security;
alter table public.doctor_slots enable row level security;
alter table public.banners enable row level security;

-- User-specific tables
alter table public.user_profiles enable row level security;
alter table public.user_fcm_tokens enable row level security;
alter table public.appointments enable row level security;
alter table public.notifications enable row level security;

-- 8. RLS POLICIES

-- Public read for master data
create policy "Public read specializations"
  on public.specializations for select using (true);

create policy "Public read clinics"
  on public.clinics for select using (true);

create policy "Public read doctors"
  on public.doctors for select using (true);

create policy "Public read schedules"
  on public.doctor_schedules for select using (true);

create policy "Public read slots"
  on public.doctor_slots for select using (true);

create policy "Public read banners (active only)"
  on public.banners for select
  using (
    is_active = true
    and (starts_at is null or starts_at <= now())
    and (ends_at is null or ends_at >= now())
  );

-- User profiles: user can read/update their own
create policy "User select own profile"
  on public.user_profiles for select
  using (auth.uid() = auth_id);

create policy "User insert own profile"
  on public.user_profiles for insert
  with check (auth.uid() = auth_id);

create policy "User update own profile"
  on public.user_profiles for update
  using (auth.uid() = auth_id);

-- FCM tokens: user can manage their own
create policy "User manage own fcm tokens"
  on public.user_fcm_tokens for all
  using (
    auth.uid() = (select auth_id from public.user_profiles where id = user_id)
  );

-- Appointments: patient can read/insert/update (cancel) their own
create policy "Patient select own appointments"
  on public.appointments for select
  using (
    auth.uid() = (select auth_id from public.user_profiles where id = patient_id)
  );

create policy "Patient insert own appointments"
  on public.appointments for insert
  with check (
    auth.uid() = (select auth_id from public.user_profiles where id = patient_id)
  );

create policy "Patient cancel own appointments"
  on public.appointments for update
  using (
    auth.uid() = (select auth_id from public.user_profiles where id = patient_id)
    and status in ('pending', 'upcoming')
  );

-- Notifications: user can read/update own
create policy "User manage own notifications"
  on public.notifications for select
  using (
    auth.uid() = (select auth_id from public.user_profiles where id = user_id)
  );

create policy "User update own notifications"
  on public.notifications for update
  using (
    auth.uid() = (select auth_id from public.user_profiles where id = user_id)
  );
