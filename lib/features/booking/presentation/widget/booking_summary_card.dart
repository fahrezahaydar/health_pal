// lib/features/booking/presentation/widget/booking_summary_card.dart
//
// Card yang menampilkan ringkasan booking — digunakan di bottom sheet
// konfirmasi Book Appointment page.

import 'package:flutter/material.dart';

import '../../../../core/network/json_converters.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

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
          _row(Icons.person, doctorName),
          const SizedBox(height: 8),
          _row(Icons.medical_services, specializationName),
          const SizedBox(height: 8),
          _row(Icons.calendar_today, _formatDate(date)),
          const SizedBox(height: 8),
          _row(Icons.access_time, '$startTime - $endTime'),
          const SizedBox(height: 8),
          _row(
            Icons.payments,
            '${formatRupiah(fee)} (Simulasi)',
            valueColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.grey500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextTheme.bodyMedium.copyWith(
              color: valueColor ?? AppTheme.grey900,
              fontWeight: valueColor != null ? FontWeight.w600 : null,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }
}
