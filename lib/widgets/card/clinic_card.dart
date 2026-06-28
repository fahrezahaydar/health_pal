import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    this.width = 240,
    this.isSelected = false,
  });

  final ClinicEntity clinic;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final double width;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Skeleton.unite(
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.blue : AppTheme.grey200,
              width: isSelected ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 2,
                    child: clinic.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: clinic.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, _) =>
                                const PlaceholderImage(height: 160),
                            errorWidget: (_, _, _) =>
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      clinic.name,
                      style: AppTextTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(
                          AppIcons.location,
                          size: 14,
                          color: AppTheme.grey400,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            clinic.address,
                            style: AppTextTheme.bodySmall.copyWith(
                              fontSize: 12,
                              color: AppTheme.grey500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    _RatingRow(
                      ratingAvg: clinic.ratingAvg,
                      reviewCount: clinic.reviewCount,
                    ),
                    const Divider(height: 1, color: AppTheme.grey200),
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
        ? '($reviewCount Review)'
        : '($reviewCount Reviews)';
    return Row(
      spacing: 4,
      children: [
        Text(
          ratingDisplay,
          style: AppTextTheme.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.grey900,
            fontSize: 12,
          ),
        ),
        Wrap(
          spacing: -2,
          children: List.generate(5, (i) {
            return Icon(
              i < ratingAvg.round() ? Icons.star : Icons.star_border,
              size: 14,
              color: Colors.amber,
            );
          }),
        ),
        Text(
          reviewText,
          style: AppTextTheme.bodySmall.copyWith(
            color: AppTheme.grey500,
            fontSize: 12,
          ),
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
      spacing: 4,
      children: [
        const Icon(AppIcons.myLocation, size: 14, color: AppTheme.grey500),
        Text(
          '$distanceDisplay / $durationDisplay',
          style: AppTextTheme.bodySmall.copyWith(
            color: AppTheme.grey500,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        if (category != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              const Icon(
                Icons.local_hospital,
                size: 12,
                color: AppTheme.grey500,
              ),
              Text(
                category!,
                style: AppTextTheme.bodySmall.copyWith(
                  color: AppTheme.grey500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
