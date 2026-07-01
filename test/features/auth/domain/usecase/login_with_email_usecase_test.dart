// test/features/auth/domain/usecase/login_with_email_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/auth/domain/repository/auth_repository.dart';
import 'package:health_pal/features/auth/domain/usecase/login_with_email_usecase.dart';

import '../../../../helpers/test_helpers.dart';

class MockRepo extends Mock implements AuthRepository {}

void main() {
  test('calls repository.signInWithEmail and returns result', () async {
    final repo = MockRepo();
    final useCase = LoginWithEmailUseCase(repo);
    when(() => repo.signInWithEmail(any(), any()))
        .thenAnswer((_) async => Success(TestData.mockUser()));

    final result = await useCase('a@b.com', 'pass');
    expect(result, isA<Success<UserEntity>>());
    verify(() => repo.signInWithEmail('a@b.com', 'pass')).called(1);
  });
}
