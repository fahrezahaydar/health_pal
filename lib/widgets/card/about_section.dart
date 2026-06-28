import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key, this.description});

  final String? description;

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  @override
  Widget build(BuildContext context) {
    final desc = widget.description;
    if (desc == null || desc.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text('About Me', style: AppTextTheme.headlineLarge),
        ReadMoreText(
          desc,
          trimMode: TrimMode.Line,
          trimLines: 3,
          trimCollapsedText: ' View More',
          trimExpandedText: ' View Less',
          style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),

          moreStyle: AppTextTheme.bodySmall.copyWith(
            color: AppTheme.grey900,
            fontWeight: FontWeight.w600,
          ),
          lessStyle: AppTextTheme.bodySmall.copyWith(
            color: AppTheme.grey900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
