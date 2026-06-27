import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../widgets/card/category_card.dart';
import '../../domain/entity/specialization_entity.dart';

class QuickCategories extends StatefulWidget {
  const QuickCategories({super.key, required this.specializations});

  final List<SpecializationEntity> specializations;

  @override
  State<QuickCategories> createState() => _QuickCategoriesState();
}

class _QuickCategoriesState extends State<QuickCategories> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final specs = widget.specializations;
    if (specs.isEmpty) return const SizedBox.shrink();

    const int initialCount = 8;
    final displayCount = _isExpanded ? specs.length : initialCount.clamp(0, specs.length);
    final hasMore = specs.length > initialCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Categories', style: AppTextTheme.headlineSmall),
            if (hasMore)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Text(
                  _isExpanded ? 'See Less' : 'See All',
                  style: AppTextTheme.bodySmall,
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
          itemCount: displayCount,
          itemBuilder: (context, index) {
            final s = specs[index];
            return CategoryCard.fromEntity(
              s,
              onTap: () => context.push(
                '${RoutePaths.doctorSearch}?id=${s.id}',
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
