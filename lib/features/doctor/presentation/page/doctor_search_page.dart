// lib/features/doctor/presentation/page/doctor_search_page.dart
//
// Halaman pencarian dokter. Pattern search bar + debouncer (300ms) +
// filter chips + list of doctor cards. TIDAK ADA date picker (per SS#10).
//
// Semua widget di-render inline di build() — tidak ada private methods.
// State management via flat SearchState di SearchCubit.
//
// Struktur:
// - DoctorSearchPage: StatelessWidget (BlocProvider)
// - DoctorSearchView: StatefulWidget (controllers, debouncer, scroll listener)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart' show getIt;
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../widgets/card/doctor_card.dart';
import '../../../../widgets/loader/dot_loader.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/shared/empty_state_view.dart';
import '../../../home/domain/entity/specialization_entity.dart';
import '../bloc/search/search_cubit.dart';
import '../bloc/search/search_state.dart';
import '../widget/doctor_filter_chip.dart';

class DoctorSearchPage extends StatelessWidget {
  const DoctorSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (_) => getIt<SearchCubit>(),
      child: const DoctorSearchView(),
    );
  }
}

class DoctorSearchView extends StatefulWidget {
  const DoctorSearchView({super.key});

  @override
  State<DoctorSearchView> createState() => DoctorSearchViewState();
}

class DoctorSearchViewState extends State<DoctorSearchView> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _debouncer = Debouncer(const Duration(milliseconds: 300));
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      final cubit = context.read<SearchCubit>();
      final state = cubit.state;

      if (!state.hasMore ||
          state.isLoading ||
          state.isLoadingMore ||
          state.doctors.isEmpty) {
        return;
      }

      final position = _scrollController.position;

      if (position.pixels >= position.maxScrollExtent - 200) {
        cubit.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
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
        title: Text('Cari Dokter', style: AppTextTheme.titleLarge),
      ),
      body: Column(
        spacing: 16,
        children: [
          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                _debouncer(() {
                  if (!mounted) return;
                  context.read<SearchCubit>().searchDoctors(value);
                });
              },
              style: AppTextTheme.bodySmall,
              decoration: InputDecoration(
                hintText: 'Nama / Spesialisasi',
                prefixIcon: const Icon(
                  AppIcons.searchNormal,
                  color: AppTheme.grey400,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          AppIcons.closeCircle,
                          color: AppTheme.grey400,
                        ),
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchCubit>().searchDoctors(null);
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.grey100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── Filter Chips ──
          BlocSelector<
            SearchCubit,
            SearchState,
            ({List<SpecializationEntity> specs, String? activeId})
          >(
            selector: (s) =>
                (specs: s.specializations, activeId: s.activeSpecializationId),
            builder: (context, selected) {
              final specs = selected.specs;
              final activeId = selected.activeId;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  spacing: 8,
                  children: specs.map((spec) {
                    final isAll = spec.id == 'all';
                    final isSelected = isAll
                        ? activeId == null
                        : activeId == spec.id;
                    return DoctorFilterChip(
                      label: spec.name,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<SearchCubit>().filterBySpecialization(
                          isAll ? null : spec.id,
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),

          // ── Results ──
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  context.read<SearchCubit>().searchDoctors(_controller.text),
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.separated(
                        itemCount: 3,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, _) => const DoctorCard(
                          name: 'Memuat...',
                          specialization: 'Memuat...',
                          clinic: 'Memuat...',
                        ),
                      ),
                    );
                  }

                  if (state.errorMessage != null && state.doctors.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: ErrorSection(
                        message: state.errorMessage!,
                        onRetry: () =>
                            context.read<SearchCubit>().searchDoctors(null),
                      ),
                    );
                  }

                  if (state.isResultEmpty) {
                    return const EmptyStateView(
                      icon: Icons.search_off,
                      message: 'Dokter tidak ditemukan',
                      hint: 'Coba gunakan kata kunci lain',
                    );
                  }

                  final doctors = state.doctors;
                  final hasMore = state.hasMore;
                  final cubit = context.read<SearchCubit>();
                  final favIds = state.favoriteDoctorIds;

                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: doctors.length + (hasMore ? 1 : 0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index >= doctors.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: DotLoader()),
                        );
                      }
                      final d = doctors[index];
                      return DoctorCard(
                        name: d.fullName,
                        specialization: d.specializationName,
                        rating: d.ratingAvg,
                        reviewCount: d.ratingCount,
                        clinic: d.clinicName,
                        photoUrl: d.photoUrl,
                        isFavorite: favIds.contains(d.id),
                        onTap: () => context.push(
                          RoutePaths.doctorDetail.replaceAll(':doctorId', d.id),
                        ),
                        onFavoriteTap: () => cubit.toggleFavorite(d.id),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
