import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

class WorkingTimeSection extends StatelessWidget {
  const WorkingTimeSection({super.key, this.workingTimeDisplay});

  final String? workingTimeDisplay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Working Time', style: AppTextTheme.titleLarge),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.grey200),
          ),
          child: Text(
            workingTimeDisplay ?? 'No schedule available',
            style: AppTextTheme.bodySmall.copyWith(
              fontStyle: workingTimeDisplay == null
                  ? FontStyle.italic
                  : FontStyle.normal,
              color: workingTimeDisplay == null
                  ? AppTheme.grey400
                  : AppTheme.grey700,
            ),
          ),
        ),
      ],
    );
  }
}
