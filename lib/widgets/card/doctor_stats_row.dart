import 'package:flutter/material.dart';
import 'package:health_pal/core/theme/app_icons.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/doctor/domain/entity/doctor_entity.dart';

class DoctorStatsRow extends StatelessWidget {
  const DoctorStatsRow({super.key, required this.doctor});

  final DoctorEntity doctor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        _StatItem(
          icon: AppIcons.profile2user,
          value: '${doctor.totalPatients}+',
          label: 'Patients',
        ),
        _StatItem(
          icon: AppIcons.medal,
          value: '${doctor.experienceYears}+',
          label: 'Experience',
        ),
        _StatItem(
          icon: AppIcons.starFilled,
          value: doctor.ratingDisplay,
          label: 'Rating',
        ),
        _StatItem(
          icon: AppIcons.messages,
          value: '${doctor.ratingCount}',
          label: 'Reviews',
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
          child: Icon(icon, size: 32, color: AppTheme.primary),
        ),
        Text(
          value,
          style: AppTextTheme.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
        ),
      ],
    );
  }
}
