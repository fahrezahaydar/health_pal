import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/profile/domain/repository/profile_repository.dart';
import 'package:health_pal/features/profile/domain/usecase/update_profile_usecase.dart';

class _M extends Mock implements ProfileRepository {}

void main() {
  test('returns Success and delegates to repository with all params', () async {
    final r = _M();
    final u = UpdateProfileUseCase(r);
    when(() => r.updateProfile(
          authId: any(named: 'authId'),
          fullName: any(named: 'fullName'),
          nickname: any(named: 'nickname'),
          dateOfBirth: any(named: 'dateOfBirth'),
          gender: any(named: 'gender'),
          avatarUrl: any(named: 'avatarUrl'),
          phoneNumber: any(named: 'phoneNumber'),
        )).thenAnswer(
      (_) async => const Success(
        UserEntity(id: 'u', authId: 'a', fullName: 'New', email: 'e@e.com'),
      ),
    );
    final result = await u(authId: 'a', fullName: 'New', nickname: 'N');
    expect(result, isA<Success<UserEntity>>());
    verify(() => r.updateProfile(
          authId: 'a',
          fullName: 'New',
          nickname: 'N',
          dateOfBirth: null,
          gender: null,
          avatarUrl: null,
          phoneNumber: null,
        )).called(1);
  });

  test('returns Failure when repository fails', () async {
    final r = _M();
    final u = UpdateProfileUseCase(r);
    when(() => r.updateProfile(
          authId: any(named: 'authId'),
          fullName: any(named: 'fullName'),
          nickname: any(named: 'nickname'),
          dateOfBirth: any(named: 'dateOfBirth'),
          gender: any(named: 'gender'),
          avatarUrl: any(named: 'avatarUrl'),
          phoneNumber: any(named: 'phoneNumber'),
        )).thenAnswer((_) async => const Failure(FailureCode.serverError, 'err'));
    final result = await u(authId: 'a');
    expect(result, isA<Failure<UserEntity>>());
    expect((result as Failure).code, FailureCode.serverError);
  });
}
