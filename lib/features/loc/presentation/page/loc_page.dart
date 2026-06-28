import 'package:carousel_slider_plus/carousel_slider_plus.dart';
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
  final _pageController = PageController();
  int _lastAutoScrolledIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LocCubit>().requestLocationAndLoad();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocCubit, LocState>(
        builder: (context, state) {
          return switch (state) {
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
            _ => _loadingSkeleton(context),
          };
        },
      ),
    );
  }

  Widget _loadingSkeleton(BuildContext context) {
    final mock = ClinicEntity.mock();
    final screenWidth = MediaQuery.of(context).size.width;

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
              child: CarouselSlider(
                items: mock.map((c) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 240,
                    child: ClinicCard(clinic: c),
                  ),
                )).toList(),
                options: CarouselOptions(
                  height: 210,
                  viewportFraction: (240 + 16) / screenWidth,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  padEnds: false,
                ),
              ),
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
    final screenWidth = MediaQuery.of(context).size.width;

    if (selectedClinicId != null) {
      final idx = clinics.indexWhere((c) => c.id == selectedClinicId);
      if (idx >= 0 && idx != _lastAutoScrolledIndex) {
        _lastAutoScrolledIndex = idx;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _pageController.animateToPage(
              idx,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
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
              child: CarouselSlider(
                items: clinics.map((c) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 240,
                    child: ClinicCard(
                      clinic: c,
                      isSelected: c.id == selectedClinicId,
                      onTap: () {
                        cubit.selectClinic(c.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(c.name)),
                        );
                      },
                      onFavoriteTap: () => cubit.toggleFavorite(c.id),
                    ),
                  ),
                )).toList(),
                options: CarouselOptions(
                  height: 210,
                  viewportFraction: (240 + 16) / screenWidth,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  padEnds: false,
                ),
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
