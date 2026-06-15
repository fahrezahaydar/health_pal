import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../widgets/card/status_badge.dart';
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
            _AppointmentCard(appointment: upcoming!)
          else
            const _EmptyState(),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final UpcomingAppointmentEntity appointment;

  // Sprint 2 — A5: status sudah typed BookingStatus di entity,
  // tidak perlu firstWhere fallback. Gunakan langsung appointment.status.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Sprint 2 — A6 (Fix M2): path param renamed to :appointmentId
      // (was :bookingId). booking_history_page.dart already uses
      // :appointmentId in replaceAll — dulu path mismatch caused
      // broken navigation there.
      onTap: () => context.push(
        RoutePaths.bookingDetail.replaceAll(':appointmentId', appointment.id),
      ),
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
            _buildDoctorAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.doctorName, style: AppTextTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    appointment.specializationName,
                    style: AppTextTheme.bodySmall.copyWith(
                      color: AppTheme.grey500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Iconsax.calendar,
                    // Sprint 2 — A3: format slotDate (DateTime?) + slotStart
                    // (TimeOfDay?) via DateFormatter nullable variants.
                    // Output: "15 Jun 2026 • 09:00" per Wireframe 06 §4.
                    text:
                        '${DateFormatter.toFullDateOrDash(appointment.slotDate)} • '
                        '${DateFormatter.toTimeOfDayStringOrDash(appointment.slotStart)}',
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    icon: Iconsax.location,
                    text: appointment.clinicName,
                  ),
                ],
              ),
            ),
            StatusBadge(status: appointment.status),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar() {
    return ClipOval(
      child: Container(
        width: 56,
        height: 56,
        color: AppTheme.grey100,
        alignment: Alignment.center,
        child: appointment.doctorPhoto != null
            ? Image.network(
                appointment.doctorPhoto!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Iconsax.user, color: AppTheme.grey400, size: 28),
              )
            : const Icon(Iconsax.user, color: AppTheme.grey400, size: 28),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.grey400),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
          const Icon(Iconsax.calendar, size: 40, color: AppTheme.grey300),
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
              child: Text(
                'Book Appointment',
                style: AppTextTheme.bodySmall.copyWith(color: AppTheme.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
