// lib/features/doctor/domain/entity/doctor_entity.dart

import 'package:equatable/equatable.dart';

import '../../../home/domain/entity/specialization_entity.dart';
import 'clinic_entity.dart';
import 'doctor_schedule_entity.dart';

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
  final int totalPatients;
  final List<DoctorScheduleEntity> schedules;

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
    this.totalPatients = 0,
    this.schedules = const [],
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

  /// Derived: working time display string.
  /// Menggabungkan jadwal aktif ke format: "Senin–Jumat, 08:00 AM – 06:00 PM".
  /// Jika ada multiple day ranges, gunakan format terkompak.
  String get workingTimeDisplay {
    if (schedules.isEmpty) return 'No schedule available';
    final active = schedules.where((s) => s.isActive).toList();
    if (active.isEmpty) return 'No schedule available';

    // Sort by dayOfWeek
    final sorted = List<DoctorScheduleEntity>.from(active)
      ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));

    // If only one entry, display it directly
    if (sorted.length == 1) {
      return '${sorted.first.dayName}, ${sorted.first.timeDisplay}';
    }

    // Try to group consecutive days with same time
    final buffer = StringBuffer();
    int i = 0;
    while (i < sorted.length) {
      final start = sorted[i];
      int j = i;
      while (
          j + 1 < sorted.length &&
          sorted[j + 1].dayOfWeek == sorted[j].dayOfWeek + 1 &&
          sorted[j + 1].startTime == sorted[j].startTime &&
          sorted[j + 1].endTime == sorted[j].endTime) {
        j++;
      }
      if (buffer.isNotEmpty) buffer.write(', ');
      if (j == i) {
        buffer.write('${start.dayName}, ${start.timeDisplay}');
      } else {
        buffer.write(
          '${start.dayName}–${sorted[j].dayName}, ${start.timeDisplay}',
        );
      }
      i = j + 1;
    }
    return buffer.toString();
  }

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
        totalPatients,
        schedules,
        clinic,
        specialization,
      ];
}
