// lib/features/booking/presentation/page/booking_success_page.dart
//
// Halaman sukses setelah booking. Per wireframe 11-booking-success.md:
// - Success icon (animated checkmark)
// - Title + description
// - Detail card (dokter, klinik, tanggal, jam, fee, status)
// - 2 CTA: "Kembali ke Home" + "Lihat Riwayat"
//
// Pola: Stateless wrapper (BlocProvider) + view (UI). Untuk success page
// yang tidak punya state, kita tidak perlu BlocProvider — cukup Statless.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/json_converters.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../domain/entity/appointment_entity.dart';

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({super.key, this.appointment});

  final AppointmentEntity? appointment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Success Icon ──
              Container(
                width: 128,
                height: 128,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.paleGreen,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: AppTheme.green,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Booking Berhasil!',
                style: AppTextTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                appointment != null
                    ? 'Appointment kamu dengan ${appointment!.doctorName} telah berhasil dibuat.'
                    : 'Appointment kamu telah berhasil dibuat.',
                style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (appointment != null) _buildDetailCard(appointment!),
              const SizedBox(height: 16),
              Text(
                '🔔 Notifikasi konfirmasi akan dikirim ke perangkatmu',
                style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: LightFilledButton(
                  label: 'Kembali ke Home',
                  onTap: () => context.go(RoutePaths.home),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go(RoutePaths.bookingHistory),
                  child: const Text('Lihat Riwayat Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(AppointmentEntity appt) {
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
          Text('Detail Booking', style: AppTextTheme.titleLarge),
          const SizedBox(height: 12),
          _row(Icons.person, appt.doctorName),
          const SizedBox(height: 8),
          _row(Icons.local_hospital, appt.clinicName),
          const SizedBox(height: 8),
          if (appt.slotDate != null)
            _row(Icons.calendar_today, _formatDate(appt.slotDate!)),
          if (appt.timeRangeDisplay != null) ...[
            const SizedBox(height: 8),
            _row(Icons.access_time, appt.timeRangeDisplay!),
          ],
          const SizedBox(height: 8),
          _row(
            Icons.payments,
            '${formatRupiah(appt.consultationFeeSnapshot)} (Simulasi)',
            valueColor: AppTheme.primary,
          ),
          const SizedBox(height: 8),
          _row(
            Icons.info_outline,
            'Status: ${appt.status[0].toUpperCase()}${appt.status.substring(1)}',
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
        Icon(icon, size: 16, color: AppTheme.grey500),
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
