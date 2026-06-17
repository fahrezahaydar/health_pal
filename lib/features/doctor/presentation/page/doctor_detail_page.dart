// lib/features/doctor/presentation/page/doctor_detail_page.dart
//
// Halaman detail dokter. TIDAK ADA date picker (per SS#10).
// Tombol "Book Appointment" navigate ke BookAppointmentPage dengan
// extra: {doctorId, doctorName, consultationFee, suggestedSlotId?}.
//
// Per docs/wireframe/09-doctor-detail.md (v1.0.1).
//
// Struktur (sama dengan features/home/presentation/page/home_page.dart):
// - DoctorDetailPage: StatelessWidget yang hanya menyediakan BlocProvider
//   dan meneruskan `doctorId` ke view.
// - DoctorDetailView: StatefulWidget yang berisi semua state, initState,
//   methods, dan UI. Dipisah agar BlocProvider tidak re-create saat
//   parent rebuild.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/network/json_converters.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/shared/label_value_row.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entity/doctor_entity.dart';
import '../../domain/entity/doctor_slot_entity.dart';
import '../bloc/doctor_detail/doctor_detail_cubit.dart';
import '../bloc/doctor_detail/doctor_detail_state.dart';
import '../../../../widgets/card/doctor_card_detail.dart';
import '../widget/slot_availability_text.dart';

class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({super.key, required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorDetailCubit>(
      create: (_) => getIt<DoctorDetailCubit>(),
      child: DoctorDetailView(doctorId: doctorId),
    );
  }
}

class DoctorDetailView extends StatefulWidget {
  const DoctorDetailView({super.key, required this.doctorId});

  final String doctorId;

  @override
  State<DoctorDetailView> createState() => DoctorDetailViewState();
}

class DoctorDetailViewState extends State<DoctorDetailView> {
  String? _selectedSlotId;
  bool _isFavorite = false;

