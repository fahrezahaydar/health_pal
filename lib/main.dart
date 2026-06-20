// lib/main.dart
//
// Init order (PENTING — dependensi antar service):
// 1. WidgetsFlutterBinding.ensureInitialized()
// 2. dotenv.load()           — .env vars untuk credentials
// 3. Supabase.initialize()   — auth + database client
// 4. Firebase.initializeApp() — required by FirebaseMessaging
// 5. configureDependencies()  — DI (injectable)
// 6. AppServices.init()      — session restore, routing decision
// 7. FcmService init        — request permission + upsert token
//
// Background handler HARUS di-top-level function dan di-register SEBELUM
// runApp(). Lihat [firebaseMessagingBackgroundHandler] di fcm_service.dart.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/locator.dart';
import 'core/router/app_router.dart';
import 'core/services/app_services.dart';
import 'core/services/fcm_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 0. Global error handlers — register SEBELUM Supabase agar setiap
  //    exception dari auth/DB dapat ditangani dan session-expired
  //    tidak menyebabkan crash.
  _registerErrorHandlers();

  // 1. .env
  await dotenv.load(fileName: '.env');

  // 2. Supabase (auth + db)
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // 3. Firebase (required before FirebaseMessaging)
  await Firebase.initializeApp();

  // 4. DI
  await configureDependencies();

  final appService = GetIt.instance<AppServices>();
  await appService.init();

  // 5. FCM — request permission, upsert token, register listeners
  await _initFcm();

  runApp(const MyApp());
}

/// FCM initialization flow.
/// - Register background handler (top-level function, must be early)
/// - Request permission (iOS + Android 13+)
/// - Get + upsert token to Supabase
/// - Subscribe to token refresh + foreground message + tap
Future<void> _initFcm() async {
  // Background handler — registered FIRST agar tidak missed messages.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final fcm = GetIt.instance<FcmService>();
  try {
    await fcm.requestPermission();
    await fcm.upsertTokenToSupabase();
    fcm.onTokenRefresh();
  } catch (e) {
    // FCM init failure TIDAK boleh block app launch — log dan continue.
    debugPrint('FCM init failed: $e');
  }
}

/// Daftarkan error handler global. Dipanggil paling awal di main().
///
/// Tujuannya: TANGKAP `AuthException` dari Supabase yang menandakan
/// session expired / token invalid, lalu sign-out secara graceful
/// tanpa crash. AppServices.authStateListener kemudian akan
/// mengarahkan user ke halaman login.
void _registerErrorHandlers() {
  // Framework errors (build, layout, paint, gesture).
  FlutterError.onError = (FlutterErrorDetails details) {
    if (_isSessionExpiredError(details.exception)) {
      _signOutQuietly();
      return;
    }
    FlutterError.presentError(details);
  };

  // Async errors yang tidak tertangkap framework.
  PlatformDispatcher.instance.onError = (error, stack) {
    if (_isSessionExpiredError(error)) {
      _signOutQuietly();
      return true;
    }
    return false;
  };
}

/// Cek apakah exception adalah AuthException dengan pesan session-expired.
bool _isSessionExpiredError(Object? error) {
  if (error is! AuthException) return false;
  final msg = error.message.toLowerCase();
  return (error.statusCode == '400' || error.statusCode == '401') &&
      (msg.contains('session expired') ||
          msg.contains('jwt expired') ||
          msg.contains('token expired') ||
          msg.contains('invalid token'));
}

/// Trigger sign-out tanpa await — fire and forget.
/// AppServices.authStateListener akan tangani navigasi.
void _signOutQuietly() {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<AppServices>()) {
    // ignore: discarded_futures
    getIt<AppServices>().logout();
  } else {
    // Fallback: Supabase sudah di-init tapi DI belum jalan.
    // ignore: discarded_futures
    Supabase.instance.client.auth.signOut();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GetIt.instance<AppRouter>().router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
