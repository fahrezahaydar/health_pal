// lib/widgets/card/booking_summary_card.dart
//
// Card yang menampilkan ringkasan booking — digunakan di bottom sheet
// konfirmasi Book Appointment page.

import 'package:flutter/material.dart';

import '../../core/network/json_converters.dart';
import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/booking/domain/entity/appointment_entity.dart';
import '../shared/info_row.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    super.key,
    required this.doctorName,
    required this.specializationName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.fee,
  });

  final String doctorName;
  final String specializationName;
  final DateTime date;
  final String startTime;
  final String endTime;
  final double fee;

  factory BookingSummaryCard.fromEntity(AppointmentEntity entity) {
    return BookingSummaryCard(
      doctorName: entity.doctorName,
      specializationName: entity.specializationName,
      date: entity.slotDate ?? DateTime(2024, 1, 15),
      startTime: entity.startTimeDisplay ?? '',
      endTime: entity.endTimeDisplay ?? '',
      fee: entity.consultationFeeSnapshot,
    );
  }

  factory BookingSummaryCard.skeleton() => BookingSummaryCard(
        doctorName: '---',
        specializationName: '---',
        date: DateTime(2024, 1, 15),
        startTime: '--:--',
        endTime: '--:--',
        fee: 0,
      );

  @override
  Widget build(BuildContext context) {
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
          Text('Ringkasan Booking', style: AppTextTheme.titleLarge),
          const SizedBox(height: 16),
          InfoRow(icon: Icons.person, text: doctorName, iconSize: 18),
          const SizedBox(height: 8),
          InfoRow(icon: Icons.medical_services, text: specializationName, iconSize: 18),
          const SizedBox(height: 8),
          InfoRow(icon: Icons.calendar_today, text: DateFormatter.toShortDate(date), iconSize: 18),
          const SizedBox(height: 8),
          InfoRow(icon: Icons.access_time, text: '$startTime - $endTime', iconSize: 18),
          const SizedBox(height: 8),
          InfoRow(
            icon: Icons.payments,
            text: '${formatRupiah(fee)} (Simulasi)',
            iconSize: 18,
            valueColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}
