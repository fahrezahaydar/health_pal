import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/home/domain/entity/specialization_entity.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    this.name,
    this.iconUrl,
    this.colorHex,
    this.onTap,
  });

  final String? name;
  final String? iconUrl;
  final String? colorHex;
  final VoidCallback? onTap;

  factory CategoryCard.fromEntity(
    SpecializationEntity entity, {
    VoidCallback? onTap,
  }) {
    return CategoryCard(
      name: entity.name,
      iconUrl: entity.iconUrl,
      colorHex: entity.colorHex,
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
          AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (context, c) {
                final circleSize = c.maxWidth;

                return Container(
                  decoration: BoxDecoration(
                    color:
                        _parseColor(colorHex) ??
                        AppTheme.paleBlue.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,

                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentGeometry.center,
                    children: [
                      Positioned(
                        top: -circleSize / 2,
                        left: -circleSize / 2,
                        child: Container(
                          width: circleSize,
                          height: circleSize,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 255, 255, 0.2),
                            // color: Colors.amber,
                          ),
                        ),
                      ),
                      SvgPicture.network(
                        iconUrl ?? '',
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        placeholderBuilder: (_) {
                          return Icon(
                            _iconData(name),
                            size: 28,
                            color: AppTheme.blue,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name ?? '',
            style: AppTextTheme.labelSmall.copyWith(color: AppTheme.grey700),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color? _parseColor(String? hex) {
    if (hex == null) return null;
    final h = hex.replaceFirst('#', '');
    if (h.length != 6 && h.length != 8) return null;
    final v = int.tryParse(h, radix: 16);
    if (v == null) return null;
    if (h.length == 6) return Color(0xFF000000 | v);
    return Color(v);
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
