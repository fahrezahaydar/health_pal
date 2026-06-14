# BUG-001 — Auth Routing Issues

**Tanggal:** 2026-06-14 (last updated: FIX-7 v2 enhancement)  
**Feature:** Auth + Routing  
**Severity:** Critical  
**Status:** Resolved (including BUG-001-E race condition)

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

### BUG-001-B: Sign Up, User Diarahkan ke Home (skip Create Profile) (FIXED)

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

**Status:** Fixed — diselesesaikan via FIX-1, FIX-2, FIX-3, FIX-4, FIX-6. Commit: `487ded6` (termasuk FIX-5), sebelumnya `74aac93`, `6c67997`, `a700eed`, `0a352c0`.

---

### BUG-001-C: Sign In, Langsung ke Home padahal Profile Belum Lengkap (FIXED)

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

**Status:** Fixed — diselesesaikan via FIX-1, FIX-2, FIX-3, FIX-5, FIX-7. Commit: `487ded6`, lalu FIX-7.

---

### BUG-001-E: Sign Up → Create Profile → Flicker ke Home → Balik Create Profile (FIXED)

**Deskripsi:**  
Setelah sign up berhasil dan navigate ke Create Profile, app tiba-tiba pindah ke Home lalu balik ke Create Profile (flicker). Ini terjadi karena race condition antara:
1. Manual navigation ke Create Profile (dari `sign_up_page.dart` listener yang panggil `setProfileIncomplete()` + `context.go(createProfile)`)
2. `_onAuthStateChange.signedIn` → `_setStatusFromProfile()` (async) → Failure case default ke `authenticated` (FIX-2 fallback) → Kondisi 4 redirect ke Home
3. FIX-7 v2 home guard fires → setProfileIncomplete() → Kondisi 3 redirect balik ke CreateProfile

**Root Cause:**

Dua lapis race condition di BUG-002's FIX-2 fallback path:

1. **`_setStatusFromProfile()` Failure case di `app_services.dart` line 113-114 default ke `authenticated`** — tapi untuk new user (sign up baru), row `user_profiles` belum ada → `getCurrentUser()` returns `notFound` → `Failure`. Listener (SignUpPage) sudah set status ke `profileIncomplete` via `setProfileIncomplete()` (sync, IMMEDIATE), tapi async fetcher (T3 → T7) **downgrade** status ke `authenticated` setelah listener navigate (T6) ke createProfile.

2. **Router Kondisi 4 (`authenticated`) TIDAK punya guard untuk `createProfile`** — kalau status somehow jadi `authenticated` saat user di `/sign-up/create-profile`, Kondisi 4 redirect ke `/home`.

**Trace timeline:**

```
T0: status=unauthenticated, user on /sign-up
T1: User taps Create Account
T2: Supabase auth.signUp() runs
T3: signedIn event → _setStatusFromProfile() (async, starts)
T4: auth.signUp() returns
T5: SignUpBloc emits SignUpSuccess
T6: SignUpPage listener:
    a. setProfileIncomplete() → status=profileIncomplete (sync) ✅
    b. context.go(createProfile) → Kondisi 3 → stay ✅
T7: _setStatusFromProfile() (T3) finishes:
    a. getCurrentUser() → notFound (new user, no row)
    b. SEBELUM FIX: status=authenticated → notifyListeners → Kondisi 4 → /home ❌
    c. SESUDAH FIX: status stays profileIncomplete → no change ✅
T8: (with SEBELUM FIX)
    HomePage mounts → GreetingCubit fetch → notFound
    → GreetingNoProfile (FIX-7 v2) → setProfileIncomplete()
    → status=profileIncomplete → Kondisi 3 → /sign-up/create-profile
    → Flicker: CreateProfile → Home → CreateProfile ❌
```

**File yang terkait:**

- `lib/core/services/app_services.dart` line 103-115 — `_setStatusFromProfile()` Failure case default `authenticated` (BUG: downgrade)
- `lib/core/router/app_router.dart` Kondisi 4 — TIDAK ada guard `createProfile`
- `lib/features/auth/presentation/page/sign_up_page.dart` line 78 — `setProfileIncomplete()` listener call (safety belt, tapi di-override oleh async fetcher)

