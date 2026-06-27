import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/doctor/domain/entity/doctor_entity.dart';
import '../shared/app_network_image.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({
    super.key,
    required this.doctor,
    this.onMapTap,
  });

  final DoctorEntity doctor;
  final VoidCallback? onMapTap;

  factory DoctorInfoCard.skeleton() => DoctorInfoCard(
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 96,
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: AppNetworkImage(
                  imageUrl: doctor.photoUrl,
                  iconData: Icons.person,
                  iconSize: 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 8),
                const Divider(thickness: 1, height: 1),
                const SizedBox(height: 8),
                Text(
                  doctor.specializationName,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.grey600,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onMapTap,
                  child: Row(
                    children: [
                      // TODO: change to iconsax — currently Material fallback
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppTheme.grey500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor.clinicName,
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppTheme.grey700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
