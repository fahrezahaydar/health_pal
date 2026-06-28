import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/card/about_section.dart';
import '../../../../widgets/card/doctor_info_card.dart';
import '../../../../widgets/card/doctor_stats_row.dart';
import '../../../../widgets/card/reviews_header.dart';
import '../../../../widgets/card/working_time_section.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../domain/entity/doctor_entity.dart';
import '../bloc/doctor_detail/doctor_detail_cubit.dart';
import '../bloc/doctor_detail/doctor_detail_state.dart';

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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.grey900),
          onPressed: () => context.pop(),
        ),
        title: Text('Detail Dokter', style: AppTextTheme.headlineLarge),
        // TODO: change to iconsax — currently Material fallback
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? AppTheme.darkRed : AppTheme.grey700,
              ),
              onPressed: () => setState(() => _isFavorite = !_isFavorite),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<DoctorDetailCubit>().loadDetail(widget.doctorId),
        child: BlocBuilder<DoctorDetailCubit, DoctorDetailState>(
          builder: (context, state) {
            return switch (state) {
              DoctorDetailInitial() || DoctorDetailLoading() =>
                const Skeletonizer(enabled: true, child: _LoadedSkeleton()),
              DoctorDetailError(:final message) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: ErrorSection(
                  message: message,
                  onRetry: () => context.read<DoctorDetailCubit>().loadDetail(
                    widget.doctorId,
                  ),
                ),
              ),
              DoctorDetailLoaded(:final doctor) =>
                _buildLoaded(context, doctor: doctor),
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
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoctorInfoCard(
            doctor: doctor,
            onMapTap: () => _openMaps(context, doctor),
          ),
          const SizedBox(height: 24),
          DoctorStatsRow(doctor: doctor),
          const SizedBox(height: 24),
          AboutSection(description: doctor.description),
          const SizedBox(height: 24),
          WorkingTimeSection(workingTimeDisplay: doctor.workingTimeDisplay),
          const SizedBox(height: 24),
          const ReviewsHeader(),
          const SizedBox(height: 80),
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

class _LoadedSkeleton extends StatelessWidget {
  const _LoadedSkeleton();

  @override
  Widget build(BuildContext context) {
    final mock = DoctorEntity.mock();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoctorInfoCard.skeleton(),
          const SizedBox(height: 24),
          DoctorStatsRow(doctor: mock),
          const SizedBox(height: 24),
          AboutSection(description: mock.description),
          const SizedBox(height: 24),
          WorkingTimeSection(workingTimeDisplay: mock.workingTimeDisplay),
          const SizedBox(height: 24),
          const ReviewsHeader(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