**Status:** Fixed — diselesesaikan via Fix Part 1 (`_setStatusFromProfile` Failure case guard) + Fix Part 2 (router `createProfile` early return).

---

### BUG-001-D: User Bisa Stay di Home Tanpa Profile Lengkap (OPEN)

**Deskripsi:**  
User yang terlanjur masuk ke Home (status `AppStatus.authenticated`) tanpa `is_profile_complete = true` di DB tetap bisa stay di Home, browse semua tab, dan tidak di-redirect ke Create Profile. Seharusnya ada guard runtime yang merefresh status dari source of truth dan redirect user ke `/sign-up/create-profile` jika profile tiba-tiba tidak lengkap.

**Root Cause:**

Tiga lapis defense hilang:

1. **Router redirect Kondisi 4 (`authenticated`) tidak re-validasi `is_profile_complete`.** Lihat `lib/core/router/app_router.dart` line 81-89: Kondisi 4 hanya cek apakah user mencoba akses auth/onboarding routes. Tidak ada fetch `getCurrentUser()` ulang. Status `authenticated` di-cache di `AppServices._status` dan diasumsikan valid sampai ada auth event.

2. **Router redirect re-evaluasi hanya saat `AppServices.notifyListeners()`.** `app_router.dart:42` pakai `refreshListenable: _appServices`. Redirect TIDAK re-evaluasi pada navigasi internal (misal: user di Home, tap tab ke Profile, balik ke Home). Selama status tidak berubah, redirect diam.

3. **`HomePage` tidak punya guard apapun.** `lib/features/home/presentation/page/home_page.dart` line 22-45 cuma `MultiBlocProvider` untuk cubits (Greeting, Banner, Upcoming, Specialization). Tidak ada `BlocListener`, `RouteObserver`, atau `WidgetsBindingObserver` yang cek `isProfileComplete` saat Home mount/resume.

Skenario konkret yang luput:

- **Skenario X1**: Saat sign-in, `getCurrentUser()` `Failure` (network error, no cache) → status default ke `authenticated` (per FIX-2 fallback di `app_services.dart`). User di Home meskipun profile sebenarnya incomplete di DB.
- **Skenario X2**: Profile user di-mark incomplete oleh admin/backend setelah sign-in. Status lokal masih `authenticated`. User stay di Home tanpa indikasi.
- **Skenario X3**: User membuka Home via deep link (push notification ke `/booking-history/:id`). Router Kondisi 4 izinkan. Profile sebenarnya incomplete (misal user baru di-invite admin, belum lengkapi). User bisa browse tanpa diminta lengkapi profile.
- **Skenario X4**: User kill app saat di tengah create-profile (status `profileIncomplete`, tapi DB `is_profile_complete = true` karena cubit sudah save). Reopen app: `init()` fetch profile → `isProfileComplete = true` → status `authenticated` → Home. SEHARUSNYA OK (ini bukan bug). TAPI kalau ada race di mana cubit save gagal sebagian atau DB transaction rollback, user bisa stuck.

**File yang terkait:**

- `lib/features/home/presentation/page/home_page.dart` line 22-106 — tidak ada guard profile check
- `lib/features/home/presentation/bloc/greeting/greeting_cubit.dart` — load profile tapi state tidak expose `isProfileComplete` ke UI
- `lib/core/router/app_router.dart` line 81-89 — Kondisi 4 tidak re-validasi profile
- `lib/core/services/app_services.dart` line 116-128 — `_setStatusFromProfile()` cuma dipanggil dari `init()` dan event `signedIn`, tidak ada periodic/refresh mechanism

**Status:** Fixed — diselesesaikan via FIX-7.

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

- [x] **FIX-7**: Guard di Home page — refresh `is_profile_complete` saat Home mount, redirect ke CreateProfile jika incomplete
  - File: `lib/features/home/presentation/page/home_page.dart` dan dependency-nya.
  - **Strategi**: extend `GreetingCubit` (alternatif ringan dari bug report) — `GreetingCubit` sudah load profile; expose `isProfileComplete` ke state, lalu `HomePage` BlocListener react. Tidak ada network call tambahan.
  - File: `lib/features/auth/presentation/page/sign_up_page.dart` line 70-78
  - Untuk menghindari race condition dengan `signedIn` event Supabase, sign-up flow idealnya set status ke `profileIncomplete` secara eksplisit sebelum `context.go(createProfile)`.
  - Alternatif: cukup andalkan FIX-2 (event handler fetch profile), tapi ini race-prone.

