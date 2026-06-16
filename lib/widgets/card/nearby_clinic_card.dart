import 'package:flutter/material.dart';

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
    this.doctorCountDisplay,
    this.onTap,
    this.width = 200,
  });

  final String? name;
  final String? imageUrl;
  final String? distanceDisplay;
  final String? doctorCountDisplay;
  final VoidCallback? onTap;
  final double width;

  factory NearbyClinicCard.fromEntity(ClinicEntity entity, {VoidCallback? onTap}) {
    return NearbyClinicCard(
      name: entity.name,
      imageUrl: entity.imageUrl,
      distanceDisplay: entity.distanceDisplay,
      doctorCountDisplay: entity.doctorCountDisplay,
      onTap: onTap,
    );
  }

  factory NearbyClinicCard.skeleton() => const NearbyClinicCard(
        name: 'Loading...',
        distanceDisplay: '-- km',
        doctorCountDisplay: '--',
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
                  ? Image.network(
                      imageUrl!,
                      width: width,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const PlaceholderImage(height: 100),
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
                        // TODO: change to iconsax — currently Material fallback
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppTheme.grey400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distanceDisplay ?? '',
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppTheme.grey500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      doctorCountDisplay ?? '',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: AppTheme.grey500,
                      ),
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
