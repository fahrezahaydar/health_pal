# BUG-002 — Profile Issues

**Tanggal:** 2026-06-14 (last updated: FIX-1 selesai)
**Feature:** Profile
**Severity:** Critical
**Status:** In Progress (BUG-002-A resolved, BUG-002-B open)

---

## Ringkasan Audit

Dua symptom teridentifikasi saat code review terhadap flow Profile + Logout:

1. Profile page gagal load data user — `PGRST205: Could not find the table 'public.me'`.
2. Saat load gagal, user tidak bisa logout — stuck di error state tanpa UI affordance.

Audit doc terkait:
- `docs/api_contract/api_contract_health_pal.md` section 3.5 (line 643-690) — `GET /me` view, tapi `me` view belum di-migrate ke Supabase DB.
- `docs/erd/erd_healh_pal.md` — tabel `user_profiles` (bukan `users`) adalah source of truth untuk profil user.

---

## Bug List

### BUG-002-A: getProfile() Query ke Table 'me' (Tidak Ditemukan di DB)

**Deskripsi:**  
`ProfileRemoteDataSource.getProfile()` memanggil Supabase dengan `.from('me')` sesuai API contract section 3.5. Tapi view `me` tersebut tidak ada di database Supabase — query mengembalikan error `PGRST205: Could not find the table 'public.me' in the schema cache`. Profile page gagal load data user, user melihat error state.

**Root Cause:**  
API contract section 3.5 (line 643-690) mendokumentasikan `GET /me` sebagai view PostgREST yang filter otomatis via `auth.uid()`:

```sql
CREATE VIEW me AS
  SELECT * FROM user_profiles
  WHERE auth_id = auth.uid();
GRANT SELECT ON me TO authenticated;
```

Tapi migration SQL tersebut BELUM dijalankan di Supabase DB. Hasilnya view `public.me` tidak ada di schema cache. `profile_remote_datasource.dart:31` query `.from('me')` langsung kena `PGRST205`.

Sebagai perbandingan:
- `auth_remote_datasource.dart:48-52` query `.from('user_profiles').eq('auth_id', userId).maybeSingle()` — WORKS
- `home_remote_datasource.dart:57-65` (sebelum FIX-7 v2) query `.from('user_profiles').eq('auth_id', authId).single()` — WORKS
- `profile_remote_datasource.dart:31` query `.from('me')` — FAILS (view tidak ada)

Nama tabel yang benar adalah **`user_profiles`** (bukan `users` seperti di task spec — ini typo di task). Source of truth: `docs/erd/erd_healh_pal.md`.

**File yang terkait:**

- `lib/features/profile/data/datasource/profile_remote_datasource.dart` line 30-40 — query `.from('me')` yang salah
- `docs/api_contract/api_contract_health_pal.md` line 643-690 — spec `me` view (belum diimplementasi di DB)

**Status:** Fixed — diselesesaikan via FIX-1.

---

### BUG-002-B: Logout Tidak Bisa Diakses Saat loadProfile() Gagal

**Deskripsi:**  
Saat `loadProfile()` gagal (misalnya karena BUG-002-A), ProfileCubit emit `ProfileError`. `_errorState` di `profile_page.dart:235-260` HANYA menampilkan icon warning + pesan error + tombol "Coba lagi". Tidak ada tombol logout di error state. User yang mengalami error profile tidak punya cara untuk logout — harus force-close app.

**Root Cause:**  
`ProfilePage._ProfileView.build()` (line 51-71) render berbeda state dengan switch:

- `ProfileLoaded` → `_loaded()` widget (line 73-87) yang berisi `_userCard` + `_menuList` + `_logoutButton`. Tombol logout ada.
- `ProfileError` → `_errorState` widget (line 235-260) yang HANYA berisi icon + pesan + tombol "Coba lagi". **TIDAK ada tombol logout.**

`_errorState` kurang affordance untuk logout. User yang stuck di error state (misalnya `PGRST205` dari BUG-002-A, atau network error, atau RLS deny) tidak bisa sign out lewat UI.

