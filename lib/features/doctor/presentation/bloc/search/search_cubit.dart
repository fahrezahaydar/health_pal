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

  List<SpecializationEntity> specializations = [];

  /// Internal state for pagination.
  int _offset = 0;
  String? _lastQuery;
  String? _lastSpecializationId;
  static const int _pageSize = 20;

  SearchCubit(this._getDoctors, this._getSpecializations)
      : super(const SearchInitial());

  /// Search dokter berdasarkan query (nama / spesialisasi).
  /// Reset offset, replace result list.
  Future<void> searchDoctors(String? query) async {
    _lastQuery = (query?.trim().isEmpty ?? true) ? null : query!.trim();
    _offset = 0;
    emit(const SearchLoading());
    final result = await _getDoctors(
      query: _lastQuery,
      specializationId: _lastSpecializationId,
      limit: _pageSize,
      offset: _offset,
    );
    switch (result) {
      case Success<List<DoctorEntity>>():
        if (result.data.isEmpty) {
          emit(SearchEmpty(lastQuery: _lastQuery));
        } else {
          _offset += result.data.length;
          emit(SearchLoaded(
            doctors: result.data,
            activeQuery: _lastQuery,
            activeSpecializationId: _lastSpecializationId,
            hasMore: result.data.length >= _pageSize,
          ));
        }
      case Failure<List<DoctorEntity>>():
        emit(SearchError(message: result.message));
    }
  }

  /// Filter by specialization (replace result, keep query).
  Future<void> filterBySpecialization(String? specializationId) async {
    _lastSpecializationId = specializationId;
    await searchDoctors(_lastQuery);
  }

  /// Append next page of results (infinite scroll).
  Future<void> loadMore() async {
    final current = state;
    if (current is! SearchLoaded || !current.hasMore) return;
    final result = await _getDoctors(
      query: _lastQuery,
      specializationId: _lastSpecializationId,
      limit: _pageSize,
      offset: _offset,
    );
    switch (result) {
      case Success<List<DoctorEntity>>():
        _offset += result.data.length;
        emit(current.copyWith(
          doctors: [...current.doctors, ...result.data],
          hasMore: result.data.length >= _pageSize,
        ));
      case Failure<List<DoctorEntity>>():
        emit(SearchError(message: result.message));
    }
  }

  /// Load specializations from repository (for filter chips).
  Future<void> loadSpecializations() async {
    final result = await _getSpecializations();
    switch (result) {
      case Success<List<SpecializationEntity>>():
        specializations = result.data;
      case _:
        specializations = [];
    }
  }

  /// Reset to initial (clear all results).
  void clearSearch() {
    _lastQuery = null;
    _lastSpecializationId = null;
    _offset = 0;
    emit(const SearchInitial());
  }
}
