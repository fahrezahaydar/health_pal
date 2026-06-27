// lib/features/doctor/presentation/bloc/search/search_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../home/domain/entity/specialization_entity.dart';
import '../../../../home/domain/usecase/get_specializations_usecase.dart';
import '../../../domain/entity/doctor_entity.dart';
import '../../../domain/usecase/get_doctors_usecase.dart';
import 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final GetDoctorsUseCase _getDoctors;
  final GetSpecializationsUseCase _getSpecializations;

  int _offset = 0;
  String? _lastQuery;
  String? _lastSpecializationId;
  static const int _pageSize = 20;

  SearchCubit(this._getDoctors, this._getSpecializations)
      : super(const SearchState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(isLoadingSpecializations: true));
    final specResult = await _getSpecializations();
    final specs = switch (specResult) {
      Success<List<SpecializationEntity>>() => specResult.data,
      _ => <SpecializationEntity>[],
    };
    emit(state.copyWith(
      specializations: specs,
      isLoadingSpecializations: false,
    ));
    searchDoctors(null);
  }

  /// Search dokter — reset offset, replace result list.
  Future<void> searchDoctors(String? query) async {
    _lastQuery = (query?.trim().isEmpty ?? true) ? null : query!.trim();
    _offset = 0;
    emit(state.copyWith(
      isLoadingDoctors: true,
      clearError: true,
      activeQuery: _lastQuery,
    ));
    final result = await _getDoctors(
      query: _lastQuery,
      specializationId: _lastSpecializationId,
      limit: _pageSize,
      offset: _offset,
    );
    switch (result) {
      case Success<List<DoctorEntity>>():
        _offset += result.data.length;
        emit(state.copyWith(
          doctors: result.data,
          isLoadingDoctors: false,
          hasMore: result.data.length >= _pageSize,
        ));
      case Failure<List<DoctorEntity>>():
        emit(state.copyWith(
          isLoadingDoctors: false,
          errorMessage: result.message,
        ));
    }
  }

  /// Filter by specialization — re-trigger search.
  Future<void> filterBySpecialization(String? specializationId) async {
    _lastSpecializationId = specializationId;
    emit(state.copyWith(activeSpecializationId: specializationId));
    await searchDoctors(_lastQuery);
  }

  /// Append next page (infinite scroll).
  Future<void> loadMore() async {
    final s = state;
    if (!s.hasMore ||
        s.isLoadingMore ||
        s.isLoadingDoctors ||
        s.doctors.isEmpty) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    final result = await _getDoctors(
      query: _lastQuery,
      specializationId: _lastSpecializationId,
      limit: _pageSize,
      offset: _offset,
    );
    switch (result) {
      case Success<List<DoctorEntity>>():
        _offset += result.data.length;
        emit(state.copyWith(
          doctors: [...s.doctors, ...result.data],
          isLoadingMore: false,
          hasMore: result.data.length >= _pageSize,
        ));
      case Failure<List<DoctorEntity>>():
        // Preserve existing list on failure
        emit(state.copyWith(isLoadingMore: false));
    }
  }

  /// Toggle favorite status (local state, tidak persist ke server).
  void toggleFavorite(String doctorId) {
    final ids = Set<String>.from(state.favoriteDoctorIds);
    if (ids.contains(doctorId)) {
      ids.remove(doctorId);
    } else {
      ids.add(doctorId);
    }
    emit(state.copyWith(favoriteDoctorIds: ids));
  }

  /// Reset semua state ke initial.
  void clearSearch() {
    _lastQuery = null;
    _lastSpecializationId = null;
    _offset = 0;
    emit(const SearchState(
      specializations: [],
      isLoadingSpecializations: false,
    ));
  }
}
