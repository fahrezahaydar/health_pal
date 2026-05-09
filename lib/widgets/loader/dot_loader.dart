import 'dart:math';

import 'package:flutter/widgets.dart';

/// Contoh penggunaan:
/// DotLoader()
/// DotLoader(color: Colors.blue, size: 60, dotCount: 12)

class DotLoader extends StatefulWidget {
  final Color color;
  final double size;
  final int dotCount;
  final Duration duration;

  const DotLoader({
    super.key,
    this.color = const Color(0xFF2D2D2D),
    this.size = 80,
    this.dotCount = 12,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<DotLoader> createState() => _DotLoaderState();
}

class _DotLoaderState extends State<DotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _DotLoaderPainter(
              progress: _controller.value,
              color: widget.color,
              dotCount: widget.dotCount,
            ),
          );
        },
      ),
    );
  }
}

class _DotLoaderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int dotCount;

  _DotLoaderPainter({
    required this.progress,
    required this.color,
    required this.dotCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Dot size scales with overall size
    final dotRadius = size.width * 0.07;

    for (int i = 0; i < dotCount; i++) {
      // Angle: start from top (-π/2), go clockwise
      final angle = (2 * pi / dotCount) * i - pi / 2;

      // Each dot's position on the ring
      final dotCenter = Offset(
        center.dx + (radius - dotRadius - 2) * cos(angle),
        center.dy + (radius - dotRadius - 2) * sin(angle),
      );

      // Opacity: trailing dot is brightest (opacity=1),
      // dots further back fade out. The "active" dot leads the rotation.
      final activeDot = (progress * dotCount).floor() % dotCount;
      int delta = (i - activeDot + dotCount) % dotCount;

      // Fade: active dot = 1.0, oldest dot ≈ 0.08
      final opacity = 1.0 - (delta / dotCount) * 0.92;

      final paint = Paint()
        ..color = color.withValues(alpha: opacity.clamp(0.08, 1.0))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(dotCenter, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_DotLoaderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
