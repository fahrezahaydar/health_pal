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

### 3.1 Entity (Domain — pure Dart)

```dart
// lib/features/auth/domain/entity/user_entity.dart
class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? nickname;
  final String? photoUrl;
  final DateTime? dateOfBirth;
  final Gender gender;

  const UserEntity({...});

  @override
  List<Object?> get props => [id, email, fullName];
}
```

### 3.2 Model (Data — JSON aware)

```dart
// lib/features/auth/data/model/user_model.dart
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.nickname,
    super.photoUrl,
    super.dateOfBirth,
    required super.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      photoUrl: json['avatar_url'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: Gender.values.byName(json['gender'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'nickname': nickname,
    'avatar_url': photoUrl,
    'date_of_birth': dateOfBirth?.toIso8601String(),
    'gender': gender.name,
  };
}
```

**Entity extends Model?** Tidak. Model extends Entity agar di presentation cukup pakai Entity.

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