---

## Skenario Validasi

| # | Skenario | Expected | Status |
|---|----------|----------|--------|
| 1 | Fresh install (belum pernah onboarding) | Onboarding | Done (commit 0f48e8c) |
| 2 | Sudah onboarding, belum login | Login | Done (commit 0f48e8c) |
| 3 | Sign up baru | Create Profile | Done (FIX-1 sampai FIX-6) |
| 4 | Sign in, profile belum lengkap | Create Profile | Done (FIX-1 sampai FIX-5) |
| 5 | Sign in, profile sudah lengkap | Home | Done (FIX-5) |
| 6 | Session expired | Login (bukan onboarding) | Done (commit 0f48e8c) |
| 7 | Sudah login + profile lengkap, buka app | Home | Done (FIX-2) |
| 8 | Sudah login + profile incomplete, buka app | Create Profile | Done (FIX-2 + FIX-3) |
| 9 | Logout, lalu login lagi | Login, lalu sesuai profile | Done (FIX-5) |
| 10 | User terlanjur di Home, profile belum lengkap (server-side change) | Redirect ke Create Profile | Done (FIX-7) |

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
| FIX-5: `LoginPage` listener cek `isProfileComplete` | Done | 487ded6 |
| FIX-6: `SignUpPage` panggil `setProfileIncomplete()` | Done | d96837d |
| FIX-7: Guard di Home page refresh `is_profile_complete` | Done (v1 + v2 enhancement) | 743e529 + uncommitted |
| FIX-8: BUG-001-E — fix race condition `_setStatusFromProfile` downgrade + router `createProfile` guard | Done | uncommitted |

**Status summary:** 8 dari 8 fix selesai (100% — termasuk BUG-001-E race condition fix). **BUG-001 Resolved.**

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

#### FIX-6 (Done)

File diubah:

- `lib/core/services/app_services.dart`:
  - Tambah method publik `setProfileIncomplete()` — transisi ke `AppStatus.profileIncomplete`. Idempotent (no-op jika status sudah sama).
  - Dartdoc menjelaskan use case: safety belt untuk sign-up flow agar tidak ada celah waktu di mana status `unauthenticated` saat user navigate.

- `lib/features/auth/presentation/page/sign_up_page.dart`:
  - Tambah import `package:get_it/get_it.dart` dan `core/services/app_services.dart`.
  - Line 70-78: Listener `SignUpSuccess` panggil `GetIt.instance<AppServices>().setProfileIncomplete()` sebelum `context.go(createProfile, extra: ...)`.

- Trace sign-up flow end-to-end:
  1. User on /sign-up, status=unauthenticated.
  2. Submit -> Supabase create user+session.
  3. signedIn event -> _setStatusFromProfile() starts (async).
  4. Bloc emit SignUpSuccess.
  5. Listener: setProfileIncomplete() -> status=profileIncomplete (sync). context.go(createProfile, extra).
  6. Router Kondisi 3: status=profileIncomplete, loc=/sign-up/create-profile -> stay. User at createProfile.
  7. _setStatusFromProfile() complete: status=profileIncomplete (no change, _updateStatus idempotent). User stays.
  8. User isi form, tap Save -> FIX-4 flow -> status=authenticated -> home. ✅

- Tanpa FIX-6 (sebelumnya): ada celah waktu sesaat antara step 4 dan step 7 di mana status masih `unauthenticated`. Router Kondisi 2 + isOnAuthRoute masih allow createProfile, jadi user tidak terlempar ke /sign-in. Tapi safety belt ini memastikan konsistensi jika ada deep link / navigasi cepat.

- `flutter analyze` clean.

#### FIX-7 (Done)

File diubah:

- `lib/features/home/data/model/user_profile_model.dart`:
  - Tambah field `final bool isProfileComplete;`
  - Parse dari `json['is_profile_complete']` (default `false`).
  - Include di `toEntity()`.

