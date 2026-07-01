import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_entity.dart';
import 'package:health_pal/features/profile/domain/repository/profile_repository.dart';
import 'package:health_pal/features/profile/domain/usecase/get_favorites_usecase.dart';

class _M extends Mock implements ProfileRepository {}

void main() {
  test('returns Success and delegates to repository (v1.1 placeholder)', () async {
    final r = _M();
    final u = GetFavoritesUseCase(r);
    when(() => r.getFavorites())
        .thenAnswer((_) async => const Success(<DoctorEntity>[]));
    final result = await u();
    expect(result, isA<Success<List<DoctorEntity>>>());
    verify(() => r.getFavorites()).called(1);
  });

  test('returns Failure when repository fails', () async {
    final r = _M();
    final u = GetFavoritesUseCase(r);
    when(() => r.getFavorites()).thenAnswer(
      (_) async => const Failure(FailureCode.serverError, 'err'),
    );
    final result = await u();
    expect(result, isA<Failure<List<DoctorEntity>>>());
    expect((result as Failure).code, FailureCode.serverError);
  });
}
