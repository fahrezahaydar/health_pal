import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import '../../../../core/enums/booking_status.dart';

/// Entity untuk "Upcoming Treatment" card di Home Page.
///
/// **Sprint 2 — Task A3 (Fix K3):** slot fields sudah typed
/// sesuai TDD 05 §3.2:
/// - `slotDate` = `DateTime?` (DATE-only dari PostgreSQL, parsed via
///   `DateOnlyJsonConverter` di model)
/// - `slotStart`, `slotEnd` = `TimeOfDay?` (TIME-only, parsed via
///   `TimeOnlyJsonConverter`)
///
/// **Sprint 2 — Task A5 (Fix M3):** `status` sudah typed ke
/// `BookingStatus` enum (bukan `String`), jadi UI tidak perlu
/// `BookingStatus.values.firstWhere(...)` yang fallback ke
/// `pending` tanpa warning. Pakai `BookingStatus.fromJson()` di
/// model, yang pakai `switch` eksplisit untuk semua known status
/// dan `_ => BookingStatus.pending` untuk unknown value.
///
/// `slotDate`, `slotStart`, `slotEnd` nullable (bukan magic default)
/// untuk safety: jika API kirim null/malformed, tidak ada epoch-0 atau
/// 00:00 default yang confusing di UI.
class UpcomingAppointmentEntity extends Equatable {
  final String id;
  final String doctorName;
  final String? doctorPhoto;
  final String clinicName;
  final String specializationName;
  final DateTime? slotDate;
  final TimeOfDay? slotStart;
  final TimeOfDay? slotEnd;
  final BookingStatus status;

  const UpcomingAppointmentEntity({
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

  @override
  List<Object?> get props => [
        id,
        doctorName,
        doctorPhoto,
        clinicName,
        specializationName,
        slotDate,
        slotStart,
        slotEnd,
        status,
      ];
}
