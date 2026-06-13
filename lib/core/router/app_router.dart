import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'route_paths.dart';

import '../../features/auth/presentation/page/create_profile_page.dart';
import '../../features/auth/presentation/page/forgot_password_page.dart';
import '../../features/auth/presentation/page/login_page.dart';
import '../../features/auth/presentation/page/sign_up_page.dart';
import '../../features/booking/presentation/page/book_appointment_page.dart';
import '../../features/booking/presentation/page/booking_detail_page.dart';
import '../../features/booking/presentation/page/booking_history_page.dart';
import '../../features/booking/presentation/page/booking_success_page.dart';
import '../../features/booking/domain/entity/appointment_entity.dart';
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

      final isAuthRoute =
          loc.startsWith('/sign-in') || loc.startsWith('/sign-up');
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
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'signIn',
        builder: (_, _) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            name: 'forgotPassword',
            builder: (_, _) => const ForgotPasswordPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/sign-up',
        name: 'signUp',
        builder: (_, _) => const SignUpPage(),
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
        builder: (_, _, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (_, _) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/loc',
                name: 'locationSearch',
                builder: (_, _) => const LocPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/booking-history',
                name: 'bookingHistory',
                builder: (_, _) => const BookingHistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (_, _) => const ProfilePage(),
              ),
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
        builder: (_, _) => const DoctorSearchPage(),
      ),
      GoRoute(
        path: '/doctor/:doctorId',
        name: 'doctorDetail',
        builder: (_, state) =>
            DoctorDetailPage(doctorId: state.pathParameters['doctorId']!),
      ),

      // ═══════════════════════════
      // STACK — BOOKING
      // ═══════════════════════════
      GoRoute(
        path: '/booking/:doctorId',
        name: 'bookAppointment',
        builder: (_, state) =>
            BookAppointmentPage(doctorId: state.pathParameters['doctorId']!),
      ),
      GoRoute(
        path: '/booking/success',
        name: 'bookingSuccess',
        builder: (_, state) {
          final extra = state.extra;
          return BookingSuccessPage(
            appointment: extra is AppointmentEntity ? extra : null,
          );
        },
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
      GoRoute(
        path: '/profile/edit',
        name: 'editProfile',
        builder: (_, _) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/profile/favorite',
        name: 'favorite',
        builder: (_, _) => const FavoritePage(),
      ),
      GoRoute(
        path: '/profile/notifications',
        name: 'notifications',
        builder: (_, _) => const NotificationPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (_, _) => const SettingsPage(),
      ),
      GoRoute(
        path: '/help-support',
        name: 'helpSupport',
        builder: (_, _) => const HelpSupportPage(),
      ),
      GoRoute(
        path: '/terms-and-conditions',
        name: 'termsAndConditions',
        builder: (_, _) => const TermsAndConditionsPage(),
      ),

      // ═══════════════════════════
      // STACK — UTILITY
      // ═══════════════════════════
      GoRoute(
        path: '/no-internet',
        name: 'noInternet',
        builder: (_, _) => const NoInternetPage(),
      ),
    ],

    errorBuilder: (context, state) =>
        NotFoundPage(message: 'Halaman ${state.uri.path} tidak ditemukan'),
  );
}

/// Handle deep link dari push notification tap.
///
/// Payload format (parsed dari FcmService.parseNotificationPayload):
/// - type: 'booking_confirmed' | 'booking_cancelled' | 'booking_reminder' | 'general'
/// - appointmentId: string? (optional)
/// - path: string? (optional override)
///
/// Behavior:
/// - booking_*  + appointmentId → push /booking-history/:appointmentId
/// - general / default            → push /profile/notifications
/// - explicit `path` field       → push ke path tsb (jika valid route)
void handleNotificationNavigation(
  BuildContext context,
  Map<String, dynamic> payload,
) {
  final type = payload['type'] as String? ?? 'general';
  final appointmentId = payload['appointmentId'] as String?;
  final customPath = payload['path'] as String?;

  // Custom path override
  if (customPath != null && customPath.isNotEmpty) {
    context.push(customPath);
    return;
  }

  switch (type) {
    case 'booking_confirmed':
    case 'booking_cancelled':
    case 'booking_reminder':
      if (appointmentId != null) {
        context.push('/booking-history/$appointmentId');
      } else {
        context.push(RoutePaths.bookingHistory);
      }
      break;
    case 'general':
    default:
      context.push(RoutePaths.notificationSettings);
  }
}
