# Audit: Register + Create Profile Flow

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal Audit** | 24 Juni 2026 |
| **Auditor** | Flutter Developer |
| **Cakupan** | Onboarding → Sign Up → Create Profile → Home |
| **Referensi** | USER_FLOW.md §4.2, API Contract §2.1 + §3.2, BUG-004, TDD 04 §4.4 |

---

## 1. End-to-End Flow

```
[Onboarding] → completeOnboarding() → AppStatus.unauthenticated
    ↓
[Sign In / Sign Up]
    ↓ (pilih Sign Up)
[Sign Up Page] — form-only (NO Supabase call)
    ↓ context.go('/sign-up/create-profile', extra: {email, password, name})
[Create Profile Page]
    ↓ cubit.register()
  ┌─────────────────────────────────────────┐
  │ RegisterAndCreateProfileUseCase.call()  │
  │  → AuthRepository.registerAndCreate…() │
  │    1. auth.signUp()                     │
  │    2. upload avatar (optional)          │
  │    3. INSERT user_profiles              │
  │    4. update auth metadata              │
  │    5. cache local                       │
  │    6. return Result.success             │
  └─────────────────────────────────────────┘
    ↓ success
  AppServices.markProfileComplete()
    ↓
  context.go('/home')
```

---

## 2. Route Tree

| Route | Page | Auth Required | Source File |
|---|---|---|---|
| `/onboarding` | `OnboardingPage` | No | `app_router.dart:106` |
| `/sign-up` | `SignUpPage` | No | `app_router.dart:128` |
| `/sign-up/create-profile` | `CreateProfilePage` | **Special** (bypass redirect) | `app_router.dart:136` |
| `/sign-in` | `SignInPage` | No | `app_router.dart:112` |

**Redirect guard special case** (`app_router.dart:61`):
```dart
if (loc == RoutePaths.createProfile) return null; // ← JANGAN redirect
```

---

## 3. Arsitektur per Layer

### 3.1 Data Layer

| File | Path | Peran |
|---|---|---|
| `AuthRemoteDataSource` | `lib/features/auth/data/datasource/auth_remote_datasource.dart` | Supabase calls: signUp, upload, insert profile, update metadata, delete_user RPC |
| `AuthLocalDataSource` | `lib/features/auth/data/datasource/auth_local_datasource.dart` | SharedPref: cache user profile, session |
| `AuthRepositoryImpl` | `lib/features/auth/data/repository/auth_repository_impl.dart` | Orchestrator: atomic `registerAndCreateProfile()` + `_safeCleanup()` |

### 3.2 Domain Layer

| File | Path | Peran |
|---|---|---|
| `AuthRepository` | `lib/features/auth/domain/repository/auth_repository.dart` | Abstract interface |
| `RegisterAndCreateProfileUseCase` | `lib/features/auth/domain/usecase/register_and_create_profile_usecase.dart` | Primary use case (atomic) |
| `CreateProfileUseCase` | `lib/features/auth/domain/usecase/create_profile_usecase.dart` | Secondary use case (fallback — profile only) |

### 3.3 Presentation Layer

| File | Path | Peran |
|---|---|---|
| `SignUpPage` | `lib/features/auth/presentation/page/sign_up_page.dart` | Form name/email/password → navigasi ke create-profile |
| `CreateProfilePage` | `lib/features/auth/presentation/page/create_profile_page.dart` | Form foto/nickname/gender/DOB → submit |
| `CreateProfileCubit` | `lib/features/auth/presentation/bloc/create_profile/create_profile_cubit.dart` | State management: register(), createProfile() |
| `CreateProfileState` | `lib/features/auth/presentation/bloc/create_profile/create_profile_state.dart` | Sealed state + form fields |
| `OnboardingPage` | `lib/features/onboarding/presentation/page/onboarding_page.dart` | 3-slide carousel |
| `OnboardingNotifier` | `lib/features/onboarding/presentation/bloc/onboarding_notifier.dart` | PageView logic + completeOnboarding() |

### 3.4 Core Services

| File | Path | Peran |
|---|---|---|
| `AppServices` | `lib/core/services/app_services.dart` | AppStatus state machine + auth listener |
| `AppStatus` | `lib/core/enums/app_status.dart` | Enum: `loading → onboarding → unauthenticated → profileIncomplete → authenticated` |
| `AppRouter` | `lib/core/router/app_router.dart` | GoRouter + redirect guard |
| `RoutePaths` | `lib/core/router/route_paths.dart` | Route path constants |

---

## 4. State Machine Diagram (AppStatus)

```
start → loading
          ↓ (onboardingDone = false)
        onboarding
          ↓ (completeOnboarding)
        unauthenticated
          ↓ (signUp success → profileIncomplete safety belt)
        profileIncomplete
          ↓ (markProfileComplete)
        authenticated
          ↓ (signOut)
        unauthenticated
```

