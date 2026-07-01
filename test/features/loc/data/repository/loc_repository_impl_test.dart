// test/features/loc/data/repository/loc_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/loc/data/datasource/loc_remote_datasource.dart';
import 'package:health_pal/features/loc/data/model/clinic_model.dart';
import 'package:health_pal/features/loc/data/repository/loc_repository_impl.dart';
import 'package:health_pal/features/loc/domain/entity/clinic_entity.dart';

class MockRemote extends Mock implements LocRemoteDataSource {}

void main() {
  late MockRemote remote;
  late LocRepositoryImpl repo;

  setUp(() {
    remote = MockRemote();
    repo = LocRepositoryImpl(remote);
  });

  group('getNearbyClinics', () {
    test('returns clinic list on success', () async {
      when(() => remote.getNearbyClinics(
        lat: any(named: 'lat'),
        lng: any(named: 'lng'),
        radiusKm: any(named: 'radiusKm'),
      )).thenAnswer((_) async => [
        const ClinicModel(id: 'c1', name: 'Klinik A', address: 'Jl. A',
          latitude: -6.2, longitude: 106.8),
      ]);

      final result = await repo.getNearbyClinics(lat: -6.2, lng: 106.8);
      expect(result, isA<Success<List<ClinicEntity>>>());
    });

    test('returns failure on error', () async {
      when(() => remote.getNearbyClinics(
        lat: any(named: 'lat'),
        lng: any(named: 'lng'),
        radiusKm: any(named: 'radiusKm'),
      )).thenThrow(Exception('error'));

      final result = await repo.getNearbyClinics(lat: -6.2, lng: 106.8);
      expect(result, isA<Failure<List<ClinicEntity>>>());
    });
  });
}
