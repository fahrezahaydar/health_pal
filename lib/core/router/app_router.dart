import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/presentation/page/create_profile_page.dart';
import '../../features/auth/presentation/page/forgot_password_page.dart';
import '../../features/auth/presentation/page/login_page.dart';
import '../../features/auth/presentation/page/sign_up_page.dart';
import '../../features/booking/presentation/page/book_appointment_page.dart';
import '../../features/booking/presentation/page/booking_detail_page.dart';
import '../../features/booking/presentation/page/booking_history_page.dart';
import '../../features/booking/presentation/page/booking_success_page.dart';
import '../../features/doctor/presentation/page/doctor_detail_page.dart';
import '../../features/doctor/presentation/page/doctor_search_page.dart';
import '../../features/home/presentation/page/home_page.dart';
import '../../features/loc/presentation/page/loc_page.dart';
import '../../features/onboarding/presentation/page/onboarding_page.dart';
import '../../features/profile/presentation/page/edit_profile_page.dart';
import '../../features/profile/presentation/page/favorite_page.dart';
import '../../features/profile/presentation/page/notification_page.dart';
import '../../features/profile/presentation/page/profile_page.dart';
import '../../features/settings/presentation/page/help_support_page.dart';
import '../../features/settings/presentation/page/no_internet_page.dart';
import '../../features/settings/presentation/page/settings_page.dart';
import '../../features/settings/presentation/page/terms_and_conditions_page.dart';
import '../enums/app_status.dart';
import '../services/app_services.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/not_found_page.dart';

@lazySingleton
class AppRouter {
  final AppServices _appServices;

  AppRouter(this._appServices);

  late final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: _appServices,

    redirect: (context, state) {
      final status = _appServices.status;
      final loc = state.uri.path;

      final isAuthRoute = loc.startsWith('/sign-in') || loc.startsWith('/sign-up');
      final isPublicRoute = loc == '/onboarding' || loc == '/no-internet';

      switch (status) {
        case AppStatus.loading:
          return null;
        case AppStatus.onboarding:
          return loc == '/onboarding' ? null : '/onboarding';
        case AppStatus.unauthenticated:
          if (isPublicRoute || isAuthRoute) return null;
          return '/sign-in';
        case AppStatus.authenticated:
          if (isPublicRoute || isAuthRoute) return '/home';
          return null;
      }
    },

    routes: [
      // ═══════════════════════════
      // PRE-AUTH
      // ═══════════════════════════
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'signIn',
        builder: (_, __) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            name: 'forgotPassword',
            builder: (_, __) => const ForgotPasswordPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/sign-up',
        name: 'signUp',
        builder: (_, __) => const SignUpPage(),
        routes: [
          GoRoute(
            path: 'create-profile',
            name: 'createProfile',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>?;
              return CreateProfilePage(
                email: data?['email'] ?? '',
                password: data?['password'] ?? '',
                fullname: data?['name'] ?? '',
              );
            },
          ),
        ],
      ),

      // ═══════════════════════════
      // MAIN SHELL
      // ═══════════════════════════
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AppShell(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', name: 'home', builder: (_, __) => const HomePage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/loc', name: 'locationSearch', builder: (_, __) => const LocPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/booking-history', name: 'bookingHistory', builder: (_, __) => const BookingHistoryPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/profile', name: 'profile', builder: (_, __) => const ProfilePage()),
            ],
          ),
        ],
      ),

      // ═══════════════════════════
      // STACK — DOCTOR
      // ═══════════════════════════
      GoRoute(
        path: '/doctor/search',
        name: 'doctorSearch',
        builder: (_, __) => const DoctorSearchPage(),
      ),
      GoRoute(
        path: '/doctor/:doctorId',
        name: 'doctorDetail',
        builder: (_, state) => DoctorDetailPage(
          doctorId: state.pathParameters['doctorId']!,
        ),
      ),

      // ═══════════════════════════
      // STACK — BOOKING
      // ═══════════════════════════
      GoRoute(
        path: '/booking/:doctorId',
        name: 'bookAppointment',
        builder: (_, state) => BookAppointmentPage(
          doctorId: state.pathParameters['doctorId']!,
        ),
      ),
      GoRoute(
        path: '/booking/success',
        name: 'bookingSuccess',
        builder: (_, __) => const BookingSuccessPage(),
      ),
      GoRoute(
        path: '/booking-history/:appointmentId',
        name: 'bookingDetail',
        builder: (_, state) => BookingDetailPage(
          appointmentId: state.pathParameters['appointmentId']!,
        ),
      ),

      // ═══════════════════════════
      // STACK — PROFILE
      // ═══════════════════════════
      GoRoute(path: '/profile/edit', name: 'editProfile', builder: (_, __) => const EditProfilePage()),
      GoRoute(path: '/profile/favorite', name: 'favorite', builder: (_, __) => const FavoritePage()),
      GoRoute(path: '/profile/notifications', name: 'notifications', builder: (_, __) => const NotificationPage()),
      GoRoute(path: '/settings', name: 'settings', builder: (_, __) => const SettingsPage()),
      GoRoute(path: '/help-support', name: 'helpSupport', builder: (_, __) => const HelpSupportPage()),
      GoRoute(path: '/terms-and-conditions', name: 'termsAndConditions', builder: (_, __) => const TermsAndConditionsPage()),

      // ═══════════════════════════
      // STACK — UTILITY
      // ═══════════════════════════
      GoRoute(path: '/no-internet', name: 'noInternet', builder: (_, __) => const NoInternetPage()),
    ],

    errorBuilder: (context, state) => NotFoundPage(
      message: 'Halaman ${state.uri.path} tidak ditemukan',
    ),
  );
}
