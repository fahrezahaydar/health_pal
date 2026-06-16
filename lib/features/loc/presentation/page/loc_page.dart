// lib/features/loc/presentation/page/loc_page.dart
//
// Halaman Loc (Nearby Clinics) — tab ke-3 bottom nav.
// Per wireframe 07-location-search.md.
// Pola: Stateless wrapper (BlocProvider) + Stateful view (logic + UI).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart' show getIt;
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/loader/error_section.dart';
import '../bloc/loc_cubit.dart';
import '../bloc/loc_state.dart';
import '../../domain/entity/clinic_entity.dart';
import '../widget/loc_map_widget.dart';
import '../../../../widgets/card/clinic_card.dart';

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
                      // TODO: change to iconsax — currently Material fallback
                      const Icon(Icons.arrow_drop_down,
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
              Skeletonizer(
                enabled: true,
                child: _loaded(
                  context,
                  ClinicEntity.mock(),
                  10,
                  Position(
                    latitude: -6.2088,
                    longitude: 106.8456,
                    accuracy: 0,
                    altitude: 0,
                    speed: 0,
                    speedAccuracy: 0,
                    heading: 0,
                    timestamp: DateTime(2026, 6, 16),
                    altitudeAccuracy: 0,
                    headingAccuracy: 0,
                  ),
                ),
              ),
            LocPermissionDenied(:final reason) =>
              _permissionDenied(context, reason),
            LocError(:final message) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: ErrorSection(
                  message: message,
                  onRetry: () =>
                      context.read<LocCubit>().requestLocationAndLoad(),
                ),
              ),
            LocLoaded(:final clinics, :final radiusKm, :final currentPosition) =>
              _loaded(context, clinics, radiusKm, currentPosition),
          };
        },
      ),
    );
  }

  static const _specializations = <String>[
    'Semua', 'Umum', 'Gigi', 'Kulit', 'Anak', 'Mata', 'THT', 'Jantung', 'Saraf',
  ];

  Widget _loaded(
    BuildContext context,
    List<ClinicEntity> clinics,
    double radiusKm,
    Position currentPosition,
  ) {
    if (clinics.isEmpty) {
      return _emptyState(context, radiusKm);
    }
    // Sprint 4 — S4.6: sort clinics based on sortBy state.
    final sorted = List<ClinicEntity>.of(clinics);
    final sortBy = context.read<LocCubit>().state is LocLoaded
        ? (context.read<LocCubit>().state as LocLoaded).sortBy
        : 'distance';
    switch (sortBy) {
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case 'doctor_count':
        sorted.sort((a, b) => b.doctorCount.compareTo(a.doctorCount));
      default:
        sorted.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    }
    return RefreshIndicator(
      onRefresh: () => context.read<LocCubit>().refresh(),
      child: CustomScrollView(
        slivers: [
          // Sprint 4.5 — M2+M3: Map View (40% screen height)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: LocMapWidget(
                  clinics: sorted,
                  userLat: currentPosition.latitude,
                  userLng: currentPosition.longitude,
                  radiusKm: radiusKm,
                  onMarkerTap: (clinic) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(clinic.name)),
                    );
                  },
                ),
              ),
            ),
          ),
          // Info banner
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppTheme.white,
              child: Text(
                '${clinics.length} klinik ditemukan dalam ${radiusKm.toStringAsFixed(0)} km',
                style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey700),
              ),
            ),
          ),
          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              color: AppTheme.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: BlocBuilder<LocCubit, LocState>(
                  buildWhen: (prev, curr) =>
                      curr is LocLoaded &&
                      (prev is! LocLoaded ||
                          prev.selectedSpecialization !=
                              curr.selectedSpecialization),
                  builder: (context, state) {
                    final selected = state is LocLoaded
                        ? state.selectedSpecialization
                        : null;
                    return Row(
                      children: _specializations.map((s) {
                        final isSelected = s == 'Semua'
                            ? selected == null
                            : selected == s;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(s),
                            selected: isSelected,
                            onSelected: (_) {
                              context.read<LocCubit>().setFilter(
                                    s == 'Semua' ? null : s,
                                  );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
          // Sort row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: BlocBuilder<LocCubit, LocState>(
                buildWhen: (prev, curr) =>
                    curr is LocLoaded &&
                    (prev is! LocLoaded || prev.sortBy != curr.sortBy),
                builder: (context, state) {
                  final sortBy = state is LocLoaded ? state.sortBy : 'distance';
                  return Row(
                    children: [
                      const Icon(Icons.sort, size: 16, color: AppTheme.grey500),
                      const SizedBox(width: 6),
                      ...['distance', 'name', 'doctor_count'].map((value) {
                        final label = switch (value) {
                          'distance' => 'Jarak',
                          'name' => 'Nama',
                          'doctor_count' => 'Dokter',
                          _ => value,
                        };
                        final isSelected = sortBy == value;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(label, style: const TextStyle(fontSize: 12)),
                            selected: isSelected,
                            onSelected: (_) =>
                                context.read<LocCubit>().setSortBy(value),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Clinic list
          SliverList.separated(
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final c = sorted[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClinicCard(clinic: c),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _permissionDenied(BuildContext context, String reason) {
    return SingleChildScrollView(
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
            // TODO: change to iconsax — currently Material fallback
            child: const Icon(
              Icons.location_disabled,
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
          const SizedBox(height: 32),
          // Sprint 4 — S4.4: City input fallback (wireframe 07).
          // Saat location denied, user bisa masukkan nama kota.
          // Full implementation (geocoding → filter clinics by city)
          // membutuhkan endpoint backend — deferred ke Sprint 5.
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('atau',
                    style: TextStyle(color: AppTheme.grey400)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          Text('Cari Klinik Berdasarkan Kota',
              style: AppTextTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Masukkan nama kota',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (city) {
              if (city.trim().isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mencari klinik di $city...'),
                  ),
                );
                // TODO: implementasi city-based search (Sprint 5+)
                // Butuh: geocoding API atau endpoint GET facilities?city=xxx
              }
            },
          ),
        ],
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
            // TODO: change to iconsax — currently Material fallback
            const Icon(Icons.local_hospital,
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
