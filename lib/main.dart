import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'core/di/locator.dart';
import 'core/router/app_router.dart';
import 'core/services/app_services.dart';
import 'core/theme/app_text_theme.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init DI
  await configureDependencies();

  final appService = GetIt.instance<AppServices>();

  // 🔥 IMPORTANT: initialize BEFORE runApp
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
