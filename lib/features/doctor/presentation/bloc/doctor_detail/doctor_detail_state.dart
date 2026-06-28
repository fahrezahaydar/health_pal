// lib/features/doctor/presentation/bloc/doctor_detail/doctor_detail_state.dart

import 'package:equatable/equatable.dart';

import '../../../domain/entity/doctor_entity.dart';
import '../../../domain/entity/doctor_schedule_entity.dart';

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
  final List<DoctorScheduleEntity> schedules;
  final String? suggestedSlotId;

  const DoctorDetailLoaded({
    required this.doctor,
    this.schedules = const [],
    this.suggestedSlotId,
  });

  DoctorDetailLoaded copyWith({
    DoctorEntity? doctor,
    List<DoctorScheduleEntity>? schedules,
    String? suggestedSlotId,
  }) =>
      DoctorDetailLoaded(
        doctor: doctor ?? this.doctor,
        schedules: schedules ?? this.schedules,
        suggestedSlotId: suggestedSlotId ?? this.suggestedSlotId,
      );

  @override
  List<Object?> get props => [doctor, schedules, suggestedSlotId];
}

class DoctorDetailError extends DoctorDetailState {
  final String message;
  const DoctorDetailError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
