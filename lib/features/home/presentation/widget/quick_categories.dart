import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/card/category_card.dart';
import '../../domain/entity/specialization_entity.dart';

class QuickCategories extends StatelessWidget {
  const QuickCategories({super.key, required this.specializations});

  final List<SpecializationEntity> specializations;

  @override
  Widget build(BuildContext context) {
    if (specializations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Categories', style: AppTextTheme.headlineSmall),
            GestureDetector(
              onTap: () => context.push(RoutePaths.doctorSearch),
              child: Text('See All', style: AppTextTheme.bodySmall),
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
          itemCount: 8,
          itemBuilder: (context, index) {
            final s = specializations[index];
            return CategoryCard.fromEntity(
              s,
              onTap: () => context.push(
                '${RoutePaths.doctorSearch}?specialization=${s.id}',
              ),
            );
          },
        ),
      ],
    );
  }
}

class QuickCategoriesLoading extends StatelessWidget {
  const QuickCategoriesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: QuickCategories(specializations: SpecializationEntity.mock()),
    );
  }
}
