-- =============================================================
-- 017_add_doctor_id_to_create_appointment_rpc.sql
-- Fix: tambah d.id dan d.experience_years di nested doctors
-- object response create_appointment RPC.
--
-- Root cause: AppointmentDoctorModel membutuhkan field 'id'
-- sebagai required field. RPC response sebelumnya hanya mengirim
-- full_name, photo_url, dan specializations — tanpa id.
-- Saat AppointmentModel.fromJson memparse response, freezed
-- throw TypeError karena missing required field 'id'.
--
-- Akibat: booking terlihat "sukses" di DB (insert sukses,
-- is_booked=true) tapi Flutter tidak bisa render success page
-- karena parse error. Error ditangkap oleh catch di repository
-- dan dikembalikan sebagai Result.failure.
-- =============================================================

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

  -- 6. Return appointment data — WAJIB include d.id + d.experience_years
  --    (AppointmentDoctorModel requires id, experience_years for fromJson)
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
        'id', d.id,
        'full_name', d.full_name,
        'photo_url', d.photo_url,
        'experience_years', d.experience_years,
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
