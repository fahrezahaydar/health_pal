import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/loc/domain/entity/clinic_entity.dart';
import 'package:health_pal/features/loc/domain/repository/loc_repository.dart';
import 'package:health_pal/features/loc/domain/usecase/get_nearby_clinics_usecase.dart';

class _M extends Mock implements LocRepository {}

void main() {
  test('returns Success and delegates to repository with lat/lng/radius', () async {
    final r = _M();
    final u = GetNearbyClinicsUseCase(r);
    when(() => r.getNearbyClinics(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
          radiusKm: any(named: 'radiusKm'),
        )).thenAnswer((_) async => const Success(<ClinicEntity>[]));
    final result = await u(lat: -6.2, lng: 106.8);
    expect(result, isA<Success<List<ClinicEntity>>>());
    verify(() => r.getNearbyClinics(
          lat: -6.2,
          lng: 106.8,
          radiusKm: 10.0,
        )).called(1);
  });

  test('returns Failure when repository fails (e.g. permission denied)', () async {
    final r = _M();
    final u = GetNearbyClinicsUseCase(r);
    when(() => r.getNearbyClinics(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
          radiusKm: any(named: 'radiusKm'),
        )).thenAnswer(
      (_) async => const Failure(FailureCode.unauthorized, 'permission denied'),
    );
    final result = await u(lat: -6.2, lng: 106.8);
    expect(result, isA<Failure<List<ClinicEntity>>>());
    expect((result as Failure).code, FailureCode.unauthorized);
  });
}
