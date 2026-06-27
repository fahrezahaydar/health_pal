// lib/features/profile/presentation/page/favorite_page.dart
//
// Halaman Favorite Doctors. Placeholder v1.1 (Fase 8 task 8.13) — backend
// favorites table belum ada, jadi cubit selalu return empty list.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/card/doctor_card.dart';
import '../../../../widgets/loader/error_section.dart';
import '../bloc/favorite/favorite_cubit.dart';
import '../bloc/favorite/favorite_state.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteCubit>(
      create: (_) => getIt<FavoriteCubit>()..loadFavorites(),
      child: Scaffold(
        backgroundColor: AppTheme.grey50,
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(AppIcons.arrowBack, color: AppTheme.grey900),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Favorite', style: AppTextTheme.titleLarge),
        ),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            return switch (state) {
              FavoriteInitial() || FavoriteLoading() => const Skeletonizer(
                enabled: true,
                child: _FavSkeletonContent(),
              ),
              FavoriteLoaded(:final doctors) when doctors.isEmpty =>
                _emptyState(),
              FavoriteLoaded(:final doctors) => _list(doctors),
              FavoriteError(:final message) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: ErrorSection(
                  message: message,
                  onRetry: () => context.read<FavoriteCubit>().loadFavorites(),
                ),
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _list(List doctors) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: doctors.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final d = doctors[index];
        return DoctorCard(
          name: d.fullName,
          specialization: d.specializationName,
          rating: d.ratingAvg,
          reviewCount: d.ratingCount,
          clinic: d.clinicName,
          photoUrl: d.photoUrl,
          isFavorite: true,
          onTap: () => context.push(
            RoutePaths.doctorDetail.replaceAll(':doctorId', d.id),
          ),
        );
      },
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.favorite, size: 80, color: AppTheme.grey300),
            const SizedBox(height: 16),
            Text('Belum ada dokter favorit', style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tambahkan dokter ke favorit untuk akses cepat',
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavSkeletonContent extends StatelessWidget {
  const _FavSkeletonContent();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const DoctorCard(
        name: 'Loading Doctor',
        specialization: 'Loading Spec',
        clinic: 'Loading Clinic',
      ),
    );
  }
}
