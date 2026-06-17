// lib/features/doctor/presentation/page/doctor_search_page.dart
//
// Halaman pencarian dokter. Pattern search bar + debouncer (300ms) +
// filter chips + list of doctor cards. TIDAK ADA date picker (per SS#10).
//
// Per docs/wireframe/08-doctor-search.md.
//
// Struktur (sama dengan features/home/presentation/page/home_page.dart):
// - DoctorSearchPage: StatelessWidget yang hanya menyediakan BlocProvider
// - DoctorSearchView: StatefulWidget yang berisi semua state, controller,
//   debouncer, dan UI. Dipisah agar BlocProvider tidak re-create saat
//   parent rebuild.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/network/result.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../widgets/card/doctor_card.dart';
import '../../../../widgets/loader/dot_loader.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/shared/empty_state_view.dart';
import '../../../home/domain/entity/specialization_entity.dart';
import '../../../home/domain/usecase/get_specializations_usecase.dart';
import '../../domain/entity/doctor_entity.dart';
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

const _mockDoctors = [
  DoctorEntity(id: 'sk-1', clinicId: 'sk-c', specializationId: 'sk-s',
      fullName: 'Loading Doctor 1', experienceYears: 0, consultationFee: 0),
  DoctorEntity(id: 'sk-2', clinicId: 'sk-c', specializationId: 'sk-s',
      fullName: 'Loading Doctor 2', experienceYears: 0, consultationFee: 0),
  DoctorEntity(id: 'sk-3', clinicId: 'sk-c', specializationId: 'sk-s',
      fullName: 'Loading Doctor 3', experienceYears: 0, consultationFee: 0),
];

class DoctorSearchView extends StatefulWidget {
  const DoctorSearchView({super.key});

  @override
  State<DoctorSearchView> createState() => DoctorSearchViewState();
}

class DoctorSearchViewState extends State<DoctorSearchView> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late final Debouncer _debouncer;
  String? _selectedSpecializationId;
  List<SpecializationEntity> _specializations = [];

  // Static "Semua" chip yang selalu muncul di awal.
  static const _allChip = SpecializationEntity(id: 'all', name: 'Semua');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _debouncer = Debouncer(const Duration(milliseconds: 300));
    _scrollController.addListener(_onScroll);
    _loadSpecializations();
  }

  Future<void> _loadSpecializations() async {
    final result = await getIt<GetSpecializationsUseCase>()();
    if (!mounted) return;
    switch (result) {
      case Success<List<SpecializationEntity>>():
        setState(() => _specializations = result.data);
      case _:
        // Fallback untuk jika gagal load — minimal ada "Semua" chip.
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debouncer(() {
      if (!mounted) return;
      context.read<SearchCubit>().searchDoctors(value);
    });
  }

  void _onFilterTap(String? id) {
    setState(() => _selectedSpecializationId = id);
    context.read<SearchCubit>().filterBySpecialization(id);
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
        children: [
          // ── Search Bar ──
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Nama / Spesialisasi',
                prefixIcon: const Icon(Icons.search, color: AppTheme.grey400),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppTheme.grey400,
                        ),
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchCubit>().clearSearch();
                          setState(() {});
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
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _specializations.length + 1,
                itemBuilder: (context, index) {
                  final spec = index == 0
                      ? _allChip
                      : _specializations[index - 1];
                  final isAll = spec.id == 'all';
                  final isSelected = isAll
                      ? _selectedSpecializationId == null
                      : _selectedSpecializationId == spec.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: DoctorFilterChip(
                      label: spec.name,
                      isSelected: isSelected,
                      onTap: () => _onFilterTap(isAll ? null : spec.id),
                    ),
                  );
                },
              ),
            ),
          ),
          // ── Results ──
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  context.read<SearchCubit>().searchDoctors(_controller.text),
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return switch (state) {
                    SearchInitial() => const EmptyStateView(
                        icon: Icons.search,
                        message: 'Cari dokter berdasarkan nama atau spesialisasi',
                      ),
                    SearchLoading() => Skeletonizer(
                        enabled: true,
                        child: _buildList(_mockDoctors, true),
                      ),
                    SearchEmpty() => const EmptyStateView(
                        icon: Icons.search_off,
                        message: 'Dokter tidak ditemukan',
                        hint: 'Coba gunakan kata kunci lain',
                      ),
                    SearchError(:final message) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: ErrorSection(
                          message: message,
                          onRetry: () =>
                              context.read<SearchCubit>().searchDoctors(null),
                        ),
                      ),
                    SearchLoaded(:final doctors, :final hasMore) =>
                      _buildList(doctors, hasMore),
                  };
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<DoctorEntity> doctors, bool hasMore) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: doctors.length + (hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
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
          fee: d.consultationFee,
          clinic: d.clinicName,
          photoUrl: d.photoUrl,
          onTap: () => context.push(
            RoutePaths.doctorDetail.replaceAll(':doctorId', d.id),
          ),
        );
      },
    );
  }

}
