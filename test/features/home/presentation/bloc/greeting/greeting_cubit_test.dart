// D4 — GreetingCubit (P0 — BUG-002-FIX-3 regression)
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/home/domain/entity/user_profile_entity.dart';
import 'package:health_pal/features/home/domain/usecase/get_user_profile_usecase.dart';
import 'package:health_pal/features/home/presentation/bloc/greeting/greeting_cubit.dart';
import 'package:health_pal/features/home/presentation/bloc/greeting/greeting_state.dart';

class _M extends Mock implements GetUserProfileUseCase {}
void main() {
  group('GreetingCubit', () {
    late _M useCase; late GreetingCubit cubit;
    setUp(() { useCase = _M(); cubit = GreetingCubit(useCase); });
    tearDown(() => cubit.close());

    test('initial state', () => expect(cubit.state, const GreetingInitial()));

    test('loadProfile success emits GreetingLoaded', () async {
      when(() => useCase('aid')).thenAnswer((_) async => Success(const UserProfileEntity(id: 'p', nickname: 'T', isProfileComplete: true)));
      final pid = await cubit.loadProfile('aid');
      expect(cubit.state, isA<GreetingLoaded>());
      expect((cubit.state as GreetingLoaded).nickname, 'T');
      expect(pid, 'p');
    });

    test('loadProfile notFound emits GreetingNoProfile', () async {
      when(() => useCase('aid')).thenAnswer((_) async => Failure(FailureCode.notFound, 'No profile'));
      final pid = await cubit.loadProfile('aid');
      expect(cubit.state, isA<GreetingNoProfile>());
      expect(pid, isNull);
    });

    test('loadProfile other error emits GreetingError', () async {
      when(() => useCase('aid')).thenAnswer((_) async => Failure(FailureCode.serverError, 'Server error'));
      await cubit.loadProfile('aid');
      expect(cubit.state, isA<GreetingError>());
      expect((cubit.state as GreetingError).message, 'Server error');
    });
  });
}
