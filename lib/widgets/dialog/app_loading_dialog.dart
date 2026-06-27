import 'package:flutter/widgets.dart'; // Menggunakan widgets.dart saja

import '../../core/theme/app_theme.dart';
import '../loader/dot_loader.dart';

class AppLoadingDialog extends StatelessWidget {
  const AppLoadingDialog({super.key});

  static bool isShow = false;

  static Future<void> show(BuildContext context) async {
    if (isShow) return;

    isShow = true;

    // showGeneralDialog lebih rendah levelnya dibanding showDialog (Material)
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Loading',
      barrierColor: const Color(0x80000000), // Warna overlay (hitam transparan)
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
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
    // Kita mengganti Dialog (Material) dengan susunan Widget dasar
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF), // Manual hex untuk putih
          borderRadius: BorderRadius.circular(16),
          // Opsional: tambahkan bayangan karena Dialog material punya elevation bawaan
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const DotLoader(size: 56, color: AppTheme.grey800),
      ),
    );
  }
}
