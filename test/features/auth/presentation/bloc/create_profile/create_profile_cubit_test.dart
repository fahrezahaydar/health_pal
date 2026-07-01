// D2 — CreateProfileCubit
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/auth/domain/usecase/create_profile_usecase.dart';
import 'package:health_pal/features/auth/domain/usecase/register_and_create_profile_usecase.dart';
import 'package:health_pal/features/auth/presentation/bloc/create_profile/create_profile_cubit.dart';

class _MockRegister extends Mock implements RegisterAndCreateProfileUseCase {}
class _MockCreateProfile extends Mock implements CreateProfileUseCase {}

void main() {
  group('CreateProfileCubit', () {
    late _MockRegister register;
    late _MockCreateProfile createProfile;
    late CreateProfileCubit cubit;

    setUp(() {
      register = _MockRegister();
      createProfile = _MockCreateProfile();
      cubit = CreateProfileCubit(register, createProfile,
        const CreateProfileArgs(fullName: 'Test', email: 'a@b.com', password: 'pass'));
    });
    tearDown(() => cubit.close());

    test('initial state has correct name and email', () {
      expect(cubit.state.fullName, 'Test');
      expect(cubit.state.email, 'a@b.com');
    });

    group('register', () {
      test('emits success when registration succeeds', () async {
        when(() => register(
          email: any(named: 'email'), password: any(named: 'password'),
          fullName: any(named: 'fullName'), nickname: any(named: 'nickname'),
          gender: any(named: 'gender'), dateOfBirth: any(named: 'dateOfBirth'),
        )).thenAnswer((_) async => const Success(UserEntity(id: 'u', authId: 'a', fullName: 'Test', email: 'a@b.com')));

        await cubit.register();
        expect(cubit.state.status, CubitStatus.success);
      });

      test('emits failure when registration fails', () async {
        when(() => register(
          email: any(named: 'email'), password: any(named: 'password'),
          fullName: any(named: 'fullName'), nickname: any(named: 'nickname'),
          gender: any(named: 'gender'), dateOfBirth: any(named: 'dateOfBirth'),
        )).thenAnswer((_) async => const Failure(FailureCode.serverError, 'Server error'));

        await cubit.register();
        expect(cubit.state.status, CubitStatus.failure);
        expect(cubit.state.errorMessage, 'Server error');
      });
    });

    group('updateFullName / updateNickname', () {
      test('updateFullName changes fullName', () {
        cubit.updateFullName('New Name');
        expect(cubit.state.fullName, 'New Name');
      });
      test('updateNickname changes nickname', () {
        cubit.updateNickname('Nick');
        expect(cubit.state.nickname, 'Nick');
      });
    });
  });
}
