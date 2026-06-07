# Technical Design Document — Bagian 7: Dependency Injection Graph

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Package** | `injectable` + `get_it` |

---

## Daftar Isi

1. [DI Architecture](#1-di-architecture)
2. [Module Registration](#2-module-registration)
3. [Dependency Graph per Fitur](#3-dependency-graph-per-fitur)
4. [Lifecycle Management](#4-lifecycle-management)
5. [Full Registration List](#5-full-registration-list)

---

## 1. DI Architecture

```
┌─────────────────────────────────────────────┐
│            get_it (Service Locator)          │
│  getIt<SupabaseClient>()                     │
│  getIt<AuthRepository>()                     │
│  getIt<SignInBloc>()                         │
│  ...                                         │
├─────────────────────────────────────────────┤
│         injectable (Code Generator)          │
│  @singleton → getIt.registerSingleton()      │
│  @lazySingleton → registerLazySingleton()    │
│  @factory → registerFactory()                │
│  @injectable → registerFactory()             │
└─────────────────────────────────────────────┘
```

---

## 2. Module Registration

### 2.1 External Module

```dart
// lib/core/di/register_module.dart
@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
```

### 2.2 Environment

```dart
// lib/core/di/environment.dart
const dev = Environment('dev');
const prod = Environment('prod');

@dev
@Injectable(as: AuthRepository)
class AuthRepositoryImplDev implements AuthRepository { ... }

@prod
@Injectable(as: AuthRepository)
class AuthRepositoryImplProd implements AuthRepository { ... }
```

---

## 3. Dependency Graph per Fitur

### Auth Feature

```
┌─────────────┐     ┌────────────────────┐     ┌──────────────────────┐
│ SignInBloc  │────▶│ LoginWithEmail     │────▶│ AuthRepository       │
│ @factory    │     │ UseCase            │     │ (abstract)           │
│             │     │ @injectable        │     │ @lazySingleton       │
└─────────────┘     └────────────────────┘     └──────────┬───────────┘
                                                          │
                                               ┌──────────▼───────────┐
                                               │ AuthRepositoryImpl   │
                                               │ @Injectable(as: ...) │
                                               └──────────┬───────────┘
                                                          │
                                     ┌────────────────────┼────────────────────┐
                                     │                    │                    │
                            ┌────────▼──────┐   ┌─────────▼───────┐  ┌─────────▼───────┐
                            │ AuthRemote    │   │ AuthLocal       │  │ SupabaseClient  │
                            │ DataSource    │   │ DataSource      │  │ @singleton      │
                            │ @injectable   │   │ @injectable     │  │                 │
                            └───────────────┘   └─────────────────┘  └─────────────────┘
```

### Doctor Feature

```
┌──────────────┐     ┌───────────────────┐     ┌─────────────────┐
│ SearchCubit  │────▶│ SearchDoctors     │────▶│ DoctorRepository│
│ @factory     │     │ UseCase           │     │ @lazySingleton  │
└──────────────┘     └───────────────────┘     └────────┬────────┘
                                                          │
┌──────────────┐     ┌───────────────────┐               │
│ DoctorDetail │────▶│ GetDoctorDetail   │───────────────┘
│ Cubit        │     │ UseCase           │
│ @factory     │     └───────────────────┘
└──────────────┘
```

---

## 4. Lifecycle Management

| Annotation | Scope | Dipakai Untuk |
|---|---|---|
| `@singleton` | Satu instance, seumur app | `SupabaseClient`, `SharedPreferences` |
| `@lazySingleton` | Satu instance, dibuat saat pertama dipanggil | `AppRouter`, `AppServices`, `AuthRepository`, `DoctorRepository` |
| `@factory` | Instance baru setiap kali | `SignInBloc`, `HomeCubit`, `CreateProfileCubit` |
| `@injectable` | Factory (sama) | DataSource, UseCase |
| `@preResolve` | Inisialisasi async sebelum app ready | `SharedPreferences` |

### 4.1 BLoC Lifecycle

BLoC/Cubit menggunakan `@factory` — bukan singleton — agar state tidak terbagi antar pengguna:

```dart
@factory
class HomeCubit extends Cubit<HomeState> { ... }

// Setiap kali user masuk ke HomePage:
//   HomeCubit baru dibuat → state = initial
//   loadData() → state = loaded

// Setiap kali user keluar dari HomePage:
//   HomeCubit di-dispose → memory terlepas
```

### 4.2 Repository Lifecycle

Repository menggunakan `@lazySingleton` — dibuat sekali dan dipakai bersama:

```dart
@lazySingleton
class AuthRepositoryImpl implements AuthRepository { ... }

// SignInBloc dan SignUpBloc panggil repository yang SAMA
// → tidak ada duplikasi data source
```

---

## 5. Full Registration List

### Singletons

```dart
@singleton
  SupabaseClient
  SharedPreferences

@lazySingleton
  AppServices
  AppRouter
  SharedPrefService

  // Repository
  AuthRepository (impl)
  DoctorRepository (impl)
  BookingRepository (impl)
  ProfileRepository (impl)
  HomeRepository (impl)
```

### Factory (per request)

```dart
// BLoC / Cubit — baru setiap halaman dibuka
@factory
  OnboardingNotifier
  SignInBloc
  SignUpBloc
  ForgotPasswordCubit
  CreateProfileCubit
  HomeCubit
  SearchCubit
  DoctorDetailCubit
  LocCubit
  BookingBloc
  BookingHistoryCubit
  BookingDetailCubit
  ProfileCubit
  EditProfileCubit

// UseCase — tidak punya state
@injectable
  LoginWithEmailUseCase
  SignUpUseCase
  ForgotPasswordUseCase
  CreateProfileUseCase
  GetBannersUseCase
  GetUpcomingUseCase
  GetSpecializationsUseCase
  SearchDoctorsUseCase
  GetDoctorDetailUseCase
  GetSlotsUseCase
  SearchByLocationUseCase
  CreateAppointmentUseCase
  GetBookingHistoryUseCase
  GetBookingDetailUseCase
  CancelAppointmentUseCase
  GetProfileUseCase
  UpdateProfileUseCase
  UploadAvatarUseCase
  LogoutUseCase

// DataSource — tidak punya state
@injectable
  AuthRemoteDataSource
  AuthLocalDataSource
  DoctorRemoteDataSource
  BookingRemoteDataSource
  ProfileRemoteDataSource
  ProfileLocalDataSource
  BannerRemoteDataSource
  NotificationRemoteDataSource
```
