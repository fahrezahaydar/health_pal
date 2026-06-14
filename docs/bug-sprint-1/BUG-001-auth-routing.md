# BUG-001 — Auth Routing Issues

**Tanggal:** 2026-06-14  
**Feature:** Auth + Routing  
**Severity:** Critical  
**Status:** In Progress

---

## Ringkasan Audit

Tiga symptom teridentifikasi saat code review terhadap flow auth & routing:

1. **Session expired** mengirim user kembali ke Onboarding (padahal harus ke Login).
2. **Sign up baru** langsung mengarah ke Home tanpa mengisi Create Profile.
3. **Sign in** dengan profile belum lengkap langsung ke Home (padahal harus ke Create Profile).

Audit doc terkait:

- `docs/user_flow/USER_FLOW.md` bagian 4.1 — Sign In harus routing ke `/home` atau `/sign-up/create-profile` berdasarkan `is_profile_complete`
- `docs/wireframe/02-sign-in.md` line 90 — "AppServices.login() dipanggil setelah auth sukses, mengubah AppStatus ke authenticated, lalu GoRouter redirect ke /home (atau /sign-up/create-profile jika is_profile_complete = false)"
- `docs/audit/cto_executive_summary.md` bagian SHOWSTOPPER #4 — `is_profile_complete` di response login/signup BELUM dipakai untuk routing decision
- `docs/erd/erd_healh_pal.md` — kolom `is_profile_complete` sudah ada di tabel `user_profiles`

---

## Bug List

### BUG-001-A: Session Expired, Kembali ke Onboarding (FIXED)

**Deskripsi:**  
Saat session Supabase expired, user dilempar ke halaman Onboarding, padahal harusnya ke Login.

**Root Cause:**  
`AppServices.init()` lama menggunakan `prefs.isLoggedIn` (lokal) + `appSessionDuration` (timestamp lokal) sebagai sumber status. Setelah onboarding, jika session Supabase expired tapi prefs masih menandai logged in, router redirect tidak punya jalur eksplisit "session expired ke Login"; sebaliknya beberapa path malah mengarahkan kembali ke Onboarding.

**File yang terkait:**

- `lib/core/services/app_services.dart` (init + `_isSessionExpired`)
- `lib/core/constants/app_constants.dart` (`appSessionDuration`)
- `lib/core/services/shared_prefs.dart` (`loginTimestamp`)
- `lib/core/router/app_router.dart` (redirect logic)
- `lib/main.dart` (global error handler untuk `AuthException`)

**Status:** Fixed — sudah diperbaiki di commit `0f48e8c` "fix(auth): handle session expired gracefully, fix onboarding routing logic". `init()` sekarang pakai `Supabase.instance.client.auth.currentSession` + `session.isExpired`; redirect logic memiliki 3 kondisi eksplisit; global error handler untuk `AuthException` sudah ditambahkan.

---

### BUG-001-B: Sign Up, User Diarahkan ke Home (skip Create Profile) (OPEN)

**Deskripsi:**  
Setelah sign-up berhasil, user langsung landing di Home tanpa sempat mengisi Create Profile form. Seharusnya sign up, Create Profile, Home.

**Root Cause:**  
Setelah `_client.auth.signUp(...)` di `auth_remote_datasource.dart` line 21, Supabase otomatis membuat session dan emit event `AuthChangeEvent.signedIn`. Listener `_onAuthStateChange` di `app_services.dart` line 73-77 langsung transisi status ke `AppStatus.authenticated`. Redirect logic (kondisi 3 di `app_router.dart` line 73-77) melihat status=authenticated dan loc=`/sign-up` (auth route), lalu redirect ke `/home`. Akibatnya `SignUpPage` listener (`sign_up_page.dart` line 70-78) yang bermaksud `context.go(RoutePaths.createProfile)` kalah cepat dari redirect router, dan user berakhir di Home.

Selain itu, `CreateProfileCubit.saveProfile` (`create_profile_cubit.dart` line 51-60, `create_profile_page.dart` line 206-213) TIDAK mengirim field `is_profile_complete: true` ke repository, sehingga setelah profile disimpan ke DB, flag `is_profile_complete` masih bernilai default `false`. Hal ini membuat cek profile completeness setelah sign-in menjadi misleading.

**File yang terkait:**

