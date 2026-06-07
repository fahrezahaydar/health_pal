# Technical Design Document — Bagian 10: Testing Strategy

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Status Saat Ini** | 0 test — `test/` belum ada |
| **Package** | `flutter_test`, `bloc_test`, `mockito` |

---

## Daftar Isi

1. [Test Pyramid](#1-test-pyramid)
2. [Unit Test Strategy](#2-unit-test-strategy)
3. [Widget Test Strategy](#3-widget-test-strategy)
4. [Integration Test Strategy](#4-integration-test-strategy)
5. [Target Coverage per Fitur](#5-target-coverage-per-fitur)
6. [Mock Strategy](#6-mock-strategy)
7. [File Organization](#7-file-organization)
8. [Test Commands](#8-test-commands)

---

## 1. Test Pyramid

```
        /\           Integration Tests (2-3)
       /  \          Full flow: auth → booking → cancel
      /    \
     /      \        Widget Tests (15-20)
    /        \       Per halaman krusial: Home, Detail, Booking, History
   /          \
  /            \     Unit Tests (50-60)
 /              \    BLoC/Cubit, UseCase, Repository, Model, Utils
──────────────────
```

**Target total: ~75 test untuk MVP.**

---

## 2. Unit Test Strategy

### 2.1 Yang Di-test

| Layer | Jumlah Target | Contoh |
|---|---|---|
| Model | 10 | `UserModel.fromJson()`, `AppointmentModel.toJson()` |
| Entity | 5 | `UserEntity.props`, `copyWith` |
| UseCase | 15 | `LoginWithEmailUseCase.execute()` — success & failure |
| Cubit/BLoc | 20 | `SignInBloc` — email success, email error, google success |
| Utils | 5 | `validators`, `date_formatter`, `debouncer` |
| Repository | 5 | `AuthRepositoryImpl.login()` — API success, error mapping |

### 2.2 Contoh Test BLoC

```dart
// test/features/auth/presentation/bloc/sign_in_bloc_test.dart
void main() {
  late MockAuthRepository mockRepo;
  late MockAppServices mockAppServices;
  late SignInBloc bloc;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockAppServices = MockAppServices();
    bloc = SignInBloc(mockRepo, mockAppServices);
  });

  blocTest<SignInBloc, SignInState>(
    'emits [Loading, Success] when login is successful',
    build: () {
      when(() => mockRepo.loginWithEmail(any, any))
          .thenAnswer((_) async => Success(mockUser));
      return bloc;
    },
    act: (bloc) => bloc.add(SignInEmailSubmitted(email: 'a@b.com', password: 'pass1234')),
    expect: () => [
      isA<SignInLoading>(),
      isA<SignInSuccess>(),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'emits [Loading, Error] when credentials are invalid',
    build: () {
      when(() => mockRepo.loginWithEmail(any, any))
          .thenAnswer((_) async => Failure(FailureCode.unauthorized, 'Invalid'));
      return bloc;
    },
    act: (bloc) => bloc.add(SignInEmailSubmitted(email: 'a@b.com', password: 'wrong')),
    expect: () => [
      isA<SignInLoading>(),
      isA<SignInError>(),
    ],
  );
}
```

### 2.3 Contoh Test Model

```dart
// test/features/auth/data/model/user_model_test.dart
void main() {
  group('UserModel.fromJson', () {
    test('parses valid JSON correctly', () {
      final json = {
        'id': '123',
        'full_name': 'Rina Kartika',
        'email': 'rina@example.com',
        'nickname': 'Rina',
        'gender': 'female',
        'date_of_birth': '1998-03-15',
      };
      final model = UserModel.fromJson(json);
      expect(model.id, '123');
      expect(model.fullName, 'Rina Kartika');
      expect(model.gender, Gender.female);
    });

    test('returns null for optional fields', () {
      final json = {
        'id': '123',
        'full_name': 'Test',
        'email': 'test@test.com',
        'gender': 'male',
      };
      final model = UserModel.fromJson(json);
      expect(model.nickname, isNull);
      expect(model.photoUrl, isNull);
    });
  });
}
```

---

## 3. Widget Test Strategy

### 3.1 Yang Di-test

| Halaman | Test | Prioritas |
|---|---|---|
| Home | Render banner, upcoming card, kategori | 🔴 High |
| Doctor Detail | Pilih tanggal → slot muncul | 🔴 High |
| Book Appointment | Form validasi, pilih slot, submit | 🔴 High |
| Sign In | Form validasi, error state | 🟡 Medium |
| Booking History | Filter tab, card render | 🟡 Medium |
| Profile | Menu render, logout dialog | 🟢 Low |

### 3.2 Contoh Test Widget

```dart
// test/features/auth/presentation/page/sign_in_page_test.dart
void main() {
  testWidgets('shows validation error when email is empty', (tester) async {
    await tester.pumpWidget(MaterialApp(home: SignInPage()));
    await tester.enterText(find.byType(TextField).first, '');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('Email wajib diisi'), findsOneWidget);
  });
}
```

---

## 4. Integration Test Strategy

### 4.1 Flow yang Di-test (v1.0)

| # | Flow | Langkah |
|---|---|---|
| 1 | Auth → Home | Register → Create Profile → Lihat Home |
| 2 | Search → Booking | Cari dokter → Detail → Pilih slot → Booking → Sukses |
| 3 | Cancel | Buka history → Detail → Batalkan → Confirm |

### 4.2 Setup Integration Test

```dart
// test/integration/booking_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full booking flow', (tester) async {
    // Mock Supabase
    await tester.pumpWidget(App());

    // Register
    await tester.tap(find.text('Sign Up'));
    await tester.enterText(find.byKey(Key('name_field')), 'Test User');
    // ... lanjut sampai booking success
  });
}
```

---

## 5. Target Coverage per Fitur

| Fitur | Unit Test | Widget Test | Total |
|---|---|---|---|
| Auth | 12 | 4 | 16 |
| Onboarding | 2 | 1 | 3 |
| Home | 5 | 2 | 7 |
| Doctor | 10 | 4 | 14 |
| Booking | 12 | 4 | 16 |
| Profile | 5 | 2 | 7 |
| Core (utils, model) | 8 | — | 8 |
| **Total** | **54** | **17** | **71** |

---

## 6. Mock Strategy

```yaml
# pubspec.yaml dev_dependencies
mockito: ^5.4.0
build_runner: ^2.13.1
```

```dart
// test/helpers/mocks.dart
@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<DoctorRepository>(),
  MockSpec<BookingRepository>(),
  MockSpec<AppServices>(),
  MockSpec<SupabaseClient>(),
])
```

**Mocking pattern:**
- Repository: mock dengan `mockito`
- Supabase: mock `SupabaseClient` → mock response per method
- BLoC: test langsung, tanpa mock BLoC itu sendiri

---

## 7. File Organization

```
test/
├── helpers/
│   ├── mocks.dart              # @GenerateNiceMocks
│   └── test_data.dart          # Factory data untuk test
│
├── core/
│   ├── network/
│   │   ├── api_exception_test.dart
│   │   └── error_handler_test.dart
│   └── services/
│       └── cache_service_test.dart
│
├── features/
│   ├── auth/
│   │   ├── data/model/
│   │   │   └── user_model_test.dart
│   │   ├── domain/usecase/
│   │   │   └── login_usecase_test.dart
│   │   ├── data/repository/
│   │   │   └── auth_repository_test.dart
│   │   └── presentation/bloc/
│   │       ├── sign_in_bloc_test.dart
│   │       ├── sign_up_bloc_test.dart
│   │       └── forgot_password_cubit_test.dart
│   │
│   ├── booking/
│   │   ├── data/model/
│   │   │   └── appointment_model_test.dart
│   │   ├── domain/usecase/
│   │   │   └── create_appointment_test.dart
│   │   ├── data/repository/
│   │   │   └── booking_repository_test.dart
│   │   └── presentation/bloc/
│   │       ├── booking_bloc_test.dart
│   │       ├── booking_history_cubit_test.dart
│   │       └── booking_detail_cubit_test.dart
│   │
│   ├── doctor/
│   │   └── ... (similar structure)
│   │
│   └── home/
│       └── ... (similar structure)
│
└── integration/
    ├── auth_flow_test.dart
    └── booking_flow_test.dart
```

---

## 8. Test Commands

```powershell
# Semua test
flutter test

# Test spesifik file
flutter test test/features/auth/presentation/bloc/sign_in_bloc_test.dart

# Coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Integration test
flutter test test/integration/

# Watch mode (development)
flutter test --watch
```
