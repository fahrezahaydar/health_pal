import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entity/specialization_entity.dart';

class QuickCategories extends StatelessWidget {
  const QuickCategories({super.key, required this.specializations});

  final List<SpecializationEntity> specializations;

  @override
  Widget build(BuildContext context) {
    if (specializations.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories', style: AppTextTheme.headlineSmall),
              GestureDetector(
                onTap: () => context.push(RoutePaths.doctorSearch),
                child: Text(
                  'See All',
                  style: AppTextTheme.bodySmall.copyWith(color: AppTheme.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: specializations.length,
            itemBuilder: (context, index) {
              return _CategoryItem(specialization: specializations[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.specialization});

  final SpecializationEntity specialization;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '${RoutePaths.doctorSearch}?specialization=${specialization.id}',
      ),
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
            child: specialization.iconUrl != null
                ? Image.network(
                    specialization.iconUrl!,
                    width: 28,
                    height: 28,
                    errorBuilder: (_, _, _) => Icon(
                      _getIcon(specialization.name),
                      size: 28,
                      color: AppTheme.blue,
                    ),
                  )
                : Icon(
                    _getIcon(specialization.name),
                    size: 28,
                    color: AppTheme.blue,
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            specialization.name,
            style: AppTextTheme.labelSmall.copyWith(color: AppTheme.grey700),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Sprint 2 — C5: Replace all Iconsax icons with Material Icons
  // fallback. Owner will swap to Iconsax equivalents via TODO list.
  // Icon mapping is heuristic by specialization name substring.
  IconData _getIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('dent')) return Icons.medical_services;
    if (lower.contains('card')) return Icons.favorite;
    if (lower.contains('pulm') || lower.contains('lung')) return Icons.air;
    if (lower.contains('neuro')) return Icons.psychology;
    if (lower.contains('gastro')) return Icons.science;
    if (lower.contains('lab')) return Icons.biotech;
    if (lower.contains('vacc')) return Icons.vaccines;
    if (lower.contains('gener')) return Icons.person;
    // TODO: change to iconsax — currently Material fallback
    return Icons.local_hospital;
  }
}
