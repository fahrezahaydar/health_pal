import 'package:go_router/go_router.dart';
import 'package:health_pal/features/auth/page/sign_up_page.dart';
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
    initialLocation: '/onboarding',

    refreshListenable: _onboardingService,

    redirect: (context, state) {
      final status = _onboardingService.status;
      final loc = state.matchedLocation;

      // Daftar route yang boleh diakses tanpa login
      final bool isAuthRoute = loc == '/login' || loc == '/sign-up';

      if (status == AppStatus.onboarding) {
        return loc == '/onboarding' ? null : '/onboarding';
      }

      if (status == AppStatus.unauthenticated) {
        // Jika user mau ke login atau sign-up, ijinkan (return null).
        // Jika mau ke halaman lain (misal /home), paksa ke /login.
        return isAuthRoute ? null : '/login';
      }

      if (status == AppStatus.authenticated) {
        // Jika sudah login tapi malah di halaman login/sign-up/onboarding,
        // lempar ke home.
        if (isAuthRoute || loc == '/onboarding') return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/sign-up', builder: (_, _) => const SignUpPage()),
      GoRoute(path: '/home', builder: (_, _) => const HomePage()),
    ],
  );
}
