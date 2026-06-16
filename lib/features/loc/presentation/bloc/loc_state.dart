// lib/features/loc/presentation/bloc/loc_state.dart

import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entity/clinic_entity.dart';

sealed class LocState extends Equatable {
  const LocState();
  @override
  List<Object?> get props => [];
}

class LocInitial extends LocState {
  const LocInitial();
}

/// State saat user menolak permission lokasi.
class LocPermissionDenied extends LocState {
  /// Bisa 'denied' (first time) atau 'deniedForever' (permanently).
  final String reason;
  const LocPermissionDenied({this.reason = ''});

  @override
  List<Object?> get props => [reason];
}

class LocLoading extends LocState {
  const LocLoading();
}

class LocLoaded extends LocState {
  final List<ClinicEntity> clinics;
  final Position currentPosition;
  final double radiusKm;
  final String? selectedSpecialization;
  final String sortBy;

  const LocLoaded({
    required this.clinics,
    required this.currentPosition,
    this.radiusKm = 10.0,
    this.selectedSpecialization,
    this.sortBy = 'distance',
  });

  LocLoaded copyWith({
    List<ClinicEntity>? clinics,
    Position? currentPosition,
    double? radiusKm,
    String? selectedSpecialization,
    String? sortBy,
  }) =>
      LocLoaded(
        clinics: clinics ?? this.clinics,
        currentPosition: currentPosition ?? this.currentPosition,
        radiusKm: radiusKm ?? this.radiusKm,
        selectedSpecialization:
            selectedSpecialization ?? this.selectedSpecialization,
        sortBy: sortBy ?? this.sortBy,
      );

  @override
  List<Object?> get props =>
      [clinics, currentPosition, radiusKm, selectedSpecialization, sortBy];
}

class LocError extends LocState {
  final String message;
  const LocError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
