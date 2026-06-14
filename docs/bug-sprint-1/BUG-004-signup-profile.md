# BUG-004 — Sign Up Profile Data Issues

**Tanggal:** 2026-06-14
**Feature:** Auth — Sign Up + Create Profile
**Severity:** 🔴 Critical
**Status:** 🚧 In Progress (4/8 fix landed — UI integration pending)

---

## Progress Log

| # | Fix | Commit | Status |
|---|-----|--------|--------|
| 1 | FIX-1: Hapus `signUp()` dari Sign Up page | `920aaf8` | ✅ Done |
| 2 | FIX-2: Hapus `SignUpBloc/Event/State/UseCase` (YAGNI) | `72f6f05` | ✅ Done |
| 3 | FIX-3+4+5: Atomic `registerAndCreateProfile` + `display_name` + cleanup | `68af411` | ✅ Done |
| 4 | FIX-6: Refactor `CreateProfileCubit` ke use case baru | `d0d98e4` | ✅ Done |
| 5 | FIX-7: Update `CreateProfilePage` (form + call new usecase) | — | ⏳ Pending |
| 6 | FIX-8: Verifikasi router redirect | — | ⏳ Pending |

**Branch:** `master` · **Ahead of origin:** 4 commits

**Known broken state:** `create_profile_page.dart:207` masih panggil `cubit.saveProfile(...)` (method lama). `flutter analyze` gagal dengan 1 expected error. Akan di-fix di FIX-7.

---

## Bug List

### BUG-004-A: full_name Tidak Tersimpan ke user_profiles
**Deskripsi:** Setelah sign up, tabel user_profiles tidak terisi `full_name` walau user sudah input nama lengkap di form sign up (name field). Name yang dikumpulkan di sign_up_page **hilang** karena tidak pernah diteruskan ke Supabase Auth maupun user_profiles sampai (dan hanya jika) user menyelesaikan Create Profile page.

**Root Cause:**
- `lib/features/auth/presentation/page/sign_up_page.dart:32` — `_nameController` menampung input name.
- `lib/features/auth/presentation/page/sign_up_page.dart:51-60` — `_onCreateAccount()` mengirim `SignUpSubmitted(name, email, password)` ke BLoC.
- `lib/features/auth/presentation/bloc/sign_up/sign_up_event.dart:7-12` — Event `SignUpSubmitted` membawa `name`, TAPI…
- `lib/features/auth/domain/usecase/sign_up_usecase.dart:13-15` — `call(String email, String password)` **drop parameter name**, hanya forward `email` & `password` ke repository.
- `lib/features/auth/data/repository/auth_repository_impl.dart:47-63` — `signUpWithEmail(email, password)` **tidak** menyimpan name ke mana pun.
- `lib/features/auth/data/datasource/auth_remote_datasource.dart:20-22` — `signUpWithEmail` call `_client.auth.signUp(email: email, password: password)` tanpa `data:` metadata.
- `lib/features/auth/presentation/page/create_profile_page.dart:56` — Name baru di-pre-fill dari `widget.fullname` (extra), dan…
- `lib/features/auth/presentation/page/create_profile_page.dart:207-214` — `full_name` baru masuk ke `saveProfile` data map **hanya jika user submit form create profile**.

Akibat: name yang diinput di sign_up_page TIDAK tersimpan di mana pun sampai user menyelesaikan create profile. Jika user menutup app / abandon flow, name hilang.

**File yang Terimpact:**
- `lib/features/auth/presentation/page/sign_up_page.dart`
- `lib/features/auth/presentation/bloc/sign_up/sign_up_event.dart`
- `lib/features/auth/domain/usecase/sign_up_usecase.dart`
- `lib/features/auth/data/repository/auth_repository_impl.dart`
- `lib/features/auth/data/datasource/auth_remote_datasource.dart`

**Status:** [x] **Code-fixed (FIX-3+4+5+6)** — atomic `registerAndCreateProfile` sekarang INSERT `full_name` ke `user_profiles`. **UI integration pending (FIX-7)** — page belum panggil use case baru.

---

