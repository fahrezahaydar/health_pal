# Auth Fix — Session Timeout & Guard Wiring

> Referensi: `app_router.dart` (redirect guard), `app_services.dart` (auth state), `shared_prefs.dart` (login timestamp), `app_constants.dart` (session duration)

## Masalah
1. `AppServices.login()` tidak pernah dipanggil → status tetap `unauthenticated`
2. Tidak ada session timeout → user bisa login selamanya
3. Tidak ada listener Supabase `onAuthStateChange` → logout dari luar tidak terdeteksi

## Yang sudah dilakukan

| # | Task | File | Status |
|---|---|---|---|
| 1 | AppConstants: `appSessionDuration` (4 jam) | `lib/core/constants/app_constants.dart` | ✅ |
| 2 | SharedPrefService: `loginTimestamp` + `clearAuth()` | `lib/core/services/shared_prefs.dart` | ✅ |
| 3 | AppServices: inject `SupabaseClient`, `_isSessionExpired()`, `login()` simpan timestamp, `logout()` panggil Supabase + clear prefs, `_onAuthStateChange` listener, `_forceLogout()` | `lib/core/services/app_services.dart` | ✅ |
| 4 | Wire `AppServices.login()` ke `SignInPage` (on `SignInSuccess`) | `login_page.dart` | ✅ |
| 5 | Wire `AppServices.login()` ke `CreateProfilePage` (on `CreateProfileSuccess`) | `create_profile_page.dart` | ✅ |

## Yang perlu dilakukan ke depan

| # | Task | Keterangan | Prioritas |
|---|---|---|---|
| 1 | Wiring `AppServices.logout()` di ProfilePage | Panggil `AppServices.logout()` saat tombol logout ditekan | **Medium** |
| 2 | Auto-logout dialog saat session expired | Saat `_isSessionExpired()` true, tampilkan dialog sebelum redirect ke `/sign-in` | **Low** |
| 3 | Handle `AuthChangeEvent.passwordRecovery` di AppServices | Untuk forgot password flow via magic link | **Low** |
| 4 | Cek apakah `AuthChangeEvent.signedOut` sudah handling semua skenario | Test manual: sign out dari Supabase dashboard → app harus otomatis redirect | **Low** |
