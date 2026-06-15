import 'package:flutter/material.dart';
import 'package:iconsax_latest/iconsax_latest.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A row used as a menu list tile.
///
/// Displays an [icon] on the left, a [label] in the middle, and a trailing
/// arrow icon. The entire tile is tappable via [onTap].
class MenuItemTile extends StatelessWidget {
  const MenuItemTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

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
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(Iconsax.arrowRight03, size: 18, color: AppTheme.grey400),
          ],
        ),
      ),
    );
  }
}