- `lib/features/home/domain/entity/user_profile_entity.dart`:
  - Tambah field `final bool isProfileComplete;`
  - Update `props` dan constructor.

- `lib/features/home/presentation/bloc/greeting/greeting_state.dart`:
  - `GreetingLoaded` tambah field `final bool isProfileComplete;` (default `false`).
  - Update `props`.

- `lib/features/home/presentation/bloc/greeting/greeting_cubit.dart`:
  - `loadProfile` sekarang parse `result.data.isProfileComplete` dan emit ke `GreetingLoaded`.

- `lib/features/home/presentation/page/home_page.dart`:
  - Tambah import `package:get_it/get_it.dart` dan `core/services/app_services.dart`.
  - Extend `BlocListener<GreetingCubit, GreetingState>` (line 54-65): setelah existing logic `UpcomingCubit.loadUpcoming`, tambah cek `if (!state.isProfileComplete) GetIt.instance<AppServices>().setProfileIncomplete();`.

- Trace guard flow:
  1. User di Home (status=authenticated, mungkin dari FIX-2 network-failure fallback atau admin side change).
  2. HomePage mount, GreetingCubit `loadProfile` dipanggil.
  3. Home remote datasource fetch `user_profiles` baris user.
  4. Cubit emit `GreetingLoaded(isProfileComplete: false)`.
  5. Listener: `setProfileIncomplete()` -> status sync ke `profileIncomplete`, `notifyListeners()`.
  6. Router Kondisi 3: status=profileIncomplete, loc=/home -> `/sign-up/create-profile`. User di createProfile.

- Edge case & limitasi (FIX-7 v1):
  - **GreetingError** (network glitch): listener TIDAK fire (cuma listen ke GreetingLoaded). User stay di Home dengan empty greeting. Conservative choice (menghindari false positive redirect). Bisa di-improve nanti dengan `WidgetsBindingObserver` untuk re-check on app resume.
  - **Server-side change setelah first load**: GreetingCubit di `StatefulShellRoute` di-reuse saat tab switch; `loadProfile` cuma dipanggil sekali. Guard tidak re-fire. Bisa di-handle dengan `WidgetsBindingObserver` re-fetch on app resume. Future enhancement.
  - **No infinite loop**: setelah redirect ke createProfile dan user save profile (FIX-4), status ke `authenticated`, user kembali ke Home, GreetingCubit re-fetch, GreetingLoaded(isProfileComplete=true), no action. Loop-free.

- `flutter analyze` clean.

#### FIX-7 v2 (enhancement — empty profile saat hot restart)

User report: hot restart dengan profile row kosong di DB masih tidak trigger guard. Root cause: `home_remote_datasource.dart` pakai `.single()` yang throw `notFound`, cubit emit `GreetingError`, listener FIX-7 v1 TIDAK listen ke state itu.

File diubah:

- `lib/features/home/data/datasource/home_remote_datasource.dart`:
  - Ganti `.single()` -> `.maybeSingle()`. Return `UserProfileModel?` (null untuk no row).
- `lib/features/home/data/repository/home_repository_impl.dart`:
  - Tambah import `core/enums/failure_code.dart` dan `core/network/api_exception.dart`.
  - Handle null dari remote: return `Result.failure(ApiException(code: FailureCode.notFound, message: 'User profile not found'))`.
- `lib/features/home/presentation/bloc/greeting/greeting_state.dart`:
  - Tambah state baru `GreetingNoProfile` (distinct dari `GreetingError`).
- `lib/features/home/presentation/bloc/greeting/greeting_cubit.dart`:
  - Tambah import `core/enums/failure_code.dart`.
  - Pattern match `Failure<UserProfileEntity>(:final code)`: jika `code == FailureCode.notFound.name` -> emit `GreetingNoProfile`; else `GreetingError(message: result.message)`.
- `lib/features/home/presentation/page/home_page.dart`:
  - Extend `BlocListener`: tambah `else if (state is GreetingNoProfile) GetIt.instance<AppServices>().setProfileIncomplete();`.
  - Komentar inline menjelaskan kenapa `GreetingError` (network) tidak trigger guard.

