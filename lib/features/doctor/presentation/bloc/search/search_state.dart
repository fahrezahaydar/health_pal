// lib/features/doctor/presentation/bloc/search/search_state.dart

import 'package:equatable/equatable.dart';

import '../../../domain/entity/doctor_entity.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<DoctorEntity> doctors;
  final String? activeQuery;
  final String? activeSpecializationId;
  final bool hasMore;

  const SearchLoaded({
    this.doctors = const [],
    this.activeQuery,
    this.activeSpecializationId,
    this.hasMore = false,
  });

  SearchLoaded copyWith({
    List<DoctorEntity>? doctors,
    String? activeQuery,
    String? activeSpecializationId,
    bool? hasMore,
  }) =>
      SearchLoaded(
        doctors: doctors ?? this.doctors,
        activeQuery: activeQuery ?? this.activeQuery,
        activeSpecializationId:
            activeSpecializationId ?? this.activeSpecializationId,
        hasMore: hasMore ?? this.hasMore,
      );

  @override
  List<Object?> get props =>
      [doctors, activeQuery, activeSpecializationId, hasMore];
}

class SearchEmpty extends SearchState {
  final String? lastQuery;
  const SearchEmpty({this.lastQuery});

  @override
  List<Object?> get props => [lastQuery];
}

class SearchError extends SearchState {
  final String message;
  const SearchError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
