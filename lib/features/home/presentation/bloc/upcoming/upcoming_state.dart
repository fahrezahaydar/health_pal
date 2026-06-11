import 'package:equatable/equatable.dart';

import '../../../domain/entity/upcoming_appointment_entity.dart';

sealed class UpcomingState extends Equatable {
  const UpcomingState();

  @override
  List<Object?> get props => [];
}

class UpcomingInitial extends UpcomingState {
  const UpcomingInitial();
}

class UpcomingLoading extends UpcomingState {
  const UpcomingLoading();
}

class UpcomingLoaded extends UpcomingState {
  final UpcomingAppointmentEntity? upcoming;

  const UpcomingLoaded({this.upcoming});

  @override
  List<Object?> get props => [upcoming];
}

class UpcomingError extends UpcomingState {
  final String message;

  const UpcomingError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
