import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/doctor/domain/entity/doctor_entity.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.name,
    required this.specialization,
    this.rating,
    this.fee,
    this.clinic,
    this.photoUrl,
    this.onTap,
  });

  final String name;
  final String specialization;
  final double? rating;
  final double? fee;
  final String? clinic;
  final String? photoUrl;
  final VoidCallback? onTap;

  factory DoctorCard.fromEntity(DoctorEntity entity, {VoidCallback? onTap}) {
    return DoctorCard(
      name: entity.fullName,
      specialization: entity.specializationName,
      rating: entity.ratingAvg,
      fee: entity.consultationFee,
      clinic: entity.clinicName,
      photoUrl: entity.photoUrl,
      onTap: onTap,
    );
  }

  factory DoctorCard.skeleton() => const DoctorCard(
        name: 'Loading...',
        specialization: 'Loading...',
        clinic: 'Loading...',
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.grey100,
                borderRadius: BorderRadius.circular(28),
              ),
              child: photoUrl != null
                  ? null
                  : const Icon(Icons.person, color: AppTheme.grey400, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(specialization, style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.grey500,
                  )),
                  if (clinic != null) ...[
                    const SizedBox(height: 2),
                    Text(clinic!, style: AppTextTheme.labelSmall.copyWith(
                      color: AppTheme.grey400,
                    )),
                  ],
                  if (fee != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${fee!.toStringAsFixed(0)}',
                      style: AppTextTheme.labelMedium.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (rating != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.paleGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 12, color: AppTheme.green),
                    const SizedBox(width: 2),
                    Text(
                      rating!.toStringAsFixed(1),
                      style: AppTextTheme.labelSmall.copyWith(
                        color: AppTheme.deepTeal,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
