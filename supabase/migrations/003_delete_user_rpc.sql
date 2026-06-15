-- Migration 003: delete_user() RPC function
--
-- BUG-004-D: self-delete user dari auth.users setelah atomic
-- registerAndCreateProfile gagal (mis. INSERT user_profiles error
-- setelah signUp sukses). Tanpa fungsi ini, ghost account tercipta:
-- auth.users row exists tapi user_profiles kosong.
--
-- Dipanggil dari Flutter via: _client.rpc('delete_user')
-- RLS: hanya men-delete user dengan auth.uid() yang sama.
-- Security definer: berjalan dengan privilege owner (superuser)
-- untuk bisa delete dari auth.users (yang biasanya restricted).

create or replace function delete_user()
returns void
language plpgsql
security definer
as $$
begin
  delete from auth.users where id = auth.uid();
end;
$$;
