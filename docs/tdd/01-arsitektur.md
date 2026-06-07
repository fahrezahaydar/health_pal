# Technical Design Document — Bagian 1: Arsitektur

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Acuan** | PRD v1.0, USER_FLOW v2.0, Wireframe v1.0 |

---

## Daftar Isi

1. [Pola Arsitektur](#1-pola-arsitektur)
2. [Lapisan Arsitektur](#2-lapisan-arsitektur)
3. [Aturan Dependency](#3-aturan-dependency)
4. [Alur Data (Data Flow)](#4-alur-data-data-flow)
5. [State Management Strategy](#5-state-management-strategy)
6. [Navigasi & Routing](#6-navigasi--routing)
7. [Error Boundary Strategy](#7-error-boundary-strategy)

---

## 1. Pola Arsitektur

**Feature-First Clean Architecture** dengan 3 lapis per fitur:

```
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                     │
│            (UI + State Management)                       │
│  Page ──► Bloc/Cubit ──► Widget                          │
├─────────────────────────────────────────────────────────┤
│                    DOMAIN LAYER                          │
│         (Bisnis logic — pure Dart, no Flutter)           │
│  Entity ──► UseCase ──► Repository Interface             │
├─────────────────────────────────────────────────────────┤
│                      DATA LAYER                          │
│         (Implementasi teknis)                            │
│  Repository Impl ──► DataSource ──► Model                │
│                        ├── Remote (Supabase)             │
│                        └── Local (Cache)                 │
└─────────────────────────────────────────────────────────┘
```

### Kenapa Feature-First?

| Alasan | Detail |
|---|---|
| **Kohesi tinggi** | Semua file untuk satu fitur ada dalam satu folder — mudah ditemukan, mudah dihapus |
| **Skalabilitas tim** | Tiap developer bisa kerja di fitur berbeda tanpa konflik file |
| **Testability** | Tiap layer bisa di-test independen (unit test domain tanpa Flutter) |
| **Kejelasan dependensi** | Aturan dependency (→) bisa di-enforce: `data → domain ← presentation` |

---

## 2. Lapisan Arsitektur

### 2.1 Presentation Layer (UI + BLoC)

**Tanggung jawab:**
- Menampilkan UI sesuai state
- Menerima input user → dispatch event ke BLoC
- Tidak ada logika bisnis langsung

**Komponen:**
| Komponen | Contoh | Teknologi |
|---|---|---|
| Page | `SignInPage` | `StatefulWidget` / `StatelessWidget` |
| BLoC | `SignInBloc` | `flutter_bloc` |
| Event | `SignInSubmitted` | `Equatable` |
| State | `SignInInitial`, `SignInLoading`, `SignInError` | `Equatable` |
| Widget | `DoctorCard`, `AppointmentCard` | Reusable per fitur |

**Aturan:**
- Page hanya memanggil BLoC method / add event
- Page tidak pernah langsung memanggil Repository
- BLoC tidak boleh mengimpor file dari `package:flutter` (kecuali `dart:ui` untuk platform)
- Widget spesifik fitur disimpan di `features/{fitur}/presentation/widget/`
- Widget umum lintas fitur disimpan di `lib/widgets/`

### 2.2 Domain Layer (Pure Dart)

**Tanggung jawab:**
- Logika bisnis aplikasi
- Definisi entity dan repository interface
- Tidak bergantung pada framework atau package eksternal

**Komponen:**
| Komponen | Contoh | Keterangan |
|---|---|---|
| Entity | `UserEntity` | `Equatable`, immutable |
| Repository Interface | `AuthRepository` | `abstract class` |
| UseCase | `LoginWithEmailUseCase` | Satu kelas = satu fungsi bisnis |
| Value Object | `Email`, `Password` | Validasi nilai |

**Aturan:**
- **Zero Flutter dependency** — tidak boleh import `package:flutter/...`
- Tidak ada `fromJson`/`toJson` di Entity (itu tanggung jawab Model di Data layer)
- UseCase hanya bergantung pada Repository Interface (abstraksi)
- Setiap UseCase memiliki method `call()` atau `execute()` — bisa sync/async

### 2.3 Data Layer

**Tanggung jawab:**
- Implementasi konkret Repository Interface
- Mengelola sumber data (remote API, local cache)
- Mapping antara Entity ↔ Model

**Komponen:**
| Komponen | Contoh | Keterangan |
|---|---|---|
| Repository Impl | `AuthRepositoryImpl` | Implement `AuthRepository` |
| Remote DataSource | `AuthRemoteDataSource` | Supabase API calls |
| Local DataSource | `AuthLocalDataSource` | SharedPreferences / Hive |
| Model | `UserModel` | `fromJson`/`toJson`, extends `UserEntity` |
| DTO | `LoginResponseDTO` | Mapping response API |

**Aturan:**
- RepositoryImpl memilih data source berdasarkan prioritas (remote first / cache first)
- Model extends Entity → bisa digunakan di domain tanpa casting
- DataSource bersifat stateless — state dikelola di BLoC

---

## 3. Aturan Dependency

### 3.1 Arah Dependency

```
┌──────────────────────────────────────────────┐
│               Presentation                    │
│  (Page → Bloc)                               │
│         │                                     │
│         │ depends on                          │
│         ▼                                     │
│               Domain                          │
│  (Bloc → UseCase → Repository Interface)     │
│         │                                     │
│         │ depends on (via DI)                 │
│         ▼                                     │
│               Data                            │
│  (Repository Impl → DataSource → Model)      │
└──────────────────────────────────────────────┘
```

### 3.2 Diagram Visual Dependency per Fitur

```
┌─────────────────────────────┐
│  SignInPage                 │  ← Presentation
│    └─ SignInBloc            │
│         └─ LoginWithEmail   │
│            UseCase          │
└──────────┬──────────────────┘
           │ depends on
           ▼
┌─────────────────────────────┐
│  AuthRepository (abstract)  │  ← Domain
└──────────┬──────────────────┘
           │ implemented by
           ▼
┌─────────────────────────────┐
│  AuthRepositoryImpl         │  ← Data
│    └─ AuthRemoteDataSource  │
│    └─ AuthLocalDataSource   │
└─────────────────────────────┘
```

### 3.3 Aturan Ketat

| Dari | Ke | Boleh? | Catatan |
|---|---|---|---|
| Presentation | Domain | ✅ Via DI | Bloc panggil UseCase |
| Presentation | Data | ❌ Tidak langsung | Harus lewat Domain |
| Domain | Data | ❌ Tidak | Domain tidak tahu Data |
| Domain | Presentation | ❌ Tidak | Domain tidak tahu Flutter |
| Data | Domain | ✅ | Implements Repository Interface |
| Data | Presentation | ❌ Tidak | Data tidak tahu UI |
| Data → Data | Data → Data | ✅ | DataSource ke DataSource |

---

## 4. Alur Data (Data Flow)

### 4.1 Flow Request — Login (Email)

```
User tap "Sign In"
       │
       ▼
┌─────────────────────────────┐
│  SignInPage                 │
│  → add(SignInSubmitted())   │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  SignInBloc                 │
│  → emit(SignInLoading)      │
│  → LoginWithEmailUseCase    │
│    .execute(email, password)│
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  AuthRepositoryImpl         │
│  → remoteDataSource.login() │
│  → localDataSource.save()   │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  SupabaseClient (PostgREST) │
│  POST /auth/v1/token        │
└──────────┬──────────────────┘
           │ response
           ▼
┌─────────────────────────────┐
│  AuthRepositoryImpl         │
│  → map response → UserEntity│
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  SignInBloc                 │
│  → emit(SignInSuccess(user))│
│  → AppServices.login()      │
└──────────┬──────────────────┘
           │
           ▼
┌─────────────────────────────┐
│  GoRouter redirect          │
│  → /home                    │
└─────────────────────────────┘
```

### 4.2 Flow Response — Three Possible Paths

```
API Response
     │
     ├── 200/201 Success
     │     → map to Entity
     │     → emit Success state
     │     → UI render data
     │
     ├── 4xx Client Error
     │     → map to Failure object
     │     → emit Error state (dengan code + message)
     │     → UI tampilkan error spesifik
     │
     └── 5xx / Network Error
           → emit Error state
           → check cache
           → jika ada cache → render stale data + banner
           → jika tidak → UI tampilkan retry
```

### 4.3 Output Data Pattern

Semua interaksi data menggunakan pattern `Either<Failure, T>` atau `Result<T>`:

```dart
// lib/core/network/result.dart
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final FailureCode code;
  final String message;
  final int? statusCode;
  const Failure({
    required this.code,
    required this.message,
    this.statusCode,
  });
}

enum FailureCode {
  networkError,
  unauthorized,
  notFound,
  conflict,
  validationError,
  serverError,
  unknown,
}
```

---

## 5. State Management Strategy

### 5.1 Pilihan: flutter_bloc (BLoC + Cubit)

**Keputusan:** **flutter_bloc** untuk semua state management fitur.

| Kriteria | BLoC/Cubit | Provider | Riverpod |
|---|---|---|---|
| Separation of concern | ✅ Explicit Event→State | ⚠️ Campur | ✅ |
| Testability | ✅ Excellent | ⚠️ Medium | ✅ Good |
| Boilerplate | ⚠️ Lebih banyak | ✅ Minimal | ✅ Minimal |
| Debuggability | ✅ BlocObserver | ❌ | ✅ |
| Team familiarity | ✅ (SDK proyek) | — | ❌ Baru |

### 5.2 BLoC vs Cubit — Kapan Pakai Apa

| Pakai | Ketika | Contoh |
|---|---|---|
| **Cubit** | Flow sederhana, 1-2 method | `OnboardingCubit` (next/skip) |
| **Bloc** | Flow kompleks, banyak event | `SignInBloc` (submit, googleLogin, facebookLogin) |

### 5.3 State Pattern per Fitur

Setiap BLoC/Cubit mengikuti state pattern berikut:

```dart
// State base per fitur
sealed class BookingState {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingLoaded extends BookingState {
  final AppointmentEntity appointment;
  final List<DoctorSlotEntity> availableSlots;
  const BookingLoaded(this.appointment, this.availableSlots);
}

class BookingError extends BookingState {
  final Failure failure;
  const BookingError(this.failure);
}

class BookingSuccess extends BookingState {
  final AppointmentEntity result;
  const BookingSuccess(this.result);
}
```

### 5.4 Daftar BLoC/Cubit per Fitur

| Fitur | BLoC/Cubit | Type | Event |
|---|---|---|---|
| Onboarding | `OnboardingNotifier` | Cubit (ChangeNotifier) | nextPage, skip |
| Sign In | `SignInBloc` | Bloc | SignInEmailSubmitted, SignInWithGoogle, SignInWithFacebook |
| Sign Up | `SignUpBloc` | Bloc | SignUpSubmitted |
| Forgot Password | `ForgotPasswordCubit` | Cubit | sendEmail, verifyCode, resetPassword, back |
| Home | `HomeCubit` | Cubit | loadBanners, loadUpcoming, refresh |
| Doctor Search | `SearchCubit` | Cubit | search, filterBySpecialization, loadMore |
| Doctor Detail | `DoctorDetailCubit` | Cubit | loadDetail, selectDate, selectSlot |
| Booking | `BookingCubit` | Bloc | SelectSlot, UpdateComplaint, SubmitBooking |
| Booking History | `BookingHistoryCubit` | Cubit | loadHistory, filterByStatus, loadMore |
| Booking Detail | `BookingDetailCubit` | Cubit | loadDetail, cancelAppointment |
| Profile | `ProfileCubit` | Cubit | loadProfile, updateProfile, logout |
| Location Search | `LocCubit` | Cubit | searchByLocation, filterBySpecialization |

---

## 6. Navigasi & Routing

### 6.1 GoRouter + StatefulShellRoute

```
GoRouter
  ├── /onboarding             (pre-auth)
  ├── /sign-in                (pre-auth)
  │   └── /forgot-password
  ├── /sign-up                (pre-auth)
  │   └── /create-profile
  │
  ├── StatefulShellRoute      (auth required)
  │   ├── /home               (tab 0)
  │   ├── /loc                (tab 1)
  │   ├── /booking-history    (tab 2)
  │   └── /profile            (tab 3)
  │
  ├── /doctor/search          (stack — push)
  ├── /doctor/:doctorId       (stack)
  ├── /booking/:doctorId      (stack)
  ├── /booking/success        (stack)
  ├── /booking-history/:id    (stack)
  ├── /profile/edit           (stack)
  ├── /profile/favorite       (stack)
  ├── /profile/notification   (stack)
  ├── /profile/settings       (stack)
  ├── /profile/help           (stack)
  ├── /profile/tnc            (stack)
  └── /no-internet            (stack)
```

### 6.2 Redirect Logic

```dart
redirect: (context, state) {
  final status = _appServices.status;
  final loc = state.uri.path;

  final isAuthRoute = loc.startsWith('/sign-in')
                   || loc.startsWith('/sign-up');

  if (status == AppStatus.onboarding && loc != '/onboarding') {
    return '/onboarding';
  }
  if (status == AppStatus.unauthenticated && !isAuthRoute) {
    return '/sign-in';
  }
  if (status == AppStatus.authenticated && isAuthRoute) {
    return '/home';
  }
  return null;
}
```

---

## 7. Error Boundary Strategy

### 7.1 Arsitektur Error Handling

```
┌────────────────────────────────────────────┐
│            UI Layer (Widget)                │
│  → BlocBuilder: error → show snackbar/dialog│
├────────────────────────────────────────────┤
│         BLoC Layer                         │
│  → catch error → emit ErrorState(failure)   │
├────────────────────────────────────────────┤
│        Repository Layer                    │
│  → catch exception → return Failure        │
├────────────────────────────────────────────┤
│       DataSource Layer                     │
│  → throw ApiException / NetworkException   │
├────────────────────────────────────────────┤
│       Supabase / HTTP Client               │
│  → raw response / error                    │
└────────────────────────────────────────────┘
```

### 7.2 Error Mapping Chain

```
HTTP 409 Conflict
  → SupabaseClient throws PostgrestException(code: 409)
  → DataSource catch → throw ApiException('SLOT_ALREADY_BOOKED')
  → Repository catch → return Failure(FailureCode.conflict, 'Slot sudah dipesan')
  → BLoC catch → emit ErrorState(failure)
  → Widget catch → show dialog "Slot sudah dipesan, pilih lain"
```

### 7.3 Global Error Handler

```dart
// lib/core/network/error_handler.dart
class ErrorHandler {
  static Failure mapToFailure(Object error) {
    return switch (error) {
      ApiException(:final code, :final message) => switch (code) {
        'SLOT_ALREADY_BOOKED' => Failure(
          code: FailureCode.conflict,
          message: 'Slot sudah dipesan. Silakan pilih slot lain.',
        ),
        'UNAUTHORIZED' => Failure(
          code: FailureCode.unauthorized,
          message: 'Sesi habis. Silakan login ulang.',
        ),
        'VALIDATION_ERROR' => Failure(
          code: FailureCode.validationError,
          message: message,
        ),
        _ => Failure(
          code: FailureCode.serverError,
          message: 'Terjadi kesalahan. Coba lagi.',
        ),
      },
      NetworkException _ => Failure(
        code: FailureCode.networkError,
        message: 'Periksa koneksi internet Anda.',
      ),
      _ => Failure(
        code: FailureCode.unknown,
        message: 'Terjadi kesalahan yang tidak diketahui.',
      ),
    };
  }
}
```

---

## 8. Diagram Dependency — Semua Fitur

```
┌─────────────────────────────────────────────────────────────────┐
│                     SHARED CORE                                 │
│  core/                                                         │
│  ├── di/          → Injectable modules                         │
│  ├── enums/       → AppStatus, Gender, FailureCode             │
│  ├── network/     → ApiException, Result, ErrorHandler         │
│  ├── router/      → AppRouter (GoRouter + StatefulShellRoute)  │
│  ├── services/    → AppServices, SharedPrefService             │
│  ├── theme/       → AppTheme, AppTextTheme                     │
│  └── supabase/    → SupabaseClient singleton                   │
├─────────────────────────────────────────────────────────────────┤
│                    SHARED WIDGETS                               │
│  widgets/                                                       │
│  ├── button/      → LightFilledButton, LightOutlineButton      │
│  ├── dialog/      → AppCustomDialog, AppLoadingDialog          │
│  ├── form/        → AppForm, AppFormField, AppDropdownField    │
│  ├── input/       → AppInputField, AppPinField                │
│  ├── loader/      → DotLoader                                  │
│  └── picker/      → AppPhotoPicker                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                │
│  features/auth/            features/home/     features/booking/ │
│  ├── data/                 ├── data/          ├── data/         │
│  ├── domain/               ├── domain/        ├── domain/       │
│  └── presentation/         └── presentation/  └── presentation/ │
│                                                                │
│  features/profile/         features/onboarding/                 │
│  ├── data/                 └── presentation/                   │
│  ├── domain/                 (sederhana, tanpa data/domain)     │
│  └── presentation/                                            │
└─────────────────────────────────────────────────────────────────┘
```

---

*Dokumen ini adalah living document. Setiap perubahan arsitektur harus di-update di sini sebelum implementasi.*
