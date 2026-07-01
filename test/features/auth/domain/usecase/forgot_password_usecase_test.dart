// test/features/auth/domain/usecase/forgot_password_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/repository/auth_repository.dart';
import 'package:health_pal/features/auth/domain/usecase/forgot_password_usecase.dart';

class MockRepo extends Mock implements AuthRepository {}

void main() {
  test('calls repository.sendResetPasswordEmail', () async {
    final repo = MockRepo();
    final useCase = ForgotPasswordUseCase(repo);
    when(() => repo.sendResetPasswordEmail(any()))
        .thenAnswer((_) async => const Success(null));

    final result = await useCase('test@test.com');
    expect(result, isA<Success<void>>());
    verify(() => repo.sendResetPasswordEmail('test@test.com')).called(1);
  });
}
