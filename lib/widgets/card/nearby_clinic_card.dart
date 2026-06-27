import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/loc/domain/entity/clinic_entity.dart';
import '../shared/placeholder_image.dart';

class NearbyClinicCard extends StatelessWidget {
  const NearbyClinicCard({
    super.key,
    this.name,
    this.imageUrl,
    this.distanceDisplay,
    this.durationDisplay,
    this.ratingAvg,
    this.reviewCountDisplay,
    this.category,
    this.onTap,
    this.width = 256,
  });

  final String? name;
  final String? imageUrl;
  final String? distanceDisplay;
  final String? durationDisplay;
  final double? ratingAvg;
  final String? reviewCountDisplay;
  final String? category;
  final VoidCallback? onTap;
  final double width;

  factory NearbyClinicCard.fromEntity(
    ClinicEntity entity, {
    VoidCallback? onTap,
  }) {
    return NearbyClinicCard(
      name: entity.name,
      imageUrl: entity.imageUrl,
      distanceDisplay: entity.distanceDisplay,
      durationDisplay: entity.durationDisplay,
      ratingAvg: entity.ratingAvg,
      reviewCountDisplay: entity.reviewCountDisplay,
      category: entity.category,
      onTap: onTap,
    );
  }

  factory NearbyClinicCard.skeleton() => const NearbyClinicCard(
    name: 'Loading...',
    distanceDisplay: '-- km',
    durationDisplay: '-- min',
    ratingAvg: 0,
    reviewCountDisplay: '--',
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: width,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          const PlaceholderImage(height: 100),
                      errorWidget: (_, _, _) =>
                          const PlaceholderImage(height: 100),
                    )
                  : const PlaceholderImage(height: 100),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? '',
                      style: AppTextTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
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
                            '$distanceDisplay / $durationDisplay',
                            style: AppTextTheme.bodySmall.copyWith(
                              color: AppTheme.grey500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (ratingAvg != null && ratingAvg! > 0) ...[
                          // TODO: change to iconsax — currently Material fallback
                          const Icon(Icons.star, size: 12, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            ratingAvg!.toStringAsFixed(1),
                            style: AppTextTheme.labelSmall.copyWith(
                              color: AppTheme.grey700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        if (category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.paleBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              category!,
                              style: AppTextTheme.labelSmall.copyWith(
                                color: AppTheme.blue,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
