import 'package:flutter/widgets.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.child,
    this.count,
    this.dot = false,
    this.color = const Color(0xFFE24B4A),
    this.textColor = const Color(0xFFFCEBEB),
    this.alignment = Alignment.topRight,
    this.maxCount = 99,
    this.visible = true,
  });

  final Widget child;
  final int? count;
  final bool dot;
  final Color color;
  final Color textColor;
  final Alignment alignment;
  final int maxCount;
  final bool visible;

  String get _label {
    if (count == null) return '';
    return count! > maxCount ? '$maxCount+' : '$count';
  }

  bool get _show => visible && (dot || (count != null && count! > 0));

  @override
  Widget build(BuildContext context) {
    if (!_show) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: alignment.y < 0 ? -4 : null,
          bottom: alignment.y > 0 ? -4 : null,
          left: alignment.x < 0 ? -4 : null,
          right: alignment.x > 0 ? -4 : null,
          child: dot ? _buildDot() : _buildPill(),
        ),
      ],
    );
  }

  Widget _buildDot() => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
    ),
    child: const SizedBox(width: 10, height: 10),
  );

  Widget _buildPill() => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: textColor,
          height: 1,
        ),
      ),
    ),
  );
}
