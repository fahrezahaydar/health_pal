import 'package:flutter/widgets.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    super.key,
    required this.title,
    this.onTap,
    this.onTapMessage = '',
  });
  final String title;
  final void Function()? onTap;
  final String onTapMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextTheme.headlineSmall),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              onTapMessage,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.blue),
            ),
          ),
      ],
    );
  }
}
