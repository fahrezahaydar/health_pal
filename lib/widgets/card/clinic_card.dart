import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/loc/domain/entity/clinic_entity.dart';
import '../button/outline_button.dart';

class ClinicCard extends StatelessWidget {
  const ClinicCard({super.key, required this.clinic});

  final ClinicEntity clinic;

  Future<void> _openMaps() async {
    try {
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${clinic.latitude},${clinic.longitude}',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: clinic.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          clinic.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.local_hospital, // TODO: change to iconsax
                            color: AppTheme.grey400,
                            size: 32,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.local_hospital, // TODO: change to iconsax
                        color: AppTheme.grey400,
                        size: 32,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: AppTextTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // TODO: change to iconsax — currently Material fallback
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppTheme.grey500,
                        ),
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
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.paleBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        clinic.distanceDisplay,
                        style: AppTextTheme.labelSmall.copyWith(
                          color: AppTheme.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (clinic.specializations != null &&
              clinic.specializations!.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: clinic.specializations!
                  .take(3)
                  .map(
                    (s) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.grey100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        s,
                        style: AppTextTheme.labelSmall.copyWith(
                          color: AppTheme.grey700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          if (clinic.specializations != null &&
              clinic.specializations!.isNotEmpty)
            const SizedBox(height: 12),
          Row(
            children: [
              // TODO: change to iconsax — currently Material fallback
              const Icon(Icons.people, size: 14, color: AppTheme.grey500),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  clinic.doctorCountDisplay,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.grey700,
                  ),
                ),
              ),
              Flexible(
                child: LightOutlineButton(
                  label: 'Lihat Peta',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 6,
                  ),
                  icon: const Icon(
                    Icons.map,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  onTap: _openMaps,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
