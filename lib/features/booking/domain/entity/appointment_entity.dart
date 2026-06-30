// lib/features/booking/domain/entity/appointment_entity.dart
//
// Entity untuk appointment — nested entities sederhana (BookingDoctorEntity,
// BookingSlotEntity) yang TIDAK depend pada DoctorEntity/DoctorSlotEntity
// (lihat catatan di appointment_model.dart untuk alasannya).

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import '../../../../core/utils/date_formatter.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String slotId;
  final String status; // 'pending' | 'upcoming' | 'completed' | 'cancelled'
  final String? complaintNote;
  final double consultationFeeSnapshot;
  final DateTime? bookedAt;
  final DateTime? confirmedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ── Nested (subset dari PostgREST JOIN) ──
  final AppointmentDoctorEntity? doctor;
  final AppointmentSlotEntity? slot;

  const AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.slotId,
    required this.status,
    this.complaintNote,
    required this.consultationFeeSnapshot,
    this.bookedAt,
    this.confirmedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
    this.doctor,
    this.slot,
  });

  static AppointmentEntity mock() => AppointmentEntity(
    id: 'sk-1',
    patientId: 'sk-patient',
    doctorId: 'sk-doctor',
    slotId: 'sk-slot',
    status: 'pending',
    consultationFeeSnapshot: 0,
    doctor: AppointmentDoctorEntity.mock(),
    slot: AppointmentSlotEntity.mock(),
  );

  /// Derived: display name untuk doctor.
  String get doctorName => doctor?.fullName ?? 'Dokter';

  /// Derived: specialization name.
  String get specializationName => doctor?.specializationName ?? 'Umum';

  /// Derived: clinic name.
  String get clinicName => doctor?.clinicName ?? 'Klinik';

  /// Derived: clinic address (untuk booking detail).
  String? get clinicAddress => doctor?.clinicAddress;

  /// Derived: clinic phone.
  String? get clinicPhone => doctor?.clinicPhone;

  /// Derived: doctor photo URL.
  String? get doctorPhotoUrl => doctor?.photoUrl;

  /// Derived: experience years.
  int get experienceYears => doctor?.experienceYears ?? 0;

  /// Derived: slot date.
  DateTime? get slotDate => slot?.slotDate;

  /// Derived: start time "09:00".
  String? get startTimeDisplay => slot?.startTimeDisplay;

  /// Derived: end time "09:30".
  String? get endTimeDisplay => slot?.endTimeDisplay;

  /// Derived: time range "09:00 - 09:30".
  String? get timeRangeDisplay => slot?.timeRangeDisplay;

  @override
  List<Object?> get props => [
    id,
    patientId,
    doctorId,
    slotId,
    status,
    complaintNote,
    consultationFeeSnapshot,
    bookedAt,
    confirmedAt,
    completedAt,
    cancelledAt,
    cancellationReason,
    createdAt,
    updatedAt,
    doctor,
    slot,
  ];
}

class AppointmentDoctorEntity extends Equatable {
  final String id;
  final String fullName;
  final String? photoUrl;
  final int experienceYears;
  final String specializationName;
  final String clinicName;
  final String? clinicAddress;
  final String? clinicPhone;

  const AppointmentDoctorEntity({
    required this.id,
    required this.fullName,
    this.photoUrl,
    required this.experienceYears,
    required this.specializationName,
    required this.clinicName,
    this.clinicAddress,
    this.clinicPhone,
  });

  static AppointmentDoctorEntity mock() => const AppointmentDoctorEntity(
    id: 'sk-1',
    fullName: 'Loading Doctor',
    experienceYears: 0,
    specializationName: 'Umum',
    clinicName: 'Klinik',
  );

  @override
  List<Object?> get props => [
    id,
    fullName,
    photoUrl,
    experienceYears,
    specializationName,
    clinicName,
    clinicAddress,
    clinicPhone,
  ];
}

class AppointmentSlotEntity extends Equatable {
  final DateTime slotDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const AppointmentSlotEntity({
    required this.slotDate,
    required this.startTime,
    required this.endTime,
  });

  static AppointmentSlotEntity mock() => AppointmentSlotEntity(
    slotDate: DateTime(2024, 1, 15),
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 9, minute: 30),
  );

  String get startTimeDisplay {
    final h = startTime.hour.toString().padLeft(2, '0');
    final m = startTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get endTimeDisplay {
    final h = endTime.hour.toString().padLeft(2, '0');
    final m = endTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get display =>
      '${DateFormatter.toShortDate(slotDate)} - $startTimeDisplay';

  String get timeRangeDisplay => '$startTimeDisplay - $endTimeDisplay';

  @override
  List<Object?> get props => [slotDate, startTime, endTime];
}