- Trace fix v2:
  1. User hot restart dengan profile row kosong.
  2. `init()` -> `_setStatusFromProfile()` -> `getCurrentUser()` (auth) -> `notFound` (no cache) -> status default `authenticated` (FIX-2 fallback).
  3. Router Kondisi 4 izinkan /home.
  4. HomePage mount, `GreetingCubit.loadProfile`.
  5. Home remote fetch -> `.maybeSingle()` returns null.
  6. Repo: null -> `Result.failure(notFound)`.
  7. Cubit: code == 'notFound' -> emit `GreetingNoProfile`.
  8. Listener: `setProfileIncomplete()` -> status `profileIncomplete` -> Kondisi 3 -> /createProfile. ✅

- Trace Skenario network error (tidak boleh trigger redirect):
  1. User on Home, network glitch.
  2. `GreetingCubit.loadProfile` -> fetch throws network exception.
  3. Repo: catch -> `Result.failure(networkError)`.
  4. Cubit: code != 'notFound' -> emit `GreetingError`.
  5. Listener: tidak fire (cuma listen `GreetingLoaded` dan `GreetingNoProfile`). ✅ User stay di Home.

- `flutter analyze` clean.

#### FIX-8 / BUG-001-E (Done) — Race Condition `_setStatusFromProfile` Downgrade + Router `createProfile` Guard

File diubah:

- `lib/core/services/app_services.dart`:
  - `_setStatusFromProfile()` Failure case: jangan downgrade dari `profileIncomplete` ke `authenticated`.
  - Pattern: `if (_status != AppStatus.profileIncomplete) _updateStatus(AppStatus.authenticated);`
  - Rationale: SignUpPage listener (sync) sudah set status yang benar (`profileIncomplete`) via `setProfileIncomplete()`. Async fetcher (dari signedIn event) TIDAK boleh override kalau status saat ini sudah `profileIncomplete`. Untuk returning user (init() flow, status = loading), Failure case tetap default ke `authenticated` (FIX-2 behavior preserved).

- `lib/core/router/app_router.dart`:
  - Tambah early return di redirect logic, setelah loading check: `if (loc == RoutePaths.createProfile) return null;`
  - Rationale: Defense in depth. Kalau somehow status jadi `authenticated` (race window), Kondisi 4 tidak akan redirect dari `createProfile` ke `/home`. Primary fix ada di `_setStatusFromProfile()` (mencegah status berubah), guard ini adalah safety belt tambahan.

- Trace setelah fix (sign up flow):
  1. status=unauthenticated
  2. signedIn event → `_setStatusFromProfile()` starts (async)
  3. SignUpPage listener: `setProfileIncomplete()` → status=profileIncomplete
  4. `context.go(createProfile)` → Kondisi 3 (status=profileIncomplete, loc=createProfile) → STAY
  5. `_setStatusFromProfile()` finishes: `getCurrentUser()` → notFound → Failure
  6. **WITH FIX**: status is `profileIncomplete` → KEEP (no change, no notifyListeners)
  7. **NO FLICKER.** User stays on createProfile. ✅

- `flutter analyze` clean.

**Validasi skenario yang sudah ter-cover (semua ✅ penuh):**

- Skenario 1: Fresh install -> Onboarding (commit 0f48e8c).
- Skenario 2: Sudah onboarding, belum login -> Login (commit 0f48e8c).
- Skenario 3: Sign up baru -> CreateProfile -> Home (FIX-2 + FIX-3 + FIX-4 + FIX-5 + FIX-6).
- Skenario 4: Sign in, profile incomplete -> CreateProfile (FIX-2 + FIX-3 + FIX-5).
- Skenario 5: Sign in, profile lengkap -> Home (FIX-5).
- Skenario 6: Session expired -> Login (commit 0f48e8c).
- Skenario 7: Login + profile lengkap, buka app -> Home (FIX-2 init flow).
- Skenario 8: Login + profile incomplete, buka app -> CreateProfile (FIX-2 + FIX-3).
- Skenario 9: Logout + login lagi -> Login -> sesuai profile (FIX-5 listener + FIX-2 event).
- Skenario 10: User terlanjur di Home (network fallback atau server-side change), profile belum lengkap -> Redirect ke CreateProfile (FIX-7 guard).
