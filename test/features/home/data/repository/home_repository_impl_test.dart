// test/features/home/data/repository/home_repository_impl_test.dart
//
// Unit test untuk HomeRepositoryImpl.
// Referensi: lib/features/home/data/repository/home_repository_impl.dart
// BUG regression: Sprint 2 A2 — getUpcoming order by slot_date.asc.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:health_pal/core/enums/booking_status.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/home/data/datasource/home_local_datasource.dart';
import 'package:health_pal/features/home/data/datasource/home_remote_datasource.dart';
import 'package:health_pal/features/home/data/model/banner_model.dart';
import 'package:health_pal/features/home/data/model/specialization_model.dart';
import 'package:health_pal/features/home/data/model/upcoming_appointment_model.dart';
import 'package:health_pal/features/home/data/model/user_profile_model.dart';
import 'package:health_pal/features/home/data/repository/home_repository_impl.dart';
import 'package:health_pal/features/home/domain/entity/banner_entity.dart';
import 'package:health_pal/features/home/domain/entity/specialization_entity.dart';
import 'package:health_pal/features/home/domain/entity/upcoming_appointment_entity.dart';
import 'package:health_pal/features/home/domain/entity/user_profile_entity.dart';
import 'package:health_pal/core/services/app_services.dart';

class MockRemote extends Mock implements HomeRemoteDataSource {}
class MockLocal extends Mock implements HomeLocalDataSource {}
class MockAppServices extends Mock implements AppServices {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MockAppServices appServices;
  late HomeRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(BannerModel(id: 'fb', title: 'fb'));
    registerFallbackValue(SpecializationModel(id: 'fb', name: 'fb'));
    registerFallbackValue(UserProfileModel(id: 'fb', nickname: 'fb'));
  });

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    appServices = MockAppServices();
    repo = HomeRepositoryImpl(remote, local, appServices);
  });

  group('getBanners', () {
    test('returns banners on remote success and caches', () async {
      when(() => remote.fetchBanners()).thenAnswer((_) async => [
            BannerModel(id: 'b1', title: 'B1'),
          ]);
      when(() => local.cacheBanners(any())).thenAnswer((_) async {});

      final result = await repo.getBanners();
      expect(result, isA<Success<List<BannerEntity>>>());
      verify(() => local.cacheBanners(any())).called(1);
    });

    test('returns cached banners when remote fails', () async {
      when(() => remote.fetchBanners()).thenThrow(Exception('Network error'));
      when(() => local.getCachedBanners()).thenReturn([
        BannerModel(id: 'cached', title: 'Cached'),
      ]);

      final result = await repo.getBanners();
      expect(result, isA<Success<List<BannerEntity>>>());
    });

    test('returns failure when remote fails and no cache', () async {
      when(() => remote.fetchBanners()).thenThrow(Exception('Network error'));
      when(() => local.getCachedBanners()).thenReturn(null);

      final result = await repo.getBanners();
      expect(result, isA<Failure<List<BannerEntity>>>());
    });
  });

  group('getUpcoming', () {
    test('returns entity on remote success', () async {
      when(() => remote.fetchUpcoming('pid-1')).thenAnswer((_) async =>
          UpcomingAppointmentModel(
            id: 'u1', doctorName: 'Dr.', clinicName: 'Klnk',
            specializationName: 'Umum',
            slotDate: DateTime(2026, 6, 15), slotStart: null,
            slotEnd: null, status: BookingStatus.upcoming,
          ));

      final result = await repo.getUpcoming('pid-1');
      expect(result, isA<Success<UpcomingAppointmentEntity?>>());
    });

    test('returns null entity when remote returns null', () async {
      when(() => remote.fetchUpcoming('pid-2')).thenAnswer((_) async => null);

      final result = await repo.getUpcoming('pid-2');
      expect(result, isA<Success<UpcomingAppointmentEntity?>>());
      expect((result as Success).data, isNull);
    });
  });

  group('getSpecializations', () {
    test('returns list on remote success', () async {
      when(() => remote.fetchSpecializations()).thenAnswer((_) async => [
            SpecializationModel(id: 's1', name: 'Umum'),
          ]);
      when(() => local.cacheSpecializations(any())).thenAnswer((_) async {});

      final result = await repo.getSpecializations();
      expect(result, isA<Success<List<SpecializationEntity>>>());
    });
  });

  group('getUserProfile', () {
    const authId = 'auth-1';

    test('returns profile on remote success', () async {
      when(() => remote.fetchUserProfile(authId)).thenAnswer((_) async =>
          UserProfileModel(id: 'p1', nickname: 'Test', isProfileComplete: true));
      when(() => local.cacheUserProfile(any())).thenAnswer((_) async {});

      final result = await repo.getUserProfile(authId);
      expect(result, isA<Success<UserProfileEntity>>());
      verify(() => local.cacheUserProfile(any())).called(1);
    });

    test('returns notFound when remote returns null', () async {
      when(() => remote.fetchUserProfile(authId))
          .thenAnswer((_) async => null);

      final result = await repo.getUserProfile(authId);
      expect(result, isA<Failure<UserProfileEntity>>());
    });

    test('returns cached when remote fails', () async {
      when(() => remote.fetchUserProfile(authId))
          .thenThrow(Exception('error'));
      when(() => local.getCachedUserProfile()).thenReturn(
          UserProfileModel(id: 'cached', nickname: 'Cached'));

      final result = await repo.getUserProfile(authId);
      expect(result, isA<Success<UserProfileEntity>>());
    });
  });
}
