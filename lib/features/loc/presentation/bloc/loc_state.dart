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
  final String? searchKeyword;
  final String? selectedClinicId;

  const LocLoaded({
    required this.clinics,
    required this.currentPosition,
    this.radiusKm = 10.0,
    this.searchKeyword,
    this.selectedClinicId,
  });

  LocLoaded copyWith({
    List<ClinicEntity>? clinics,
    Position? currentPosition,
    double? radiusKm,
    String? searchKeyword,
    String? selectedClinicId,
    bool clearSearch = false,
    bool clearSelected = false,
  }) =>
      LocLoaded(
        clinics: clinics ?? this.clinics,
        currentPosition: currentPosition ?? this.currentPosition,
        radiusKm: radiusKm ?? this.radiusKm,
        searchKeyword: clearSearch ? null : (searchKeyword ?? this.searchKeyword),
        selectedClinicId: clearSelected ? null : (selectedClinicId ?? this.selectedClinicId),
      );

  @override
  List<Object?> get props =>
      [clinics, currentPosition, radiusKm, searchKeyword, selectedClinicId];
}

class LocError extends LocState {
  final String message;
  const LocError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
