import 'dart:io';

import '../../../../core/network/result.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> signInWithEmail(String email, String password);
  Future<Result<UserEntity>> signInWithGoogle();
  Future<Result<UserEntity>> registerAndCreateProfile({
    required String email,
    required String password,
    required String fullName,
    required String nickname,
    required String gender,
    required DateTime dob,
    File? photo,
  });
  Future<Result<UserEntity>> createProfile(Map<String, dynamic> data, {File? photo});
  Future<Result<void>> sendResetPasswordEmail(String email);
  Future<Result<void>> resetPassword(String newPassword);
  Future<Result<void>> signOut();
  Future<Result<UserEntity>> getCurrentUser();
  bool get isLoggedIn;
}
