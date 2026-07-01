// test/features/auth/presentation/bloc/sign_in/sign_in_cubit_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/auth/domain/usecase/login_with_email_usecase.dart';
import 'package:health_pal/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';

class MockUseCase extends Mock implements LoginWithEmailUseCase {}

void main() {
  group('SignInCubit', () {
    late MockUseCase useCase;
    late SignInCubit cubit;

    setUp(() {
      useCase = MockUseCase();
      cubit = SignInCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is SignInInitial', () {
      expect(cubit.state, const SignInInitial());
    });

    group('signInWithEmail', () {
      test('emits [Loading, Success] when login succeeds', () async {
        final user = UserEntity(id: '1', authId: 'a', fullName: 'T', email: 't@t.com');
        when(() => useCase('a@b.com', 'pass'))
            .thenAnswer((_) async => Success(user));

        await cubit.signInWithEmail('a@b.com', 'pass');

        expect(cubit.state, isA<SignInSuccess>());
        expect((cubit.state as SignInSuccess).user, user);
      });

      test('emits [Loading, Failure] when login fails', () async {
        when(() => useCase('a@b.com', 'wrong'))
            .thenAnswer((_) async => Failure(FailureCode.unauthorized, 'Invalid'));

        await cubit.signInWithEmail('a@b.com', 'wrong');

        expect(cubit.state, isA<SignInFailure>());
        expect((cubit.state as SignInFailure).message, 'Invalid');
      });
    });

    group('signInWithGoogle', () {
      test('emits [Loading, Failure] with coming soon message', () {
        // synchronous — no await needed
        cubit.signInWithGoogle();
        expect(cubit.state, isA<SignInFailure>());
        expect((cubit.state as SignInFailure).message, 'Google sign in coming soon');
      });
    });
  });
}
