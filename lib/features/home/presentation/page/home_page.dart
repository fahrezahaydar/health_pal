import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:health_pal/core/di/locator.dart';
import 'package:health_pal/core/services/app_services.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/enums/booking_status.dart';
import '../../../profile/presentation/bloc/notification/notification_cubit.dart';
import '../../../profile/presentation/bloc/notification/notification_state.dart';
import '../../domain/entity/banner_entity.dart';
import '../../domain/entity/specialization_entity.dart';
import '../../domain/entity/upcoming_appointment_entity.dart';
import '../bloc/banner/banner_cubit.dart';
import '../bloc/banner/banner_state.dart';
import '../bloc/greeting/greeting_cubit.dart';
import '../bloc/greeting/greeting_state.dart';
import '../bloc/specialization/specialization_cubit.dart';
import '../bloc/specialization/specialization_state.dart';
import '../bloc/upcoming/upcoming_cubit.dart';
import '../bloc/upcoming/upcoming_state.dart';
import '../widget/banner_carousel.dart';
import '../widget/greeting_section.dart';
import '../widget/quick_categories.dart';
import '../widget/search_bar_home.dart';
import '../widget/upcoming_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            // Sprint 2 — A4 (Fix K4): was `getIt<SupabaseClient>().auth.currentUser?.id`
            // — TDD 01 §3.3 dependency rule violation (presentation
            // touches data layer directly). Sekarang via AppServices
            // (singleton global state owner). Pattern konsisten dengan
            // BlocListener di bawah yang juga pakai `GetIt.instance<AppServices>()`.
            final authId =
                GetIt.instance<AppServices>().currentAuthId ?? '';
            return getIt<GreetingCubit>()..loadProfile(authId);
          },
        ),
        BlocProvider(create: (context) => getIt<BannerCubit>()..loadBanners()),
        BlocProvider(
          create: (context) =>
              getIt<SpecializationCubit>()..loadSpecializations(),
        ),
        BlocProvider(create: (context) => getIt<UpcomingCubit>()),
        // Sprint 2 — A8: load notification count (replaces hardcoded 5 badge)
        BlocProvider(create: (context) => getIt<NotificationCubit>()),
      ],
      child: const _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody();

  // Sprint 2 — C1: Skeletonizer mock data (non-empty) for production
  // widgets whose default empty-data branch returns SizedBox.shrink.
  // Per AGENTS.md: DILARANG dedicated skeleton widget files — reuse
  // production widget langsung via Skeletonizer(enabled:..., child:...).
  // When `state is *Loading`, the production widget receives this
  // non-empty data so Skeletonizer can paint bone placeholders over
  // the resulting layout. Once loaded, the real data replaces these.
  // Hoisted to static const so we don't allocate per-rebuild.
  static const _skeletonBanners = <BannerEntity>[
    BannerEntity(id: 'sk-1', title: 'Loading banner placeholder 1'),
    BannerEntity(id: 'sk-2', title: 'Loading banner placeholder 2'),
    BannerEntity(id: 'sk-3', title: 'Loading banner placeholder 3'),
  ];
  static const _skeletonSpecializations = <SpecializationEntity>[
    SpecializationEntity(id: 'sk-1', name: 'Loading spec 1'),
    SpecializationEntity(id: 'sk-2', name: 'Loading spec 2'),
    SpecializationEntity(id: 'sk-3', name: 'Loading spec 3'),
    SpecializationEntity(id: 'sk-4', name: 'Loading spec 4'),
    SpecializationEntity(id: 'sk-5', name: 'Loading spec 5'),
    SpecializationEntity(id: 'sk-6', name: 'Loading spec 6'),
    SpecializationEntity(id: 'sk-7', name: 'Loading spec 7'),
    SpecializationEntity(id: 'sk-8', name: 'Loading spec 8'),
  ];
  static const _skeletonUpcoming = UpcomingAppointmentEntity(
    id: 'sk-1',
    doctorName: 'Loading Doctor Name Placeholder',
    clinicName: 'Loading Clinic Name Placeholder',
    specializationName: 'Loading Specialization Placeholder',
    // Intentionally null slot fields — DateFormatter returns "—" for
    // null, Skeletonizer paints bones over the dash.
    slotDate: null,
    slotStart: null,
    slotEnd: null,
    status: BookingStatus.upcoming,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<GreetingCubit, GreetingState>(
          listener: (context, state) {
            if (state is GreetingLoaded) {
              if (state.profileId.isNotEmpty) {
                context.read<UpcomingCubit>().loadUpcoming(state.profileId);
                // Sprint 2 — A8: load unread notification count after profile loaded
                context
                    .read<NotificationCubit>()
                    .loadNotifications(state.profileId);
              }
              // FIX-7: Guard profile completeness. Jika profile incomplete
              // (misalnya network failure fallback di FIX-2 atau server-side
              // change setelah sign-in), set status ke profileIncomplete.
              // Router Kondisi 3 akan redirect ke /sign-up/create-profile.
              // Idempotent: jika status sudah profileIncomplete, no-op.
              if (!state.isProfileComplete) {
                GetIt.instance<AppServices>().setProfileIncomplete();
              }
            } else if (state is GreetingNoProfile) {
              // FIX-7 enhancement: row user_profiles tidak ada untuk
              // user ini. Sama seperti isProfileComplete=false, kita
              // treat sebagai incomplete dan redirect ke CreateProfile.
              // Distinct dari GreetingError (network/timeout) agar
              // transient error TIDAK trigger false-positive redirect.
              GetIt.instance<AppServices>().setProfileIncomplete();
            }
            // GreetingError (network/timeout) -> no action; user stay
            // di Home dan retry terjadi natural di app resume / pull-refresh.
          },
          child: ListView(
            children: [
              BlocBuilder<NotificationCubit, NotificationListState>(
                builder: (context, notifState) {
                  final unread = switch (notifState) {
                    NotificationLoaded(:final unreadCount) => unreadCount,
                    _ => 0,
                  };
                  return BlocBuilder<GreetingCubit, GreetingState>(
                    builder: (context, greetingState) {
                      final isLoading = greetingState is GreetingLoading;
                      // Sprint 2 — C1: Skeletonizer wrap for GreetingSection.
                      // When loading, Skeletonizer paints bones over the
                      // "Halo, " text + notification icon. When loaded,
                      // Skeletonizer is disabled — real content shows.
                      // SearchBarHome is intentionally NOT wrapped (no
                      // loading state — purely static tap target).
                      return Skeletonizer(
                        enabled: isLoading,
                        child: BlocSelector<GreetingCubit, GreetingState, String>(
                          selector: (state) => switch (state) {
                            GreetingLoaded(:final nickname) => nickname,
                            _ => '',
                          },
                          builder: (context, nickname) {
                            return GreetingSection(
                              nickname: isLoading ? 'Halo' : nickname,
                              unreadCount: unread,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              // Sprint 2 — A1: Search Bar widget (stateless, tap → doctor search)
              // Per Wireframe 06 §2 + PRD §6.2 + home_page_audit.md §13.1 K1
              // C1 note: SearchBarHome tidak dibungkus Skeletonizer karena
              // tidak ada loading state (stateless tap target, content
              // static). Per AD-6 — skeletonizer HANYA untuk data-driven
              // sections.
              const SearchBarHome(),
              BlocBuilder<BannerCubit, BannerState>(
                builder: (context, state) {
                  final isLoading = state is BannerLoading;
                  // Sprint 2 — C1: mock banners saat loading agar
                  // BannerCarousel render 3 skeleton cards (default
                  // empty list returns SizedBox.shrink per widget code,
                  // no skeleton possible).
                  final banners = isLoading
                      ? _skeletonBanners
                      : (state is BannerLoaded
                          ? state.banners
                          : const <BannerEntity>[]);
                  return Skeletonizer(
                    enabled: isLoading,
                    child: BannerCarousel(banners: banners),
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<UpcomingCubit, UpcomingState>(
                builder: (context, state) {
                  final isLoading = state is UpcomingLoading;
                  // Sprint 2 — C1: mock upcoming saat loading agar
                  // UpcomingCard render appointment-card layout (bukan
                  // empty state) untuk Skeletonizer paint bones.
                  final upcoming = isLoading
                      ? _skeletonUpcoming
                      : (state is UpcomingLoaded ? state.upcoming : null);
                  return Skeletonizer(
                    enabled: isLoading,
                    child: UpcomingCard(upcoming: upcoming),
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<SpecializationCubit, SpecializationState>(
                builder: (context, state) {
                  final isLoading = state is SpecializationLoading;
                  // Sprint 2 — C1: mock 8 specializations (2 rows × 4
                  // columns per Wireframe 06 grid) saat loading agar
                  // QuickCategories render grid skeleton.
                  final specializations = isLoading
                      ? _skeletonSpecializations
                      : (state is SpecializationLoaded
                          ? state.specializations
                          : const <SpecializationEntity>[]);
                  return Skeletonizer(
                    enabled: isLoading,
                    child: QuickCategories(specializations: specializations),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sprint 2 — C1: Skeletonizer needs valid BookingStatus value for
// mock _skeletonUpcoming. Using BookingStatus.upcoming — enum value
// is const-evaluable so static const _skeletonUpcoming compiles fine.
// (No need for private alias; enum is imported above.)
