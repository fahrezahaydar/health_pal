import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.icon,
  });

  final double width;
  final double height;
  // TODO: change to iconsax — currently Material fallback (iconsax_latest suffix error-prone)
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppTheme.grey100,
      alignment: Alignment.center,
      child: Icon(
        icon ?? Icons.local_hospital,
        size: 32,
        color: AppTheme.grey400,
      ),
    );
  }
}
