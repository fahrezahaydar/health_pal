import 'package:flutter/material.dart';
import 'package:health_pal/core/theme/app_text_theme.dart';
import 'package:health_pal/core/theme/app_theme.dart';
import 'package:health_pal/widgets/shared/app_divider.dart';

class LogOutBottomModal extends StatelessWidget {
  const LogOutBottomModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(
              'Log Out?',
              style: AppTextTheme.headlineLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const AppDivider(),

            Text(
              'Are you sure you want to log out from your account?',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
            ),

            const SizedBox.shrink(),

            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      backgroundColor: AppTheme.grey200,
                    ),

                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes, Logout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const LogOutBottomModal(),
    );

    return result ?? false;
  }
}
