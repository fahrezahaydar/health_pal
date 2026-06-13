// lib/features/profile/domain/usecase/update_profile_usecase.dart

import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../repository/profile_repository.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  /// Update profile fields. Field null = tidak di-update.
  Future<Result<UserEntity>> call({
    required String authId,
    String? fullName,
    String? nickname,
    String? dateOfBirth,
    String? gender,
    String? avatarUrl,
  }) {
    return _repository.updateProfile(
      authId: authId,
      fullName: fullName,
      nickname: nickname,
      dateOfBirth: dateOfBirth,
      gender: gender,
      avatarUrl: avatarUrl,
    );
  }
}

@injectable
class UploadAvatarUseCase {
  final ProfileRepository _repository;

  UploadAvatarUseCase(this._repository);

  /// Upload avatar ke Supabase Storage → return public URL.
  /// Caller (EditProfileCubit) yang orchestrate: upload dulu, lalu
  /// PATCH user_profiles.avatar_url dengan URL hasil upload.
  Future<Result<String>> call({
    required String userId,
    required File photo,
  }) {
    return _repository.uploadAvatar(userId: userId, photo: photo);
  }
}
