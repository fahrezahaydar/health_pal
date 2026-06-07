import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/locator.dart';
import 'core/router/app_router.dart';
import 'core/services/app_services.dart';
import 'core/theme/app_text_theme.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env
  await dotenv.load(fileName: '.env');

  // Init Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Init Firebase
  await Firebase.initializeApp();

  // Init DI
  await configureDependencies();

  final appService = GetIt.instance<AppServices>();

  await appService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GetIt.instance<AppRouter>().router;

    return WidgetsApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      color: AppTheme.primary, // Wajib diisi di WidgetsApp
      textStyle: AppTextTheme.bodyMedium,
    );
  }
}