  Future<void> _openMaps(BuildContext context, DoctorEntity doctor) async {
    final lat = doctor.clinic?.latitude;
    final lng = doctor.clinic?.longitude;
    if (lat == null || lng == null) return;
    try {
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    // Load detail after first frame (avoid emit during build).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DoctorDetailCubit>().loadDetail(widget.doctorId);
    });
  }

  void _onBookAppointment(DoctorEntity doctor) {
    context.push(
      RoutePaths.bookAppointment.replaceAll(':doctorId', doctor.id),
      extra: {
        'doctorId': doctor.id,
        'doctorName': doctor.fullName,
        'consultationFee': doctor.consultationFee,
        'suggestedSlotId': _selectedSlotId,
      },
    );
  }

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
        title: Text('Detail Dokter', style: AppTextTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppTheme.grey700),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<DoctorDetailCubit>().loadDetail(widget.doctorId),
        child: BlocBuilder<DoctorDetailCubit, DoctorDetailState>(
        builder: (context, state) {
          return switch (state) {
            DoctorDetailInitial() ||
            DoctorDetailLoading() =>
              const Skeletonizer(
                enabled: true,
                child: _LoadedSkeleton(),
              ),
            DoctorDetailError(:final message) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: ErrorSection(
                  message: message,
                  onRetry: () =>
                      context.read<DoctorDetailCubit>().loadDetail(widget.doctorId),
                ),
              ),
            DoctorDetailLoaded(
              :final doctor,
              :final sampleSlots,
              :final availableSlotCount,
            ) =>
              _buildLoaded(
                context,
                doctor: doctor,
                sampleSlots: sampleSlots,
                availableCount: availableSlotCount,
              ),
          };
        },
      ),
      ),
      bottomNavigationBar: BlocBuilder<DoctorDetailCubit, DoctorDetailState>(
        builder: (context, state) {
          if (state is! DoctorDetailLoaded) return const SizedBox.shrink();
          return _buildBottomBar(context, state.doctor);
        },
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context, {
    required DoctorEntity doctor,
    required List<DoctorSlotEntity> sampleSlots,
    required int availableCount,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Card ──
          DoctorCardDetail(
            doctor: doctor,
            isFavorite: _isFavorite,
            onFavoriteToggle: () =>
                setState(() => _isFavorite = !_isFavorite),
          ),
          const SizedBox(height: 16),

          // ── Info Card (Education, Experience, Clinic, Fee) ──
          _buildInfoCard(doctor),
          const SizedBox(height: 16),

          // ── Slot Availability (SS#10: text only, no date picker) ──
          Text('Ketersediaan Jadwal', style: AppTextTheme.titleLarge),
          const SizedBox(height: 8),
          SlotAvailabilityText(
            availableCount: availableCount,
            daysAhead: 7,
          ),
          const SizedBox(height: 12),

          // ── Sample slots preview (5 first) ──
          if (sampleSlots.isNotEmpty) ...[
            Text('Preview Slot (5 Pertama)',
                style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sampleSlots.map<Widget>((slot) {
                final isSelected = _selectedSlotId == slot.id;
                return ChoiceChip(
                  label: Text(slot.startTimeDisplay),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedSlotId =
                          isSelected ? null : slot.id;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'ℹ️  Pilih tanggal & slot lengkap di halaman Booking',
              style: AppTextTheme.bodySmall,
            ),
            const SizedBox(height: 16),
          ],

          // ── Ulasan (v1.1 placeholder) ──
          Text('Ulasan Pasien', style: AppTextTheme.titleLarge),
          const SizedBox(height: 8),
          _buildReviewsPlaceholder(),
          const SizedBox(height: 80), // padding for bottom bar
        ],
      ),
    );
  }

  Widget _buildInfoCard(DoctorEntity doctor) {
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
          if (doctor.education != null && doctor.education!.isNotEmpty) ...[
            const LabelValueRow(
              icon: Icons.school_outlined,
              label: 'Pendidikan',
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                doctor.education!,
                style: AppTextTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (doctor.experienceYears > 0)
            LabelValueRow(
              icon: Icons.work_outline,
              label: 'Pengalaman',
              value: '${doctor.experienceYears} tahun',
            ),
          if (doctor.description != null &&
              doctor.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const LabelValueRow(
              icon: Icons.info_outline,
              label: 'Tentang',
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                doctor.description!,
                style: AppTextTheme.bodySmall,
              ),
            ),
          ],
          const SizedBox(height: 12),
          LabelValueRow(
            icon: Icons.local_hospital_outlined,
            label: 'Klinik',
            value: doctor.clinicName,
          ),
          if (doctor.clinic?.address != null) ...[
            const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: GestureDetector(
                  onTap: () => _openMaps(context, doctor),
                  child: Text(
                    '${doctor.clinic!.address}, ${doctor.clinic!.city ?? ''}',
                    style: AppTextTheme.bodySmall
                        .copyWith(color: AppTheme.primary),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 12),
          LabelValueRow(
            icon: Icons.payments_outlined,
            label: 'Biaya',
            value: formatRupiah(doctor.consultationFee),
            valueColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Column(
        children: [
          const Icon(Icons.rate_review_outlined,
              size: 40, color: AppTheme.grey300),
          const SizedBox(height: 8),
          Text(
            'Fitur ulasan datang di v1.1',
            style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, DoctorEntity doctor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: LightFilledButton(
            label: 'Book Appointment',
            icon: const Icon(Icons.calendar_today, color: AppTheme.onPrimary),
            onTap: () => _onBookAppointment(doctor),
          ),
        ),
      ),
    );
  }

}

/// Sprint 5 — D2: Reuse production widget for Skeletonizer.
/// Factory constructor dengan mock data agar Skeletonizer render bones.
class _LoadedSkeleton extends StatelessWidget {
  const _LoadedSkeleton();

  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param — only used for skeleton
    return _buildLoadedStatic(
      context,
      doctor: DoctorEntity.mock(),
      sampleSlots: [DoctorSlotEntity.mock()],
      availableCount: 0,
    );
  }
}

// Static version of _buildLoaded for skeleton reuse.
Widget _buildLoadedStatic(
  BuildContext context, {
  required DoctorEntity doctor,
  required List<DoctorSlotEntity> sampleSlots,
  required int availableCount,
}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoctorCardDetail(doctor: doctor, isFavorite: false),
        const SizedBox(height: 16),
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
              if (doctor.education != null) ...[
                const LabelValueRow(icon: Icons.school_outlined, label: 'Pendidikan'),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(doctor.education!, style: AppTextTheme.bodySmall),
                ),
                const SizedBox(height: 12),
              ],
              LabelValueRow(icon: Icons.work_outline, label: 'Pengalaman', value: '${doctor.experienceYears} tahun'),
              const SizedBox(height: 12),
              LabelValueRow(icon: Icons.local_hospital_outlined, label: 'Klinik', value: doctor.clinicName),
              const SizedBox(height: 12),
              LabelValueRow(icon: Icons.payments_outlined, label: 'Biaya', value: 'Rp${doctor.consultationFee.toStringAsFixed(0)}'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Ketersediaan Jadwal', style: AppTextTheme.titleLarge),
        const SizedBox(height: 8),
        SlotAvailabilityText(availableCount: availableCount, daysAhead: 7),
        if (sampleSlots.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Preview Slot (5 Pertama)', style: AppTextTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sampleSlots.map<Widget>((slot) {
              return ChoiceChip(label: Text(slot.startTimeDisplay), selected: false);
            }).toList(),
          ),
        ],
        const SizedBox(height: 80),
      ],
    ),
  );
}


