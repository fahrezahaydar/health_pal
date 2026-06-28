-- =============================================================
-- 010_slot_booked_trigger.sql
-- Trigger untuk menjaga konsistensi doctor_slots.is_booked
-- + Function create_appointment untuk atomic transaction
-- Berdasarkan ERD §4.4 dan ADR-011
-- =============================================================

-- 1. Trigger function: set slot booked/unbooked berdasarkan appointment
create or replace function public.set_slot_booked_on_appointment()
returns trigger as $$
begin
  if tg_op = 'INSERT' then
    update public.doctor_slots
    set is_booked = true
    where id = new.slot_id;
    return new;
  elsif tg_op = 'UPDATE' and new.status = 'cancelled' then
    update public.doctor_slots
    set is_booked = false
    where id = old.slot_id;
    return new;
  end if;
  return new;
end;
$$ language plpgsql;

-- 2. Trigger: set booked saat appointment dibuat
create trigger trg_slot_booked_on_appointment
  after insert on public.appointments
  for each row
  execute function public.set_slot_booked_on_appointment();

-- 3. Trigger: unbook saat appointment dibatalkan
create trigger trg_slot_unbooked_on_cancellation
  after update of status on public.appointments
  for each row
  when (new.status = 'cancelled')
  execute function public.set_slot_booked_on_appointment();

-- 4. Function: atomic create appointment (dipanggil via RPC — PostgREST)
-- p_patient_id diambil dari auth.uid() via RLS atau subquery
create or replace function public.create_appointment(
  p_doctor_id uuid,
  p_slot_id uuid,
  p_complaint_note text default null
) returns jsonb
language plpgsql
as $$
declare
  v_fee numeric(12,2);
  v_appointment_id uuid;
  v_slot_booked boolean;
  v_doctor_name text;
  v_clinic_name text;
  v_slot_date date;
  v_slot_start time;
  v_slot_end time;
begin
  -- Lock slot row to prevent race condition
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

  -- Get consultation fee snapshot
  select consultation_fee into v_fee
  from public.doctors
  where id = p_doctor_id;

  if not found then
    raise exception 'DOCTOR_NOT_FOUND';
  end if;

  -- Insert appointment (patient_id dari auth.uid())
  insert into public.appointments (patient_id, doctor_id, slot_id, consultation_fee_snapshot, complaint_note)
  values (auth.uid(), p_doctor_id, p_slot_id, v_fee, p_complaint_note)
  returning id into v_appointment_id;

  -- Get doctor + clinic name for notification
  select d.full_name, c.name into v_doctor_name, v_clinic_name
  from public.doctors d
  join public.clinics c on c.id = d.clinic_id
  where d.id = p_doctor_id;

  -- Get slot info
  select slot_date, slot_start, slot_end into v_slot_date, v_slot_start, v_slot_end
  from public.doctor_slots
  where id = p_slot_id;

  -- Insert notification (user_id dari auth.uid())
  insert into public.notifications (user_id, appointment_id, type, title, body)
  values (
    auth.uid(),
    v_appointment_id,
    'booking_success',
    'Booking Berhasil',
    format('Booking kamu dengan %s di %s sudah berhasil dibuat. Jadwal: %s %s.',
      v_doctor_name, v_clinic_name, v_slot_date::text, v_slot_start::text)
  );

  -- Return appointment data with nested relations
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
