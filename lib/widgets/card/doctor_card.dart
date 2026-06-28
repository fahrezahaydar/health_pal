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
          spacing: 12,
          children: [
            AppNetworkImage(
              imageUrl: photoUrl,
              width: 108,
              height: 108,
              borderRadius: 12,
              iconData: Icons.person,
              iconSize: 28,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppTextTheme.headlineSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onFavoriteTap != null)
                        IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorite ? Colors.red : AppTheme.grey400,
                          ),
                          onPressed: onFavoriteTap,
                        ),
                    ],
                  ),
                  const Divider(thickness: 1, height: 1),
                  Text(
                    specialization,
                    style: AppTextTheme.bodySmall.copyWith(
                      color: AppTheme.grey600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (clinic != null) ...[
                    Row(
                      spacing: 4,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppTheme.grey400,
                        ),
                        Expanded(
                          child: Text(
                            clinic!,
                            style: AppTextTheme.bodySmall.copyWith(
                              color: AppTheme.grey600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (rating != null) ...[
                    Row(
                      spacing: 4,

                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppTheme.orange,
                        ),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: AppTextTheme.labelSmall.copyWith(
                            color: AppTheme.grey500,
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
                            style: AppTextTheme.bodySmall.copyWith(
                              fontSize: 12,
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
