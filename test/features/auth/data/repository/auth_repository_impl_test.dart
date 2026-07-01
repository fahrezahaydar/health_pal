// test/features/auth/data/repository/auth_repository_impl_test.dart
//
// Unit test untuk AuthRepositoryImpl.
// Mock: mocktail (zero codegen) — avoids mockito v5 closure incompatibility.
// Scope: methods tanpa SupabaseClient dependency.
//
// Note: auth_repository_impl.dart constructor butuh SupabaseClient
// non-null. Method yang di-test TIDAK menggunakan _supabaseClient,
// jadi kita passing mock SupabaseClient (stub — tidak ada interaction).

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:health_pal/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:health_pal/features/auth/data/model/user_model.dart';
import 'package:health_pal/features/auth/data/repository/auth_repository_impl.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/auth/domain/repository/auth_repository.dart';

class MockAuthRemote extends Mock implements AuthRemoteDataSource {}
class MockAuthLocal extends Mock implements AuthLocalDataSource {}
class MockSupabase extends Mock implements SupabaseClient {}

UserModel _mockUser({required String authId}) => UserModel(
      id: 'user-$authId',
      authId: authId,
      fullName: 'Test User',
      email: 'test@test.com',
      nickname: 'Tester',
      dateOfBirth: DateTime(1990, 1, 1),
      gender: 'male',
      isProfileComplete: true,
    );

AuthResponse _authResponse(String userId) {
  final session = _session(userId);
  return AuthResponse(session: session);
}

Session _session(String userId) {
  final s = MockSession();
  final u = MockUser();
  when(() => s.user).thenReturn(u);
  when(() => u.id).thenReturn(userId);
  return s;
}

class MockSession extends Mock implements Session {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthRemote remote;
  late MockAuthLocal local;
  late MockSupabase supabase;
  late AuthRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(_mockUser(authId: 'fallback'));
  });

  setUp(() {
    remote = MockAuthRemote();
    local = MockAuthLocal();
    supabase = MockSupabase();
    repo = AuthRepositoryImpl(remote, local, supabase);
  });

  group('signInWithEmail', () {
    const email = 'a@b.com';
    const password = 'pass';
    const authId = 'auth-123';

    test('returns Success with UserEntity on valid credentials', () async {
      when(() => remote.signInWithEmail(any(), any()))
          .thenAnswer((_) async => _authResponse(authId));
      when(() => remote.fetchUserProfile(authId))
          .thenAnswer((_) async => _mockUser(authId: authId));
      when(() => local.cacheUser(any())).thenAnswer((_) async {});

      final result = await repo.signInWithEmail(email, password);
      expect(result, isA<Success<UserEntity>>());
      verify(() => local.cacheUser(any())).called(1);
    });

    test('returns Failure when userId is empty', () async {
      when(() => remote.signInWithEmail(any(), any()))
          .thenAnswer((_) async => _authResponse(''));

      final result = await repo.signInWithEmail(email, password);
      expect(result, isA<Failure<UserEntity>>());
      expect((result as Failure).code, FailureCode.unauthorized);
    });

    test('returns Failure when remote throws', () async {
      when(() => remote.signInWithEmail(any(), any()))
          .thenThrow(Exception('Network error'));

      final result = await repo.signInWithEmail(email, password);
      expect(result, isA<Failure<UserEntity>>());
    });
  });

  group('signInWithGoogle', () {
    const authId = 'google-1';

    test('returns Success on successful Google auth', () async {
      when(() => remote.signInWithGoogle())
          .thenAnswer((_) async => _authResponse(authId));
      when(() => remote.fetchUserProfile(authId))
          .thenAnswer((_) async => _mockUser(authId: authId));
      when(() => local.cacheUser(any())).thenAnswer((_) async {});

      final result = await repo.signInWithGoogle();
      expect(result, isA<Success<UserEntity>>());
    });

    test('returns Failure on Google auth error', () async {
      when(() => remote.signInWithGoogle())
          .thenThrow(Exception('Google error'));

      final result = await repo.signInWithGoogle();
      expect(result, isA<Failure<UserEntity>>());
    });
  });

  group('signOut', () {
    test('clears local cache and returns Success', () async {
      when(() => remote.signOut()).thenAnswer((_) async => {});
      when(() => local.clearUser()).thenAnswer((_) async {});

      final result = await repo.signOut();
      expect(result, isA<Success<void>>());
      verify(() => local.clearUser()).called(1);
    });

    test('returns Failure on signOut error', () async {
      when(() => remote.signOut()).thenThrow(Exception('Logout error'));

      final result = await repo.signOut();
      expect(result, isA<Failure<void>>());
    });
  });

  group('sendResetPasswordEmail', () {
    test('returns Success on valid email', () async {
      when(() => remote.sendResetPasswordEmail(any()))
          .thenAnswer((_) async => {});

      final result = await repo.sendResetPasswordEmail('test@test.com');
      expect(result, isA<Success<void>>());
    });
  });

  group('resetPassword', () {
    test('returns Success on valid password', () async {
      when(() => remote.updatePassword(any()))
          .thenAnswer((_) async => {});

      final result = await repo.resetPassword('new-pass');
      expect(result, isA<Success<void>>());
    });

    test('returns Failure on update error', () async {
      when(() => remote.updatePassword(any()))
          .thenThrow(Exception('Update failed'));

      final result = await repo.resetPassword('new-pass');
      expect(result, isA<Failure<void>>());
    });
  });
}
