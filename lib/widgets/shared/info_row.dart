import 'package:flutter/widgets.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A row displaying an [icon] followed by [text].
///
/// Used for metadata lines (e.g. date, location) inside cards.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.valueColor,
    this.iconSize = 14,
  });

  final IconData icon;
  final String text;
  final Color? valueColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: iconSize, color: AppTheme.grey500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: valueColor != null
                ? AppTextTheme.bodyMedium.copyWith(
                    color: valueColor, fontWeight: FontWeight.w600)
                : AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
          ),
        ),
      ],
    );
  }
}
