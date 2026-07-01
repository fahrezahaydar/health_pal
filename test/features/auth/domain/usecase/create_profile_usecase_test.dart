// test/features/auth/domain/usecase/create_profile_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/auth/domain/repository/auth_repository.dart';
import 'package:health_pal/features/auth/domain/usecase/create_profile_usecase.dart';
import '../../../../helpers/test_helpers.dart';

class MockRepo extends Mock implements AuthRepository {}

void main() {
  test('calls repository.createProfile and returns result', () async {
    final repo = MockRepo();
    final useCase = CreateProfileUseCase(repo);
    when(() => repo.createProfile(any(), photo: any(named: 'photo')))
        .thenAnswer((_) async => Success(TestData.mockUser()));

    final result = await useCase(
      email: 'a@b.com', fullName: 'Test', nickname: 'T',
      gender: 'male', dateOfBirth: DateTime(1990, 1, 1),
      createdAuthId: 'auth-1');
    expect(result, isA<Success<UserEntity>>());
  });
}
