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
import '../bloc/nearby/nearby_cubit.dart';
import '../bloc/nearby/nearby_state.dart';
import '../bloc/specialization/specialization_cubit.dart';
import '../bloc/specialization/specialization_state.dart';
import '../bloc/upcoming/upcoming_cubit.dart';
import '../bloc/upcoming/upcoming_state.dart';
import '../widget/banner_carousel.dart';
import '../widget/greeting_section.dart';
import '../widget/nearby_facilities.dart';
import '../widget/quick_categories.dart';
import '../widget/search_bar_home.dart';
import '../widget/upcoming_card.dart';
import '../../../../widgets/loader/error_section.dart';

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
        // Sprint 2 — C3: Nearby Medical Centers section. loadNearby
        // triggers location permission dialog if not yet granted.
        // The cubit handles all states (Loading/Loaded/LocationDenied/Error)
        // and the widget renders accordingly.
        BlocProvider(
          create: (context) => getIt<NearbyCubit>()..loadNearby(),
        ),
      ],
      child: const _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatefulWidget {
  const _HomePageBody();

  @override
  State<_HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<_HomePageBody> {
  // Sprint 2 — C2: anti-spam guard for pull-to-refresh. Prevents
  // re-triggering onRefresh while a previous refresh is still in
  // flight. Without this, repeated pulls would call 3 cubit methods
  // multiple times — cubits re-emit Loading and overwrite each
  // other's results. Returning a no-op future from onRefresh
  // (instead of an actual Future.wait) makes RefreshIndicator hide
  // the spinner instantly, defeating the UX.
  bool _isRefreshing = false;

  // Sprint 2 — C2: pull-to-refresh callback. Triggers 3 cubit
  // re-loads in parallel (per AD-7 — single RefreshIndicator, not
  // per-section). GreetingCubit is INTENTIONALLY not triggered:
  // loadProfile has sensitive logic (BUG-001/FIX-7 auto-redirect to
  // CreateProfile on notFound). We just read the current
  // GreetingLoaded.profileId to refresh the UpcomingCubit, which
  // depends on profileId.
  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    try {
      final greetingState = context.read<GreetingCubit>().state;
      final profileId =
          greetingState is GreetingLoaded ? greetingState.profileId : '';

      final futures = <Future<void>>[
        context.read<BannerCubit>().loadBanners(),
        context.read<SpecializationCubit>().loadSpecializations(),
        if (profileId.isNotEmpty)
          context.read<UpcomingCubit>().loadUpcoming(profileId),
        context.read<NearbyCubit>().loadNearby(),
      ];
      await Future.wait(futures);
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

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
          // Sprint 2 — C2: single RefreshIndicator wrap ListView
          // (per AD-7). onRefresh triggers 3 cubit re-loads — see
          // _onRefresh. Anti-spam via _isRefreshing guard.
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              // AlwaysScrollable agar pull-to-refresh tetap work walau
              // konten muat di satu screen (ListView default physics
              // BouncingScrollPhysics sudah support pull-down gesture).
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                BlocBuilder<NotificationCubit, NotificationListState>(
                  builder: (context, notifState) {
                    final unread = switch (notifState) {
                      NotificationLoaded(:final unreadCount) => unreadCount,
                      _ => 0,
                    };
                    return BlocBuilder<GreetingCubit, GreetingState>(
                      builder: (context, greetingState) {
                        return switch (greetingState) {
                          GreetingLoading() => Skeletonizer(
                              enabled: true,
                              child: GreetingSection(
                                nickname: 'Halo',
                                unreadCount: unread,
                              ),
                            ),
                          GreetingLoaded(:final nickname, :final avatarUrl) =>
                            GreetingSection(
                              nickname: nickname,
                              avatarUrl: avatarUrl,
                              unreadCount: unread,
                            ),
                          GreetingError(:final message) => ErrorSection(
                              message: message,
                              onRetry: () {
                                final authId = GetIt.instance<AppServices>()
                                        .currentAuthId ??
                                    '';
                                if (authId.isNotEmpty) {
                                  context
                                      .read<GreetingCubit>()
                                      .loadProfile(authId);
                                }
                              },
                            ),
                          // GreetingNoProfile — handled by BlocListener
                          // (redirect to CreateProfile). No UI needed here.
                          _ => const SizedBox.shrink(),
                        };
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
                  return switch (state) {
                    BannerLoading() => const Skeletonizer(
                        enabled: true,
                        child: BannerCarousel(banners: _skeletonBanners),
                      ),
                    BannerLoaded(:final banners) =>
                      BannerCarousel(banners: banners),
                    BannerError(:final message) => ErrorSection(
                        message: message,
                        onRetry: () =>
                            context.read<BannerCubit>().loadBanners(),
                      ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
                const SizedBox(height: 24),
              BlocBuilder<UpcomingCubit, UpcomingState>(
                builder: (context, state) {
                  return switch (state) {
                    UpcomingLoading() => const Skeletonizer(
                        enabled: true,
                        child: UpcomingCard(upcoming: _skeletonUpcoming),
                      ),
                    UpcomingLoaded(:final upcoming) =>
                      UpcomingCard(upcoming: upcoming),
                    UpcomingError(:final message) => ErrorSection(
                        message: message,
                        onRetry: () {
                          final gs = context.read<GreetingCubit>().state;
                          if (gs is GreetingLoaded) {
                            context
                                .read<UpcomingCubit>()
                                .loadUpcoming(gs.profileId);
                          }
                        },
                      ),
                    _ => const UpcomingCard(upcoming: null),
                  };
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<SpecializationCubit, SpecializationState>(
                builder: (context, state) {
                  return switch (state) {
                    SpecializationLoading() => const Skeletonizer(
                        enabled: true,
                        child: QuickCategories(
                          specializations: _skeletonSpecializations,
                        ),
                      ),
                    SpecializationLoaded(:final specializations) =>
                      QuickCategories(specializations: specializations),
                    SpecializationError(:final message) => ErrorSection(
                        message: message,
                        onRetry: () => context
                            .read<SpecializationCubit>()
                            .loadSpecializations(),
                      ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
              // Sprint 2 — C3: Nearby Medical Centers section.
              // Horizontal list of clinic cards. Handles all states:
              // Loading → skeleton, Loaded → cards, Empty → "Tidak ada
              // klinik", LocationDenied → "Izinkan Lokasi" button,
              // Error → retry button.
              BlocBuilder<NearbyCubit, NearbyState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: switch (state) {
                      NearbyInitial() => const NearbyFacilitiesLoading(),
                      NearbyLoading() => const NearbyFacilitiesLoading(),
                      NearbyLoaded(:final clinics) =>
                        NearbyFacilitiesLoaded(clinics: clinics),
                      NearbyEmpty() => const NearbyFacilitiesEmpty(),
                      NearbyLocationDenied(:final reason) =>
                        NearbyFacilitiesLocationDenied(reason: reason),
                      NearbyError(:final message) =>
                        NearbyFacilitiesError(message: message),
                    },
                  );
                },
              ),
            ],
            ),
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
