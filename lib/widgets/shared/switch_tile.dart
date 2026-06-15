import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A row with an icon, label, and a [Switch] toggle.
///
/// When [onChanged] is null the switch is disabled and an optional
/// [disabledHint] is shown below the label.
class SwitchTile extends StatelessWidget {
  const SwitchTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.disabledHint,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? disabledHint;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onChanged == null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.grey700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: isDisabled ? AppTheme.grey400 : AppTheme.grey900,
                  ),
                ),
                if (disabledHint != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    disabledHint!,
                    style: AppTextTheme.labelSmall
                        .copyWith(color: AppTheme.grey400),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}