### Transitions

| Transition | Trigger | File |
|---|---|---|
| `loading → onboarding` | `prefs.getBool('onboarding_done') == false` | `app_services.dart:96` |
| `onboarding → unauthenticated` | `completeOnboarding()` | `onboarding_notifier.dart:35` |
| `unauthenticated → profileIncomplete` | **Implicit**: `_onAuthStateChange` → `signedIn` → fetch profile → `isProfileComplete=false` | `app_services.dart:120` |
| `profileIncomplete → authenticated` | `markProfileComplete()` | `create_profile_page.dart:130` |
| `authenticated → unauthenticated` | `signOut()` | `app_services.dart:195` |

> **CAUTION:** `unauthenticated → profileIncomplete` terjadi otomatis saat Supabase `signedIn` event fire. Safety belt `setProfileIncomplete()` di `CreateProfilePage` (dipanggil SEBELUM `register()`) mencegah race condition redirect ke `/home` sebelum profile selesai.

---

## 5. Atomic `registerAndCreateProfile` Detail

### Step-by-step (`auth_repository_impl.dart:85-140`)

| # | Step | Method | Success | Failure |
|---|---|---|---|---|
| 1 | SignUp with metadata | `auth.signUp(email, password, data: {display_name, is_profile_complete: false})` | `createdAuthId = response.user.id` | Return error immediately |
| 2 | Upload avatar | `storage.uploadAvatar(createdAuthId, photo)` | `avatarUrl` string | Skip (optional) |
| 3 | Insert profile | `user_profiles.insert({auth_id, full_name, ...})` | Profile row created | → `_safeCleanup(createdAuthId)` |
| 4 | Update auth metadata | `auth.updateUser({is_profile_complete: true})` | Metadata updated | → `_safeCleanup(createdAuthId)` |
| 5 | Cache local | `local.cacheUser(profile)` | SharedPref saved | Return success anyway |
| 6 | Return | `Result.success(profile.toEntity())` | — | — |

### Cleanup Strategy (`_safeCleanup`, lines 148-161)

```
_safeCleanup(createdAuthId?)
  → if (createdAuthId != null)
      try:
        1. _remote.deleteCurrentUser()  // RPC delete_user() — SECURITY DEFINER
        2. log 'cleanup: ghost user deleted'
      catch (e):
        log 'cleanup fallback: signOut only'
        _remote.signOut()  // client-clean only — ghost account di server tetap ada
```

> **BLOCKER:** `delete_user()` SQL function (migration `003`) sudah ada di `supabase/migrations/003_delete_user_rpc.sql` tapi perlu diverifikasi sudah ter-deploy ke Supabase project.

---

## 6. File Inventory

### Source Files (13 files)

| # | File | Lines | Perubahan Terakhir |
|---|---|---|---|
| 1 | `lib/features/auth/data/datasource/auth_remote_datasource.dart` | — | BUG-004 |
| 2 | `lib/features/auth/data/datasource/auth_local_datasource.dart` | — | Initial |
| 3 | `lib/features/auth/data/repository/auth_repository_impl.dart` | 245 | BUG-004 |
| 4 | `lib/features/auth/domain/repository/auth_repository.dart` | 24 | BUG-004 |
| 5 | `lib/features/auth/domain/usecase/register_and_create_profile_usecase.dart` | 34 | BUG-004 |
| 6 | `lib/features/auth/domain/usecase/create_profile_usecase.dart` | 33 | BUG-004 |
| 7 | `lib/features/auth/presentation/page/sign_up_page.dart` | 246 | BUG-004 |
| 8 | `lib/features/auth/presentation/page/create_profile_page.dart` | 302 | BUG-004 |
| 9 | `lib/features/auth/presentation/bloc/create_profile/create_profile_cubit.dart` | 117 | BUG-004 |
| 10 | `lib/features/auth/presentation/bloc/create_profile/create_profile_state.dart` | 64 | BUG-004 |
| 11 | `lib/features/onboarding/presentation/page/onboarding_page.dart` | 153 | Initial |
| 12 | `lib/features/onboarding/presentation/bloc/onboarding_notifier.dart` | 45 | Initial |
| 13 | `lib/core/services/app_services.dart` | 222 | BUG-004 |

### Core Support Files

| # | File | Peran |
|---|---|---|
| 14 | `lib/core/router/app_router.dart` | Route defs + redirect guard |
| 15 | `lib/core/router/route_paths.dart` | Path constants |
| 16 | `lib/core/enums/app_status.dart` | State enum |
| 17 | `lib/core/network/result.dart` | Result sealed class |

### Documentation Files

