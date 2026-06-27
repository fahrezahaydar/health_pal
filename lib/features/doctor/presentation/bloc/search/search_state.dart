// lib/features/doctor/presentation/bloc/search/search_state.dart
//
// Flat/composite state — single class with all fields instead of
// sealed-class-per-variant. copyWith uses clearX flags for nullable
// fields (Dart cannot distinguish "set to null" from "not changed"
// via regular optional parameters).

import 'package:equatable/equatable.dart';

import '../../../../home/domain/entity/specialization_entity.dart';
import '../../../domain/entity/doctor_entity.dart';

const _unset = Object();

class SearchState extends Equatable {
  final List<DoctorEntity> doctors;
  final List<SpecializationEntity> specializations;
  final int currentPage;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? activeQuery;
  final String? activeSpecializationId;
  final bool hasMore;
  final Set<String> favoriteDoctorIds;

  const SearchState({
    this.doctors = const [],
    this.specializations = const [
      SpecializationEntity(id: 'all', name: 'Semua'),
    ],
    this.currentPage = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.activeQuery,
    this.activeSpecializationId,
    this.hasMore = false,
    this.favoriteDoctorIds = const {},
  });

  bool get isInitial =>
      doctors.isEmpty &&
      !isLoading &&
      !isLoadingMore &&
      errorMessage == null &&
      activeQuery == null &&
      activeSpecializationId == null;

  bool get isResultEmpty =>
      !isLoading && !isLoadingMore && doctors.isEmpty && !isInitial;

  SearchState copyWith({
    List<DoctorEntity>? doctors,
    List<SpecializationEntity>? specializations,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    Object? errorMessage = _unset,
    Object? activeQuery = _unset,
    Object? activeSpecializationId = _unset,
    bool? hasMore,
    Set<String>? favoriteDoctorIds,
  }) => SearchState(
    doctors: doctors ?? this.doctors,
    specializations: specializations ?? this.specializations,
    isLoading: isLoading ?? this.isLoading,
    currentPage: currentPage ?? this.currentPage,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    errorMessage: errorMessage == _unset
        ? this.errorMessage
        : errorMessage as String?,
    activeQuery: activeQuery == _unset
        ? this.activeQuery
        : activeQuery as String?,
    activeSpecializationId: activeSpecializationId == _unset
        ? this.activeSpecializationId
        : activeSpecializationId as String?,
    hasMore: hasMore ?? this.hasMore,
    favoriteDoctorIds: favoriteDoctorIds ?? this.favoriteDoctorIds,
  );

  @override
  List<Object?> get props => [
    doctors,
    specializations,
    isLoading,
    currentPage,
    isLoadingMore,
    errorMessage,
    activeQuery,
    activeSpecializationId,
    hasMore,
    favoriteDoctorIds,
  ];
}
