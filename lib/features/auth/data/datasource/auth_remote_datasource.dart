import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/enums/failure_code.dart';
import '../../../../core/network/api_exception.dart';
import '../model/user_model.dart';

@injectable
class AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSource(this._client);

  Future<AuthResponse> signInWithEmail(String email, String password) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter.healthpal://login-callback',
    );
    final session = _client.auth.currentSession;
    if (session == null) {
      throw const ApiException(
        code: FailureCode.unknown,
        message: 'Failed to get session after Google sign in',
      );
    }
    return AuthResponse(session: session, user: _client.auth.currentUser);
  }

  Future<void> sendResetPasswordEmail(String email) {
    return _client.auth.resetPasswordForEmail(email);
  }

  Future<void> updatePassword(String newPassword) {
    return _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<UserModel> fetchUserProfile(String userId) async {
    final result = await _client
        .from('user_profiles')
        .select()
        .eq('auth_id', userId)
        .maybeSingle();

    if (result == null) {
      throw const ApiException(
        code: FailureCode.notFound,
        message: 'User profile not found',
      );
    }

    final session = _client.auth.currentSession;
    return UserModel.fromJson({...result, 'email': session?.user.email ?? ''});
  }

  Future<UserModel> createUserProfile(Map<String, dynamic> data) async {
    final result = await _client
        .from('user_profiles')
        .insert(data)
        .select()
        .single();
    final session = _client.auth.currentSession;
    return UserModel.fromJson({...result, 'email': session?.user.email ?? ''});
  }

  Future<void> signOut() => _client.auth.signOut();
}
