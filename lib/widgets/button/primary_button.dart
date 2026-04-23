import 'package:flutter/widgets.dart';
import 'package:health_pal/core/theme/app_theme.dart';

class LightFilledButton extends StatefulWidget {
  const LightFilledButton({
    super.key,
    required this.label,
    required this.onTap,
    this.backgroundColor = AppTheme.primary,
    this.pressedColor,
    this.textColor = AppTheme.onPrimary,
    this.borderRadius = 42,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.fontSize = 14.0,
    this.animationDuration = const Duration(milliseconds: 120),
    this.icon,
    this.disabled = false,
    this.disabledColor = const Color(0xFFD1D5DB),
    this.disabledTextColor = const Color(0xFF9CA3AF),
    this.elevation = 0.0,
    this.shadowColor = const Color(0x33000000),
  });

  final String label;
  final VoidCallback onTap;

  final Color backgroundColor;

  /// Warna saat ditekan (biasanya sedikit lebih gelap / terang dari [backgroundColor])
  final Color? pressedColor;
  final Color textColor;

  final double borderRadius;
  final EdgeInsets padding;
  final double fontSize;
  final Duration animationDuration;

  /// Opsional: icon di sebelah kiri label
  final Widget? icon;

  /// Nonaktifkan button
  final bool disabled;
  final Color disabledColor;
  final Color disabledTextColor;

  /// Shadow opsional — default 0 (flat)
  final double elevation;
  final Color shadowColor;

  @override
  State<LightFilledButton> createState() => _LightFilledButtonState();
}

class _LightFilledButtonState extends State<LightFilledButton> {
  bool _pressed = false;

  void _onTapDown(_) {
    if (!widget.disabled) setState(() => _pressed = true);
  }

  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  Color get _bgColor {
    if (widget.disabled) return widget.disabledColor;
    return _pressed
        ? widget.pressedColor ?? AppTheme.deepTeal
        : widget.backgroundColor;
  }

  Color get _fgColor =>
      widget.disabled ? widget.disabledTextColor : widget.textColor;

  @override
  Widget build(BuildContext context) {
    final icon = widget.icon;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.disabled ? null : widget.onTap,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeOut,
        padding: widget.padding,
        height: 48,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: widget.elevation > 0 && !widget.disabled
              ? [
                  BoxShadow(
                    color: widget.shadowColor,
                    blurRadius: widget.elevation * 2,
                    offset: Offset(0, widget.elevation),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: .min,
          spacing: 8,
          children: [
            ?icon,
            Text(
              widget.label,
              style: TextStyle(
                color: _fgColor,
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