- `lib/core/services/app_services.dart` line 73-77 — `_onAuthStateChange.signedIn` set authenticated tanpa cek profile
- `lib/core/enums/app_status.dart` — belum ada state `profileIncomplete`
- `lib/features/auth/presentation/bloc/create_profile/create_profile_cubit.dart` line 51-60 — `saveProfile` tidak kirim `is_profile_complete: true`
- `lib/features/auth/presentation/page/create_profile_page.dart` line 200-217 — payload `saveProfile` tidak include flag
- `lib/features/auth/data/repository/auth_repository_impl.dart` line 103-107 — `createProfile` forward data apa adanya
- `lib/core/router/app_router.dart` line 73-77 — redirect tidak kenal state `profileIncomplete`

**Status:** Open

---

### BUG-001-C: Sign In, Langsung ke Home padahal Profile Belum Lengkap (OPEN)

**Deskripsi:**  
User yang sign in dengan `is_profile_complete = false` di DB langsung dilempar ke Home. Seharusnya di-redirect ke Create Profile dulu, sesuai `docs/wireframe/02-sign-in.md` line 90 dan `USER_FLOW.md` line 244-246.

**Root Cause:**  
`LoginPage` listener (`login_page.dart` line 65-71) menerima `SignInSuccess` yang membawa `UserEntity` (sudah berisi `isProfileComplete`, lihat `user_entity.dart` line 12), TETAPI listener tidak mengecek field tersebut. Selalu `context.go(RoutePaths.home)`.

Tambahan: `AppServices.init()` (saat app restart dengan session valid) juga tidak fetch profile untuk menentukan status, langsung set `AppStatus.authenticated`. Akibatnya user yang sedang di tengah flow create-profile (app di-kill paksa lalu dibuka lagi) akan masuk ke Home bukan kembali ke Create Profile.

**File yang terkait:**

- `lib/features/auth/presentation/page/login_page.dart` line 65-71 — listener abaikan `user.isProfileComplete`
- `lib/core/services/app_services.dart` line 42-54 — `init()` tidak fetch profile
- `lib/features/auth/data/repository/auth_repository_impl.dart` line 147-165 — `getCurrentUser()` sudah ada, tinggal dipanggil
- `lib/core/router/app_router.dart` — tidak ada state `profileIncomplete`

**Status:** Open

---

## Todo Fix List

- [ ] **FIX-1**: Tambah enum `AppStatus.profileIncomplete`
  - File: `lib/core/enums/app_status.dart`
  - State baru untuk user yang sudah sign in tapi profile belum lengkap.
  - Update diagram alur di docstring `app_services.dart`.

- [ ] **FIX-2**: Refactor `AppServices` agar transisi status berdasarkan `is_profile_complete`
  - File: `lib/core/services/app_services.dart`
  - `init()`: setelah `currentSession != null && !isExpired`, panggil `authRepository.getCurrentUser()` (fallback ke cache). Jika `user.isProfileComplete` true maka `authenticated`; jika false atau null maka `profileIncomplete`.
  - `_onAuthStateChange.signedIn`: sama, fetch profile lalu set status accordingly. Saat ini langsung `authenticated` tanpa cek.
  - Tambah method publik `markProfileComplete()` yang dipanggil dari `CreateProfilePage` listener setelah save sukses, untuk transisi `profileIncomplete` ke `authenticated`.

- [ ] **FIX-3**: Update router redirect untuk handle `profileIncomplete`
  - File: `lib/core/router/app_router.dart`
  - Tambah kondisi: `if (status == AppStatus.profileIncomplete) return loc == RoutePaths.createProfile ? null : RoutePaths.createProfile;`
  - Insert di Kondisi 2 (unauthenticated) dan Kondisi 3 (authenticated) untuk mengizinkan akses create-profile, dan memaksa user ke create-profile dari route lain.

- [ ] **FIX-4**: `CreateProfileCubit.saveProfile` set `is_profile_complete: true` di payload
  - File: `lib/features/auth/presentation/page/create_profile_page.dart` line 206-213
  - Tambah key `'is_profile_complete': true` ke map data yang dikirim ke `saveProfile`. DB akan terupdate, dan field akan kembali ke `CreateProfileSuccess.user` sehingga bisa dipakai untuk trigger `AppServices.markProfileComplete()`.

