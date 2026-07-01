import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

class AvatarInitials extends StatelessWidget {
  const AvatarInitials({
    super.key,
    required this.name,
    this.size = 42,
    this.backgroundColor,
    this.textStyle,
  });

  final String name;
  final double size;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Skeleton.ignore(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style:
              textStyle ??
              AppTextTheme.titleLarge.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
