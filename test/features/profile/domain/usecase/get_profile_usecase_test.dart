import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/profile/domain/repository/profile_repository.dart';
import 'package:health_pal/features/profile/domain/usecase/get_profile_usecase.dart';

class _M extends Mock implements ProfileRepository {}

void main() {
  test('returns Success and delegates to repository with no params', () async {
    final r = _M();
    final u = GetProfileUseCase(r);
    when(() => r.getProfile()).thenAnswer(
      (_) async => const Success(
        UserEntity(id: 'u', authId: 'a', fullName: 'T', email: 'e@e.com'),
      ),
    );
    final result = await u();
    expect(result, isA<Success<UserEntity>>());
    verify(() => r.getProfile()).called(1);
  });

  test('returns Failure when repository fails (e.g. not found / BUG-002-FIX-3)', () async {
    final r = _M();
    final u = GetProfileUseCase(r);
    when(() => r.getProfile()).thenAnswer(
      (_) async => const Failure(FailureCode.notFound, 'profile not found'),
    );
    final result = await u();
    expect(result, isA<Failure<UserEntity>>());
    expect((result as Failure).code, FailureCode.notFound);
  });
}