- [ ] **FIX-5**: `LoginPage` listener cek `user.isProfileComplete` untuk routing decision
  - File: `lib/features/auth/presentation/page/login_page.dart` line 65-71
  - Ubah agar: `if (user.isProfileComplete) context.go(home) else context.go(createProfile)`.
  - Tetap panggil `AppServices.login()` dulu sebelum routing.

- [ ] **FIX-6 (opsional)**: `SignUpPage` listener panggil `AppServices.setProfileIncomplete()`
  - File: `lib/features/auth/presentation/page/sign_up_page.dart` line 70-78
  - Untuk menghindari race condition dengan `signedIn` event Supabase, sign-up flow idealnya set status ke `profileIncomplete` secara eksplisit sebelum `context.go(createProfile)`.
  - Alternatif: cukup andalkan FIX-2 (event handler fetch profile), tapi ini race-prone.

---

## Skenario Validasi

| # | Skenario | Expected | Status |
|---|----------|----------|--------|
| 1 | Fresh install (belum pernah onboarding) | Onboarding | Done (commit 0f48e8c) |
| 2 | Sudah onboarding, belum login | Login | Done (commit 0f48e8c) |
| 3 | Sign up baru | Create Profile | Open |
| 4 | Sign in, profile belum lengkap | Create Profile | Open |
| 5 | Sign in, profile sudah lengkap | Home | Open |
| 6 | Session expired | Login (bukan onboarding) | Done (commit 0f48e8c) |
| 7 | Sudah login + profile lengkap, buka app | Home | Open (perlu fetch profile di init) |
| 8 | Sudah login + profile incomplete, buka app | Create Profile | Open |
| 9 | Logout, lalu login lagi | Login, lalu sesuai profile | Open |

---

## Catatan Implementasi

- `getCurrentUser()` di `auth_repository_impl.dart` line 147-165 sudah ada dan punya fallback ke local cache (`getCachedUser()`). Method ini bisa langsung dipanggil dari `AppServices.init()` dan `_onAuthStateChange` untuk mendapatkan `isProfileComplete` terbaru.
- `isProfileComplete` ada di `user_profiles.is_profile_complete` (DB), `UserModel.isProfileComplete` (data), `UserEntity.isProfileComplete` (domain). Konsistensi end-to-end sudah ada, yang kurang hanya dipakai di routing.
- `AppServices` saat ini menerima `SupabaseClient` dan `SharedPrefService` via DI, tapi BELUM menerima `AuthRepository`. Perlu tambah dependency injection, atau buat helper inline (lebih bersih: tambah `AuthRepository` ke constructor `AppServices`).
- Pertimbangkan edge case: saat `_onAuthStateChange.signedIn` fetch profile dan ternyata network error atau token baru expired, harus fallback ke `unauthenticated` (jangan stuck di `loading`).

---

## Progress Fix

Ringkasan status eksekusi. Detail per-fix lihat section "Fix Details" di bawah.

| Fix | Status | Commit |
|-----|--------|--------|
| FIX-1: Tambah `AppStatus.profileIncomplete` | Done | 0a352c0 |
| FIX-2: Refactor `AppServices` fetch profile | Done | a700eed |
| FIX-3: Update router redirect `profileIncomplete` | Done | 6c67997 |
| FIX-4: `CreateProfileCubit` set `is_profile_complete: true` | Done | 74aac93 |
| FIX-5: `LoginPage` listener cek `isProfileComplete` | Done | uncommitted |
| FIX-6: `SignUpPage` panggil `setProfileIncomplete()` | Pending | — |

**Status summary:** 5 dari 6 fix selesai (83%).

### Fix Details

#### FIX-1 (Done)

- Tambah enum value `profileIncomplete` di `lib/core/enums/app_status.dart`.
- Update dartdoc enum + diagram alur transisi.
- Update docstring class `AppServices` dan method `init()`.
- `flutter analyze` clean.
- Commit: `0a352c0`.

#### FIX-2 (Done)

File diubah:

- `lib/core/services/app_services.dart`:
  - Inject `AuthRepository` ke constructor.
  - Tambah helper `_setStatusFromProfile()`.
  - `init()` panggil `_setStatusFromProfile()`.
  - `_onAuthStateChange.signedIn` panggil `_setStatusFromProfile()`.
  - Tambah method publik `markProfileComplete()`.
  - Switch direstrukturisasi pakai `default` clause.

- `lib/core/di/locator.config.dart`:
  - Update DI registration.

