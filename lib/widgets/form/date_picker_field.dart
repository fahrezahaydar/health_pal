import 'package:flutter/material.dart';
import 'package:iconsax_latest/iconsax_latest.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A date picker field with label, calendar icon, and formatted value.
///
/// Renders [label] above a tappable container that displays [valueText].
/// Calls [onTap] when tapped, typically to show a date picker dialog.
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.label,
    required this.valueText,
    required this.onTap,
  });

  final String label;
  final String valueText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextTheme.bodyMedium),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.grey200),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.calendar, color: AppTheme.grey500),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    valueText,
                    style: AppTextTheme.bodyMedium,
                  ),
                ),
                const Icon(
                  Iconsax.arrowDown01,
                  color: AppTheme.grey400,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
