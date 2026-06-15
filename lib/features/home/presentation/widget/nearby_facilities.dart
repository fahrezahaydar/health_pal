import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../loc/domain/entity/clinic_entity.dart';
import '../bloc/nearby/nearby_cubit.dart';
import '../bloc/nearby/nearby_state.dart';

class NearbyFacilities extends StatelessWidget {
  const NearbyFacilities({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearbyCubit, NearbyState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: switch (state) {
            NearbyInitial() => _buildHeader(context, null, null),
            NearbyLoading() => _buildSkeleton(context),
            NearbyLoaded(:final clinics) => _buildLoaded(context, clinics),
            NearbyEmpty() => _buildEmpty(context),
            NearbyLocationDenied(:final reason) =>
              _buildPermissionDenied(context, reason),
            NearbyError(:final message) => _buildError(context, message),
          },
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    List<ClinicEntity>? clinics,
    Widget? inner,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Medical Centers',
                style: AppTextTheme.headlineSmall,
              ),
              GestureDetector(
                onTap: () {
                  // TODO: route to /facilities (Sprint 3 backlog per
                  // docs/progress/sprint_2_plan.md Lampiran B Day 6-8)
                },
                child: Text(
                  'See All',
                  style:
                      AppTextTheme.bodySmall.copyWith(color: AppTheme.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ?inner,
        ],
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, List<ClinicEntity> clinics) {
    return _buildHeader(
      context,
      clinics,
      SizedBox(
        height: 180,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: clinics.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) =>
              _NearbyCard(clinic: clinics[index]),
        ),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    // Sprint 2 — C1/C3: Skeletonizer reuse production widget pattern.
    // Render 3 mock cards that Skeletonizer transforms into bone placeholders.
    const skeletonClinics = [
      ClinicEntity(
        id: 'sk-1',
        name: 'Loading Clinic Name Placeholder',
        address: 'Loading address placeholder',
        latitude: 0,
        longitude: 0,
        distanceMeters: 1500,
        doctorCount: 5,
      ),
      ClinicEntity(
        id: 'sk-2',
        name: 'Loading Clinic Name Placeholder 2',
        address: 'Loading address placeholder 2',
        latitude: 0,
        longitude: 0,
        distanceMeters: 2500,
        doctorCount: 3,
      ),
      ClinicEntity(
        id: 'sk-3',
        name: 'Loading Clinic Name Placeholder 3',
        address: 'Loading address placeholder 3',
        latitude: 0,
        longitude: 0,
        distanceMeters: 3500,
        doctorCount: 8,
      ),
    ];
    return Skeletonizer(
      enabled: true,
      child: _buildHeader(context, skeletonClinics, null),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return _buildHeader(
      context,
      null,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Column(
          children: [
            // TODO: change to iconsax — currently Material fallback
            const Icon(Icons.location_off, size: 40, color: AppTheme.grey300),
            const SizedBox(height: 12),
            Text(
              'Tidak ada klinik di sekitar lokasi Anda.',
              style:
                  AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => context.read<NearbyCubit>().loadNearby(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Cari Lagi',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied(BuildContext context, String reason) {
    return _buildHeader(
      context,
      null,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Column(
          children: [
            // TODO: change to iconsax — currently Material fallback
            const Icon(Icons.location_disabled, size: 40, color: AppTheme.grey300),
            const SizedBox(height: 12),
            Text(
              reason,
              style:
                  AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => context.read<NearbyCubit>().loadNearby(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Izinkan Lokasi',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return _buildHeader(
      context,
      null,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Column(
          children: [
            // TODO: change to iconsax — currently Material fallback
            const Icon(Icons.error_outline, size: 40, color: AppTheme.grey300),
            const SizedBox(height: 12),
            Text(
              message,
              style:
                  AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => context.read<NearbyCubit>().loadNearby(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Coba Lagi',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyCard extends StatelessWidget {
  const _NearbyCard({required this.clinic});

  final ClinicEntity clinic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: route to /facilities/:id (Sprint 3 backlog per
        // docs/progress/sprint_2_plan.md Lampiran B Day 6-8)
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: clinic.imageUrl != null
                  ? Image.network(
                      clinic.imageUrl!,
                      width: 200,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          _buildPlaceholderImage(context),
                    )
                  : _buildPlaceholderImage(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: AppTextTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // TODO: change to iconsax — currently Material fallback
                        const Icon(Icons.location_on,
                            size: 14, color: AppTheme.grey400),
                        const SizedBox(width: 4),
                        Text(
                          clinic.distanceDisplay,
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppTheme.grey500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      clinic.doctorCountDisplay,
                      style: AppTextTheme.labelSmall.copyWith(
                        color: AppTheme.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      color: AppTheme.grey100,
      alignment: Alignment.center,
      child: const Icon(
        Icons.local_hospital,
        size: 32,
        color: AppTheme.grey400,
      ),
    );
  }
}
