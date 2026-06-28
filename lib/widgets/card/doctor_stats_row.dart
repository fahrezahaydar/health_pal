import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/doctor/domain/entity/doctor_entity.dart';

class DoctorStatsRow extends StatelessWidget {
  const DoctorStatsRow({super.key, required this.doctor});

  final DoctorEntity doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              // TODO: change to iconsax — currently Material fallback
              icon: Icons.people,
              value: '${doctor.totalPatients}+',
              label: 'Patients',
            ),
          ),
          Expanded(
            child: _StatItem(
              // TODO: change to iconsax — currently Material fallback
              icon: Icons.work_history,
              value: '${doctor.experienceYears}+',
              label: 'Experience',
            ),
          ),
          Expanded(
            child: _StatItem(
              // TODO: change to iconsax — currently Material fallback
              icon: Icons.star,
              value: doctor.ratingDisplay,
              label: 'Rating',
            ),
          ),
          Expanded(
            child: _StatItem(
              // TODO: change to iconsax — currently Material fallback
              icon: Icons.chat_bubble_outline,
              value: '${doctor.ratingCount}',
              label: 'Reviews',
            ),
          ),
        ],
      ),
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
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
          child: Icon(icon, size: 18, color: AppTheme.primary),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextTheme.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextTheme.bodySmall.copyWith(
            color: AppTheme.grey500,
          ),
        ),
      ],
    );
  }
}
