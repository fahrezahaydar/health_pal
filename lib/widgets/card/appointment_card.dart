import 'package:flutter/material.dart';

import '../../core/enums/booking_status.dart';
import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/booking/domain/entity/appointment_entity.dart';
import 'status_badge.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  final AppointmentEntity appointment;
  final VoidCallback? onTap;

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.grey100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: appointment.doctorPhotoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        appointment.doctorPhotoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.person,
                          color: AppTheme.grey400,
                          size: 28,
                        ),
                      ),
                    )
                  : const Icon(Icons.person, color: AppTheme.grey400, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.doctorName,
                    style: AppTextTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    appointment.clinicName,
                    style: AppTextTheme.bodySmall
                        .copyWith(color: AppTheme.grey500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(),
                    style: AppTextTheme.bodySmall
                        .copyWith(color: AppTheme.grey700),
                  ),
                ],
              ),
            ),
            StatusBadge(status: _status),
          ],
        ),
      ),
    );
  }

  String _formatDateTime() {
    final date = appointment.slotDate;
    final start = appointment.startTimeDisplay;
    final end = appointment.endTimeDisplay;
    if (date == null) return '';
    final dateStr = DateFormatter.toShortDate(date);
    if (start == null || end == null) return dateStr;
    return '$dateStr • $start - $end';
  }
}
