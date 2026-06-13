// lib/features/doctor/presentation/bloc/doctor_detail/doctor_detail_state.dart

import 'package:equatable/equatable.dart';

import '../../../domain/entity/doctor_entity.dart';
import '../../../domain/entity/doctor_slot_entity.dart';

sealed class DoctorDetailState extends Equatable {
  const DoctorDetailState();

  @override
  List<Object?> get props => [];
}

class DoctorDetailInitial extends DoctorDetailState {
  const DoctorDetailInitial();
}

class DoctorDetailLoading extends DoctorDetailState {
  const DoctorDetailLoading();
}

class DoctorDetailLoaded extends DoctorDetailState {
  final DoctorEntity doctor;
  final List<DoctorSlotEntity> sampleSlots;
  final int availableSlotCount;
  final String? suggestedSlotId;

  const DoctorDetailLoaded({
    required this.doctor,
    this.sampleSlots = const [],
    this.availableSlotCount = 0,
    this.suggestedSlotId,
  });

  DoctorDetailLoaded copyWith({
    DoctorEntity? doctor,
    List<DoctorSlotEntity>? sampleSlots,
    int? availableSlotCount,
    String? suggestedSlotId,
  }) =>
      DoctorDetailLoaded(
        doctor: doctor ?? this.doctor,
        sampleSlots: sampleSlots ?? this.sampleSlots,
        availableSlotCount: availableSlotCount ?? this.availableSlotCount,
        suggestedSlotId: suggestedSlotId ?? this.suggestedSlotId,
      );

  @override
  List<Object?> get props =>
      [doctor, sampleSlots, availableSlotCount, suggestedSlotId];
}

class DoctorDetailError extends DoctorDetailState {
  final String message;
  const DoctorDetailError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
