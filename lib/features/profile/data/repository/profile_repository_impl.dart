// lib/features/profile/data/repository/profile_repository_impl.dart
//
// Implementasi ProfileRepository. Pattern sama dengan repository lain
// (try/catch + Result<T>).

import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../../core/network/error_handler.dart';
import '../../../../core/network/result.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../doctor/domain/entity/doctor_entity.dart';
import '../../domain/entity/notification_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasource/profile_remote_datasource.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;

  ProfileRepositoryImpl(this._remote);

  @override
  Future<Result<UserEntity>> getProfile() async {
    try {
      final remote = await _remote.getProfile();
      return Result.success(remote.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<UserEntity>> updateProfile({
    required String authId,
    String? fullName,
    String? nickname,
    String? dateOfBirth,
    String? gender,
    String? avatarUrl,
  }) async {
    try {
      final remote = await _remote.updateProfile(
        authId: authId,
        fullName: fullName,
        nickname: nickname,
        dateOfBirth: dateOfBirth,
        gender: gender,
        avatarUrl: avatarUrl,
      );
      return Result.success(remote.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<String>> uploadAvatar({
    required String userId,
    required File photo,
  }) async {
    try {
      final url = await _remote.uploadAvatar(userId, photo);
      return Result.success(url);
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<List<DoctorEntity>>> getFavorites() async {
    try {
      // Placeholder v1.1: backend favorites table belum ada.
      // DataSource return List<dynamic> kosong, kita ignore dan
      // langsung return List<DoctorEntity> kosong.
      await _remote.getFavorites();
      return Result.success(<DoctorEntity>[]);
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<List<NotificationEntity>>> getNotifications({
    required String userId,
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      final remote = await _remote.getNotifications(
        userId: userId,
        limit: limit,
        offset: offset,
      );
      return Result.success(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<void>> markNotificationAsRead({
    required String userId,
    required String notificationId,
  }) async {
    try {
      await _remote.markNotificationAsRead(
        userId: userId,
        notificationId: notificationId,
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }
}