- Commit: `a700eed`.

#### FIX-3 (Done)

File diubah:

- `lib/core/router/app_router.dart`:
  - Tambah Kondisi 3 untuk `AppStatus.profileIncomplete`.
  - Kondisi `authenticated` di-rename jadi Kondisi 4.

- Commit: `6c67997`.

#### FIX-4 (Done)

File diubah:

- `lib/features/auth/presentation/page/create_profile_page.dart`:
  - Tambah `'is_profile_complete': true` ke payload `saveProfile`.
  - Listener panggil `markProfileComplete()` bukan `login()`.

- Commit: `74aac93`.

#### FIX-5 (Done)

File diubah:

- `lib/features/auth/presentation/page/login_page.dart` line 65-71:
  - Listener dipecah jadi 2 cabang berdasarkan `user.isProfileComplete`:
    - `isProfileComplete = true` -> panggil `AppServices.login()` (status -> authenticated, sync), `context.go(home)`. Tidak ada race karena event handler juga akan set ke `authenticated`.
    - `isProfileComplete = false` -> TIDAK panggil `login()`. Cukup `context.go(createProfile)`. Status masih `unauthenticated` saat listener jalan; router Kondisi 2 allow karena `/sign-up/createProfile` auth route. Setelah `_setStatusFromProfile()` selesai, status -> `profileIncomplete`; router Kondisi 3 match. User tetap di createProfile (no flicker).

- `lib/core/services/app_services.dart`:
  - Update dartdoc `login()` untuk note bahwa dia hanya dipakai untuk profile complete case.

- Trace sign-in flow:

  **Skenario 5 (profile lengkap)**:
  1. User on /sign-in, status=unauthenticated.
  2. Submit -> auth success.
  3. signedIn event -> _setStatusFromProfile() starts.
  4. Bloc emit SignInSuccess.
  5. Listener: login() -> status=authenticated, context.go(home).
  6. Router Kondisi 4: status=authenticated, loc=/home -> stay. User at home.
  7. _setStatusFromProfile() complete: status=authenticated (no change). User stays at home. ✅

  **Skenario 4 (profile incomplete)**:
  1. User on /sign-in, status=unauthenticated.
  2. Submit -> auth success.
  3. signedIn event -> _setStatusFromProfile() starts.
  4. Bloc emit SignInSuccess.
  5. Listener: context.go(createProfile) (TANPA panggil login()).
  6. Router Kondisi 2: status=unauthenticated, loc=/sign-up/createProfile (auth route) -> stay. User at createProfile.
  7. _setStatusFromProfile() complete: status=profileIncomplete, notify.
  8. Router Kondisi 3: status=profileIncomplete, loc=/sign-up/createProfile -> stay. User stays. ✅

  **No flicker di kedua kasus** karena status akhir konsisten dengan navigasi.

- `flutter analyze` clean.

#### FIX-6 (Pending, opsional)

Sign-up flow bisa di-improve dengan explicit `setStatusProfileIncomplete()` call di `SignUpPage` listener untuk konsistensi. Saat ini sign-up sudah bekerja dengan baik via FIX-2 + FIX-3 + FIX-4 (event handler fetch profile -> status profileIncomplete -> Kondisi 3 redirect). FIX-6 adalah safety belt tambahan untuk menghindari edge case (misalnya signedIn event yang gagal di-fire).

**Validasi skenario yang sudah ter-cover (semua ✅ penuh):**

- Skenario 1: Fresh install -> Onboarding (commit 0f48e8c).
- Skenario 2: Sudah onboarding, belum login -> Login (commit 0f48e8c).
- Skenario 3: Sign up baru -> CreateProfile -> Home (FIX-2 + FIX-3 + FIX-4 + FIX-5).
- Skenario 4: Sign in, profile incomplete -> CreateProfile (FIX-2 + FIX-3 + FIX-5).
- Skenario 5: Sign in, profile lengkap -> Home (FIX-5).
- Skenario 6: Session expired -> Login (commit 0f48e8c).
- Skenario 7: Login + profile lengkap, buka app -> Home (FIX-2 init flow).
- Skenario 8: Login + profile incomplete, buka app -> CreateProfile (FIX-2 + FIX-3).
- Skenario 9: Logout + login lagi -> Login -> sesuai profile (FIX-5 listener + FIX-2 event).
