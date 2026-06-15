import 'package:equatable/equatable.dart';

import '../../../../loc/domain/entity/clinic_entity.dart';

sealed class NearbyState extends Equatable {
  const NearbyState();

  @override
  List<Object?> get props => [];
}

class NearbyInitial extends NearbyState {
  const NearbyInitial();
}

class NearbyLoading extends NearbyState {
  const NearbyLoading();
}

class NearbyLoaded extends NearbyState {
  final List<ClinicEntity> clinics;

  const NearbyLoaded({required this.clinics});

  @override
  List<Object?> get props => [clinics];
}

class NearbyEmpty extends NearbyState {
  const NearbyEmpty();
}

class NearbyLocationDenied extends NearbyState {
  final String reason;

  const NearbyLocationDenied({this.reason = ''});

  @override
  List<Object?> get props => [reason];
}

class NearbyError extends NearbyState {
  final String message;

  const NearbyError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
