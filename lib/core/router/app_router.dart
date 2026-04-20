import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/page/login_page.dart';
import '../../features/home/page/home_page.dart';
import '../services/app_services.dart';
import '../../features/onboarding/page/onboarding_page.dart';
import '../enums/app_status.dart';
 
@lazySingleton
class AppRouter {
  final AppServices _onboardingService;

  AppRouter(this._onboardingService);

  late final router = GoRouter(
    initialLocation: '/splash',

    refreshListenable:_onboardingService,

    redirect: (context, state) {
      final status = _onboardingService.status;
      final loc = state.matchedLocation;

      if (status == AppStatus.onboarding) {
        return loc == '/onboarding' ? null : '/onboarding';
      }

      if (status == AppStatus.unauthenticated) {
        return loc == '/login' ? null : '/login';
      }

      if (status == AppStatus.authenticated) {
        return loc == '/home' ? null : '/home';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    ],
  );
}