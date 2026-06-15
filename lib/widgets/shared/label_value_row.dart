import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A row displaying an icon, a [label], and an optional [value].
///
/// Renders as `[icon] [label]: [value]`. Useful for info detail cards
/// (e.g. education, experience, clinic name).
class LabelValueRow extends StatelessWidget {
  const LabelValueRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.grey500),
        const SizedBox(width: 8),
        Text('$label: ',
            style: AppTextTheme.bodyMedium.copyWith(color: AppTheme.grey700)),
        if (value != null && value!.isNotEmpty)
          Expanded(
            child: Text(
              value!,
              style: AppTextTheme.bodyMedium
                  .copyWith(color: valueColor ?? AppTheme.grey900),
            ),
          ),
      ],
    );
  }
}
