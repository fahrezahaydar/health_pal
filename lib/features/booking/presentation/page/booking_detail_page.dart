// lib/features/booking/presentation/page/booking_detail_page.dart
//
// Halaman Detail Appointment. Per wireframe 13-booking-detail.md:
// - Header (foto, nama, spec, status badge)
// - Info card (tanggal, jam, klinik, alamat, telepon, fee, keluhan)
// - Status Timeline
// - Cancel button (jika pending/upcoming)
//
// Pola: Stateless wrapper (BlocProvider) + view (UI).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/enums/booking_status.dart';
import '../../../../core/network/json_converters.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/shared/app_network_image.dart';
import '../../../../widgets/shared/label_value_row.dart';
import '../../../../widgets/card/status_badge.dart';
import '../../../../widgets/dialog/app_loading_dialog.dart';
import '../../domain/entity/appointment_entity.dart';
import '../bloc/detail/booking_detail_cubit.dart';
import '../bloc/detail/booking_detail_state.dart';
import '../widget/status_timeline.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingDetailCubit>(
      create: (_) {
        final patientId =
            getIt<SupabaseClient>().auth.currentUser?.id ?? '';
        return getIt<BookingDetailCubit>()
          ..loadDetail(
            patientId: patientId,
            appointmentId: appointmentId,
          );
      },
      child: _BookingDetailView(appointmentId: appointmentId),
    );
  }
}

class _BookingDetailView extends StatelessWidget {
  const _BookingDetailView({required this.appointmentId});

  final String appointmentId;

  BookingStatus _parseStatus(String s) => switch (s) {
        'pending' => BookingStatus.pending,
        'upcoming' => BookingStatus.upcoming,
        'completed' => BookingStatus.completed,
        'cancelled' => BookingStatus.cancelled,
        _ => BookingStatus.pending,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.grey900),
          onPressed: () => context.pop(),
        ),
        title: Text('Detail Appointment', style: AppTextTheme.titleLarge),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final pid = getIt<SupabaseClient>().auth.currentUser?.id ?? '';
          await context.read<BookingDetailCubit>().loadDetail(
            patientId: pid,
            appointmentId: appointmentId,
          );
        },
        child: BlocBuilder<BookingDetailCubit, BookingDetailState>(
          builder: (context, state) {
            return switch (state) {
              BookingDetailInitial() ||
              BookingDetailLoading() =>
                const Skeletonizer(
                  enabled: true,
                  child: _DetailSkeleton(),
                ),
              BookingDetailError(:final message) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: ErrorSection(
                    message: message,
                    onRetry: () {
                      final pid = getIt<SupabaseClient>().auth.currentUser?.id ?? '';
                      context.read<BookingDetailCubit>().loadDetail(
                        patientId: pid,
                        appointmentId: appointmentId,
                      );
                    },
                  ),
                ),
              BookingDetailLoaded(:final appointment) => _loaded(
                  context,
                  appointment,
                ),
            };
          },
        ),
      ),
    );
  }

  Widget _loaded(BuildContext context, AppointmentEntity appt) {
    final status = _parseStatus(appt.status);
    final canCancel = status == BookingStatus.pending ||
        status == BookingStatus.upcoming;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.grey200),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.grey100,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: AppNetworkImage(
                    imageUrl: appt.doctorPhotoUrl,
                    width: 64,
                    height: 64,
                    borderRadius: 32,
                    iconData: Icons.person,
                    iconSize: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt.doctorName,
                        style: AppTextTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appt.specializationName,
                        style: AppTextTheme.bodySmall
                            .copyWith(color: AppTheme.grey500),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: status),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Info Card ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.grey200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Info Booking', style: AppTextTheme.titleLarge),
                const SizedBox(height: 12),
                if (appt.slotDate != null)
                  LabelValueRow(icon: Icons.calendar_today, label: 'Tanggal',
                      value: DateFormatter.toShortDate(appt.slotDate!)),
                if (appt.timeRangeDisplay != null) ...[
                  const SizedBox(height: 8),
                  LabelValueRow(icon: Icons.access_time, label: 'Waktu', value: appt.timeRangeDisplay!),
                ],
                const SizedBox(height: 8),
                LabelValueRow(icon: Icons.local_hospital, label: 'Klinik', value: appt.clinicName),
                if (appt.clinicAddress != null) ...[
                  const SizedBox(height: 8),
                  LabelValueRow(icon: Icons.location_on, label: 'Alamat', value: appt.clinicAddress!),
                ],
                if (appt.clinicPhone != null) ...[
                  const SizedBox(height: 8),
                  LabelValueRow(icon: Icons.phone, label: 'Telepon', value: appt.clinicPhone!),
                ],
                const SizedBox(height: 8),
                LabelValueRow(
                  icon: Icons.payments,
                  label: 'Biaya',
                  value: formatRupiah(appt.consultationFeeSnapshot),
                  valueColor: AppTheme.primary,
                ),
                if (appt.complaintNote != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Keluhan:',
                    style:
                        AppTextTheme.bodyMedium.copyWith(color: AppTheme.grey700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${appt.complaintNote!}"',
                    style: AppTextTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Status Timeline ──
          StatusTimeline(appointment: appt),
          const SizedBox(height: 16),

          // ── Cancel Button (conditional) ──
          if (canCancel)
            SizedBox(
              width: double.infinity,
              child: LightFilledButton(
                label: 'Batalkan Appointment',
                backgroundColor: AppTheme.darkRed,
                onTap: () => _confirmCancel(context, appt),
              ),
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    AppointmentEntity appt,
  ) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Yakin batalkan?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Alasan pembatalan (opsional):'),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Cth: Ada keperluan mendadak',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Ya, batalkan',
              style: TextStyle(color: AppTheme.darkRed),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await AppLoadingDialog.show(context);
    if (!context.mounted) return;
    final cubit = context.read<BookingDetailCubit>();
    await cubit.cancelAppointment(
      appointmentId: appt.id,
      cancellationReason: reasonController.text.trim().isEmpty
          ? null
          : reasonController.text.trim(),
    );
    if (context.mounted) {
      await AppLoadingDialog.dismiss(context);
    }
  }

}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(height: 80, decoration: BoxDecoration(
            color: AppTheme.grey100, borderRadius: BorderRadius.circular(12))),
          const SizedBox(height: 16),
          Container(height: 200, decoration: BoxDecoration(
            color: AppTheme.grey100, borderRadius: BorderRadius.circular(12))),
          const SizedBox(height: 16),
          Container(height: 100, decoration: BoxDecoration(
            color: AppTheme.grey100, borderRadius: BorderRadius.circular(12))),
        ],
      ),
    );
  }
}
