// test/features/auth/domain/usecase/register_and_create_profile_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/auth/domain/repository/auth_repository.dart';
import 'package:health_pal/features/auth/domain/usecase/register_and_create_profile_usecase.dart';
import '../../../../helpers/test_helpers.dart';

class MockRepo extends Mock implements AuthRepository {}

void main() {
  test('calls repository.registerAndCreateProfile and returns result', () async {
    final repo = MockRepo();
    final useCase = RegisterAndCreateProfileUseCase(repo);
    when(() => repo.registerAndCreateProfile(
      email: any(named: 'email'), password: any(named: 'password'),
      fullName: any(named: 'fullName'), nickname: any(named: 'nickname'),
      gender: any(named: 'gender'), dateOfBirth: any(named: 'dateOfBirth'),
    )).thenAnswer((_) async => Success(TestData.mockUser()));

    final result = await useCase(
      email: 'a@b.com', password: 'pass', fullName: 'A', nickname: 'A',
      gender: 'male', dateOfBirth: DateTime(1990, 1, 1));
    expect(result, isA<Success<UserEntity>>());
  });
}
