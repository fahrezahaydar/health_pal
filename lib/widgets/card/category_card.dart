import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/home/domain/entity/specialization_entity.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, this.name, this.iconUrl, this.onTap});

  final String? name;
  final String? iconUrl;
  final VoidCallback? onTap;

  factory CategoryCard.fromEntity(
    SpecializationEntity entity, {
    VoidCallback? onTap,
  }) {
    return CategoryCard(
      name: entity.name,
      iconUrl: entity.iconUrl,
      onTap: onTap,
    );
  }

  factory CategoryCard.skeleton() => const CategoryCard(name: '—');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.paleBlue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: iconUrl != null
                ? Image.network(
                    iconUrl!,
                    width: 28,
                    height: 28,
                    errorBuilder: (_, _, _) =>
                        Icon(_iconData(name), size: 28, color: AppTheme.blue),
                  )
                : Icon(_iconData(name), size: 28, color: AppTheme.blue),
          ),
          const SizedBox(height: 6),
          Text(
            name ?? '',
            style: AppTextTheme.labelSmall.copyWith(color: AppTheme.grey700),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _iconData(String? name) {
    if (name == null) return Icons.local_hospital;
    final lower = name.toLowerCase();
    if (lower.contains('dent')) return Icons.medical_services;
    if (lower.contains('card')) return Icons.favorite;
    if (lower.contains('pulm') || lower.contains('lung')) return Icons.air;
    if (lower.contains('neuro')) return Icons.psychology;
    if (lower.contains('gastro')) return Icons.science;
    if (lower.contains('lab')) return Icons.biotech;
    if (lower.contains('vacc')) return Icons.vaccines;
    if (lower.contains('gener')) return Icons.person;
    return Icons.local_hospital;
  }
}