### BUG-004-B: fullName Tidak Disimpan ke Supabase Auth display_name
**Deskripsi:** `fullName` yang diinput saat sign up seharusnya disimpan ke Supabase Auth user metadata sebagai `display_name` (atau key custom) di `auth.users.raw_user_meta_data`, tapi **tidak dilakukan** di mana pun di codebase. Akibat: relogin / refresh token tidak punya display_name untuk greeting di Home / Profile, dan `getCurrentUser()` harus fetch user_profiles dulu hanya untuk dapat nama.

**Root Cause:**
- `lib/features/auth/data/datasource/auth_remote_datasource.dart:20-22` — Implementasi Supabase signUp:

  ```dart
  Future<AuthResponse> signUpWithEmail(String email, String password) {
    return _client.auth.signUp(email: email, password: password);
  }
  ```

  Tidak ada parameter `data: {'display_name': name}` yang seharusnya dikirim untuk set user metadata.

- `lib/features/auth/data/repository/auth_repository_impl.dart:47-63` — `signUpWithEmail` tidak mem-passing name ke datasource.

- `lib/features/auth/domain/usecase/sign_up_usecase.dart:13-15` — `call(String email, String password)` tidak terima name sama sekali.

- Tidak ada method `updateAuthMetadata()` di `AuthRemoteDataSource` untuk post-hoc update metadata.

**File yang Terimpact:**
- `lib/features/auth/data/datasource/auth_remote_datasource.dart`
- `lib/features/auth/data/repository/auth_repository_impl.dart`
- `lib/features/auth/domain/usecase/sign_up_usecase.dart`
- `lib/features/auth/domain/repository/auth_repository.dart`

**Status:** [x] **Code-fixed (FIX-5 + FIX-3+4+5)** — `signUpWithEmail` sekarang support `data:` param, dan `registerAndCreateProfile` pass `{display_name: fullName, is_profile_complete: false}` saat register. Plus `updateAuthMetadata()` untuk refresh post-INSERT. **UI integration pending (FIX-7)**.

---

### BUG-004-C: Ghost Account — Sign Up Tanpa Create Profile
**Deskripsi:** Jika user sign up tapi tidak menyelesaikan create profile (close app, back button berkali-kali, koneksi putus), akun Supabase Auth **sudah terbuat** (`auth.users` ada row baru) tapi `user_profiles` kosong. User dalam state limbo:
- `auth.users` row exists
- `user_profiles` row tidak ada
- Status app jadi `profileIncomplete` (lihat `app_services.setProfileIncomplete()` di sign_up_page line 78)
- User tidak bisa pakai app, tidak bisa "cleanly" retry (email sudah terpakai)

**Root Cause:**
- `lib/features/auth/presentation/page/sign_up_page.dart:51-60` — `_onCreateAccount()` trigger `SignUpBloc` → call `sign_up_usecase` → `signUpWithEmail` → **Supabase `signUp()` dieksekusi di sini**, di Sign Up page.
- `lib/features/auth/data/datasource/auth_remote_datasource.dart:20-22` — Supabase `signUp()` permanent create user di `auth.users` (walau email confirmation bisa di-disable, row tetap ada).
- `lib/features/auth/presentation/page/sign_up_page.dart:79-86` — Baru setelah signUp sukses, navigate ke `createProfile` dengan extra `{email, password, name}`. Tapi user bisa:
  - Kill app
  - Klik back (line 110 — `context.pop()` di create_profile_page)
  - Kehilangan koneksi
- Hasil: `auth.users` ada row, `user_profiles` kosong selamanya (kecuali manual SQL cleanup).

**Keputusan Refactor:** Pindahkan `signUp()` ke Create Profile page sehingga jika user tidak selesai create profile = **tidak ada akun terbuat sama sekali** (atomic all-or-nothing). Tambah fallback `deleteCurrentUser()` jika salah satu step di tengah flow gagal (mis. upload avatar sukses tapi INSERT user_profiles gagal).

**File yang Terimpact:**
- `lib/features/auth/presentation/page/sign_up_page.dart`
- `lib/features/auth/presentation/bloc/sign_up/sign_up_bloc.dart`
- `lib/features/auth/presentation/bloc/sign_up/sign_up_event.dart`
- `lib/features/auth/domain/usecase/sign_up_usecase.dart`
- `lib/features/auth/data/repository/auth_repository_impl.dart`
- `lib/features/auth/data/datasource/auth_remote_datasource.dart`

