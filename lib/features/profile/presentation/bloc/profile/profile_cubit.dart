// lib/features/profile/presentation/bloc/profile/profile_cubit.dart
//
// Cubit untuk Profile page.
// - loadProfile → fetch dari user_profiles (lihat FIX-1 BUG-002)
// - logout → delegate ke AppServices (yang handle Supabase signOut + status)

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../../core/services/app_services.dart';
import '../../../../auth/domain/entity/user_entity.dart';
import '../../../domain/usecase/get_profile_usecase.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfile;
  final AppServices _appServices;

  ProfileCubit(this._getProfile, this._appServices)
    : super(const ProfileInitial());

  /// Load profile dari repository.
  ///
  /// **Sprint 2 — A7 (BUG-002-FIX-3):** wrap dengan try/catch agar
  /// unexpected exception (format error, null-pointer di mapper, dll)
  /// tidak bikin cubit stuck di `ProfileLoading`. Selalu emit terminal
  /// state (`ProfileLoaded` atau `ProfileError`).
  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      final result = await _getProfile();
      switch (result) {
        case Success<UserEntity>(:final data):
          emit(ProfileLoaded(data));
        case Failure(:final message):
          debugPrint('ProfileCubit.loadProfile error: $message');
          emit(ProfileError(message: message));
      }
    } catch (e, stack) {
      debugPrint('ProfileCubit.loadProfile unexpected: $e\n$stack');
      emit(const ProfileError(
        message: 'Terjadi kesalahan tak terduga. Silakan coba lagi.',
      ));
    }
  }

  Future<void> logout() async {
    await _appServices.logout();
  }
}
