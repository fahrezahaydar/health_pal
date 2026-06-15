import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A styled section label used as a heading above grouped settings/cards.
///
/// Renders [text] in uppercase-style with small font, grey color, and
/// letter-spacing.
class SectionLabel extends StatelessWidget {
  const SectionLabel({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: AppTextTheme.bodySmall.copyWith(
          color: AppTheme.grey600,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