**Status:** [x] **Code-fixed (FIX-1+2+3+4+5+6)**:
- `sign_up_page` (FIX-1) tidak lagi call Supabase — form-only
- `SignUpBloc/Event/State/UseCase` (FIX-2) dihapus
- `signUp()` pindah ke `registerAndCreateProfile` (FIX-3+4+5) di Create Profile page
- `_safeCleanup()` dengan `deleteCurrentUser()` RPC fallback (FIX-5)
- **UI integration pending (FIX-7)** — page belum panggil use case baru, jadi `_safeCleanup` belum pernah dipanggil di real flow
- **Migration dependency:** `delete_user()` RPC butuh SQL function di Supabase (Sprint 1 cleanup task, belum ada)

---

## Rencana Refactor Flow

### Flow Sebelum (Bermasalah)
```
Sign Up Page
  → input email + password + fullName
  → signUp() Supabase ← terlalu awal, BUG-004-C
  → navigate ke Create Profile (extra: email, password, name)

Create Profile Page
  → input gender + dob + photo (+ nickname — belum didefine di schema)
  → INSERT user_profiles (full_name baru sampai di sini — BUG-004-A)
  → navigate ke Home
```

**Catatan tambahan dari pembacaan kode:**
- `auth_remote_datasource.dart:65-73` (`createUserProfile`) adalah satu-satunya INSERT ke `user_profiles`.
- `auth_repository_impl.dart:85-113` (`createProfile`) adalah orchestrator: uploadAvatar → createUserProfile.
- `display_name` di auth metadata **tidak pernah di-set** (BUG-004-B).
- Tidak ada `deleteCurrentUser()` fallback untuk cleanup jika INSERT gagal setelah signUp sukses.

### Flow Sesudah (Target)
```
Sign Up Page
  → input email + password + fullName
  → validasi form saja, TIDAK call Supabase
  → navigate ke Create Profile dengan extra:
    {email, password, fullName}

Create Profile Page
  → input gender + dob + photo (+ nickname)
  → [atomic] signUp() Supabase Auth (dengan data: {display_name: fullName})
  → [atomic] uploadAvatar (jika ada photo)
  → [atomic] INSERT user_profiles dengan semua data:
    {auth_id, full_name, nickname, gender, dob, is_profile_complete: true, avatar_url}
  → [atomic] updateAuthMetadata (jaga-jaga display_name jika step signUp gagal set)
  → navigate ke Home
  → [fallback] jika step 3/4/5 gagal → deleteCurrentUser() supaya tidak ada ghost
```

---

## Todo Fix List

- [x] **FIX-1:** Hapus `signUp()` Supabase dari Sign Up page — `920aaf8`
  - ✅ Sign Up page hanya validasi form + `context.go(RoutePaths.createProfile, extra: {email, password, name})`
  - ✅ Hapus dependency ke `SignUpBloc` dari `sign_up_page.dart` (form-only, no submit)
- [x] **FIX-2:** Hapus `SignUpBloc` + `Event` + `State` + `UseCase` (Opsi A) — `72f6f05`
  - ✅ 4 file dihapus (YAGNI — sign up murni UI validation)
- [x] **FIX-3:** Buat `RegisterAndCreateProfileUseCase` baru — `68af411`
  - ✅ Atomic flow: `signUp + uploadAvatar + INSERT user_profiles + updateAuthMetadata`
  - ✅ Cleanup fallback via `_safeCleanup()` + `deleteCurrentUser()` RPC
  - ✅ Parameter: `{email, password, fullName, nickname, gender, dob, File? photo}`
  - ✅ Return: `Result<UserEntity>`
- [x] **FIX-4:** Tambah `registerAndCreateProfile()` di `AuthRepository` — `68af411`
  - ✅ Interface + impl ditambahkan. `signUpWithEmail` di interface dihapus (no caller).
  - ✅ `createProfile` interface/impl **dipertahankan** (no caller di FIX-6, tapi keep untuk future use)
- [x] **FIX-5:** Tambah method baru di `AuthRemoteDataSource` — `68af411`
  - ✅ `signUpWithEmail` + `data:` param (untuk `display_name` + `is_profile_complete`)
  - ✅ `updateAuthMetadata({displayName, isProfileComplete})` via `_client.auth.updateUser()`
  - ✅ `deleteCurrentUser()` via `_client.rpc('delete_user')` — **butuh migration SQL function** (belum ada)
