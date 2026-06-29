-- =============================================================
-- 014_security_definer_rpc.sql
-- Ubah create_appointment + cancel_appointment ke SECURITY DEFINER.
--
-- Latar belakang: function ini menggunakan SELECT ... FOR UPDATE
-- di doctor_slots. Dengan SECURITY INVOKER (default), FOR UPDATE
-- memerlukan UPDATE privilege pada doctor_slots untuk role
-- authenticated. Karena tidak ada UPDATE RLS policy di
-- doctor_slots, function crash dengan SLOT_NOT_FOUND saat
-- dipanggil via PostgREST.
--
-- Solusi: SECURITY DEFINER — function berjalan dengan privilege
-- pemilik (postgres). auth.uid() tetap bisa diakses karena
-- membaca dari GUC request.jwt.claim.sub yang di-set oleh
-- PostgREST per-request.
--
-- Keamanan tetap terjaga karena:
-- - auth.uid() resolve otomatis dari JWT caller
-- - create_appointment: lookup patient_id dari auth.uid() → HANYA
--   appointment milik caller yang dibuat
-- - cancel_appointment: FOR UPDATE + validasi ownership explicit
--   (v_appt.patient_id <> v_patient_id)
-- =============================================================

-- 1. Re-create create_appointment dengan SECURITY DEFINER
create or replace function public.create_appointment(
  p_doctor_id uuid,
  p_slot_id uuid,
  p_complaint_note text default null
) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_fee numeric(12,2);
  v_appointment_id uuid;
  v_patient_id uuid;
  v_slot_booked boolean;
begin
  -- 1. Lock + check slot availability
  select is_booked into v_slot_booked
  from public.doctor_slots
  where id = p_slot_id
  for update;

  if not found then
    raise exception 'SLOT_NOT_FOUND';
  end if;

  if v_slot_booked then
    raise exception 'SLOT_ALREADY_BOOKED';
  end if;

  -- 2. Get consultation fee snapshot
  select consultation_fee into v_fee
  from public.doctors
  where id = p_doctor_id;

  if not found then
    raise exception 'DOCTOR_NOT_FOUND';
  end if;

  -- 3. Lookup patient_id from auth.uid() -> user_profiles
  select id into v_patient_id
  from public.user_profiles
  where auth_id = auth.uid();

  if not found then
    raise exception 'USER_PROFILE_NOT_FOUND';
  end if;

  -- 4. Insert appointment
  insert into public.appointments (patient_id, doctor_id, slot_id, consultation_fee_snapshot, complaint_note)
  values (v_patient_id, p_doctor_id, p_slot_id, v_fee, p_complaint_note)
  returning id into v_appointment_id;

  -- 5. Update slot booked flag
  update public.doctor_slots set is_booked = true where id = p_slot_id;

  -- 6. Return appointment data
  return (
    select jsonb_build_object(
      'id', a.id,
      'patient_id', a.patient_id,
      'doctor_id', a.doctor_id,
      'slot_id', a.slot_id,
      'status', a.status,
      'complaint_note', a.complaint_note,
      'consultation_fee_snapshot', a.consultation_fee_snapshot,
      'booked_at', a.booked_at,
      'created_at', a.created_at,
      'doctors', jsonb_build_object(
        'full_name', d.full_name,
        'photo_url', d.photo_url,
        'specializations', jsonb_build_object('name', s.name)
      ),
      'slots', jsonb_build_object(
        'slot_date', ds.slot_date,
        'slot_start', ds.slot_start,
        'slot_end', ds.slot_end
      )
    )
    from public.appointments a
    join public.doctors d on d.id = a.doctor_id
    join public.specializations s on s.id = d.specialization_id
    join public.doctor_slots ds on ds.id = a.slot_id
    where a.id = v_appointment_id
  );
end;
$$;

-- 2. Re-create cancel_appointment dengan SECURITY DEFINER
create or replace function public.cancel_appointment(
  p_appointment_id uuid,
  p_cancellation_reason text default null,
  p_min_cancel_minutes int default 60
) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_patient_id uuid;
  v_appt appointments%rowtype;
  v_slot_date date;
  v_slot_start time without time zone;
  v_minutes_until_slot int;
begin
  -- 1. Lookup patient_id dari auth.uid()
  select id into v_patient_id
  from public.user_profiles
  where auth_id = auth.uid();

  if not found then
    raise exception 'USER_PROFILE_NOT_FOUND';
  end if;

  -- 2. Lock + fetch appointment row
  select * into v_appt
  from public.appointments
  where id = p_appointment_id
  for update;

  if not found then
    raise exception 'APPOINTMENT_NOT_FOUND';
  end if;

  -- 3. Validasi ownership
  if v_appt.patient_id <> v_patient_id then
    raise exception 'FORBIDDEN';
  end if;

  -- 4. Validasi status transition
  if v_appt.status not in ('pending', 'upcoming') then
    raise exception 'INVALID_STATUS_TRANSITION';
  end if;

  -- 5. Validasi cancel window (default 60 menit — placeholder)
  select slot_date, slot_start into v_slot_date, v_slot_start
  from public.doctor_slots
  where id = v_appt.slot_id;

  if found then
    v_minutes_until_slot := extract(epoch from (
      v_slot_date + v_slot_start - now()
    )) / 60;

    if v_minutes_until_slot < p_min_cancel_minutes then
      raise exception 'CANCEL_WINDOW_EXPIRED';
    end if;
  end if;

  -- 6. Atomic update (trigger release slot otomatis)
  update public.appointments
  set status = 'cancelled',
      cancelled_at = now(),
      cancellation_reason = p_cancellation_reason,
      updated_at = now()
  where id = p_appointment_id;

  -- 7. Return response
  return jsonb_build_object(
    'id', v_appt.id,
    'status', 'cancelled',
    'cancelled_at', now(),
    'cancellation_reason', p_cancellation_reason,
    'patient_id', v_appt.patient_id,
    'doctor_id', v_appt.doctor_id,
    'slot_id', v_appt.slot_id
  );
end;
$$;
