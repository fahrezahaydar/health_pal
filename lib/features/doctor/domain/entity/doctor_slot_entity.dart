// lib/features/doctor/domain/entity/doctor_slot_entity.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show TimeOfDay;

class DoctorSlotEntity extends Equatable {
  final String id;
  final String doctorId;
  final String? scheduleId;
  final DateTime slotDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isBooked;

  const DoctorSlotEntity({
    required this.id,
    required this.doctorId,
    this.scheduleId,
    required this.slotDate,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  /// Helper: durasi slot dalam menit (untuk display).
  int get durationMinutes {
    final startMin = startTime.hour * 60 + startTime.minute;
    final endMin = endTime.hour * 60 + endTime.minute;
    return endMin - startMin;
  }

  /// Helper: format "09:00" untuk display.
  String get startTimeDisplay {
    final h = startTime.hour.toString().padLeft(2, '0');
    final m = startTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Helper: range "09:00 - 09:30" untuk display.
  String get timeRangeDisplay {
    final eh = endTime.hour.toString().padLeft(2, '0');
    final em = endTime.minute.toString().padLeft(2, '0');
    return '$startTimeDisplay - $eh:$em';
  }

  @override
  List<Object?> get props => [
        id,
        doctorId,
        scheduleId,
        slotDate,
        startTime,
        endTime,
        isBooked,
      ];
}
