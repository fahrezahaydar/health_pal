import 'dart:async';
import 'package:health_pal/core/theme/app_icons.dart';

import 'package:flutter/widgets.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../button/outline_button.dart';
import '../button/primary_button.dart';
import '../loader/dot_loader.dart';

enum AppDialogType { success, error, warning, info }

class AppCustomDialog extends StatelessWidget {
  const AppCustomDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    this.showLoader = false,
    this.submitText,
    this.cancelText,
    this.onSubmit,
    this.onCancel,
  });

  final String title;
  final String subtitle;

  final Widget icon;
  final Color iconBackgroundColor;

  final bool showLoader;

  final String? submitText;
  final String? cancelText;

  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;

  static bool isShow = false;

  // ---------------------------------------------------------------------------
  // SHOW
  // ---------------------------------------------------------------------------

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    AppDialogType type = AppDialogType.success,
    Widget? icon,
    Color? iconBackgroundColor,
    bool showLoader = false,
    String? submitText,
    String? cancelText,
    VoidCallback? onSubmit,
    VoidCallback? onCancel,
    Duration autoDismissDuration = const Duration(seconds: 2),
    bool barrierDismissible = false,
  }) async {
    if (isShow) return;

    isShow = true;

    final hasAction = onSubmit != null || onCancel != null;

    final resolvedData = _resolveType(
      type: type,
      customIcon: icon,
      customColor: iconBackgroundColor,
    );

    Timer? autoDismissTimer;

    if (!hasAction) {
      autoDismissTimer = Timer(autoDismissDuration, () {
        if (isShow && context.mounted) {
          dismiss(context);
        }
      });
    }

    await showGeneralDialog(
      context: context,
      barrierDismissible: hasAction ? barrierDismissible : false,
      barrierLabel: 'Dialog',
      barrierColor: const Color(0x80000000),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return PopScope(
          canPop: !hasAction,
          child: AppCustomDialog(
            title: title,
            subtitle: subtitle,
            icon: resolvedData.icon,
            iconBackgroundColor: resolvedData.backgroundColor,
            showLoader: showLoader,
            submitText: submitText,
            cancelText: cancelText,
            onSubmit: onSubmit,
            onCancel: onCancel,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
            child: child,
          ),
        );
      },
    ).then((_) {
      autoDismissTimer?.cancel();
      isShow = false;
    });
  }

  // ---------------------------------------------------------------------------
  // DISMISS
  // ---------------------------------------------------------------------------

  static Future<void> dismiss(BuildContext context) async {
    if (!isShow) return;

    Navigator.of(context, rootNavigator: true).pop();

    isShow = false;
  }

  // ---------------------------------------------------------------------------
  // TYPE RESOLVER
  // ---------------------------------------------------------------------------

  static _DialogVisualData _resolveType({
    required AppDialogType type,
    Widget? customIcon,
    Color? customColor,
  }) {
    if (customIcon != null && customColor != null) {
      return _DialogVisualData(icon: customIcon, backgroundColor: customColor);
    }

    switch (type) {
      case AppDialogType.success:
        return const _DialogVisualData(
          icon: Icon(
            AppIcons.shieldTick,
            size: 72,
            color: Color(0xFF1B5E20),
          ),
          backgroundColor: Color(0xFFA5D6A7),
        );

      case AppDialogType.error:
        return const _DialogVisualData(
          icon: Icon(
            AppIcons.closeCircle,
            size: 72,
            color: Color(0xFFB71C1C),
          ),
          backgroundColor: Color(0xFFFFCDD2),
        );

      case AppDialogType.warning:
        return const _DialogVisualData(
          icon: Icon(
            AppIcons.warning2,
            size: 72,
            color: Color(0xFFE65100),
          ),
          backgroundColor: Color(0xFFFFE0B2),
        );

      case AppDialogType.info:
        return const _DialogVisualData(
          icon: Icon(
            AppIcons.infoCircle,
            size: 72,
            color: Color(0xFF0D47A1),
          ),
          backgroundColor: Color(0xFFBBDEFB),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final hasSubmit = onSubmit != null;
    final hasCancel = onCancel != null;

    return Center(
      child: Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 32,
          children: [
            // -----------------------------------------------------------------
            // ICON
            // -----------------------------------------------------------------
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
              ),
              alignment: Alignment.center,
              child: icon,
            ),

            // -----------------------------------------------------------------
            // TITLE
            // -----------------------------------------------------------------
            Column(
              spacing: 16,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.headlineLarge.copyWith(
                    color: AppTheme.primary,
                  ),
                ),
                // -----------------------------------------------------------------
                // SUBTITLE
                // -----------------------------------------------------------------
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.grey500,
                    height: 1,
                  ),
                ),
              ],
            ),

            // -----------------------------------------------------------------
            // LOADER
            // -----------------------------------------------------------------
            if (showLoader) const DotLoader(),

            // -----------------------------------------------------------------
            // ACTIONS
            // -----------------------------------------------------------------
            if (hasSubmit || hasCancel) ...[
              Row(
                children: [
                  if (hasCancel)
                    LightOutlineButton(
                      label: cancelText ?? 'Cancel',
                      onTap: onCancel,
                    ),

                  if (hasSubmit)
                    LightFilledButton(
                      label: submitText ?? 'Submit',
                      onTap: onSubmit,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PRIVATE MODEL
// -----------------------------------------------------------------------------

class _DialogVisualData {
  const _DialogVisualData({required this.icon, required this.backgroundColor});

  final Widget icon;
  final Color backgroundColor;
}
