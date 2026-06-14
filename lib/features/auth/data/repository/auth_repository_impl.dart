import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/enums/failure_code.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/error_handler.dart';
import '../../../../core/network/result.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../datasource/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._remote, this._local, this._supabaseClient);

  @override
  bool get isLoggedIn => _supabaseClient.auth.currentSession != null;

  @override
  Future<Result<UserEntity>> signInWithEmail(
      String email, String password) async {
    try {
      final response = await _remote.signInWithEmail(email, password);
      final userId = response.session?.user.id ?? '';
      if (userId.isEmpty) {
        return Result.failure(const ApiException(
          code: FailureCode.unauthorized,
          message: 'User not found in session',
        ));
      }
      final user = await _remote.fetchUserProfile(userId);
      await _local.cacheUser(user);
      return Result.success(user.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      final response = await _remote.signInWithGoogle();
      final userId = response.session?.user.id ?? '';
      if (userId.isEmpty) {
        return Result.failure(const ApiException(
          code: FailureCode.unauthorized,
          message: 'User not found in session',
        ));
      }
      final user = await _remote.fetchUserProfile(userId);
      await _local.cacheUser(user);
      return Result.success(user.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  // BUG-004 Fix: Atomic register + create-profile flow. Pindah dari
  // sign_up_page ke sini supaya jika step INSERT/uploadAvatar gagal
  // setelah signUp sukses, user di-delete via RPC `delete_user()`
  // (BUG-004-C: no ghost account).
  //
  // Flow:
  //   1) signUp Auth + set user_metadata.{display_name, is_profile_complete:false}
  //   2) uploadAvatar (jika ada photo) → bucket avatars/{authId}/profile.jpg
  //   3) INSERT user_profiles (full_name, nickname, gender, dob,
  //      is_profile_complete:true, avatar_url)
  //   4) updateAuthMetadata(is_profile_complete:true) — jaga-jaga
  //      kalau RLS trigger di step 3 overwrite
  //   *) Jika step 2/3/4 gagal → deleteCurrentUser() cleanup
  @override
  Future<Result<UserEntity>> registerAndCreateProfile({
    required String email,
    required String password,
    required String fullName,
    required String nickname,
    required String gender,
    required DateTime dob,
    File? photo,
  }) async {
    try {
      await _remote.signUpWithEmail(
        email,
        password,
        data: {
          'display_name': fullName,
          'is_profile_complete': false,
        },
      );

      final session = _supabaseClient.auth.currentSession;
      if (session == null) {
        await _safeCleanup();
        return Result.failure(const ApiException(
          code: FailureCode.unknown,
          message: 'No session after signUp',
        ));
      }
      final authId = session.user.id;

      String? avatarUrl;
      if (photo != null) {
        avatarUrl = await _remote.uploadAvatar(authId, photo);
      }

      final profile = await _remote.createUserProfile({
        'auth_id': authId,
        'full_name': fullName,
        'nickname': nickname,
        'gender': gender,
        'dob': dob.toIso8601String().split('T').first,
        'is_profile_complete': true,
        'avatar_url': avatarUrl,
      });

      await _remote.updateAuthMetadata(isProfileComplete: true);

      await _local.cacheUser(profile);
      return Result.success(profile.toEntity());
    } catch (e) {
      await _safeCleanup();
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  Future<void> _safeCleanup() async {
    try {
      await _remote.deleteCurrentUser();
    } catch (_) {
      // Silent: cleanup failure shouldn't mask original error
    }
  }

  @override
  Future<Result<UserEntity>> createProfile(
    Map<String, dynamic> data, {
    File? photo,
  }) async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) {
        return Result.failure(const ApiException(
          code: FailureCode.unauthorized,
          message: 'No active session',
        ));
      }

      String? avatarUrl;
      if (photo != null) {
        avatarUrl = await _remote.uploadAvatar(session.user.id, photo);
      }

      final profile = await _remote.createUserProfile({
        ...data,
        'auth_id': session.user.id,
        'avatar_url': ?avatarUrl,
      });
      await _local.cacheUser(profile);
      return Result.success(profile.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<void>> sendResetPasswordEmail(String email) async {
    try {
      await _remote.sendResetPasswordEmail(email);
      return Result.success(null);
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<void>> resetPassword(String newPassword) async {
    try {
      await _remote.updatePassword(newPassword);
      return Result.success(null);
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remote.signOut();
      await _local.clearUser();
      return Result.success(null);
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) {
        return Result.failure(const ApiException(
          code: FailureCode.unauthorized,
          message: 'No active session',
        ));
      }
      final user = await _remote.fetchUserProfile(session.user.id);
      return Result.success(user.toEntity());
    } catch (e) {
      final cached = _local.getCachedUser();
      if (cached != null) {
        return Result.success(cached.toEntity());
      }
      return Result.failure(const ErrorHandler().map(e));
    }
  }
}
