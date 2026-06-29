-- =============================================================
-- 013_cancel_appointment_rpc.sql
-- RPC function untuk cancel appointment — atomic, terjamin.
-- Dipanggil dari Flutter via _client.rpc('cancel_appointment', ...).
--
-- Yang dilakukan dalam 1 function (atomic transaction):
-- 1. Resolve patient_id dari auth.uid()
-- 2. FOR UPDATE lock row appointment
-- 3. Validasi ownership (appointment milik caller)
-- 4. Validasi status transition (hanya pending/upcoming → cancelled)
-- 5. Validasi cancel window (default 60 min before slot — placeholder)
-- 6. UPDATE appointments SET status='cancelled', cancelled_at=now(), ...
-- 7. Trigger trg_slot_unbooked_on_cancellation otomatis release slot
-- 8. Return jsonb response
--
-- FIX #4 dari BUG-006 appointment-backend audit.
-- =============================================================

create or replace function public.cancel_appointment(
  p_appointment_id uuid,
  p_cancellation_reason text default null,
  p_min_cancel_minutes int default 60
) returns jsonb
language plpgsql
as $$
declare
  v_patient_id uuid;
  v_appt appointments%rowtype;
  v_slot_date date;
  v_slot_start time without time zone;
  v_minutes_until_slot int;
begin
  -- 1. Lookup patient_id from auth.uid() -> user_profiles
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

comment on function public.cancel_appointment is
  'Cancel appointment — atomic: validate ownership + status + window, update row, trigger release slot';
