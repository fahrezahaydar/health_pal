// lib/features/doctor/data/model/doctor_slot_model.dart
//
// Per TDD 05 §3.6 — Model dengan @freezed + custom converters
// untuk date-only dan time-only format PostgreSQL.
//
// Field mapping:
// - `slot_date` (DATE PostgreSQL) → DateTime + @DateOnlyJsonConverter
// - `slot_start` (TIME PostgreSQL) → TimeOfDay + manual fromJson/toJson
// - `slot_end` (TIME PostgreSQL) → TimeOfDay + manual fromJson/toJson
// - `is_booked` (BOOL) → bool (built-in)
//
// Format JSON:
// "slot_date": "2026-06-15"
// "slot_start": "09:00:00"
// "slot_end": "09:30:00"
//
// Catatan: TimeOfDay dari flutter/material.dart tidak otomatis di-support
// oleh json_serializable. Solusi: gunakan @JsonKey(fromJson, toJson)
// untuk specify manual converter functions per-field.

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/doctor_slot_entity.dart';

part 'doctor_slot_model.freezed.dart';
part 'doctor_slot_model.g.dart';

@freezed
abstract class DoctorSlotModel with _$DoctorSlotModel {
  // Lihat catatan di DoctorModel untuk rationale `abstract` + `._()`.
  const DoctorSlotModel._();

  const factory DoctorSlotModel({
    required String id,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'schedule_id') String? scheduleId,
    @JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime slotDate,
    @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson)
    required TimeOfDay startTime,
    @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson)
    required TimeOfDay endTime,
    @JsonKey(name: 'is_booked') @Default(false) bool isBooked,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _DoctorSlotModel;

  factory DoctorSlotModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorSlotModelFromJson(json);
}

// ── Top-level helper functions untuk JsonKey ──
// (json_serializable butuh top-level atau static, bukan class method)
//
// Semua return type HARUS match field type persis (DateTime, TimeOfDay).
// Untuk null-safety, gunakan `as String?` di check atau throw FormatException.
DateTime _dateFromJson(dynamic value) {
  if (value == null) {
    throw const FormatException('slot_date cannot be null');
  }
  return DateTime.parse(value as String);
}

String _dateToJson(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

TimeOfDay _timeFromJson(dynamic value) {
  if (value == null) {
    throw const FormatException('time cannot be null');
  }
  final str = value as String;
  final parts = str.split(':');
  if (parts.length < 2) {
    throw FormatException('Invalid time format: $str');
  }
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

String _timeToJson(TimeOfDay value) {
  final h = value.hour.toString().padLeft(2, '0');
  final m = value.minute.toString().padLeft(2, '0');
  return '$h:$m:00';
}

extension DoctorSlotModelX on DoctorSlotModel {
  DoctorSlotEntity toEntity() => DoctorSlotEntity(
        id: id,
        doctorId: doctorId,
        scheduleId: scheduleId,
        slotDate: slotDate,
        startTime: startTime,
        endTime: endTime,
        isBooked: isBooked,
      );
}
