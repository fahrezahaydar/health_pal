import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../loc/domain/entity/clinic_entity.dart';
import '../bloc/nearby/nearby_cubit.dart';

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nearby Medical Centers', style: AppTextTheme.headlineSmall),
              GestureDetector(
                onTap: () {
                  // TODO: route to /facilities (Sprint 3)
                },
                child: Text(
                  'See All',
                  style: AppTextTheme.bodySmall.copyWith(color: AppTheme.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class NearbyFacilitiesLoaded extends StatelessWidget {
  final List<ClinicEntity> clinics;

  const NearbyFacilitiesLoaded({super.key, required this.clinics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeaderTitle(),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: clinics.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _NearbyCard(clinic: clinics[index]),
          ),
        ),
      ],
    );
  }
}

class NearbyFacilitiesLoading extends StatelessWidget {
  const NearbyFacilitiesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: NearbyFacilitiesLoaded(clinics: ClinicEntity.mock()),
    );
  }
}

class NearbyFacilitiesEmpty extends StatelessWidget {
  const NearbyFacilitiesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderTitle(),
        _StatusBody(
          // TODO: change to iconsax — currently Material fallback
          icon: Icons.location_off,
          message: 'Tidak ada klinik di sekitar lokasi Anda.',
          buttonLabel: 'Cari Lagi',
        ),
      ],
    );
  }
}

class NearbyFacilitiesLocationDenied extends StatelessWidget {
  final String reason;

  const NearbyFacilitiesLocationDenied({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeaderTitle(),
        _StatusBody(
          // TODO: change to iconsax — currently Material fallback
          icon: Icons.location_disabled,
          message: reason,
          buttonLabel: 'Izinkan Lokasi',
        ),
      ],
    );
  }
}

class NearbyFacilitiesError extends StatelessWidget {
  final String message;

  const NearbyFacilitiesError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeaderTitle(),
        _StatusBody(
          // TODO: change to iconsax — currently Material fallback
          icon: Icons.error_outline,
          message: message,
          buttonLabel: 'Coba Lagi',
        ),
      ],
    );
  }
}

class _StatusBody extends StatelessWidget {
  final IconData icon;
  final String message;
  final String buttonLabel;

  const _StatusBody({
    required this.icon,
    required this.message,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppTheme.grey300),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => context.read<NearbyCubit>().loadNearby(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  buttonLabel,
                  style: AppTextTheme.bodySmall.copyWith(color: AppTheme.white),
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
  final ClinicEntity clinic;

  const _NearbyCard({required this.clinic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: route to /facilities/:id (Sprint 3)
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: clinic.imageUrl != null
                  ? Image.network(
                      clinic.imageUrl!,
                      width: 200,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _PlaceholderImage(),
                    )
                  : const _PlaceholderImage(),
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
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppTheme.grey400,
                        ),
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
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
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
