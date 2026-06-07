import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class FcmService {
  final SupabaseClient _supabase;

  FcmService(this._supabase);

  Future<void> init() async {
    // TODO: Initialize FirebaseMessaging, request permissions
  }

  Future<void> upsertToken(String token, String platform) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('user_fcm_tokens').upsert({
      'user_id': userId,
      'fcm_token': token,
      'platform': platform,
    });
  }

  Future<void> handleForegroundMessage(Map<String, dynamic> data) async {
    // TODO: Show in-app snackbar
  }

  void handleNotificationTap(Map<String, dynamic> data) {
    // TODO: Navigate based on notification type
  }
}
