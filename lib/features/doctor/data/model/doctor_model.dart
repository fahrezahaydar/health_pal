// lib/features/doctor/data/model/doctor_model.dart
//
// Per TDD 05 §3.5 — Model dengan @freezed + @JsonKey per-field.
//
// Field-field ini mirror dari:
// - API Contract §5.1 (search) dan §5.3 (detail) responses
// - ERD `doctors` table columns (snake_case di JSON)
//
// Nested objects (clinic, specialization) di-parse langsung dari
// PostgREST nested select `*,clinics(*),specializations(*)`.
// SpecializationModel di-import dari home feature (existing).

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/model/specialization_model.dart';
import '../../domain/entity/doctor_entity.dart';
import 'clinic_model.dart';
import 'doctor_schedule_model.dart';

part 'doctor_model.freezed.dart';
part 'doctor_model.g.dart';

@freezed
abstract class DoctorModel with _$DoctorModel {
  // `abstract` modifier DIBUTUHKAN agar:
  // 1. `class _DoctorModel extends DoctorModel` di file .freezed.dart
  //    bisa extend tanpa error (memanggil super._() di constructor).
  // 2. Mixin ` _$DoctorModel` mendeklarasikan getter abstract — class
  //    `DoctorModel` harus abstract juga untuk tidak error
  //    "non_abstract_class_inherits_abstract_member".
  // 3. Private constructor `const DoctorModel._()` WAJIB ADA agar
  //    _DoctorModel bisa instantiate via super._().
  //
  // Factory `= _DoctorModel` adalah cara untuk membuat instance konkret
  // yang implement semua getter dari mixin.

  const DoctorModel._();

  const factory DoctorModel({
    required String id,
    @JsonKey(name: 'clinic_id') required String clinicId,
    @JsonKey(name: 'specialization_id') required String specializationId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    String? description,
    @JsonKey(name: 'experience_years') required int experienceYears,
    String? education,
    @JsonKey(name: 'consultation_fee') required double consultationFee,
    @JsonKey(name: 'rating_avg') @Default(0.0) double ratingAvg,
    @JsonKey(name: 'rating_count') @Default(0) int ratingCount,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,

    // ── v2.0 (ADR-009): New fields untuk Doctor Detail Page ──
    @JsonKey(name: 'total_patients') @Default(0) int totalPatients,
    @JsonKey(name: 'doctor_schedules') @Default([]) List<DoctorScheduleModel> schedules,

    // ── Nested Objects (dari PostgREST select=*,clinics(*),specializations(*)) ──
    // @JsonKey name WAJIB match nama tabel (plural) karena PostgREST
    // selalu pakai nama tabel sebagai JSON key untuk nested object.
    @JsonKey(name: 'clinics') ClinicModel? clinic,
    @JsonKey(name: 'specializations') SpecializationModel? specialization,
  }) = _DoctorModel;

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  // ── Mapper Entity ↔ Model ──────────────────────────────
  factory DoctorModel.fromEntity(DoctorEntity entity) => DoctorModel(
        id: entity.id,
        clinicId: entity.clinicId,
        specializationId: entity.specializationId,
        fullName: entity.fullName,
        photoUrl: entity.photoUrl,
        description: entity.description,
        experienceYears: entity.experienceYears,
        education: entity.education,
        consultationFee: entity.consultationFee,
        ratingAvg: entity.ratingAvg,
        ratingCount: entity.ratingCount,
        isActive: entity.isActive,
        totalPatients: entity.totalPatients,
        schedules: entity.schedules
                .map((e) => DoctorScheduleModel.fromEntity(e))
                .toList(),
        clinic: entity.clinic != null ? ClinicModel.fromEntity(entity.clinic!) : null,
        specialization: entity.specialization != null
            ? SpecializationModel.fromEntity(entity.specialization!)
            : null,
      );
}

extension DoctorModelX on DoctorModel {
  DoctorEntity toEntity() => DoctorEntity(
        id: id,
        clinicId: clinicId,
        specializationId: specializationId,
        fullName: fullName,
        photoUrl: photoUrl,
        description: description,
        experienceYears: experienceYears,
        education: education,
        consultationFee: consultationFee,
        ratingAvg: ratingAvg,
        ratingCount: ratingCount,
        isActive: isActive,
        totalPatients: totalPatients,
        schedules: schedules.map((e) => e.toEntity()).toList(),
        clinic: clinic?.toEntity(),
        specialization: specialization?.toEntity(),
      );
}
