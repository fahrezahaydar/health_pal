import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// A themed horizontal divider with [AppTheme.grey200] color.
///
/// Thin 1px line used to separate menu items in lists.
class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppTheme.grey200);
  }
}
