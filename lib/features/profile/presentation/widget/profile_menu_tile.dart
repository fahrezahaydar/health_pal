import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.grey700),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTextTheme.bodyLarge)),
            if (onTap != null)
              const Icon(
                AppIcons.arrowRight,
                size: 18,
                color: AppTheme.grey400,
              ),
          ],
        ),
      ),
    );
  }
}