- [x] **FIX-6:** Update `CreateProfileCubit` — `d0d98e4`
  - ✅ Constructor terima `RegisterAndCreateProfileUseCase` (bukan `CreateProfileUseCase`)
  - ✅ Method `registerAndCreateProfile({email, password, fullName, nickname, gender, dob, photo})` (sebelumnya `saveProfile(Map, {File?})`)
  - ✅ State machine (Initial/Loading/Success/Failure) dipertahankan
  - ✅ `create_profile_usecase.dart` dihapus (no caller)
- [ ] **FIX-7:** Update `Create Profile Page`
  - ⏳ Baca extra `{email, password, fullName}` dari GoRouter (sudah ada di constructor, tinggal pass ke cubit)
  - ⏳ Pre-fill name & email field dari extra (sudah ada di line 56-57)
  - ⏳ Tambah field: `dob` (jika belum ada di form) — `nickname` sudah ada
  - ⏳ Saat submit → panggil `cubit.registerAndCreateProfile(...)` (bukan `cubit.saveProfile`)
  - ⏳ Saat sukses → `context.go(RoutePaths.home)` (sudah ada di line 81)
- [ ] **FIX-8:** Update router redirect
  - ⏳ Pastikan `RoutePaths.createProfile` di-allow saat flow berjalan (sudah ada guard di line 60)
  - ⏳ **TIDAK perlu ubah redirect logic** — guard existing sudah handle `profileIncomplete` dengan benar
  - ⏳ Hanya pastikan: kalau `RegisterAndCreateProfileUseCase` gagal di tengah → state tetap `unauthenticated` (bukan `profileIncomplete` salah), supaya user bisa retry register dengan email yang sama

---

## File Changes Log

| File | Perubahan | Status |
|------|-----------|--------|
| `lib/features/auth/presentation/page/sign_up_page.dart` | Hapus `BlocProvider` `SignUpBloc`, hapus `_onCreateAccount` yang call bloc, ganti dengan `context.go(createProfile, extra: {...})` langsung. Hapus import bloc-related. | ✅ FIX-1 |
| `lib/features/auth/presentation/bloc/sign_up/sign_up_bloc.dart` | **HAPUS** | ✅ FIX-2 |
| `lib/features/auth/presentation/bloc/sign_up/sign_up_event.dart` | **HAPUS** | ✅ FIX-2 |
| `lib/features/auth/presentation/bloc/sign_up/sign_up_state.dart` | **HAPUS** | ✅ FIX-2 |
| `lib/features/auth/domain/usecase/sign_up_usecase.dart` | **HAPUS** | ✅ FIX-2 |
| `lib/features/auth/data/datasource/auth_remote_datasource.dart` | Tambah `updateAuthMetadata({...})`, `deleteCurrentUser()`. Modifikasi `signUpWithEmail(email, password, {data})` agar support display_name. | ✅ FIX-5 |
| `lib/features/auth/domain/repository/auth_repository.dart` | Tambah `registerAndCreateProfile(...)`. Hapus `signUpWithEmail` (no caller). `createProfile` tetap dipertahankan. | ✅ FIX-4 |
| `lib/features/auth/data/repository/auth_repository_impl.dart` | Implementasi `registerAndCreateProfile()` — atomic flow + `_safeCleanup()`. Hapus `signUpWithEmail`. `createProfile` tetap dipertahankan. | ✅ FIX-4 |
| `lib/features/auth/domain/usecase/register_and_create_profile_usecase.dart` | **BUAT BARU** — thin wrapper ke repo. | ✅ FIX-3 |
| `lib/features/auth/domain/usecase/create_profile_usecase.dart` | **HAPUS** (no caller setelah FIX-6). | ✅ FIX-6 |
| `lib/features/auth/presentation/bloc/create_profile/create_profile_cubit.dart` | Ganti dependency ke `RegisterAndCreateProfileUseCase`. Method `registerAndCreateProfile({...})` baru (sebelumnya `saveProfile`). | ✅ FIX-6 |
| `lib/core/di/locator.config.dart` | Regenerated 3× via `dart run build_runner build --force-jit`: hapus SignUpUseCase/SignUpBloc/CreateProfileUseCase factories, tambah RegisterAndCreateProfileUseCase, update CreateProfileCubit dep. | ✅ FIX-2+3+6 |
| `lib/features/auth/presentation/page/create_profile_page.dart` | Tambah field `dob` di form. Pass `{email, password, fullName}` dari extra ke `cubit.registerAndCreateProfile(...)`. Ganti `cubit.saveProfile(...)` call. | ⏳ FIX-7 |
| `lib/core/router/app_router.dart` | Verifikasi redirect guard untuk `createProfile` route saat flow berjalan. Existing guard di line 60 sudah handle — tidak perlu ubah logic. | ⏳ FIX-8 |

