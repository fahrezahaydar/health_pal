import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/doctor/domain/entity/doctor_entity.dart';
import '../shared/app_network_image.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.name,
    required this.specialization,
    this.rating,
    this.reviewCount,
    this.clinic,
    this.photoUrl,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  final String name;
  final String specialization;
  final double? rating;
  final int? reviewCount;
  final String? clinic;
  final String? photoUrl;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  factory DoctorCard.fromEntity(
    DoctorEntity entity, {
    bool isFavorite = false,
    VoidCallback? onTap,
    VoidCallback? onFavoriteTap,
  }) {
    return DoctorCard(
      name: entity.fullName,
      specialization: entity.specializationName,
      rating: entity.ratingAvg,
      reviewCount: entity.ratingCount,
      clinic: entity.clinicName,
      photoUrl: entity.photoUrl,
      isFavorite: isFavorite,
      onTap: onTap,
      onFavoriteTap: onFavoriteTap,
    );
  }

  factory DoctorCard.skeleton() => const DoctorCard(
        name: 'Loading...',
        specialization: 'Loading...',
        clinic: 'Loading...',
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNetworkImage(
              imageUrl: photoUrl,
              width: 72,
              height: 72,
              borderRadius: 12,
              iconData: Icons.person,
              iconSize: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppTextTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onFavoriteTap != null)
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color: isFavorite
                                  ? Colors.red
                                  : AppTheme.grey400,
                            ),
                            onPressed: onFavoriteTap,
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 8, thickness: 1),
                  Text(
                    specialization,
                    style: AppTextTheme.bodySmall.copyWith(
                      color: AppTheme.grey500,
                    ),
                  ),
                  if (clinic != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppTheme.grey400,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            clinic!,
                            style: AppTextTheme.labelSmall.copyWith(
                              color: AppTheme.grey400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (rating != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppTheme.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: AppTextTheme.labelSmall.copyWith(
                            color: AppTheme.deepTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (reviewCount != null && reviewCount! > 0) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '|',
                              style: AppTextTheme.labelSmall.copyWith(
                                color: AppTheme.grey300,
                              ),
                            ),
                          ),
                          Text(
                            '$reviewCount ${_reviewLabel(reviewCount!)}',
                            style: AppTextTheme.labelSmall.copyWith(
                              color: AppTheme.grey500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _reviewLabel(int count) {
    if (count == 1) return 'Ulasan';
    return 'Ulasan';
  }
}
