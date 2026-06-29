-- =============================================================
-- 015_auto_set_cancelled_at.sql
-- Safety-net trigger: auto-set cancelled_at = now() saat status
-- transisi ke 'cancelled' jika caller lupa.
--
-- Idempotent: jika caller sudah explicit set cancelled_at
-- (seperti RPC cancel_appointment yang explicit cancelled_at=now()),
-- trigger TIDAK override (kondisi: new.cancelled_at IS NULL).
--
-- Menutup gap: jika ada raw UPDATE appointments SET status='cancelled'
-- lupa cantumkan cancelled_at, trigger ini mencegah data orphan
-- (status='cancelled' tapi cancelled_at=null).
-- =============================================================

-- 1. Trigger function
create or replace function public.set_cancelled_at_on_cancel()
returns trigger
language plpgsql
as $$
begin
  if new.status = 'cancelled' and new.cancelled_at is null then
    new.cancelled_at = now();
  end if;
  return new;
end;
$$;

-- 2. Trigger: BEFORE UPDATE OF status (mencegah data orphan)
create trigger trg_appointments_set_cancelled_at
  before update of status on public.appointments
  for each row
  execute function public.set_cancelled_at_on_cancel();

-- Dokumentasi
comment on function public.set_cancelled_at_on_cancel is
  'Safety net: auto-set cancelled_at = now() jika status ke cancelled dan field kosong';
