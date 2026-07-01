// test/features/profile/data/repository/profile_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_entity.dart';
import 'package:health_pal/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:health_pal/features/profile/data/model/notification_model.dart';
import 'package:health_pal/features/profile/data/repository/profile_repository_impl.dart';
import 'package:health_pal/features/profile/domain/entity/notification_entity.dart';
import 'package:health_pal/features/auth/data/model/user_model.dart';

class MockRemote extends Mock implements ProfileRemoteDataSource {}

void main() {
  late MockRemote remote;
  late ProfileRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(UserModel(
      id: 'fb', authId: 'fb', fullName: 'fb', email: 'fb@fb.com'));
    registerFallbackValue(NotificationModel(
      id: 'fb', userId: 'fb', type: 'fb', title: 'fb', body: 'fb',
      isRead: false, sentAt: DateTime(2024, 1, 1)));
  });

  setUp(() {
    remote = MockRemote();
    repo = ProfileRepositoryImpl(remote);
  });

  group('getProfile', () {
    test('returns UserEntity on success', () async {
      when(() => remote.getProfile()).thenAnswer((_) async =>
        UserModel(id: 'u1', authId: 'a1', fullName: 'Test',
          email: 'test@test.com'));

      final result = await repo.getProfile();
      expect(result, isA<Success<UserEntity>>());
    });
  });

  group('updateProfile', () {
    test('returns updated UserEntity on success', () async {
      when(() => remote.updateProfile(
        authId: any(named: 'authId'),
        fullName: any(named: 'fullName'),
        nickname: any(named: 'nickname'),
        dateOfBirth: any(named: 'dateOfBirth'),
        gender: any(named: 'gender'),
        avatarUrl: any(named: 'avatarUrl'),
        phoneNumber: any(named: 'phoneNumber'),
      )).thenAnswer((_) async =>
        UserModel(id: 'u1', authId: 'a1', fullName: 'Updated',
          email: 'test@test.com'));

      final result = await repo.updateProfile(authId: 'a1', fullName: 'Updated');
      expect(result, isA<Success<UserEntity>>());
    });
  });

  group('getNotifications', () {
    test('returns list on success', () async {
      when(() => remote.getNotifications(
        userId: any(named: 'userId'),
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      )).thenAnswer((_) async => [
        NotificationModel(id: 'n1', userId: 'u1', type: 'booking',
          title: 'Info', body: 'Body', isRead: false,
          sentAt: DateTime(2026, 6, 15)),
      ]);

      final result = await repo.getNotifications(userId: 'u1');
      expect(result, isA<Success<List<NotificationEntity>>>());
    });
  });

  group('markNotificationAsRead', () {
    test('returns success', () async {
      when(() => remote.markNotificationAsRead(
        userId: any(named: 'userId'),
        notificationId: any(named: 'notificationId'),
      )).thenAnswer((_) async => {});

      final result = await repo.markNotificationAsRead(
        userId: 'u1', notificationId: 'n1');
      expect(result, isA<Success<void>>());
    });
  });

  group('getFavorites', () {
    test('returns list on success', () async {
      when(() => remote.getFavorites()).thenAnswer((_) async => []);

      final result = await repo.getFavorites();
      expect(result, isA<Success<List<DoctorEntity>>>());
    });
  });
}
