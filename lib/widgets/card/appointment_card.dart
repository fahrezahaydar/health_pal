import 'package:flutter/material.dart';

import '../../core/enums/booking_status.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _headerRow(context),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 16, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: _doctorInfoRow(context),
            ),
            if (_showCancel || _showReBook)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 16, thickness: 1),
              ),
            if (_showCancel || _showReBook)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _actionRow(context),
              ),
            if (!_showCancel && !_showReBook)
              const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _headerRow(BuildContext context) {
    final date = appointment.slotDate;
    final dateStr =
        date != null ? DateFormatter.toShortDate(date) : '';
    final time = appointment.startTimeDisplay ?? '';
    final dateTimeStr =
        dateStr.isNotEmpty && time.isNotEmpty ? '$dateStr · $time' : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            dateTimeStr,
            style: AppTextTheme.bodySmall.copyWith(
              color: AppTheme.grey700,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        StatusBadge(status: _status),
      ],
    );
  }

  Widget _doctorInfoRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 80,
            height: 120,
            child: AppNetworkImage(
              imageUrl: appointment.doctorPhotoUrl,
              width: 80,
              height: 120,
              borderRadius: 8,
              iconData: Icons.person,
              iconSize: 32,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.doctorName,
                style: AppTextTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                appointment.specializationName,
                style: AppTextTheme.bodySmall.copyWith(
                  color: AppTheme.grey600,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    AppIcons.locationOn,
                    size: 14,
                    color: AppTheme.grey500,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      appointment.clinicName,
                      style: AppTextTheme.bodySmall.copyWith(
                        color: AppTheme.grey500,
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
    );
  }

  Widget _actionRow(BuildContext context) {
    return Row(
      children: [
        if (_showCancel)
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.darkRed,
                side: const BorderSide(color: AppTheme.darkRed),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Cancel', style: AppTextTheme.labelMedium),
            ),
          ),
        if (_showReBook)
          Expanded(
            child: FilledButton(
              onPressed: onReBook,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Re-Book', style: AppTextTheme.labelMedium),
            ),
          ),
      ],
    );
  }
}
