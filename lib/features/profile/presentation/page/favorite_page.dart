// lib/features/profile/presentation/page/favorite_page.dart
//
// Halaman Favorite Doctors. Placeholder v1.1 (Fase 8 task 8.13) — backend
// favorites table belum ada, jadi cubit selalu return empty list.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_latest/iconsax_latest.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
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
            icon: const Icon(Iconsax.arrowLeft01, color: AppTheme.grey900),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Favorite', style: AppTextTheme.titleLarge),
        ),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            return switch (state) {
              FavoriteInitial() || FavoriteLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              FavoriteLoaded(:final doctors) when doctors.isEmpty =>
                _emptyState(),
              FavoriteLoaded(:final doctors) => _list(doctors),
              FavoriteError(:final message) => _errorState(context, message),
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
      itemBuilder: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.heart, size: 80, color: AppTheme.grey300),
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

  Widget _errorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.warning2, size: 64, color: AppTheme.darkRed),
            const SizedBox(height: 16),
            Text('Gagal memuat favorit', style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.read<FavoriteCubit>().loadFavorites(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
