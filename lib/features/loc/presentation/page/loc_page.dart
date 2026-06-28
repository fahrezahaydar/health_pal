import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart' show getIt;
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/loader/error_section.dart';
import '../bloc/loc_cubit.dart';
import '../bloc/loc_state.dart';
import '../../domain/entity/clinic_entity.dart';
import '../widget/loc_map_widget.dart';
import '../../../../widgets/card/clinic_card.dart';

const double _kCardWidth = 240;
const double _kCardSpacing = 16;
const double _kCarouselHeight = 210;
const double _kItemStep = _kCardWidth + _kCardSpacing;

class LocPage extends StatelessWidget {
  const LocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocCubit>(
      create: (_) => getIt<LocCubit>(),
      child: const _LocView(),
    );
  }
}

class _LocView extends StatefulWidget {
  const _LocView();

  @override
  State<_LocView> createState() => _LocViewState();
}

class _LocViewState extends State<_LocView> {
  final _carouselController = ScrollController();
  String? _lastAutoScrolledId;
  Timer? _snapTimer;

  @override
  void initState() {
    super.initState();
    _carouselController.addListener(_onCarouselScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LocCubit>().requestLocationAndLoad();
    });
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _carouselController.removeListener(_onCarouselScroll);
    _carouselController.dispose();
    super.dispose();
  }

  void _onCarouselScroll() {
    if (!_carouselController.hasClients) return;
    _snapTimer?.cancel();
    _snapTimer = Timer(const Duration(milliseconds: 80), _snapCarousel);
  }

  void _snapCarousel() {
    if (!_carouselController.hasClients) return;
    final offset = _carouselController.offset;
    final snapped = (offset / _kItemStep).round() * _kItemStep;
    final maxOffset = _carouselController.position.maxScrollExtent;
    final clamped = snapped.clamp(0.0, maxOffset);
    if (clamped != offset) {
      _carouselController.animateTo(
        clamped,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollToIndex(int index) {
    if (!_carouselController.hasClients) return;
    final target = index * _kItemStep;
    final maxOffset = _carouselController.position.maxScrollExtent;
    final clamped = target.clamp(0.0, maxOffset);
    _carouselController.animateTo(
      clamped,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  int _findClinicIndex(String clinicId, List<ClinicEntity> clinics) {
    return clinics.indexWhere((c) => c.id == clinicId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocCubit, LocState>(
        builder: (context, state) {
          return switch (state) {
            LocInitial() || LocLoading() => _loadingSkeleton(context),
            LocPermissionDenied(:final reason) => _permissionDenied(
              context,
              reason,
            ),
            LocError(:final message) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ErrorSection(
                message: message,
                onRetry: () =>
                    context.read<LocCubit>().requestLocationAndLoad(),
              ),
            ),
            LocLoaded(
              :final clinics,
              :final currentPosition,
              :final selectedClinicId,
            ) =>
              _mapLayout(context, clinics, currentPosition, selectedClinicId),
          };
        },
      ),
    );
  }

  Widget _clinicCarousel({
    required List<ClinicEntity> clinics,
    String? selectedClinicId,
    void Function(ClinicEntity clinic)? onTap,
    void Function(String clinicId)? onFavoriteTap,
  }) {
    return SizedBox(
      height: _kCarouselHeight,
      child: ListView.builder(
        controller: _carouselController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: _kCardSpacing),
        itemCount: clinics.length,
        itemExtent: _kItemStep,
        itemBuilder: (context, i) {
          final c = clinics[i];
          return Padding(
            padding: const EdgeInsets.only(right: _kCardSpacing),
            child: ClinicCard(
              clinic: c,
              width: _kCardWidth,
              isSelected: c.id == selectedClinicId,
              onTap: onTap != null ? () => onTap(c) : null,
              onFavoriteTap: onFavoriteTap != null
                  ? () => onFavoriteTap(c.id)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _loadingSkeleton(BuildContext context) {
    final mock = ClinicEntity.mock();
    return Skeletonizer(
      enabled: true,
      child: Stack(
        children: [
          LocMapWidget(clinics: mock, userLat: -6.2088, userLng: 106.8456),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Clinic / Hospital',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppTheme.white.withValues(alpha: 0.95),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _clinicCarousel(clinics: mock),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapLayout(
    BuildContext context,
    List<ClinicEntity> clinics,
    Position currentPosition,
    String? selectedClinicId,
  ) {
    final cubit = context.read<LocCubit>();

    if (selectedClinicId != null && selectedClinicId != _lastAutoScrolledId) {
      _lastAutoScrolledId = selectedClinicId;
      final idx = _findClinicIndex(selectedClinicId, clinics);
      if (idx >= 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _scrollToIndex(idx);
        });
      }
    }

    return Stack(
      children: [
        LocMapWidget(
          clinics: clinics,
          userLat: currentPosition.latitude,
          userLng: currentPosition.longitude,
          selectedClinicId: selectedClinicId,
          onMarkerTap: (clinic) => cubit.selectClinic(clinic.id),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Clinic / Hospital',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppTheme.white.withValues(alpha: 0.95),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (keyword) => cubit.setSearchKeyword(keyword),
            ),
          ),
        ),
        if (clinics.isNotEmpty)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _clinicCarousel(
                clinics: clinics,
                selectedClinicId: selectedClinicId,
                onTap: (clinic) {
                  cubit.selectClinic(clinic.id);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(clinic.name)));
                },
                onFavoriteTap: (id) => cubit.toggleFavorite(id),
              ),
            ),
          ),
        if (clinics.isEmpty)
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 48),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tidak ada klinik ditemukan',
                style: AppTextTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _permissionDenied(BuildContext context, String reason) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightPink,
            ),
            child: const Icon(
              AppIcons.locationDisabled,
              size: 60,
              color: AppTheme.darkRed,
            ),
          ),
          const SizedBox(height: 24),
          Text('Izin Lokasi Diperlukan', style: AppTextTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            reason,
            style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: LightFilledButton(
              label: 'Izinkan Lokasi',
              onTap: () => context.read<LocCubit>().requestLocationAndLoad(),
            ),
          ),
          const SizedBox(height: 32),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('atau', style: TextStyle(color: AppTheme.grey400)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          Text('Cari Klinik Berdasarkan Kota', style: AppTextTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Masukkan nama kota',
              prefixIcon: Icon(AppIcons.search),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (city) {
              if (city.trim().isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mencari klinik di $city...')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
