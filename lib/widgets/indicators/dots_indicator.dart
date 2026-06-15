import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

/// A row of dots used as a page/carousel indicator.
///
/// Renders [count] dots with [currentIndex] highlighted using the primary
/// color. The active dot is wider (24px) than inactive dots (8px).
class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == currentIndex ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == currentIndex ? AppTheme.primary : AppTheme.grey300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
