// lib/features/profile/domain/repository/profile_repository.dart

import 'dart:io';

import '../../../../core/network/result.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../doctor/domain/entity/doctor_entity.dart';
import '../entity/notification_entity.dart';

abstract class ProfileRepository {
  /// API §3.5 — Get current user profile via /me view.
  Future<Result<UserEntity>> getProfile();

  /// API §3.2 — Update profile fields.
  /// Field yang null TIDAK di-update (partial update).
  Future<Result<UserEntity>> updateProfile({
    required String authId,
    String? fullName,
    String? nickname,
    String? dateOfBirth,
    String? gender,
    String? avatarUrl,
    String? phoneNumber,
  });

  /// API §3.3 — Upload avatar ke Supabase Storage, return public URL.
  Future<Result<String>> uploadAvatar({
    required String userId,
    required File photo,
  });

  /// Favorites — placeholder v1.1 (return empty list).
  Future<Result<List<DoctorEntity>>> getFavorites();

  /// API §8.1 — Get user notifications.
  Future<Result<List<NotificationEntity>>> getNotifications({
    required String userId,
    int limit = 30,
    int offset = 0,
  });

  /// API §8.2 — Mark notification as read.
  Future<Result<void>> markNotificationAsRead({
    required String userId,
    required String notificationId,
  });
}
