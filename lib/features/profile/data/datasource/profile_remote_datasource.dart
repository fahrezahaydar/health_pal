// lib/features/profile/data/datasource/profile_remote_datasource.dart
//
// DataSource untuk profile + notifications endpoints.
// Pattern sama dengan AuthRemoteDataSource.
//
// Per API Contract:
// - §3.5 GET /rest/v1/me     → getProfile (single object, not array)
// - §3.2 PATCH /rest/v1/user_profiles?auth_id=eq.<auth_uid>  → updateProfile
// - §3.3 POST /storage/v1/object/avatars/<user_id>/<file>    → uploadAvatar
// - §8.1 GET /rest/v1/notifications?user_id=eq.<profile_id>  → getNotifications
//
// FAVORITES: TIDAK ada backend table per Fase 8 task 8.13 (placeholder v1.1).
// Return list kosong dari getFavorites() untuk satisfy UI.

import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/enums/failure_code.dart';
import '../../../../core/network/api_exception.dart';
import '../../../auth/data/model/user_model.dart';
import '../model/notification_model.dart';

@injectable
class ProfileRemoteDataSource {
  final SupabaseClient _client;

  ProfileRemoteDataSource(this._client);

  // ── API §3.5 Get My Profile ───────────────────────────────────────────────
  // FIX-1: Query langsung ke tabel `user_profiles` (bukan view `me`).
  // Pattern konsisten dengan auth_remote_datasource.dart:48-52 dan
  // home_remote_datasource.dart:58-62. View `me` di API contract §3.5
  // belum di-migrate ke Supabase DB; query `.from('me')` menyebabkan
  // PGRST205 (table not found).
  Future<UserModel> getProfile() async {
    final session = _client.auth.currentSession;
    if (session == null) {
      throw const ApiException(
        code: FailureCode.unauthorized,
        message: 'Tidak ada sesi aktif',
      );
    }

    final result = await _client
        .from('user_profiles')
        .select()
        .eq('auth_id', session.user.id)
        .maybeSingle();

    if (result == null) {
      throw const ApiException(
        code: FailureCode.notFound,
        message: 'User profile not found',
      );
    }

    return UserModel.fromJson({...result, 'email': session.user.email ?? ''});
  }

  // ── API §3.2 Update Profile (PATCH) ──────────────────────────────────────
  Future<UserModel> updateProfile({
    required String authId,
    String? fullName,
    String? nickname,
    String? dateOfBirth,
    String? gender,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (nickname != null) body['nickname'] = nickname;
    if (dateOfBirth != null) body['date_of_birth'] = dateOfBirth;
    if (gender != null) body['gender'] = gender;
    if (avatarUrl != null) body['avatar_url'] = avatarUrl;

    if (body.isEmpty) {
      // Nothing to update, return current profile
      return getProfile();
    }

    final result = await _client
        .from('user_profiles')
        .update(body)
        .eq('auth_id', authId)
        .select()
        .single();

    final email = _client.auth.currentSession?.user.email ?? '';
    return UserModel.fromJson({...result, 'email': email});
  }

  // ── API §3.3 Upload Avatar ───────────────────────────────────────────────
  // BUG-003 re-fix: SDK `storage_client` (line 40 storage_file_api.dart)
  // concat path dengan bucketId otomatis: `'$bucketId/$path'`. Kalau
  // path kita include 'avatars/' prefix → URL jadi
  // 'avatars/avatars/$userId/profile.jpg' (double prefix) →
  // storage.foldername(name) = ['avatars', 'avatars', '$userId'] →
  // foldername[1] = 'avatars' (BUKAN userId) → RLS check
  // `'avatars' = auth.uid()::text` always DENY.
  //
  // Fix: path HARUS relative ke bucket, tanpa 'avatars/' prefix.
  // SDK comment line 51: "[path] is the relative file path without
  // the bucket ID."
  Future<String> uploadAvatar(String userId, File photo) async {
    final bytes = await photo.readAsBytes();
    final path = '$userId/profile.jpg';

    await _client.storage
        .from('avatars')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );
    return _client.storage.from('avatars').getPublicUrl(path);
  }

  // ── FAVORITES (placeholder v1.1, no backend) ─────────────────────────────
  /// Returns empty list — favorites table not implemented.
  /// UI menampilkan empty state.
  Future<List<dynamic>> getFavorites() async {
    return <dynamic>[];
  }

  // ── API §8.1 Get Notifications ───────────────────────────────────────────
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    int limit = 30,
    int offset = 0,
  }) async {
    final result = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('sent_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (result as List)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── API §8.2 Mark Notification as Read ───────────────────────────────────
  Future<void> markNotificationAsRead({
    required String userId,
    required String notificationId,
  }) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId)
        .eq('user_id', userId);
  }
}
