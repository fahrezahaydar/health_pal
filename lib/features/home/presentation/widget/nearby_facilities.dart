import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/card/nearby_clinic_card.dart';
import '../../../../widgets/layouts/header_title.dart';
import '../../../loc/domain/entity/clinic_entity.dart';
import '../bloc/nearby/nearby_cubit.dart';

class NearbyFacilitiesLoaded extends StatelessWidget {
  final List<ClinicEntity> clinics;

  const NearbyFacilitiesLoaded({super.key, required this.clinics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderTitle(title: 'Nearby Medical Centers'),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: clinics.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                NearbyClinicCard.fromEntity(clinics[index]),
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
        HeaderTitle(title: 'Nearby Medical Centers'),
        _StatusBody(
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
        const HeaderTitle(title: 'Nearby Medical Centers'),
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
        const HeaderTitle(title: 'Nearby Medical Centers'),
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

