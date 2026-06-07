# Technical Design Document — Bagian 6: API Integration & Error Handling

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Acuan** | API Contract v1.0, TDD Bagian 5 |

---

## Daftar Isi

1. [API Client Architecture](#1-api-client-architecture)
2. [Error Taxonomy](#2-error-taxonomy)
3. [Global Error Handler](#3-global-error-handler)
4. [Error Mapping Chain](#4-error-mapping-chain)
5. [Supabase Query Patterns](#5-supabase-query-patterns)
6. [Timeout & Retry Strategy](#6-timeout--retry-strategy)
7. [Auth Token Lifecycle](#7-auth-token-lifecycle)

---

## 1. API Client Architecture

### 1.1 Supabase Client: Satu-satunya "API Client"

Tidak ada Dio / http package — semua komunikasi data via **Supabase Flutter SDK**:

```
┌────────────────────────────────────────────┐
│  Flutter App                               │
│  ┌──────────────────────────────────────┐  │
│  │  SupabaseClient                      │  │
│  │  ├── .from('doctors') → PostgREST    │  │
│  │  ├── .functions.invoke() → Edge Fn   │  │
│  │  ├── .auth → GoTrueClient            │  │
│  │  └── .storage → StorageClient        │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```

**Kenapa tidak Dio/http?** Supabase SDK handle auth headers, refresh token, dan RLS secara otomatis. Menambah HTTP client lain hanya duplikasi.

### 1.2 Initialization

```dart
// main.dart
await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
);
```

---

## 2. Error Taxonomy

### 2.1 All Possible Errors

| Sumber | Type | Contoh |
|---|---|---|
| Supabase Auth | `AuthException` | Email not confirmed, invalid credentials |
| PostgREST | `PostgrestException` | 409 conflict, 404 not found, 422 validation |
| Edge Function | `FunctionsException` | Custom error dari Edge Function |
| Network | `ClientException` (http) | Timeout, no internet, DNS |
| Supabase Realtime | `RealtimeException` | Connection closed |

### 2.2 Normalized Error (ApiException)

```dart
// lib/core/network/api_exception.dart
class ApiException implements Exception {
  final int statusCode;
  final String code;       // 'SLOT_ALREADY_BOOKED', 'VALIDATION_ERROR', etc
  final String message;    // User-friendly message
  final Map<String, dynamic>? details;

  const ApiException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.details,
  });

  bool get isUnauthorized => statusCode == 401;
  bool get isSlotConflict => code == 'SLOT_ALREADY_BOOKED';
  bool get isNotFound => statusCode == 404;

  factory ApiException.fromSupabaseError(Object error) {
    return switch (error) {
      PostgrestException(:final code, :final message, :final details) =>
        ApiException(
          statusCode: _parseHttpCode(code ?? '500'),
          code: _mapPostgrestCode(code ?? 'UNKNOWN'),
          message: message ?? 'Terjadi kesalahan database.',
          details: details,
        ),
      AuthException(:final statusCode, :final message) =>
        ApiException(
          statusCode: statusCode ?? 401,
          code: _mapAuthCode(message ?? ''),
          message: _mapAuthMessage(message ?? ''),
        ),
      FunctionsException(:final statusCode, :final message) =>
        ApiException(
          statusCode: statusCode ?? 500,
          code: _parseCustomCode(message ?? ''),
          message: message ?? 'Terjadi kesalahan server.',
        ),
      _ => ApiException(
        statusCode: 0,
        code: 'UNKNOWN_ERROR',
        message: 'Terjadi kesalahan yang tidak diketahui.',
      ),
    };
  }
}
```

---

## 3. Global Error Handler

```dart
// lib/core/network/error_handler.dart

class ErrorHandler {
  /// Panggil dari Repository untuk konversi error → Failure
  static Failure handle(Object error) {
    final apiError = error is ApiException
        ? error
        : ApiException.fromSupabaseError(error);

    // Log error untuk debugging
    _logError(apiError);

    // Map ke Failure
    return Failure(
      code: _mapToFailureCode(apiError),
      message: apiError.message,
      statusCode: apiError.statusCode,
    );
  }

  /// Auth error: trigger logout jika 401
  static Future<Failure> handleWithAuthCheck(
    Object error,
    AppServices appServices,
  ) async {
    final failure = handle(error);
    if (failure.code == FailureCode.unauthorized) {
      await appServices.logout();
    }
    return failure;
  }

  static FailureCode _mapToFailureCode(ApiException e) {
    return switch (e.code) {
      'SLOT_ALREADY_BOOKED'      => FailureCode.conflict,
      'VALIDATION_ERROR'         => FailureCode.validationError,
      'INVALID_PLATFORM'         => FailureCode.validationError,
      'NOT_FOUND'                => FailureCode.notFound,
      'FORBIDDEN'                => FailureCode.forbidden,
      'UNAUTHORIZED'             => FailureCode.unauthorized,
      'TRANSACTION_FAILED'       => FailureCode.serverError,
      'INTERNAL_SERVER_ERROR'    => FailureCode.serverError,
      'INVALID_STATUS_TRANSITION'=> FailureCode.validationError,
      'MISSING_COORDINATES'      => FailureCode.validationError,
      'INVALID_RADIUS'           => FailureCode.validationError,
      _ when e.statusCode == 0   => FailureCode.networkError,
      _                          => FailureCode.unknown,
    };
  }
}
```

---

## 4. Error Mapping Chain

### 4.1 Full Chain: Slot Conflict

```
User tap "Konfirmasi Booking"
  → POST /functions/v1/create-appointment
    → Edge Function cek is_booked = false
    → Ternyata sudah di-booking user lain (race condition)
    → Return HTTP 409 + {"code":"SLOT_ALREADY_BOOKED","message":"..."}

  → Supabase SDK throws FunctionsException(409)
    ↓
  → DataSource catch → throw ApiException.fromSupabaseError()
    → code: "SLOT_ALREADY_BOOKED", statusCode: 409
    ↓
  → Repository catch → return Failure(conflict, 'Slot sudah dipesan...')
    ↓
  → BookingBloc catch → emit BookingError(failure)
    ↓
  → BookAppointmentPage BlocListener → tampilkan dialog
    → "Slot sudah dipesan. Pilih slot lain."
    → Tap OK → refresh slot list
```

### 4.2 Full Chain: Token Expired

```
API call apa pun → Supabase SDK deteksi 401
  → SDK auto-refresh token
    → Refresh sukses → retry original request (transparent)
    → Refresh gagal → throw AuthException

  → Global ErrorHandler.handleWithAuthCheck()
    → Failure(unauthorized, 'Sesi habis')
    → AppServices.logout()
    → GoRouter redirect ke /sign-in
```

---

## 5. Supabase Query Patterns

### 5.1 Standard CRUD

```dart
// GET with nested relations
final doctors = await supabase
  .from('doctors')
  .select('''
    *,
    clinics (*),
    specializations (*)
  ''')
  .eq('is_active', true)
  .ilike('full_name', '%$keyword%')
  .order('rating_avg', ascending: false)
  .limit(20);

// INSERT with return
final result = await supabase
  .from('user_profiles')
  .insert({...})
  .select()
  .single();

// UPDATE with filter
await supabase
  .from('appointments')
  .update({'status': 'cancelled', 'cancelled_at': now.toIso8601String()})
  .eq('id', appointmentId)
  .eq('patient_id', profileId);
```

### 5.2 Edge Function Invocation

```dart
// POST custom logic
final response = await supabase.functions.invoke(
  'create-appointment',
  body: {
    'doctor_id': doctorId,
    'slot_id': slotId,
    'complaint_note': complaint,
  },
);

if (response.status != 201) {
  throw ApiException.fromSupabaseError(response);
}

final data = response.data as Map<String, dynamic>;
return CreateAppointmentResponse.fromJson(data);
```

### 5.3 Storage

```dart
// Upload avatar
final bytes = await photo.readAsBytes();
final path = 'avatars/$userId/profile.jpg';

await supabase.storage.from('avatars').uploadBinary(path, bytes);

final publicUrl = supabase.storage.from('avatars').getPublicUrl(path);

// Update profile dengan URL baru
await supabase.from('user_profiles').update({'avatar_url': publicUrl}).eq('auth_id', userId);
```

---

## 6. Timeout & Retry Strategy

### 6.1 Default Timeout

| Operation | Timeout |
|---|---|
| Query (select) | 10 detik |
| Mutation (insert/update) | 15 detik |
| File upload | 60 detik |
| Edge Function | 30 detik |
| Auth (login) | 15 detik |

### 6.2 Retry Policy

| Error | Retry Count | Delay | Notes |
|---|---|---|---|
| Network error | 2 | 1s, 3s | Exponential backoff |
| 500 Server Error | 1 | 3s | Satu kali retry |
| 429 Rate Limited | 1 | 5s | Header `Retry-After` |
| 409 Conflict | 0 | — | User harus pilih ulang |
| 4xx lainnya | 0 | — | Tidak di-retry |

```dart
Future<T> withRetry<T>(Future<T> Function() fn, {int maxRetries = 2}) async {
  for (var i = 0; i <= maxRetries; i++) {
    try {
      return await fn();
    } on NetworkException catch (_) {
      if (i == maxRetries) rethrow;
      await Future.delayed(Duration(seconds: pow(2, i).toInt()));
    }
  }
  throw const NetworkException('Max retries exceeded');
}
```

---

## 7. Auth Token Lifecycle

```
Register / Login
  → Supabase Auth return access_token + refresh_token
  → SDK simpan di SecureStorage (internal)
  → Token expired (3600 detik)
  → SDK auto-refresh menggunakan refresh_token
    → Refresh sukses → lanjut
    → Refresh gagal → AuthException → AppServices.logout()
  → User login ulang
```

**RLS Enforcement:** Semua query via `supabase.from()` otomatis menyertakan header `Authorization: Bearer <token>`. RLS di sisi PostgreSQL memvalidasi token dan menerapkan policy per baris.
