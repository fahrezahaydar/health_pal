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
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.grey400),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
