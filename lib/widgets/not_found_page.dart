import 'package:flutter/widgets.dart';

import '../core/theme/app_text_theme.dart';
import '../core/theme/app_theme.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '404',
              style: AppTextTheme.headlineLarge.copyWith(
                color: AppTheme.grey400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'Page not found',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodySmall.copyWith(
                color: AppTheme.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
