// lib/features/booking/data/model/appointment_model.dart
//
// Per TDD 05 §3.7 — AppointmentModel dengan @freezed + @JsonKey per-field.
// Field mapping mirror API Contract §6.1-6.4 responses.
//
// 14 fields: id, patientId, doctorId, slotId, status, complaintNote,
//            consultationFeeSnapshot, bookedAt, confirmedAt, completedAt,
//            cancelledAt, cancellationReason, createdAt, updatedAt
//
// Nested objects (dari PostgREST select=*,doctors(*),doctor_slots(*)):
// - doctors: subset (id, nama, foto, experience, spec, clinic)
// - doctor_slots: subset (tanggal, jam mulai/selesai)
//
// Edge Function responses (create-appointment) dan PostgREST responses
// keduanya return field names yang sama (snake_case di JSON), jadi single
// model cukup untuk kedua sumber.
//
// CATATAN: AppointmentDoctorModel, AppointmentClinicModel, AppointmentSlotModel
// adalah subset sederhana — tidak depend pada DoctorModel/DoctorSlotModel
// yang lebih kompleks. Alasan: DoctorEntity di doctor feature punya required
// `clinicId` dan `specializationId` yang TIDAK tersedia di response
// appointment (hanya nested names). Untuk menghindari impedance mismatch,
// kita buat nested models terpisah di booking feature.

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/appointment_entity.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
abstract class AppointmentModel with _$AppointmentModel {
  // Lihat catatan di DoctorModel untuk rationale `abstract` + `._()`.
  const AppointmentModel._();

  const factory AppointmentModel({
    required String id,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'slot_id') required String slotId,
    required String
    status, // 'pending' | 'upcoming' | 'completed' | 'cancelled'
    @JsonKey(name: 'complaint_note') String? complaintNote,
    @JsonKey(name: 'consultation_fee_snapshot')
    required double consultationFeeSnapshot,
    @JsonKey(name: 'booked_at') DateTime? bookedAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,

    // ── Nested Objects (dari PostgREST nested select) ──
    AppointmentDoctorModel? doctors,
    @JsonKey(name: 'doctor_slots') AppointmentSlotModel? doctorSlots,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
}

// ── Nested Models (subset untuk booking display) ─────────────────────────

@freezed
abstract class AppointmentDoctorModel with _$AppointmentDoctorModel {
  const AppointmentDoctorModel._();

  const factory AppointmentDoctorModel({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'experience_years') int? experienceYears,
    AppointmentSpecializationModel? specializations,
    AppointmentClinicModel? clinics,
  }) = _AppointmentDoctorModel;

  factory AppointmentDoctorModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentDoctorModelFromJson(json);
}

@freezed
abstract class AppointmentSpecializationModel
    with _$AppointmentSpecializationModel {
  const factory AppointmentSpecializationModel({required String name}) =
      _AppointmentSpecializationModel;

  factory AppointmentSpecializationModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSpecializationModelFromJson(json);
}

@freezed
abstract class AppointmentClinicModel with _$AppointmentClinicModel {
  const factory AppointmentClinicModel({
    required String name,
    String? address,
    String? phone,
  }) = _AppointmentClinicModel;

  factory AppointmentClinicModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentClinicModelFromJson(json);
}

@freezed
abstract class AppointmentSlotModel with _$AppointmentSlotModel {
  const factory AppointmentSlotModel({
    @JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson)
    required DateTime slotDate,
    @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson)
    required TimeOfDay slotStart,
    @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson)
    required TimeOfDay slotEnd,
  }) = _AppointmentSlotModel;

  factory AppointmentSlotModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSlotModelFromJson(json);
}

// ── Top-level JSON converter helpers ─────────────────────────────────────

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

// ── Mapper Model → Entity ────────────────────────────────────────────────

extension AppointmentModelX on AppointmentModel {
  AppointmentEntity toEntity() => AppointmentEntity(
    id: id,
    patientId: patientId,
    doctorId: doctorId,
    slotId: slotId,
    status: status,
    complaintNote: complaintNote,
    consultationFeeSnapshot: consultationFeeSnapshot,
    bookedAt: bookedAt,
    confirmedAt: confirmedAt,
    completedAt: completedAt,
    cancelledAt: cancelledAt,
    cancellationReason: cancellationReason,
    createdAt: createdAt,
    updatedAt: updatedAt,
    doctor: doctors?.toEntity(),
    slot: doctorSlots?.toEntity(),
  );
}

extension AppointmentDoctorModelX on AppointmentDoctorModel {
  AppointmentDoctorEntity toEntity() => AppointmentDoctorEntity(
    id: id,
    fullName: fullName,
    photoUrl: photoUrl,
    experienceYears: experienceYears ?? 0,
    specializationName: specializations?.name ?? 'Umum',
    clinicName: clinics?.name ?? 'Klinik',
    clinicAddress: clinics?.address,
    clinicPhone: clinics?.phone,
  );
}

extension AppointmentSlotModelX on AppointmentSlotModel {
  AppointmentSlotEntity toEntity() => AppointmentSlotEntity(
    slotDate: slotDate,
    startTime: slotStart,
    endTime: slotEnd,
  );
}
