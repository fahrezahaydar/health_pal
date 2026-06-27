import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

class ReviewsHeader extends StatelessWidget {
  const ReviewsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Reviews', style: AppTextTheme.titleLarge),
        TextButton(
          onPressed: null,
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.grey400,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text('See All'),
        ),
      ],
    );
  }
}
