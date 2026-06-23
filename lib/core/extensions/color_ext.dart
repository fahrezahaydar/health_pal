import 'package:flutter/material.dart';

extension HexColor on String {
  Color? toColor() {
    final h = replaceFirst('#', '');
    if (h.length != 6 && h.length != 8) return null;
    final v = int.tryParse(h, radix: 16);
    if (v == null) return null;
    if (h.length == 6) return Color(0xFF000000 | v);
    return Color(v);
  }
}
