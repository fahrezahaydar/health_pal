import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_theme.dart';

class LogoutMenuTile extends StatelessWidget {
  const LogoutMenuTile({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(AppIcons.logout, size: 20, color: AppTheme.darkRed),
            SizedBox(width: 12),
            Text(
              'Log Out',
              style: TextStyle(
                color: AppTheme.darkRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
