import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

class LogoutMenuTile extends StatelessWidget {
  const LogoutMenuTile({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          spacing: 12,
          children: [
            const Icon(AppIcons.logout, size: 24, color: AppTheme.darkRed),
            Text(
              'Log Out',
              style: AppTextTheme.bodyLarge.copyWith(color: AppTheme.darkRed),
            ),
          ],
        ),
      ),
    );
  }
}
