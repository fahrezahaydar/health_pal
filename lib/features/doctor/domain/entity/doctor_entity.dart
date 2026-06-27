// lib/features/doctor/domain/entity/doctor_entity.dart

import 'package:equatable/equatable.dart';

import '../../../home/domain/entity/specialization_entity.dart';
import 'clinic_entity.dart';

class DoctorEntity extends Equatable {
  final String id;
  final String clinicId;
  final String specializationId;
  final String fullName;
  final String? photoUrl;
  final String? description;
  final int experienceYears;
  final String? education;
  final double consultationFee;
  final double ratingAvg;
  final int ratingCount;
  final bool isActive;

  // ── Nested (dari PostgREST JOIN) ──
  final ClinicEntity? clinic;
  final SpecializationEntity? specialization;

  const DoctorEntity({
    required this.id,
    required this.clinicId,
    required this.specializationId,
    required this.fullName,
    this.photoUrl,
    this.description,
    required this.experienceYears,
    this.education,
    required this.consultationFee,
    this.ratingAvg = 0.0,
    this.ratingCount = 0,
    this.isActive = true,
    this.clinic,
    this.specialization,
  });

  /// Derived: nama tampilan dokter (untuk greeting/header).
  String get displayName => fullName;

  /// Derived: nama spesialisasi (jika sudah di-load).
  String get specializationName => specialization?.name ?? 'Umum';

  /// Derived: nama klinik (jika sudah di-load).
  String get clinicName => clinic?.name ?? 'Klinik';

  /// Derived: rating text (formatted untuk display).
  String get ratingDisplay => ratingAvg.toStringAsFixed(1);

  static DoctorEntity mock() => const DoctorEntity(
        id: 'sk-1',
        clinicId: 'sk-clinic',
        specializationId: 'sk-spec',
        fullName: 'Loading Doctor Name',
        experienceYears: 0,
        consultationFee: 0,
      );

  /// List of mock doctors for skeleton loading (3 items).
  static List<DoctorEntity> mockList() => const [
        DoctorEntity(
          id: 'sk-1',
          clinicId: 'sk-c',
          specializationId: 'sk-s',
          fullName: 'Loading Doctor 1',
          experienceYears: 0,
          consultationFee: 0,
        ),
        DoctorEntity(
          id: 'sk-2',
          clinicId: 'sk-c',
          specializationId: 'sk-s',
          fullName: 'Loading Doctor 2',
          experienceYears: 0,
          consultationFee: 0,
        ),
        DoctorEntity(
          id: 'sk-3',
          clinicId: 'sk-c',
          specializationId: 'sk-s',
          fullName: 'Loading Doctor 3',
          experienceYears: 0,
          consultationFee: 0,
        ),
      ];

  @override
  List<Object?> get props => [
        id,
        clinicId,
        specializationId,
        fullName,
        photoUrl,
        description,
        experienceYears,
        education,
        consultationFee,
        ratingAvg,
        ratingCount,
        isActive,
        clinic,
        specialization,
      ];
}
