import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A contact info card with an icon, label, value, and trailing arrow.
///
/// Tapping the card triggers [onTap], typically to launch a URL.
class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextTheme.labelSmall
                        .copyWith(color: AppTheme.grey500),
                  ),
                  const SizedBox(height: 2),
                  Text(value, style: AppTextTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(AppIcons.arrowRight03, color: AppTheme.grey400, size: 18),
          ],
        ),
      ),
    );
  }
}
