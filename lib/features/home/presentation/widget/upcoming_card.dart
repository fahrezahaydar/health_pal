import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/card/upcoming_appointment_card.dart';
import '../../domain/entity/upcoming_appointment_entity.dart';

class UpcomingCard extends StatelessWidget {
  const UpcomingCard({super.key, this.upcoming});

  final UpcomingAppointmentEntity? upcoming;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming Treatment', style: AppTextTheme.headlineSmall),
          const SizedBox(height: 12),
          if (upcoming != null)
            UpcomingAppointmentCard.fromEntity(upcoming!)
          else
            const _EmptyState(),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Column(
        children: [
          const Icon(AppIcons.calendar, size: 40, color: AppTheme.grey300),
          const SizedBox(height: 12),
          Text(
            'No upcoming treatment found.',
            style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push(RoutePaths.doctorSearch),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              // Sprint 2 — A9 (Fix M6): copy sesuai PRD §6.2 + Wireframe 06 §Empty
              child: Text(
                'Cari Dokter',
                style: AppTextTheme.bodySmall.copyWith(color: AppTheme.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingCardLoading extends StatelessWidget {
  const UpcomingCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: UpcomingCard(upcoming: UpcomingAppointmentEntity.mock()),
    );
  }
}
