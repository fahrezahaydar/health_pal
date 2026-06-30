import 'package:flutter/material.dart';

import '../../core/enums/booking_status.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/booking/domain/entity/appointment_entity.dart';
import '../shared/app_network_image.dart';
import 'status_badge.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onCancel,
    this.onReBook,
  });

  final AppointmentEntity appointment;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onReBook;

  factory AppointmentCard.skeleton() => const AppointmentCard(
    appointment: AppointmentEntity(
      id: 'sk-1',
      patientId: '',
      doctorId: '',
      slotId: '',
      status: 'pending',
      consultationFeeSnapshot: 0,
    ),
  );

  BookingStatus get _status => switch (appointment.status) {
    'pending' => BookingStatus.pending,
    'upcoming' => BookingStatus.upcoming,
    'completed' => BookingStatus.completed,
    'cancelled' => BookingStatus.cancelled,
    _ => BookingStatus.pending,
  };

  bool get _showCancel =>
      _status == BookingStatus.pending || _status == BookingStatus.upcoming;

  bool get _showReBook => _status == BookingStatus.completed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: .end,
              children: [
                if (appointment.slot != null)
                  Expanded(
                    child: Text(
                      appointment.slot?.display ?? '',
                      style: AppTextTheme.titleLarge.copyWith(
                        color: AppTheme.grey800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                StatusBadge(status: _status),
              ],
            ),
            const Divider(thickness: 1),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12,
              children: [
                AppNetworkImage(
                  imageUrl: appointment.doctorPhotoUrl,
                  width: 80,
                  height: 80,
                  borderRadius: 8,
                  iconData: Icons.person,
                  iconSize: 32,
                ),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: AppTextTheme.bodyMedium.copyWith(
                          color: AppTheme.grey800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        appointment.specializationName,
                        style: AppTextTheme.bodySmall.copyWith(
                          color: AppTheme.grey600,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        crossAxisAlignment: .start,
                        children: [
                          const Icon(
                            AppIcons.locationOn,
                            size: 16,
                            color: AppTheme.grey500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.clinicName,
                              style: AppTextTheme.bodySmall.copyWith(
                                color: AppTheme.grey600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_showCancel || _showReBook) const Divider(thickness: 1),
            if (_showCancel || _showReBook)
              Row(
                children: [
                  if (_showCancel)
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: onCancel,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.grey200,
                        ),
                        child: Text('Cancel', style: AppTextTheme.labelMedium),
                      ),
                    ),
                  if (_showReBook)
                    Expanded(
                      child: FilledButton(
                        onPressed: onReBook,

                        child: Text('Re-Book', style: AppTextTheme.labelMedium),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
