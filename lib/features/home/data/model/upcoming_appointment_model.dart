import 'package:flutter/material.dart' show TimeOfDay;

import '../../../../core/network/json_converters.dart';
import '../../domain/entity/upcoming_appointment_entity.dart';

/// Model untuk "Upcoming Treatment" card di Home Page.
///
/// **Sprint 2 — Task A3 (Fix K3):** slot fields di-parse menggunakan
/// converters dari `core/network/json_converters.dart` (per TDD 05 §3.2):
/// - `slotDate` (raw "YYYY-MM-DD") → `DateTime?` via `DateOnlyJsonConverter`
/// - `slotStart`/`slotEnd` (raw "HH:MM:SS") → `TimeOfDay?` via
///   `TimeOnlyJsonConverter`
///
/// Model masih manual (bukan `@freezed`) — refactor ke `@freezed` +
/// `@JsonKey` adalah task B1 (Pool B). Untuk A3, kita pakai converters
/// secara inline di `fromJson`.
///
/// `status` masih `String` — enum mapping adalah A5.
class UpcomingAppointmentModel {
  static const _dateConverter = DateOnlyJsonConverter();
  static const _timeConverter = TimeOnlyJsonConverter();

  final String id;
  final String doctorName;
  final String? doctorPhoto;
  final String clinicName;
  final String specializationName;
  final DateTime? slotDate;
  final TimeOfDay? slotStart;
  final TimeOfDay? slotEnd;
  final String status;

  const UpcomingAppointmentModel({
    required this.id,
    required this.doctorName,
    this.doctorPhoto,
    required this.clinicName,
    required this.specializationName,
    required this.slotDate,
    required this.slotStart,
    required this.slotEnd,
    required this.status,
  });

  factory UpcomingAppointmentModel.fromJson(Map<String, dynamic> json) {
    final doctors = json['doctors'] as Map<String, dynamic>?;
    final slots = json['doctor_slots'] as Map<String, dynamic>?;

    final clinics = doctors?['clinics'] as Map<String, dynamic>?;
    final specializations =
        doctors?['specializations'] as Map<String, dynamic>?;

    return UpcomingAppointmentModel(
      id: json['id'] as String,
      doctorName: doctors?['full_name'] as String? ?? '',
      doctorPhoto: doctors?['photo_url'] as String?,
      clinicName: clinics?['name'] as String? ?? '',
      specializationName: specializations?['name'] as String? ?? '',
      slotDate: _dateConverter.fromJson(slots?['slot_date'] as String?),
      slotStart: _timeConverter.fromJson(slots?['slot_start'] as String?),
      slotEnd: _timeConverter.fromJson(slots?['slot_end'] as String?),
      status: json['status'] as String? ?? '',
    );
  }

  UpcomingAppointmentEntity toEntity() => UpcomingAppointmentEntity(
        id: id,
        doctorName: doctorName,
        doctorPhoto: doctorPhoto,
        clinicName: clinicName,
        specializationName: specializationName,
        slotDate: slotDate,
        slotStart: slotStart,
        slotEnd: slotEnd,
        status: status,
      );
}
