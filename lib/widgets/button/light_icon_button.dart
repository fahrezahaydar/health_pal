import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_pal/core/theme/app_theme.dart';

class LightIconButton extends StatefulWidget {
  const LightIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.pressedColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(8),
    this.animationDuration = const Duration(milliseconds: 120),
  });

  final Widget icon;
  final void Function()? onTap;
  final Color? pressedColor;
  final double borderRadius;
  final EdgeInsets padding;
  final Duration animationDuration;

  @override
  State<LightIconButton> createState() => _LightIconButtonState();
}

class _LightIconButtonState extends State<LightIconButton> {
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
        decoration: BoxDecoration(
          color: _pressed
              ? widget.pressedColor ?? AppTheme.grey400
              : AppTheme.grey100,
          // borderRadius: BorderRadius.circular(widget.borderRadius),
          shape: BoxShape.circle,
        ),
        child: widget.icon,
      ),
    );
  }
}
