// lib/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart
//
// Cubit untuk Edit Profile page.
// - loadEdit → fetch current profile (populate form)
// - updateProfile → PATCH user_profiles; optional upload avatar first
//
// Catatan: Cubit ini TIDAK mengelola state Saving/Success. Loading
// dan feedback (success/error) ditangani oleh caller via callback
// onSuccess / onError + AppLoadingDialog + AppCustomDialog. Ini
// memisahkan "state dari data" dari "state dari UI side-effect".

import 'dart:io';
import 'dart:ui';

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
  ///
  /// Tidak ada emit state intermediate (Saving/Success). Caller
  /// menampilkan loading via [AppLoadingDialog] dan feedback via
  /// [AppCustomDialog] menggunakan [onSuccess] / [onError].
  Future<void> updateProfile({
    required String authId,
    required String userId,
    String? fullName,
    String? nickname,
    String? dateOfBirth,
    String? gender,
    File? photo,
    required VoidCallback onSuccess,
    required void Function(String message) onError,
  }) async {
    String? avatarUrl;
    if (photo != null) {
      final uploadResult = await _uploadAvatar(userId: userId, photo: photo);
      switch (uploadResult) {
        case Success(:final data):
          avatarUrl = data;
        case Failure(:final message):
          onError('Gagal upload avatar: $message');
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
      case Success<UserEntity>():
        onSuccess();
      case Failure(:final message):
        onError(message);
    }
  }
}
