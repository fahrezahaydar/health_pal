import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:health_pal/core/di/locator.dart';
import 'package:health_pal/core/services/app_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
import '../widget/upcoming_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final authId = getIt<SupabaseClient>().auth.currentUser?.id ?? '';
            return getIt<GreetingCubit>()..loadProfile(authId);
          },
        ),
        BlocProvider(create: (context) => getIt<BannerCubit>()..loadBanners()),
        BlocProvider(
          create: (context) =>
              getIt<SpecializationCubit>()..loadSpecializations(),
        ),
        BlocProvider(create: (context) => getIt<UpcomingCubit>()),
      ],
      child: const _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<GreetingCubit, GreetingState>(
          listener: (context, state) {
            if (state is GreetingLoaded) {
              if (state.profileId.isNotEmpty) {
                context.read<UpcomingCubit>().loadUpcoming(state.profileId);
              }
              // FIX-7: Guard profile completeness. Jika profile incomplete
              // (misalnya network failure fallback di FIX-2 atau server-side
              // change setelah sign-in), set status ke profileIncomplete.
              // Router Kondisi 3 akan redirect ke /sign-up/create-profile.
              // Idempotent: jika status sudah profileIncomplete, no-op.
              if (!state.isProfileComplete) {
                GetIt.instance<AppServices>().setProfileIncomplete();
              }
            }
          },
          child: ListView(
            children: [
              BlocSelector<GreetingCubit, GreetingState, String>(
                selector: (state) => switch (state) {
                  GreetingLoaded(:final nickname) => nickname,
                  _ => '',
                },
                builder: (context, nickname) {
                  return GreetingSection(nickname: nickname);
                },
              ),
              BlocSelector<BannerCubit, BannerState, List<BannerEntity>>(
                selector: (state) => switch (state) {
                  BannerLoaded(:final banners) => banners,
                  _ => const [],
                },
                builder: (context, banners) {
                  return BannerCarousel(banners: banners);
                },
              ),
              const SizedBox(height: 24),
              BlocSelector<UpcomingCubit, UpcomingState, UpcomingAppointmentEntity?>(
                selector: (state) => switch (state) {
                  UpcomingLoaded(:final upcoming) => upcoming,
                  _ => null,
                },
                builder: (context, upcoming) {
                  return UpcomingCard(upcoming: upcoming);
                },
              ),
              const SizedBox(height: 24),
              BlocSelector<SpecializationCubit, SpecializationState, List<SpecializationEntity>>(
                selector: (state) => switch (state) {
                  SpecializationLoaded(:final specializations) => specializations,
                  _ => const [],
                },
                builder: (context, specializations) {
                  return QuickCategories(specializations: specializations);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
