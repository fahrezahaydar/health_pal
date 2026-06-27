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

  static const int _pageSize = 10;

  SearchCubit(this._getDoctors, this._getSpecializations)
    : super(const SearchState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(isLoading: true));
    final specResult = await _getSpecializations();
    final loaded = switch (specResult) {
      Success<List<SpecializationEntity>>() => specResult.data,
      _ => <SpecializationEntity>[],
    };
    emit(
      state.copyWith(specializations: [...state.specializations, ...loaded]),
    );
    _fetch();
  }

  /// Search dokter — reset offset, replace result list.
  Future<void> _fetch({bool isAppend = false}) async {
    if (!state.isLoadingMore) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    } else {
      emit(state.copyWith(errorMessage: null));
    }
    final result = await _getDoctors(
      query: state.activeQuery,
      specializationId: state.activeSpecializationId,
      limit: _pageSize,
      offset: _pageSize * (state.currentPage - 1),
    );
    switch (result) {
      case Success<List<DoctorEntity>>():
        emit(
          state.copyWith(
            doctors: isAppend
                ? [...state.doctors, ...result.data]
                : result.data,
            isLoading: false,
            isLoadingMore: false,
            hasMore: result.data.length >= _pageSize,
          ),
        );
      case Failure<List<DoctorEntity>>():
        emit(
          state.copyWith(
            isLoadingMore: false,
            isLoading: false,
            errorMessage: result.message,
          ),
        );
    }
  }

  /// Filter by specialization — re-trigger search.
  Future<void> filterBySpecialization(String? specializationId) async {
    emit(
      state.copyWith(activeSpecializationId: specializationId, currentPage: 1),
    );
    await _fetch();
  }

  /// Append next page (infinite scroll).
  Future<void> loadMore() async {
    final s = state;
    if (!s.hasMore || s.isLoadingMore || s.isLoading || s.doctors.isEmpty) {
      return;
    }
    emit(
      state.copyWith(isLoadingMore: true, currentPage: state.currentPage + 1),
    );
    _fetch(isAppend: true);
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

  Future<void> searchDoctors(String? query) async {
    final sanitized = (query?.trim().isEmpty ?? true) ? null : query!.trim();
    emit(state.copyWith(activeQuery: sanitized, currentPage: 1));
    _fetch();
  }

  Future<void> reset(String? query) async {
    emit(state.copyWith(activeQuery: null, currentPage: 1));
    _fetch();
  }
}
