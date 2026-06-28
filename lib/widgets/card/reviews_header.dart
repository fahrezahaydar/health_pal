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
        Text('Reviews', style: AppTextTheme.headlineLarge),
        GestureDetector(
          onTap: null,
          child: Text(
            'See All',
            style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey400),
          ),
        ),
      ],
    );
  }
}