**Catatan `deleteCurrentUser()`:**
- Supabase JS/Dart SDK tidak expose self-delete user secara langsung untuk anon client.
- Opsi A: Pakai service-role key (TIDAK aman di client).
- Opsi B: Buat Postgres RPC `delete_user()` yang dipanggil dengan `auth.uid()` di server (aman — RLS enforce `auth.uid() = id`).
- Opsi C: Jangan hapus user, biarkan jadi `profileIncomplete` permanent (status quo — TIDAK direkomendasikan karena BUG-004-C).
- **Rekomendasi: Opsi B** — tambah migration SQL function `delete_user()` di Sprint 1 cleanup task.

---

## Skenario Validasi

| Skenario | Expected | Status |
|----------|----------|--------|
| Sign up → cancel/back di Create Profile | Tidak ada user terbuat di `auth.users` | [ ] (menunggu FIX-7 + manual test) |
| Sign up → Create Profile lengkap (no photo) | `auth.users` + `user_profiles` terisi, `display_name` di metadata | [ ] (menunggu FIX-7 + manual test) |
| Sign up → Create Profile + foto | Avatar terupload ke `storage/avatars/{authId}/profile.jpg` | [ ] (menunggu FIX-7 + manual test) |
| Cek `display_name` setelah register | `auth.users.raw_user_meta_data->>'display_name'` = fullName | [ ] (menunggu FIX-7 + manual test) |
| Login setelah register | Langsung ke `/home` (profile sudah complete) | [ ] (menunggu FIX-7 + manual test) |
| Sign up → upload avatar sukses → INSERT profile gagal | `auth.users` row di-delete via `delete_user()` RPC, user bisa retry | [ ] (cleanup code ada di FIX-3+4+5, tapi RPC function belum ada di DB) |
| Logout setelah register, lalu login lagi | Tidak ada loop ke create-profile (profile complete) | [ ] (menunggu FIX-7 + manual test) |

---

## Verifikasi SQL Setelah Fix

```sql
select
  au.email,
  au.raw_user_meta_data->>'display_name' as display_name,
  up.full_name,
  up.nickname,
  up.gender,
  up.dob,
  up.is_profile_complete,
  up.avatar_url,
  au.created_at
from auth.users au
left join user_profiles up on up.auth_id = au.id
order by au.created_at desc
limit 5;
```

Expected setelah fix:
- `display_name` TIDAK NULL
- `up.full_name` TIDAK NULL (match dengan `display_name`)
- `up.is_profile_complete` = `true` untuk user yang sudah selesai flow
- `up.avatar_url` NULL jika tidak upload foto, TIDAK NULL jika upload

```sql
-- Verifikasi storage RLS — avatar path harus di folder userId masing-masing
select
  name,
  bucket_id,
  owner,
  created_at
from storage.objects
where bucket_id = 'avatars'
order by created_at desc
limit 5;
```

Expected: `name` = `{userId}/profile.jpg` (bukan `avatars/{userId}/profile.jpg` — lihat BUG-003).

---

## Referensi

- BUG-001-E → race condition router redirect (terkait: guard di `app_router.dart:60` masih relevan)
- BUG-003 → storage RLS double-prefix (terkait: upload avatar di flow ini)
- `docs/api_contract/api_contract_health_pal.md` → createProfile endpoint spec
- `docs/erd/erd_healh_pal.md` → `user_profiles` table schema
- `docs/wireframe/` → wireframe Sign Up + Create Profile untuk validasi field yang dikumpulkan

---
*Dibuat: 2026-06-14*
*Update terakhir: 2026-06-14 (FIX-1+2+3+4+5+6 landed)*
