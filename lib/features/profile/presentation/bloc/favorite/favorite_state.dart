// lib/features/profile/presentation/bloc/favorite/favorite_state.dart

import 'package:equatable/equatable.dart';

import '../../../../doctor/domain/entity/doctor_entity.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

class FavoriteLoaded extends FavoriteState {
  final List<DoctorEntity> doctors;
  const FavoriteLoaded(this.doctors);

  @override
  List<Object?> get props => [doctors];
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
