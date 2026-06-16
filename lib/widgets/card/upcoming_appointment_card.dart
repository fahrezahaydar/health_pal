import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax.dart';

import '../../core/enums/booking_status.dart';
import '../../core/router/route_paths.dart';
import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/home/domain/entity/upcoming_appointment_entity.dart';
import '../shared/info_row.dart';
import 'status_badge.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({
    super.key,
    this.doctorName,
    this.doctorPhoto,
    this.specializationName,
    this.clinicName,
    this.slotDate,
    this.slotStart,
    this.status,
    this.appointmentId,
    this.onTap,
  });

  final String? doctorName;
  final String? doctorPhoto;
  final String? specializationName;
  final String? clinicName;
  final DateTime? slotDate;
  final TimeOfDay? slotStart;
  final BookingStatus? status;
  final String? appointmentId;
  final VoidCallback? onTap;

  factory UpcomingAppointmentCard.fromEntity(
    UpcomingAppointmentEntity entity, {
    VoidCallback? onTap,
  }) {
    return UpcomingAppointmentCard(
      doctorName: entity.doctorName,
      doctorPhoto: entity.doctorPhoto,
      specializationName: entity.specializationName,
      clinicName: entity.clinicName,
      slotDate: entity.slotDate,
      slotStart: entity.slotStart,
      status: entity.status,
      appointmentId: entity.id,
      onTap: onTap,
    );
  }

  factory UpcomingAppointmentCard.skeleton() =>
      const UpcomingAppointmentCard(
        doctorName: 'Loading...',
        specializationName: 'Loading...',
        clinicName: 'Loading...',
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            final id = appointmentId;
            if (id != null) {
              context.push(
                RoutePaths.bookingDetail
                    .replaceAll(':appointmentId', id),
              );
            }
          },
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
            _DoctorAvatar(photoUrl: doctorPhoto),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctorName ?? '',
                      style: AppTextTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    specializationName ?? '',
                    style: AppTextTheme.bodySmall
                        .copyWith(color: AppTheme.grey500),
                  ),
                  const SizedBox(height: 8),
                  InfoRow(
                    icon: Iconsax.calendar,
                    text:
                        '${DateFormatter.toFullDateOrDash(slotDate)} • '
                        '${DateFormatter.toTimeOfDayStringOrDash(slotStart)}',
                  ),
                  const SizedBox(height: 4),
                  InfoRow(
                    icon: Iconsax.location,
                    text: clinicName ?? '',
                  ),
                ],
              ),
            ),
            StatusBadge(
              status: status ?? BookingStatus.pending,
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  const _DoctorAvatar({this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 56,
        height: 56,
        color: AppTheme.grey100,
        alignment: Alignment.center,
        child: photoUrl != null
            ? Image.network(
                photoUrl!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Iconsax.user,
                  color: AppTheme.grey400,
                  size: 28,
                ),
              )
            : const Icon(Iconsax.user, color: AppTheme.grey400, size: 28),
      ),
    );
  }
}
