# Technical Design Document — Bagian 5: Data Layer Design

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Acuan** | ERD v1.0, API Contract v1.0 |

---

## Daftar Isi

1. [Lapisan Data](#1-lapisan-data)
2. [Repository Pattern](#2-repository-pattern)
3. [Model ↔ Entity Mapping](#3-model--entity-mapping)
4. [Data Source Strategy](#4-data-source-strategy)
5. [Daftar Model per Fitur](#5-daftar-model-per-fitur)
6. [Supabase Client](#6-supabase-client)

---

## 1. Lapisan Data

```
┌─────────────────────────────────────────────┐
│              Repository (Impl)               │
│  Pilih data source: Remote / Local / Both    │
├─────────────────────────────────────────────┤
│  RemoteDataSource            LocalDataSource │
│  (Supabase / PostgREST)     (SharedPref/Hive)│
│  ┌──────────────────┐       ┌──────────────┐ │
│  │ SupabaseClient   │       │ SharedPref   │ │
│  │ GoTrueClient     │       │ Hive Box     │ │
│  │ FunctionsClient  │       │              │ │
│  └──────────────────┘       └──────────────┘ │
└─────────────────────────────────────────────┘
```

---

## 2. Repository Pattern

### 2.1 Abstract Interface (Domain)

```dart
// lib/features/auth/domain/repository/auth_repository.dart
abstract class AuthRepository {
  Future<Result<UserEntity>> loginWithEmail(String email, String password);
  Future<Result<UserEntity>> loginWithGoogle();
  Future<Result<UserEntity>> signUp(String name, String email, String password);
  Future<Result<void>> sendForgotPasswordEmail(String email);
  Future<Result<void>> resetPassword(String newPassword);
}
```

### 2.2 Implementation (Data)

```dart
// lib/features/auth/data/repository/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Result<UserEntity>> loginWithEmail(String email, String password) async {
    try {
      final response = await _remote.login(email, password);
      await _local.saveSession(response.session);
      final user = response.user.toEntity();
      return Success(user);
    } on ApiException catch (e) {
      return Failure(mapFailure(e));
    } on NetworkException catch (e) {
      return Failure(FailureCode.networkError, 'Periksa koneksi');
    }
  }
}
```

### 2.3 Error Handling Flow

```
RemoteDataSource
  → throws ApiException / PostgrestException / FormatException
RepositoryImpl
  → catch → panggil ErrorHandler.mapToFailure()
  → return Failure
```

---

## 3. Model ↔ Entity Mapping

### 3.0 Strategi Mapping: Snake ↔ Camel & Enum

**Keputusan Arsitektur v1.0:**

| Aspek | Keputusan | Rationale |
|---|---|---|
| JSON key naming | `snake_case` (sesuai PostgreSQL/Supabase) | Native DB convention, no transform cost |
| Dart field naming | `camelCase` (sesuai Dart convention) | Standard linter enforced |
| Mapping strategy | **Per-field `@JsonKey(name: 'snake_case')`** | Eksplisit, mudah di-debug, tidak butuh global config |
| Code generation | `@freezed` + `@JsonSerializable` | Immutable, copyWith, ==/hashCode otomatis |
| Snake fallback | ❌ Tidak pakai `FieldRename.snake` global | Lebih eksplisit, hindari surprise untuk field yang sudah camel |
| DateTime format | Custom converter per type (date-only, time-only, ISO 8601) | Native Dart `DateTime` tidak support `TimeOfDay` |
| Enum mapping | `@JsonValue('snake_value')` per enum constant | Hindari runtime `byName` exception |
| **Gender enum values** | `male`, `female`, `other` (per ERD v1.0 §2.2) | Konsisten dengan PostgreSQL CHECK constraint |

> **Catatan penting:** Pada TDD v1.0 awal tertulis nilai enum Gender yang salah (bukan `other`) — ini sudah dikoreksi ke `other` di v1.0.1 (lihat Changelog). Backend (PostgreSQL `user_profiles.gender`) hanya menerima `male`, `female`, `other` sesuai ERD CHECK constraint.

---

### 3.1 Enum Definition (di `core/enums/`)

```dart
// lib/core/enums/gender.dart
import 'package:json_annotation/json_annotation.dart';

enum Gender {
  @JsonValue('male') male,
  @JsonValue('female') female,
  @JsonValue('other') other,
}

// lib/core/enums/booking_status.dart
enum BookingStatus {
  @JsonValue('pending') pending,
  @JsonValue('upcoming') upcoming,
  @JsonValue('completed') completed,
  @JsonValue('cancelled') cancelled,
}
```

> **Pattern:** Selalu tambahkan `@JsonValue('snake_value')` di setiap enum constant. Hindari `Gender.values.byName(json['gender'])` yang throw exception saat server kirim nilai baru.

---

### 3.2 Custom JSON Converters (date-only & time-only)

```dart
// lib/core/network/json_converters.dart
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:json_annotation/json_annotation.dart';

/// Converter untuk DATE-ONLY format ("2026-06-15") → DateTime
/// Dipakai untuk: slot_date, date_of_birth, banner.starts_at
class DateOnlyJsonConverter implements JsonConverter<DateTime?, String?> {
  const DateOnlyJsonConverter();
  
  @override
  DateTime? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    return DateTime.parse(json); // "2026-06-15" → DateTime(2026, 6, 15)
  }
  
  @override
  String? toJson(DateTime? object) {
    if (object == null) return null;
    return '${object.year.toString().padLeft(4, '0')}-'
        '${object.month.toString().padLeft(2, '0')}-'
        '${object.day.toString().padLeft(2, '0')}';
  }
}

/// Converter untuk TIME-ONLY format ("09:00:00") → TimeOfDay
/// Dipakai untuk: slot_start, slot_end
class TimeOnlyJsonConverter implements JsonConverter<TimeOfDay?, String?> {
  const TimeOnlyJsonConverter();
  
  @override
  TimeOfDay? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    final parts = json.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
  
  @override
  String? toJson(TimeOfDay? object) {
    if (object == null) return null;
    final h = object.hour.toString().padLeft(2, '0');
    final m = object.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }
}

/// ISO 8601 datetime converter (default, no annotation needed)
/// "2026-06-07T10:30:00.000Z" → DateTime
/// Dipakai untuk: booked_at, confirmed_at, created_at, updated_at
/// → cukup pakai DateTime.parse() built-in
```

---

### 3.3 Entity (Domain — pure Dart, no Flutter)

```dart
// lib/features/auth/domain/entity/user_entity.dart
import 'package:equatable/equatable.dart';
import 'package:health_pal/core/enums/gender.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? nickname;
  final String? photoUrl;
  final DateTime? dateOfBirth;
  final Gender gender;
  final bool isProfileComplete;
  
  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.gender,
    this.nickname,
    this.photoUrl,
    this.dateOfBirth,
    this.isProfileComplete = false,
  });
  
  @override
  List<Object?> get props => [id, email];
}
```

**Prinsip:** Entity TIDAK punya `fromJson/toJson` — itu tanggung jawab Model di Data layer. Entity juga TIDAK depend `package:flutter` atau `package:json_annotation`.

---

### 3.4 Model (Data — JSON aware) — Pattern dengan `@freezed` + `@JsonSerializable`

```dart
// lib/features/auth/data/model/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:health_pal/core/enums/gender.dart';
import 'package:health_pal/core/network/json_converters.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();  // ← Required untuk @JsonKey factory method
  
  const factory UserModel({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    String? nickname,
    @JsonKey(name: 'avatar_url') String? photoUrl,
    @JsonKey(name: 'date_of_birth') @DateOnlyJsonConverter() DateTime? dateOfBirth,
    required Gender gender,
    @JsonKey(name: 'is_profile_complete') @Default(false) bool isProfileComplete,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  // Mapper Entity ↔ Model
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    id: entity.id,
    fullName: entity.fullName,
    email: entity.email,
    nickname: entity.nickname,
    photoUrl: entity.photoUrl,
    dateOfBirth: entity.dateOfBirth,
    gender: entity.gender,
    isProfileComplete: entity.isProfileComplete,
  );
}

// Extension untuk konversi Model → Entity
extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    fullName: fullName,
    email: email,
    nickname: nickname,
    photoUrl: photoUrl,
    dateOfBirth: dateOfBirth,
    gender: gender,
    isProfileComplete: isProfileComplete,
  );
}
```

> **Catatan:** `const UserModel._();` private constructor **WAJIB** ada jika Anda butuh custom method (seperti `toEntity()`) di dalam `@freezed` class. Build runner akan generate `_$UserModel` mixin.

---

### 3.5 DoctorModel — Contoh Lengkap dengan Nested Object & Date Converter

```dart
// lib/features/doctor/data/model/doctor_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:health_pal/core/enums/gender.dart';  // untuk reviewer/owner (opsional)
import 'package:health_pal/features/clinic/data/model/clinic_model.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_entity.dart';
import 'package:health_pal/features/specialization/data/model/specialization_model.dart';

part 'doctor_model.freezed.dart';
part 'doctor_model.g.dart';

@freezed
class DoctorModel with _$DoctorModel {
  const DoctorModel._();

  const factory DoctorModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'specialization_id') required String specializationId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    String? description,
    @JsonKey(name: 'experience_years') required int experienceYears,
    String? education,
    @JsonKey(name: 'consultation_fee') required double consultationFee,
    @JsonKey(name: 'rating_avg') @Default(0.0) double ratingAvg,
    @JsonKey(name: 'rating_count') @Default(0) int ratingCount,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    
    // ── Nested Objects (dari PostgREST select=*,clinics(*),specializations(*)) ──
    ClinicModel? clinic,
    SpecializationModel? specialization,
  }) = _DoctorModel;
  
  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
  
  // ── Mapper ─────────────────────────────────────────────
  factory DoctorModel.fromEntity(DoctorEntity entity) => DoctorModel(
    id: entity.id,
    clinicId: entity.clinicId,
    specializationId: entity.specializationId,
    fullName: entity.fullName,
    photoUrl: entity.photoUrl,
    description: entity.description,
    experienceYears: entity.experienceYears,
    education: entity.education,
    consultationFee: entity.consultationFee,
    ratingAvg: entity.ratingAvg,
    ratingCount: entity.ratingCount,
    isActive: entity.isActive,
  );
}

extension DoctorModelX on DoctorModel {
  DoctorEntity toEntity() => DoctorEntity(
    id: id,
    clinicId: clinicId,
    specializationId: specializationId,
    fullName: fullName,
    photoUrl: photoUrl,
    description: description,
    experienceYears: experienceYears,
    education: education,
    consultationFee: consultationFee,
    ratingAvg: ratingAvg,
    ratingCount: ratingCount,
    isActive: isActive,
    clinic: clinic?.toEntity(),
    specialization: specialization?.toEntity(),
  );
}
```

---

### 3.6 DoctorSlotModel — Contoh dengan TimeOnly Converter

```dart
// lib/features/doctor/data/model/doctor_slot_model.dart
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:health_pal/core/network/json_converters.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_slot_entity.dart';

part 'doctor_slot_model.freezed.dart';
part 'doctor_slot_model.g.dart';

@freezed
class DoctorSlotModel with _$DoctorSlotModel {
  const DoctorSlotModel._();
  
  const factory DoctorSlotModel({
    required String id,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'schedule_id') String? scheduleId,
    @JsonKey(name: 'slot_date') @DateOnlyJsonConverter() required DateTime slotDate,
    @JsonKey(name: 'slot_start') @TimeOnlyJsonConverter() required TimeOfDay slotStart,
    @JsonKey(name: 'slot_end') @TimeOnlyJsonConverter() required TimeOfDay slotEnd,
    @JsonKey(name: 'is_booked') @Default(false) bool isBooked,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _DoctorSlotModel;
  
  factory DoctorSlotModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorSlotModelFromJson(json);
}

extension DoctorSlotModelX on DoctorSlotModel {
  DoctorSlotEntity toEntity() => DoctorSlotEntity(
    id: id,
    doctorId: doctorId,
    scheduleId: scheduleId,
    slotDate: slotDate,
    slotStart: slotStart,
    slotEnd: slotEnd,
    isBooked: isBooked,
  );
}
```

---

### 3.7 Build Runner Configuration

Tambahkan di `build.yaml` di root project untuk konsistensi:

```yaml
# build.yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          field_rename: none          # ← JANGAN pakai global; kita handle per-field @JsonKey
          explicit_to_json: true      # ← Generate toJson() eksplisit (bukan implicit)
          create_factory: true        # ← Generate fromJson factory
          create_to_json: true        # ← Generate toJson() method
          include_if_null: false      # ← Field null di-skip saat serialize
          
      freezed:
        options:
          format: true
          mode: full                  # ← Generate copyWith, ==, hashCode, toString
```

**Generate command (per v1.0.1 — pakai `--force-jit` karena Dart 3.10 SDK + `dart compile` tidak support build hooks):**
```bash
# Watch mode (development)
dart run build_runner watch --force-jit

# One-shot (CI / one-time generate)
dart run build_runner build --force-jit
```

> **Catatan v1.0.1:** Sejak upgrade ke Dart SDK 3.10, flag `--delete-conflicting-outputs` menyebabkan error `'dart compile' does not support build hooks, use 'dart build' instead`. Solusi: pakai `--force-jit` (JIT mode compilation). Output file `*.g.dart`, `*.freezed.dart`, `*.mocks.dart` tetap ter-generate seperti biasa.

---

### 3.8 Paket yang Diperlukan (`pubspec.yaml`)

```yaml
dependencies:
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  equatable: ^2.0.5

dev_dependencies:
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
```

---

### 3.9 Ringkasan Pattern

| Pattern | Kapan Pakai | Contoh |
|---|---|---|
| `@JsonKey(name: 'snake')` per field | Selalu untuk field dari API | `full_name`, `avatar_url` |
| `@DateOnlyJsonConverter()` | Field `DATE` (PostgreSQL) | `slot_date`, `date_of_birth` |
| `@TimeOnlyJsonConverter()` | Field `TIME` (PostgreSQL) | `slot_start`, `slot_end` |
| `DateTime` (default) | Field `TIMESTAMPTZ` (PostgreSQL) | `booked_at`, `created_at` |
| `@JsonValue('snake')` di enum | Selalu untuk enum dari API | `Gender.male` → `'male'` |
| `@Default(value)` | Field optional dengan default | `is_active = true` |
| `const ClassName._();` | `@freezed` class dengan custom method | Wajib untuk `toEntity()` |
| `extension ClassX on ClassName` | Method tambahan di `@freezed` class | `toEntity()`, helper methods |
| Nested Model (PostgREST select) | Relasi 1-to-1 atau 1-to-N | `ClinicModel? clinic` |

---

### 3.10 Changelog

| Versi | Tanggal | Perubahan |
|---|---|---|
| v1.0 | Juni 2026 | Initial — UserModel dengan manual fromJson/toJson |
| v1.0.1 | 13 Jun 2026 | **SS#7 Enhanced:** Tambah §3.0 Strategi Snake↔Camel, §3.1 Enum definition, §3.2 Custom converters, §3.3 Entity pattern, §3.4 UserModel dengan @freezed, §3.5 DoctorModel lengkap, §3.6 DoctorSlotModel dengan TimeOnly, §3.7 build.yaml, §3.8 pubspec. Koreksi enum Gender: nilai lama yang salah → `other` (sesuai ERD) |

---

## 4. Data Source Strategy

### 4.1 Remote First + Cache Fallback

```dart
class HomeRepositoryImpl implements HomeRepository {
  Future<Result<List<BannerEntity>>> getBanners() async {
    try {
      final remote = await _remote.getBanners();
      await _local.cacheBanners(remote);
      return Success(remote);
    } on NetworkException {
      final cached = await _local.getCachedBanners();
      if (cached != null) return Success(cached);
      return Failure(FailureCode.networkError, '...');
    }
  }
}
```

### 4.2 Kapan Pakai Cache

| Data | Strategy | Cache Duration | Storage |
|---|---|---|---|
| Specializations | Cache first | 7 hari | SharedPref (JSON) |
| Banners | Remote first | 5 menit | SharedPref (JSON) |
| Doctor list | Remote only | — | — |
| Slots | Remote only | — | — |
| User profile | Remote first | Session | SharedPref |
| Onboarding status | Local only | Permanent | SharedPref |
| Auth session | Local only | Until expiry | Secure storage |

---

## 5. Daftar Model per Fitur

| Fitur | Model | Sumber (ERD Table) |
|---|---|---|
| Auth | `UserModel` | `auth_users` + `user_profiles` |
| Auth | `FcmTokenModel` | `user_fcm_tokens` |
| Home | `BannerModel` | `banners` |
| Home | `UpcomingAppointmentModel` | `appointments` (nested doctor + slot) |
| Doctor | `DoctorModel` | `doctors` |
| Doctor | `SpecializationModel` | `specializations` |
| Doctor | `ClinicModel` | `clinics` |
| Doctor | `DoctorSlotModel` | `doctor_slots` |
| Booking | `AppointmentModel` | `appointments` |
| Profile | `ProfileModel` | `user_profiles` |
| Notification | `NotificationModel` | `notifications` |

---

## 6. Supabase Client

```dart
// lib/core/network/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class SupabaseModule {
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}

// ── Contoh Query Pattern ──

// GET dengan filter langsung
final doctors = await supabaseClient
  .from('doctors')
  .select('*, clinics(*), specializations(*)')
  .eq('is_active', true)
  .ilike('full_name', '%$query%')
  .order('rating_avg', ascending: false)
  .limit(20);

// Edge Function
final result = await supabaseClient.functions
  .invoke('create-appointment', body: {
    'doctor_id': doctorId,
    'slot_id': slotId,
    'complaint_note': complaint,
  });

// Auth
final response = await supabaseClient.auth.signUp(
  email: email,
  password: password,
);
final session = await supabaseClient.auth.signInWithPassword(
  email: email,
  password: password,
);
```
