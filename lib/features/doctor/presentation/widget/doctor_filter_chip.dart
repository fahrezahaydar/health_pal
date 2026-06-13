// lib/features/doctor/presentation/widget/doctor_filter_chip.dart
//
// Widget chip filter spesialisasi. Horizontal scrollable list.
// Dipakai di DoctorSearchPage.

import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

class DoctorFilterChip extends StatelessWidget {
  const DoctorFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.grey300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? AppTheme.white : AppTheme.grey500,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTextTheme.labelMedium.copyWith(
                color: isSelected ? AppTheme.white : AppTheme.grey700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
