import 'package:flutter/widgets.dart';
import 'package:health_pal/core/theme/app_theme.dart';

class LightOutlineButton extends StatefulWidget {
  const LightOutlineButton({
    super.key,
    required this.label,
    this.onTap,
    this.borderColor = AppTheme.grey200,
    this.textColor = AppTheme.primary,
    this.pressedColor,
    this.borderRadius = 8.0,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.fontSize = 14.0,
    this.animationDuration = const Duration(milliseconds: 120),
    this.icon,
  });

  final String label;
  final void Function()? onTap;

  /// Warna border & teks saat idle
  final Color borderColor;
  final Color textColor;

  /// Warna background saat ditekan
  final Color? pressedColor;

  final double borderRadius;
  final double borderWidth;
  final EdgeInsets padding;
  final double fontSize;
  final Duration animationDuration;

  /// Opsional: icon di sebelah kiri label
  final Widget? icon;

  @override
  State<LightOutlineButton> createState() => _LightOutlineButtonState();
}

class _LightOutlineButtonState extends State<LightOutlineButton> {
  bool _pressed = false;

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeOut,
        padding: widget.padding,
        height: 42,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _pressed
              ? widget.pressedColor ?? AppTheme.primary.withValues(alpha: 0.16)
              : const Color(0x00000000),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            if (widget.icon != null) ...[widget.icon!],
            Text(
              widget.label,
              style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
