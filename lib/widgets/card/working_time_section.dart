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
      spacing: 8,
      children: [
        Text('Working Time', style: AppTextTheme.headlineLarge),
        Text(
          workingTimeDisplay ?? 'No schedule available',
          style: AppTextTheme.bodySmall.copyWith(
            fontStyle: workingTimeDisplay == null
                ? FontStyle.italic
                : FontStyle.normal,
            color: workingTimeDisplay == null
                ? AppTheme.grey400
                : AppTheme.grey500,
          ),
        ),
      ],
    );
  }
}
