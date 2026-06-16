import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/doctor/domain/entity/doctor_entity.dart';

class DoctorCardDetail extends StatelessWidget {
  const DoctorCardDetail({
    super.key,
    required this.doctor,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  final DoctorEntity doctor;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  factory DoctorCardDetail.skeleton() => DoctorCardDetail(
        doctor: DoctorEntity.mock(),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.grey100,
              borderRadius: BorderRadius.circular(40),
            ),
            child: doctor.photoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      doctor.photoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(
                        Icons.person,
                        color: AppTheme.grey400,
                        size: 40,
                      ),
                    ),
                  )
                : const Icon(Icons.person, color: AppTheme.grey400, size: 40),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.fullName,
                  style: AppTextTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specializationName,
                  style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (doctor.ratingCount > 0) ...[
                      const Icon(Icons.star,
                          size: 14, color: AppTheme.green),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.ratingDisplay} (${doctor.ratingCount})',
                        style: AppTextTheme.labelSmall
                            .copyWith(color: AppTheme.deepTeal),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (doctor.experienceYears > 0) ...[
                      const Icon(Icons.work_outline,
                          size: 12, color: AppTheme.grey400),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.experienceYears} tahun',
                        style: AppTextTheme.labelSmall
                            .copyWith(color: AppTheme.grey500),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.clinicName,
                  style:
                      AppTextTheme.labelSmall.copyWith(color: AppTheme.grey500),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppTheme.darkRed : AppTheme.grey400,
            ),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}
