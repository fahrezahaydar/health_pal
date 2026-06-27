// lib/features/doctor/presentation/bloc/search/search_state.dart
//
// Flat/composite state — single class with all fields instead of
// sealed-class-per-variant. copyWith uses clearX flags for nullable
// fields (Dart cannot distinguish "set to null" from "not changed"
// via regular optional parameters).

import 'package:equatable/equatable.dart';

import '../../../../home/domain/entity/specialization_entity.dart';
import '../../../domain/entity/doctor_entity.dart';

class SearchState extends Equatable {
  final List<DoctorEntity> doctors;
  final List<SpecializationEntity> specializations;
  final bool isLoadingDoctors;
  final bool isLoadingSpecializations;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? activeQuery;
  final String? activeSpecializationId;
  final bool hasMore;
  final Set<String> favoriteDoctorIds;

  const SearchState({
    this.doctors = const [],
    this.specializations = const [],
    this.isLoadingDoctors = false,
    this.isLoadingSpecializations = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.activeQuery,
    this.activeSpecializationId,
    this.hasMore = false,
    this.favoriteDoctorIds = const {},
  });

  bool get isInitial =>
      doctors.isEmpty &&
      !isLoadingDoctors &&
      !isLoadingMore &&
      errorMessage == null &&
      activeQuery == null &&
      activeSpecializationId == null;

  bool get isResultEmpty =>
      !isLoadingDoctors && !isLoadingMore && doctors.isEmpty && !isInitial;

  SearchState copyWith({
    List<DoctorEntity>? doctors,
    List<SpecializationEntity>? specializations,
    bool? isLoadingDoctors,
    bool? isLoadingSpecializations,
    bool? isLoadingMore,
    // clearX flags: pass any non-null value to reset the corresponding
    // nullable field back to null.
    Object? clearError,
    String? errorMessage,
    Object? clearQuery,
    String? activeQuery,
    Object? clearSpecialization,
    String? activeSpecializationId,
    bool? hasMore,
    Set<String>? favoriteDoctorIds,
  }) =>
      SearchState(
        doctors: doctors ?? this.doctors,
        specializations: specializations ?? this.specializations,
        isLoadingDoctors: isLoadingDoctors ?? this.isLoadingDoctors,
        isLoadingSpecializations:
            isLoadingSpecializations ?? this.isLoadingSpecializations,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        errorMessage:
            clearError != null ? null : errorMessage ?? this.errorMessage,
        activeQuery:
            clearQuery != null ? null : activeQuery ?? this.activeQuery,
        activeSpecializationId: clearSpecialization != null
            ? null
            : activeSpecializationId ?? this.activeSpecializationId,
        hasMore: hasMore ?? this.hasMore,
        favoriteDoctorIds: favoriteDoctorIds ?? this.favoriteDoctorIds,
      );

  @override
  List<Object?> get props => [
        doctors,
        specializations,
        isLoadingDoctors,
        isLoadingSpecializations,
        isLoadingMore,
        errorMessage,
        activeQuery,
        activeSpecializationId,
        hasMore,
        favoriteDoctorIds,
      ];
}