**Tambahan:** `ProfileCubit.loadProfile()` (line 24-34) tidak punya try/catch. Kalau `_getProfile()` throw exception (bukan return `Result.failure` — bisa terjadi kalau repository's catch-all di-bypass), future rejected dan cubit stuck di `ProfileLoading` (loading spinner indefinitely). User tidak pernah lihat error state, dan tetap tidak bisa logout.

```dart
Future<void> loadProfile() async {
  emit(const ProfileLoading());
  final result = await _getProfile();  // <-- no try/catch; exception propagates
  switch (result) {
    case Success<UserEntity>(:final data):
      emit(ProfileLoaded(data));
    case Failure(:final message):
      print('ProfileCubit.loadProfile error: $message');
      emit(ProfileError(message: message));
  }
}
```

`logout()` di cubit (line 36-38) sendiri tidak depend `loadProfile()` — pure delegate ke `AppServices.logout()`. Tapi karena user tidak bisa akses tombol logout di error state, logout tidak bisa dipicu.

**File yang terkait:**

- `lib/features/profile/presentation/page/profile_page.dart` line 235-260 — `_errorState` widget tanpa logout button
- `lib/features/profile/presentation/bloc/profile/profile_cubit.dart` line 24-34 — `loadProfile` tanpa try/catch (potential future rejection)
- `lib/core/services/app_services.dart` — `logout()` (sudah benar: signOut + clearAuth + status update)

**Status:** Open

---

## Todo Fix List

- [x] **FIX-1**: Ganti query `.from('me')` di `ProfileRemoteDataSource.getProfile()` → query `.from('user_profiles').eq('auth_id', currentUserId).maybeSingle()` (konsisten dengan `auth_remote_datasource.dart:48-52` dan `home_remote_datasource.dart:58-62`).
  - File: `lib/features/profile/data/datasource/profile_remote_datasource.dart` line 30-40
  - Pattern: ambil `currentSession?.user.id` sebagai `authId`, filter by `auth_id`.
  - Optional: hapus `// Get email dari session` comment (sudah jelas dari context).
  - Catatan: nama tabel adalah `user_profiles` (bukan `users`).

- [ ] **FIX-2**: Tambah tombol logout di `_errorState` widget (dan/atau pindahkan logout ke AppBar agar selalu reachable).

- [ ] **FIX-2**: Tambah tombol logout di `_errorState` widget (dan/atau pindahkan logout ke AppBar agar selalu reachable).
  - File: `lib/features/profile/presentation/page/profile_page.dart` line 235-260
  - Pilihan desain:
    - (a) Tambah `OutlinedButton.icon` "Logout" di bawah tombol "Coba lagi" di `_errorState`. Sederhana, scoped.
    - (b) Pindahkan tombol logout ke `AppBar` `actions` agar selalu terlihat di semua state (loaded/error). Lebih robust tapi ubah UI di loaded state juga.
  - Rekomendasi: opsi (a) untuk minimal diff, atau (b) untuk defense-in-depth. Diskusikan dengan designer.
  - Test: `loadProfile()` paksa error (misal disable network) → user bisa logout lewat error state.

- [ ] **FIX-3**: Tambah try/catch di `ProfileCubit.loadProfile()` agar future tidak reject.
  - File: `lib/features/profile/presentation/bloc/profile/profile_cubit.dart` line 24-34
  - Pattern:
    ```dart
    try {
      final result = await _getProfile();
      // ... existing switch
    } catch (e, stack) {
      // ignore: avoid_print
      print('ProfileCubit.loadProfile unexpected error: $e\n$stack');
      emit(ProfileError(message: 'Terjadi kesalahan tak terduga. Coba lagi.'));
    }
    ```
  - Tujuannya: cubit selalu emit terminal state (Loaded atau Error), tidak pernah stuck di Loading.
  - Tanpa ini, edge case (unhandled exception) bikin user stuck di loading spinner.

---

## Skenario Validasi

| # | Skenario | Expected | Status |
|---|----------|----------|--------|
| 1 | Buka Profile page (network OK, profile exists) | Data user tampil | Done (FIX-1) |
| 2 | Buka Profile page (network OK, query 'me' fail — sekarang tidak ada) | N/A (query diganti ke user_profiles) | N/A |
| 3 | Buka Profile page (network error) | Tampil error state + tombol Logout + Coba lagi | Open (FIX-2) |
| 4 | Logout dari Profile page (state loaded) | Berhasil logout, navigate ke Login | Pass (current behavior) |
| 5 | Logout dari Profile page (state error) | Berhasil logout, navigate ke Login | Open (FIX-2) |
| 6 | loadProfile() throw unexpected exception | Tampil error state, tidak stuck loading | Open (FIX-3) |
| 7 | Refresh Profile (pull-to-refresh dari loaded state) | Re-fetch, tampil data | Pass (current behavior) |

---

## Catatan Implementasi

- **FIX-1 minimal diff**: 5 baris (ganti `.from('me')` jadi `.from('user_profiles').eq('auth_id', authId)`, tambah `authId` variable). Tidak butuh migration SQL karena tabel `user_profiles` sudah ada dan RLS sudah configured (lihat `auth_remote_datasource.dart` yang sudah bekerja dengan pattern ini).
- **FIX-1 API contract drift**: API contract section 3.5 perlu di-update juga (markdown only) — note bahwa Flutter saat ini pakai direct table query, bukan `/me` view. Atau migration SQL `CREATE VIEW me ...` bisa dijalankan. Untuk Sprint 1 hot-fix, direct query lebih cepat.
- **FIX-2 UX consideration**: Tombol "Logout" di error state gunakan `AppTheme.darkRed` yang sudah dipakai di `_logoutButton()` (consistency).
- **FIX-3 future-proof**: Pertimbangkan juga untuk catch di `logout()` method (jaga-jaga `AppServices.logout()` throw). Saat ini `AppServices.logout()` punya try/catch internal (line 95-100), jadi seharusnya aman. Tapi defensive try/catch di cubit tidak ada salahnya.
- **Out of scope untuk Sprint 1**: Retry button di error state sudah ada ("Coba lagi") — tidak perlu ditambah. Refresh indicator di loaded state juga sudah ada (line 74-75).

---

## Progress Fix

| Fix | Status | Commit |
|-----|--------|--------|
| FIX-1: Ganti query `.from('me')` -> `user_profiles` | Done | uncommitted |
| FIX-2: Tambah logout button di `_errorState` | Pending | — |
| FIX-3: Try/catch di `ProfileCubit.loadProfile` | Pending | — |

**Status summary:** 1 dari 3 fix selesai (33%).

### Fix Details

#### FIX-1 (Done)

File diubah:

- `lib/features/profile/data/datasource/profile_remote_datasource.dart`:
  - Tambah import `core/enums/failure_code.dart` dan `core/network/api_exception.dart`.
  - Ganti `await _client.from('me').select().maybeSingle()` jadi `await _client.from('user_profiles').select().eq('auth_id', session.user.id).maybeSingle()`.
  - Ganti `throw Exception(...)` jadi `throw const ApiException(code: FailureCode.notFound, ...)` agar konsisten dengan pattern di `auth_remote_datasource.dart`.
  - Tambah null check di awal: kalau `currentSession == null`, throw `ApiException(code: FailureCode.unauthorized, message: 'Tidak ada sesi aktif')`.
  - Hapus `// Get email dari session (tidak ada di /me view)` comment (sudah obsolete karena query sekarang langsung ke `user_profiles` yang include `email` — tapi `email` masih perlu di-merge dari session karena field ini tidak ada di tabel `user_profiles`).
  - Update header comment di file: "via /me view" jadi generic "API §3.5 Get My Profile".

- `lib/features/profile/presentation/bloc/profile/profile_cubit.dart`:
  - Tambah import `package:flutter/foundation.dart`.
  - Ganti `print('...')` jadi `debugPrint('...')` agar comply dengan lint `avoid_print`. Sekaligus fix `flutter analyze` warning.
  - Update header comment: "loadProfile -> fetch dari /me" jadi "loadProfile -> fetch dari user_profiles (lihat FIX-1 BUG-002)".

- Trace:
  - Sebelum: query `.from('me')` -> PGRST205 -> `Result.failure(notFound)` -> `ProfileError`.
  - Sesudah: query `.from('user_profiles').eq('auth_id', ...)` -> 200 OK dengan data row -> `ProfileLoaded(user)`.

- Verifikasi: `flutter analyze` -> No issues found!
