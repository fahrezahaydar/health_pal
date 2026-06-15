import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// A white rounded card container with a grey border.
///
/// Used as a wrapper around grouped settings items or menu lists.
class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Column(children: children),
    );
  }
}
