import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Skeleton.unite(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            spacing: 12,
            children: [
              Icon(icon, size: 24, color: AppTheme.grey700),
              Expanded(child: Text(label, style: AppTextTheme.bodyLarge)),
              if (onTap != null)
                const Icon(
                  AppIcons.chevronRight,
                  size: 16,
                  color: AppTheme.grey400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
