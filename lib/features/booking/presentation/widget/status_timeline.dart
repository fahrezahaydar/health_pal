// lib/features/booking/presentation/widget/status_timeline.dart
//
// Timeline widget yang menampilkan status appointment.
// Items:
// - "Booking dibuat" (selalu ada jika bookedAt != null)
// - "Dikonfirmasi" (jika confirmedAt != null atau status = upcoming/completed)
// - "Kunjungan selesai" (jika completedAt != null atau status = completed)
// - "Dibatalkan" (jika cancelledAt != null, dengan alasan jika ada)

import 'package:flutter/material.dart';

import '../../../../core/enums/booking_status.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entity/appointment_entity.dart';

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.appointment});

  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Timeline', style: AppTextTheme.titleLarge),
          const SizedBox(height: 16),
          for (int i = 0; i < items.length; i++) ...[
            _TimelineItem(
              item: items[i],
              isLast: i == items.length - 1,
            ),
          ],
        ],
      ),
    );
  }

  List<_TimelineEntry> _buildItems() {
    final status = _parseStatus(appointment.status);
    final items = <_TimelineEntry>[];

    // 1. Booked (selalu ada untuk semua status)
    if (appointment.bookedAt != null) {
      items.add(_TimelineEntry(
        label: 'Booking dibuat',
        date: appointment.bookedAt!,
        isCompleted: true,
      ));
    }

    // 2. Confirmed (untuk upcoming/completed)
    if (status == BookingStatus.upcoming || status == BookingStatus.completed) {
      items.add(_TimelineEntry(
        label: 'Dikonfirmasi',
        date: appointment.confirmedAt ?? appointment.createdAt ?? DateTime.now(),
        isCompleted: true,
      ));
    }

    // 3. Completed
    if (status == BookingStatus.completed && appointment.completedAt != null) {
      items.add(_TimelineEntry(
        label: 'Kunjungan selesai',
        date: appointment.completedAt!,
        isCompleted: true,
      ));
    }

    // 4. Cancelled
    if (status == BookingStatus.cancelled && appointment.cancelledAt != null) {
      items.add(_TimelineEntry(
        label: 'Dibatalkan',
        date: appointment.cancelledAt!,
        isCompleted: true,
        subtitle: appointment.cancellationReason,
      ));
    }

    // Fallback: jika bookedAt null (edge case), tetap tampilkan
    if (items.isEmpty) {
      items.add(_TimelineEntry(
        label: 'Booking dibuat',
        date: appointment.createdAt ?? DateTime.now(),
        isCompleted: true,
      ));
    }

    return items;
  }

  BookingStatus _parseStatus(String s) => switch (s) {
        'pending' => BookingStatus.pending,
        'upcoming' => BookingStatus.upcoming,
        'completed' => BookingStatus.completed,
        'cancelled' => BookingStatus.cancelled,
        _ => BookingStatus.pending,
      };
}

class _TimelineEntry {
  final String label;
  final DateTime date;
  final bool isCompleted;
  final String? subtitle;

  _TimelineEntry({
    required this.label,
    required this.date,
    required this.isCompleted,
    this.subtitle,
  });
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.item, required this.isLast});

  final _TimelineEntry item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Indicator + Line ──
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isCompleted ? AppTheme.green : AppTheme.grey200,
                ),
                child: const Icon(Icons.check, size: 14, color: AppTheme.white),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppTheme.grey200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // ── Content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: AppTextTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text(
                    DateFormatter.toShortDate(item.date),
                    style: AppTextTheme.bodySmall
                        .copyWith(color: AppTheme.grey500),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '"${item.subtitle}"',
                      style: AppTextTheme.bodySmall
                          .copyWith(color: AppTheme.grey700),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
