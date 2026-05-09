import 'package:flutter/material.dart';

import '../loader/dot_loader.dart';

class AppLoadingDialog extends StatelessWidget {
  const AppLoadingDialog({super.key});

  static bool isShow = false;

  static Future<void> show(BuildContext context) async {
    if (isShow) return;

    isShow = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return const PopScope(canPop: false, child: AppLoadingDialog());
      },
    ).then((_) {
      isShow = false;
    });
  }

  static Future<void> dismiss(BuildContext context) async {
    if (!isShow) return;

    Navigator.of(context, rootNavigator: true).pop();

    isShow = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: DotLoader(size: 56, color: Color(0xFF1F2A37)),
        ),
      ),
    );
  }
}
