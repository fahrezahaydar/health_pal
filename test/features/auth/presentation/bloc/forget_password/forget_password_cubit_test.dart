// D3 — ForgotPasswordCubit
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:health_pal/features/auth/presentation/bloc/forget_password/forget_password_state.dart';

class _MockUseCase extends Mock implements ForgotPasswordUseCase {}

void main() {
  group('ForgotPasswordCubit', () {
    late _MockUseCase useCase;
    late ForgotPasswordCubit cubit;

    setUp(() {
      useCase = _MockUseCase();
      cubit = ForgotPasswordCubit(useCase);
    });
    tearDown(() => cubit.close());

    test('initial state is initial', () {
      expect(cubit.state, ForgotPasswordStep.initial);
    });

    group('sendEmail', () {
      test('calls onSuccess and emits verify on success', () async {
        when(() => useCase('test@test.com'))
            .thenAnswer((_) async => const Success(null));

        var successMsg = '';
        await cubit.sendEmail('test@test.com',
          onSuccess: (msg) => successMsg = msg);

        expect(cubit.state, ForgotPasswordStep.verify);
        expect(successMsg, contains('Reset link'));
      });

      test('calls onError on failure', () async {
        when(() => useCase('bad@test.com'))
            .thenAnswer((_) async => const Failure(FailureCode.serverError, 'Error sending'));

        var errorMsg = '';
        await cubit.sendEmail('bad@test.com',
          onError: (msg) => errorMsg = msg);

        expect(errorMsg, 'Error sending');
      });
    });

    group('back', () {
      test('stays at initial when already initial', () {
        cubit.back();
        expect(cubit.state, ForgotPasswordStep.initial);
      });
    });
  });
}
