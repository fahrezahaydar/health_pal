import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../button/primary_button.dart';
import '../button/outline_button.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Ya',
    this.cancelLabel = 'Batal',
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Ya',
    String cancelLabel = 'Batal',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: AppTextTheme.headlineSmall),
      content: Text(message, style: AppTextTheme.bodySmall),
      actions: [
        LightOutlineButton(
          onTap: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
          label: cancelLabel,
        ),
        LightFilledButton(
          onTap: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          label: confirmLabel,
        ),
      ],
    );
  }
}
