import 'package:flutter/material.dart';

import '../../core/enums/booking_status.dart';
import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
  });

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextTheme.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String get label => switch (status) {
        BookingStatus.pending => 'Menunggu',
        BookingStatus.upcoming => 'Dikonfirmasi',
        BookingStatus.completed => 'Selesai',
        BookingStatus.cancelled => 'Dibatalkan',
      };

  Color get backgroundColor => switch (status) {
        BookingStatus.pending => AppTheme.statusPendingBg,
        BookingStatus.upcoming => AppTheme.statusUpcomingBg,
        BookingStatus.completed => AppTheme.statusCompletedBg,
        BookingStatus.cancelled => AppTheme.statusCancelledBg,
      };

  Color get textColor => switch (status) {
        BookingStatus.pending => AppTheme.statusPendingText,
        BookingStatus.upcoming => AppTheme.statusUpcomingText,
        BookingStatus.completed => AppTheme.statusCompletedText,
        BookingStatus.cancelled => AppTheme.statusCancelledText,
      };
}