| # | File | Peran |
|---|---|---|
| 18 | `docs/user_flow/USER_FLOW.md` | Flow diagrams §4.1, §4.2 |
| 19 | `docs/api_contract/api_contract_health_pal.md` | API specs §2.1, §3.1, §3.2, §3.3, §3.5 |
| 20 | `docs/tdd/02-folder-structure.md` | Folder layout |
| 21 | `docs/tdd/03-routing-design.md` | Route tree + guard logic |
| 22 | `docs/tdd/04-state-management.md` | Cubit spec |
| 23 | `docs/tdd/12-task-breakdown.md` | Task list |
| 24 | `docs/wireframe/03-sign-up.md` | Sign Up wireframe |
| 25 | `docs/wireframe/04-create-profile.md` | Create Profile wireframe |
| 26 | `docs/bug-sprint-1/BUG-004-signup-profile.md` | Bug report + 11 FIXes |

---

## 7. Gap Analysis

### ✅ Implemented Correctly

| Aspek | Detail |
|---|---|
| Form-only Sign Up | `SignUpPage` tidak panggil Supabase — navigasi ke create-profile via `extra` |
| Atomic register+profile | `RegisterAndCreateProfileUseCase` gabung signUp + insert profile dalam satu method |
| Safety belt | `setProfileIncomplete()` BEFORE register() → cegah redirect dini |
| Router bypass | Route `createProfile` di-skip dari redirect guard → tidak akan kena redirect ke `/home` |
| Cleanup on failure | `_safeCleanup()` → RPC `delete_user()` + fallback `signOut()` |
| UI error "already registered" | Dialog khusus dengan pesan actionable |
| Result pattern | Semua use case return sealed class `Result<T>` |

### ⚠️ Issues / Risiko

| # | Issue | Severity | Detail |
|---|---|---|---|
| 1 | `delete_user()` RPC belum diverifikasi deploy | **HIGH** | Migration `003` exists, tapi belum tentu sudah di `supabase db push`. Cleanup fallback hanya `signOut()` → ghost account. |
| 2 | Google sign-up tidak handle | **MEDIUM** | `SignUpPage` tombol Google/Facebook `onPressed: () {}` — no-op. User flow Google via `/sign-in` (signInWithOAuth), tapi tidak ada handler untuk user baru yang daftar via Google → tidak ada create-profile flow. |
| 3 | Race condition safety belt | **MEDIUM** | `setProfileIncomplete()` hanya dipanggil sekali di init. Jika `_onAuthStateChange` fire SEBELUM `setProfileIncomplete`, redirect ke `/home` bisa terjadi sebelum profile selesai. |
| 4 | Email verification not handled | **LOW** | API Contract §2.1: Supabase kirim email verifikasi. Tapi di flow tidak ada cek `email_confirmed_at`. User bisa lanjut ke create-profile tanpa verifikasi email. |
| 5 | Duplicate use case | **LOW** | `CreateProfileUseCase` (secondary) masih ada meski sudah digantikan `RegisterAndCreateProfileUseCase`. Dead code? |
| 6 | Date format inconsistency | **LOW** | `date_of_birth` dikirim sebagai `"yyyy-MM-dd"` string (manual split). ERD specify `DATE` type. OK untuk PostgreSQL, tapi perlu konsistensi. |
| 7 | Error dialog blocking | **LOW** | `failure` state → dismiss loading dialog → show error dialog. Tapi cubit masih di `failure` state — user harus exit page untuk retry. |

### 🔴 BLOCKER Checklist

- [ ] Verifikasi `supabase/migrations/003_delete_user_rpc.sql` sudah di-deploy
- [ ] Test: sign up → matikan internet step 3 → verify cleanup dipanggil
- [ ] Test: sign up → profile sudah ada (already registered) → verify error dialog
- [ ] Test: `supabase db reset` → flow end-to-end (onboarding → sign up → create profile → home)
- [ ] Test: safety belt — verify redirect guard tidak pernah arahkan ke `/home` sebelum `markProfileComplete()`

---

## 8. Rekomendasi

| # | Rekomendasi | Prioritas |
|---|---|---|
| 1 | Verifikasi deployment `delete_user()` RPC + test cleanup path | **HIGH** |
| 2 | Implement Google sign-up flow (buat `RegisterAndCreateProfileWithGoogleUseCase` atau handle via existing use case) | **MEDIUM** |
| 3 | Pindah `setProfileIncomplete()` ke `onInit` cubit sebelum listener apa pun aktif | **MEDIUM** |
| 4 | Evaluate dead code: apakah `CreateProfileUseCase` masih dipakai atau bisa dihapus? | **LOW** |
| 5 | Tambah integration test untuk atomic flow + cleanup | **LOW** |

---

*Dokumen ini adalah audit snapshot untuk register + create profile flow. Setiap perubahan pada flow ini harus mengupdate dokumen ini.*
