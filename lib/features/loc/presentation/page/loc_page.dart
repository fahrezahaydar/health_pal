// lib/features/loc/presentation/page/loc_page.dart
//
// Halaman Loc (Nearby Clinics) — tab ke-3 bottom nav.
// Per wireframe 07-location-search.md.
// Pola: Stateless wrapper (BlocProvider) + Stateful view (logic + UI).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_latest/iconsax_latest.dart';

import '../../../../core/di/locator.dart' show getIt;
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';
import '../bloc/loc_cubit.dart';
import '../bloc/loc_state.dart';
import '../widget/clinic_card.dart';

class LocPage extends StatelessWidget {
  const LocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocCubit>(
      create: (_) => getIt<LocCubit>()..requestLocationAndLoad(),
      child: const _LocView(),
    );
  }
}

class _LocView extends StatelessWidget {
  const _LocView();

  static const _radiusOptions = <double>[1, 3, 5, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text('Klinik Terdekat', style: AppTextTheme.titleLarge),
        actions: [
          BlocBuilder<LocCubit, LocState>(
            builder: (context, state) {
              if (state is! LocLoaded) return const SizedBox.shrink();
              return PopupMenuButton<double>(
                tooltip: 'Ubah radius',
                icon: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.paleBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${state.radiusKm.toStringAsFixed(0)} km',
                        style: AppTextTheme.labelSmall
                            .copyWith(color: AppTheme.blue, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Iconsax.arrowDown01,
                          size: 12, color: AppTheme.blue),
                    ],
                  ),
                ),
                onSelected: (km) =>
                    context.read<LocCubit>().changeRadius(km),
                itemBuilder: (_) => _radiusOptions
                    .map((km) => PopupMenuItem<double>(
                          value: km,
                          child: Text('$km km'),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<LocCubit, LocState>(
        builder: (context, state) {
          return switch (state) {
            LocInitial() ||
            LocLoading() =>
              const _LoadingView(),
            LocPermissionDenied(:final reason) =>
              _permissionDenied(context, reason),
            LocError(:final message) => _errorView(context, message),
            LocLoaded(:final clinics, :final radiusKm) =>
              _loaded(context, clinics, radiusKm),
          };
        },
      ),
    );
  }

  Widget _loaded(
    BuildContext context,
    List clinics,
    double radiusKm,
  ) {
    if (clinics.isEmpty) {
      return _emptyState(context, radiusKm);
    }
    return RefreshIndicator(
      onRefresh: () => context.read<LocCubit>().refresh(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppTheme.white,
            child: Text(
              '${clinics.length} klinik ditemukan dalam ${radiusKm.toStringAsFixed(0)} km',
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey700),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: clinics.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final c = clinics[i];
                return ClinicCard(clinic: c);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _permissionDenied(BuildContext context, String reason) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.lightPink,
              ),
              child: const Icon(
                Iconsax.locationCross,
                size: 60,
                color: AppTheme.darkRed,
              ),
            ),
            const SizedBox(height: 24),
            Text('Izin Lokasi Diperlukan',
                style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              reason,
              style: AppTextTheme.bodySmall
                  .copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: LightFilledButton(
                label: 'Izinkan Lokasi',
                onTap: () =>
                    context.read<LocCubit>().requestLocationAndLoad(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.warning2,
                size: 64, color: AppTheme.darkRed),
            const SizedBox(height: 16),
            Text('Gagal Memuat Klinik', style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextTheme.bodySmall
                  .copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () =>
                  context.read<LocCubit>().requestLocationAndLoad(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context, double radiusKm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.hospital,
                size: 80, color: AppTheme.grey300),
            const SizedBox(height: 16),
            Text('Tidak Ada Klinik',
                style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tidak ada klinik dalam radius ${radiusKm.toStringAsFixed(0)} km dari lokasimu. Coba perbesar radius.',
              style: AppTextTheme.bodySmall
                  .copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () =>
                  context.read<LocCubit>().requestLocationAndLoad(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
