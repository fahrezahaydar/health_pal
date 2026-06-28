import 'package:flutter/material.dart';
import 'package:health_pal/core/theme/app_icons.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/doctor/domain/entity/doctor_entity.dart';
import '../shared/app_network_image.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({super.key, required this.doctor, this.onMapTap});

  final DoctorEntity doctor;
  final VoidCallback? onMapTap;

  factory DoctorInfoCard.skeleton() =>
      DoctorInfoCard(doctor: DoctorEntity.mock());

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
        spacing: 16,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 96,
              height: 96,
              child: AppNetworkImage(
                imageUrl: doctor.photoUrl,
                iconData: Icons.person,
                iconSize: 32,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  doctor.fullName,
                  style: AppTextTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(thickness: 1, height: 1),
                Text(
                  doctor.specializationName,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.grey600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onMapTap,
                  child: Row(
                    spacing: 4,
                    children: [
                      const Icon(
                        AppIcons.locationOn,
                        size: 16,
                        color: AppTheme.grey500,
                      ),
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
