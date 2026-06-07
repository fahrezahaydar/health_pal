import '../../../../core/network/result.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> signInWithEmail(String email, String password);
  Future<Result<UserEntity>> signUpWithEmail(String email, String password);
  Future<Result<UserEntity>> signInWithGoogle();
  Future<Result<UserEntity>> createProfile(Map<String, dynamic> data);
  Future<Result<void>> sendResetPasswordEmail(String email);
  Future<Result<void>> resetPassword(String newPassword);
  Future<Result<void>> signOut();
  Future<Result<UserEntity>> getCurrentUser();
  bool get isLoggedIn;
}
