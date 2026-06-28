import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
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
                DoctorViewContent(DoctorEntity.mock(), isLoading: true),
              DoctorDetailError(:final message) => Center(
                child: ErrorSection(
                  message: message,
                  onRetry: () => context.read<DoctorDetailCubit>().loadDetail(
                    widget.doctorId,
                  ),
                ),
              ),
              DoctorDetailLoaded(:final doctor) => DoctorViewContent(doctor),
            };
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<DoctorDetailCubit, DoctorDetailState>(
        builder: (context, state) {
          if (state is! DoctorDetailLoaded) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () => _onBookAppointment(state.doctor),
              child: const Text('Book Appointment'),
            ),
          );
        },
      ),
    );
  }
}

class DoctorViewContent extends StatelessWidget {
  const DoctorViewContent(this.doctor, {super.key, this.isLoading = false});
  final DoctorEntity doctor;
  final bool isLoading;

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
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            DoctorInfoCard(
              doctor: doctor,
              onMapTap: isLoading ? null : () => _openMaps(context, doctor),
            ),
            DoctorStatsRow(doctor: doctor),
            AboutSection(description: doctor.description),
            WorkingTimeSection(workingTimeDisplay: doctor.workingTimeDisplay),
            const ReviewsHeader(),
          ],
        ),
      ),
    );
  }
}
