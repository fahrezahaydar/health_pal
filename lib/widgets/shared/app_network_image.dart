import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.iconSize,
    this.iconData,
    this.backgroundColor,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? borderRadius;
  final double? iconSize;
  final IconData? iconData;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius != null
          ? BorderRadius.circular(borderRadius!)
          : BorderRadius.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                placeholder: (_, _) => _buildPlaceholder(context),
                errorWidget: (_, _, _) => _buildFallback(context),
              )
            : _buildFallback(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppTheme.grey100,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.grey400,
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppTheme.grey100,
      alignment: Alignment.center,
      child: Icon(
        iconData ?? Icons.person,
        size: iconSize ?? 28,
        color: AppTheme.grey400,
      ),
    );
  }
}
