-- =============================================================
-- 016_appointments_update_with_check.sql
-- Tambah WITH CHECK clause di RLS UPDATE policy appointments.
--
-- Sebelumnya policy hanya punya USING (validasi old row),
-- tanpa WITH CHECK (validasi new row). Artinya user secara
-- teoritis bisa update row ke status apapun setelah melewati
-- USING check (mis. rollback cancelled → pending).
--
-- WITH CHECK memvalidasi new row:
-- - patient_id masih milik user yang sama
-- - status hanya bisa jadi 'cancelled'
-- =============================================================

drop policy if exists "Patient cancel own appointments" on public.appointments;

create policy "Patient cancel own appointments"
  on public.appointments for update
  using (
    auth.uid() = (select auth_id from public.user_profiles where id = patient_id)
    and status in ('pending', 'upcoming')
  )
  with check (
    auth.uid() = (select auth_id from public.user_profiles where id = patient_id)
    and status = 'cancelled'
  );
