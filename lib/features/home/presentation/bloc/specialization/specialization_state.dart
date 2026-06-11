import 'package:equatable/equatable.dart';

import '../../../domain/entity/specialization_entity.dart';

sealed class SpecializationState extends Equatable {
  const SpecializationState();

  @override
  List<Object?> get props => [];
}

class SpecializationInitial extends SpecializationState {
  const SpecializationInitial();
}

class SpecializationLoading extends SpecializationState {
  const SpecializationLoading();
}

class SpecializationLoaded extends SpecializationState {
  final List<SpecializationEntity> specializations;

  const SpecializationLoaded({this.specializations = const []});

  @override
  List<Object?> get props => [specializations];
}

class SpecializationError extends SpecializationState {
  final String message;

  const SpecializationError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
