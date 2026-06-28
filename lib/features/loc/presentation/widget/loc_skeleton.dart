import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../loc/domain/entity/clinic_entity.dart';
import '../../../loc/presentation/widget/loc_map_widget.dart';
import '../../../../widgets/card/clinic_card.dart';

class LocSkeleton extends StatelessWidget {
  const LocSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final mock = ClinicEntity.mock();
    return Skeletonizer(
      enabled: true,
      child: Stack(
        children: [
          LocMapWidget(clinics: mock, userLat: -6.2088, userLng: 106.8456),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Clinic / Hospital',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppTheme.white.withValues(alpha: 0.95),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SizedBox(
                height: 210,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: mock
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SizedBox(
                              width: 240,
                              child: ClinicCard(clinic: c),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
