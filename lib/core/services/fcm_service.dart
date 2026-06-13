// lib/core/services/fcm_service.dart
//
// Firebase Cloud Messaging (FCM) service untuk push notification.
//
// Lifecycle:
// 1. requestPermission() → minta izin notifikasi (iOS + Android 13+)
// 2. getToken() → ambil FCM token
// 3. upsertTokenToSupabase() → simpan ke user_devices table
// 4. onTokenRefresh() → listener untuk auto-refresh token
// 5. handleForegroundMessage() → show snackbar/banner
// 6. handleNotificationTap() → parse payload → navigate via GoRouter
//
// Database schema (per ERD §5 user_devices table):
//   auth_id, fcm_token, platform (android/ios), updated_at
//
// API endpoint: PATCH /rest/v1/user_devices?auth_id=eq.{uid}
//   Body: { fcm_token, platform, updated_at }

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class FcmService {
  final SupabaseClient _supabase;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FcmService(this._supabase);

  /// Flag — set setelah [requestPermission] selesai agar tidak dipanggil 2x.
  bool _initialized = false;

  // ── Permission ────────────────────────────────────────────────────────────
  Future<NotificationSettings> requestPermission() async {
    if (_initialized) {
      return _messaging.getNotificationSettings();
    }
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _initialized = true;
    return settings;
  }

  // ── Token management ─────────────────────────────────────────────────────
  Future<String?> getToken() async {
    try {
      // web butuh VAPID key
      if (kIsWeb) {
        return await _messaging.getToken();
      }
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('FcmService.getToken error: $e');
      return null;
    }
  }

  /// Upsert FCM token ke `user_devices` table. Idempotent.
  /// Dipanggil dari main() setelah login + dari [_onTokenRefresh] listener.
  Future<void> upsertTokenToSupabase({String? tokenOverride}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final token = tokenOverride ?? await getToken();
    if (token == null) return;

    final platform = _detectPlatform();
    try {
      await _supabase.from('user_devices').upsert(
        {
          'auth_id': userId,
          'fcm_token': token,
          'platform': platform,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'auth_id,fcm_token',
      );
    } catch (e) {
      debugPrint('FcmService.upsertTokenToSupabase error: $e');
    }
  }

  String _detectPlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  // ── Token refresh listener ───────────────────────────────────────────────
  /// Register listener untuk FCM token refresh. Token bisa berubah saat:
  /// - User reinstall app
  /// - User clear app data
  /// - Backup/restore
  /// - App restored on new device
  void onTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      await upsertTokenToSupabase(tokenOverride: newToken);
    });
  }

  // ── Foreground message handler ───────────────────────────────────────────
  /// Stream of foreground message payloads.
  /// Page/widget bisa listen untuk show snackbar/banner.
  Stream<RemoteMessage> get onForegroundMessage {
    return FirebaseMessaging.onMessage;
  }

  // ── Notification opened (user tapped) ───────────────────────────────────
  /// Stream yang fire saat user tap notification (app di foreground).
  /// App sudah running — langsung navigate.
  Stream<RemoteMessage> get onMessageOpenedApp {
    return FirebaseMessaging.onMessageOpenedApp;
  }

  // ── Get initial message (app launched dari terminated state) ────────────
  Future<RemoteMessage?> getInitialMessage() async {
    return await _messaging.getInitialMessage();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────
  /// Parse payload untuk deep link navigation.
  /// Returns Map dengan keys: 'type' (booking_confirmed/booking_cancelled/
  /// booking_reminder/general), 'appointmentId' (optional), 'path' (optional).
  static Map<String, dynamic> parseNotificationPayload(
    Map<String, dynamic> raw,
  ) {
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : raw;
    return {
      'type': (data['type'] as String?) ?? 'general',
      'appointmentId': data['appointment_id'] as String? ?? data['appointmentId'] as String?,
      'path': data['path'] as String?,
    };
  }
}

// ── Top-level background message handler ──────────────────────────────────
// HARUS top-level (static function), dipanggil dari main().
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background handler — minimal logic only.
  // Heavy work (DI access) TIDAK bisa di sini karena isolate terpisah.
  debugPrint('Background message: ${message.notification?.title}');
}
