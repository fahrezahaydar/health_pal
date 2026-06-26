import 'package:flutter/material.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/loc/domain/entity/clinic_entity.dart';
import '../shared/placeholder_image.dart';

class ClinicCard extends StatelessWidget {
  const ClinicCard({
    super.key,
    required this.clinic,
    this.onTap,
    this.onFavoriteTap,
  });

  final ClinicEntity clinic;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(11),
                  ),
                  child: clinic.imageUrl != null
                      ? Image.network(
                          clinic.imageUrl!,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const PlaceholderImage(height: 160),
                        )
                      : const PlaceholderImage(height: 160),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      clinic.isFavorite
                          // TODO: change to iconsax — currently Material fallback
                    ? Icons.favorite
                          : Icons.favorite_border,
                      color: clinic.isFavorite
                          ? AppTheme.darkRed
                          : AppTheme.white,
                      size: 24,
                    ),
                    onPressed: onFavoriteTap,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinic.name,
                    style: AppTextTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(AppIcons.location,
                          size: 14, color: AppTheme.grey400),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          clinic.address,
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppTheme.grey500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _RatingRow(
                    ratingAvg: clinic.ratingAvg,
                    reviewCount: clinic.reviewCount,
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: AppTheme.grey200),
                  const SizedBox(height: 8),
                  _BottomInfoRow(
                    distanceDisplay: clinic.distanceDisplay,
                    durationDisplay: clinic.durationDisplay,
                    category: clinic.category,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.ratingAvg, required this.reviewCount});

  final double ratingAvg;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final ratingDisplay = ratingAvg.toStringAsFixed(1);
    final reviewText = reviewCount == 1
        ? '$reviewCount Review'
        : '$reviewCount Reviews';
    return Row(
      children: [
        Text(
          ratingDisplay,
          style: AppTextTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.grey900,
          ),
        ),
        const SizedBox(width: 4),
        ...List.generate(5, (i) {
          // TODO: change to iconsax — currently Material fallback
          return Icon(
            i < ratingAvg.round() ? Icons.star : Icons.star_border,
            size: 14,
            color: Colors.amber,
          );
        }),
        const SizedBox(width: 4),
        Text(
          reviewText,
          style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
        ),
      ],
    );
  }
}

class _BottomInfoRow extends StatelessWidget {
  const _BottomInfoRow({
    required this.distanceDisplay,
    required this.durationDisplay,
    required this.category,
  });

  final String distanceDisplay;
  final String durationDisplay;
  final String? category;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(AppIcons.myLocation, size: 14, color: AppTheme.grey500),
        const SizedBox(width: 4),
        Text(
          '$distanceDisplay / $durationDisplay',
          style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey700),
        ),
        const Spacer(),
        if (category != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.paleBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO: change to iconsax — currently Material fallback
                const Icon(
                  Icons.local_hospital,
                  size: 12,
                  color: AppTheme.blue,
                ),
                const SizedBox(width: 4),
                Text(
                  category!,
                  style: AppTextTheme.labelSmall.copyWith(
                    color: AppTheme.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
