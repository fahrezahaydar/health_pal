// lib/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart
//
// Cubit untuk Edit Profile page.
// - loadEdit → fetch current profile (populate form)
// - updateProfile → PATCH user_profiles; optional upload avatar first

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../auth/domain/entity/user_entity.dart';
import '../../../domain/usecase/get_profile_usecase.dart';
import '../../../domain/usecase/update_profile_usecase.dart';
import 'edit_profile_state.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final UploadAvatarUseCase _uploadAvatar;

  EditProfileCubit(this._getProfile, this._updateProfile, this._uploadAvatar)
    : super(const EditProfileInitial());

  Future<void> loadEdit() async {
    final result = await _getProfile();
    switch (result) {
      case Success<UserEntity>(:final data):
        emit(EditProfileLoaded(data));
      case Failure(:final message):
        emit(EditProfileError(message: message));
    }
  }

  /// Update profile (optional new avatar).
  /// Flow: if photo != null → upload dulu → dapat URL → PATCH.
  Future<void> updateProfile({
    required String authId,
    required String userId,
    String? fullName,
    String? nickname,
    String? dateOfBirth,
    String? gender,
    File? photo,
  }) async {
    final current = state;
    if (current is EditProfileLoaded || current is EditProfileSuccess) {
      final user = current is EditProfileLoaded
          ? current.user
          : (current as EditProfileSuccess).user;
      emit(EditProfileSaving(user));
    }

    String? avatarUrl;
    if (photo != null) {
      final uploadResult = await _uploadAvatar(userId: userId, photo: photo);
      switch (uploadResult) {
        case Success(:final data):
          avatarUrl = data;
        case Failure(:final message):
          emit(EditProfileError(message: 'Gagal upload avatar: $message'));
          return;
      }
    }

    final result = await _updateProfile(
      authId: authId,
      fullName: fullName,
      nickname: nickname,
      dateOfBirth: dateOfBirth,
      gender: gender,
      avatarUrl: avatarUrl,
    );

    switch (result) {
      case Success<UserEntity>(:final data):
        emit(EditProfileSuccess(data));
      case Failure(:final message):
        emit(EditProfileError(message: message));
    }
  }
}
