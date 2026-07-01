// test/helpers/test_helpers.dart
//
// Shared helper utilities untuk semua test di health_pal.
// Berisi: factory untuk Entity, helper untuk BLoC/Cubit, dan
// common matcher functions.
//
// PENTING: Constructor signature HARUS match dengan entity class asli.
// Selalu rujuk ke file entity saat menulis factory.

import 'package:flutter/material.dart' show TimeOfDay;

import 'package:health_pal/core/enums/booking_status.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/booking/domain/entity/appointment_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/clinic_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_schedule_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_slot_entity.dart';
import 'package:health_pal/features/home/domain/entity/banner_entity.dart';
import 'package:health_pal/features/home/domain/entity/specialization_entity.dart';
import 'package:health_pal/features/home/domain/entity/upcoming_appointment_entity.dart';
import 'package:health_pal/features/home/domain/entity/user_profile_entity.dart';
import 'package:health_pal/features/profile/domain/entity/notification_entity.dart';

// ══════════════════════════════════════════════════════════════════
//   ENTITY FACTORIES
//   Pakai pattern: TestData.entityName({overrides})
// ══════════════════════════════════════════════════════════════════

class TestData {
  TestData._();

  // ── User (Auth) ──
  // Signature HARUS match UserEntity constructor di
  // lib/features/auth/domain/entity/user_entity.dart
  static UserEntity mockUser({
    String? id,
    String? authId,
    String? email,
    String? fullName,
    String? nickname,
    String? gender,
    bool? isProfileComplete,
  }) {
    return UserEntity(
      id: id ?? 'user-test-123',
      authId: authId ?? 'auth-test-123',
      email: email ?? 'test@example.com',
      fullName: fullName ?? 'Test User',
      nickname: nickname,
      avatarUrl: null,
      dateOfBirth: DateTime(1990, 1, 1),
      gender: gender,
      isProfileComplete: isProfileComplete ?? false,
    );
  }

  // ── Banner (Home) ──
  static BannerEntity mockBanner({
    String? id,
    String? title,
    String? imageUrl,
    int? displayOrder,
  }) {
    return const BannerEntity(
      id: 'banner-test-1',
      title: 'Test Promo',
    );
  }

  // ── Specialization (Home) ──
  static SpecializationEntity mockSpecialization({
    String? id,
    String? name,
    String? iconUrl,
  }) {
    return const SpecializationEntity(
      id: 'spec-test-1',
      name: 'Umum',
    );
  }

  // ── Upcoming Appointment (Home) ──
  // Sprint 2 — A3: slotDate (DateTime?), slotStart/slotEnd (TimeOfDay?)
  // (was String, per TDD 05 §3.2 + json_converters.dart). Test factory
  // harus match entity signature.
  static UpcomingAppointmentEntity? mockUpcoming({bool isNull = false}) {
    if (isNull) return null;
    return UpcomingAppointmentEntity(
      id: 'appt-test-1',
      doctorName: 'dr. Test',
      clinicName: 'Klinik Test',
      specializationName: 'Umum',
      slotDate: DateTime(2026, 6, 15),
      slotStart: const TimeOfDay(hour: 9, minute: 0),
      slotEnd: const TimeOfDay(hour: 9, minute: 30),
      // Sprint 2 — A5: status sekarang BookingStatus enum (bukan String).
      status: BookingStatus.upcoming,
    );
  }

  // ── User Profile (Home) — minimal entity ──
  static UserProfileEntity mockUserProfile({
    String? id,
    String? nickname,
    bool? isProfileComplete,
    String? avatarUrl,
  }) {
    return UserProfileEntity(
      id: id ?? 'profile-test-1',
      nickname: nickname ?? 'Tester',
      isProfileComplete: isProfileComplete ?? false,
      avatarUrl: avatarUrl,
    );
  }

  // ── Doctor ──
  // lib/features/doctor/domain/entity/doctor_entity.dart
  // Constructor: {required id, required clinicId, required specializationId,
  // required fullName, photoUrl?, description?, required experienceYears,
  // education?, required consultationFee, ratingAvg=0.0, ratingCount=0,
  // isActive=true, totalPatients=0, schedules=[], clinic?, specialization?}
  static DoctorEntity mockDoctor({
    String? id,
    String? fullName,
    int? experienceYears,
    double? consultationFee,
    List<DoctorScheduleEntity>? schedules,
    ClinicEntity? clinic,
  }) {
    return DoctorEntity(
      id: id ?? 'doctor-test-1',
      clinicId: 'clinic-test-1',
      specializationId: 'spec-test-1',
      fullName: fullName ?? 'dr. Test Doctor',
      experienceYears: experienceYears ?? 5,
      consultationFee: consultationFee ?? 150000,
      schedules: schedules ?? const [],
      clinic: clinic ?? mockClinic(),
    );
  }

  /// List of mock doctors for skeleton / list testing.
  static List<DoctorEntity> mockDoctorList({int count = 3}) =>
      List.generate(count, (i) => mockDoctor(
        id: 'doctor-test-$i',
        fullName: 'dr. Doctor $i',
      ));

  // ── Clinic (Doctor feature) ──
  // lib/features/doctor/domain/entity/clinic_entity.dart
  // Constructor: {required id, required name, address?, city?,
  // latitude?, longitude?, phone?, imageUrl?}
  static ClinicEntity mockClinic({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return ClinicEntity(
      id: id ?? 'clinic-test-1',
      name: name ?? 'Klinik Test Sehat',
      address: address ?? 'Jl. Test No. 123',
      latitude: latitude ?? -6.2,
      longitude: longitude ?? 106.8,
      phone: '021-1234567',
      imageUrl: 'https://example.com/clinic.jpg',
    );
  }

  // ── Doctor Schedule ──
  // lib/features/doctor/domain/entity/doctor_schedule_entity.dart
  // Constructor: {required id, required doctorId, required dayOfWeek,
  // required startTime, required endTime, slotDurationMinutes=30, isActive=true}
  static DoctorScheduleEntity mockDoctorSchedule({
    String? id,
    String? doctorId,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    bool? isActive,
  }) {
    return DoctorScheduleEntity(
      id: id ?? 'schedule-test-1',
      doctorId: doctorId ?? 'doctor-test-1',
      dayOfWeek: dayOfWeek ?? 1,
      startTime: startTime ?? '08:00:00',
      endTime: endTime ?? '17:00:00',
      isActive: isActive ?? true,
    );
  }

  // ── Doctor Slot ──
  // lib/features/doctor/domain/entity/doctor_slot_entity.dart
  // Constructor: {required id, required doctorId, scheduleId?,
  // required slotDate, required startTime, required endTime, isBooked=false}
  static DoctorSlotEntity mockDoctorSlot({
    String? id,
    String? doctorId,
    DateTime? slotDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? isBooked,
  }) {
    return DoctorSlotEntity(
      id: id ?? 'slot-test-1',
      doctorId: doctorId ?? 'doctor-test-1',
      slotDate: slotDate ?? DateTime(2026, 6, 15),
      startTime: startTime ?? const TimeOfDay(hour: 9, minute: 0),
      endTime: endTime ?? const TimeOfDay(hour: 9, minute: 30),
      isBooked: isBooked ?? false,
    );
  }

  // ── Appointment (Booking) — with nested entities ──
  // lib/features/booking/domain/entity/appointment_entity.dart
  // Constructor: {required id, required patientId, required doctorId,
  // required slotId, required status (String), complaintNote?,
  // required consultationFeeSnapshot, bookedAt?, confirmedAt?, completedAt?,
  // cancelledAt?, cancellationReason?, createdAt?, updatedAt?, doctor?, slot?}
  static AppointmentEntity mockAppointment({
    String? id,
    String? status,
    double? consultationFeeSnapshot,
    AppointmentDoctorEntity? doctor,
    AppointmentSlotEntity? slot,
  }) {
    return AppointmentEntity(
      id: id ?? 'appointment-test-1',
      patientId: 'patient-test-1',
      doctorId: doctor?.id ?? 'doctor-test-1',
      slotId: 'slot-test-1',
      status: status ?? 'upcoming',
      consultationFeeSnapshot: consultationFeeSnapshot ?? 150000,
      doctor: doctor ?? mockAppointmentDoctor(),
      slot: slot ?? mockAppointmentSlot(),
      bookedAt: DateTime(2026, 6, 15),
    );
  }

  // ── Appointment Doctor (nested in AppointmentEntity) ──
  // lib/features/booking/domain/entity/appointment_entity.dart:116-156
  // Constructor: {required id, required fullName, photoUrl?,
  // required experienceYears, required specializationName,
  // required clinicName, clinicAddress?, clinicPhone?}
  static AppointmentDoctorEntity mockAppointmentDoctor({
    String? id,
    String? fullName,
    String? specializationName,
    String? clinicName,
  }) {
    return AppointmentDoctorEntity(
      id: id ?? 'doctor-test-1',
      fullName: fullName ?? 'dr. Test Doctor',
      experienceYears: 5,
      specializationName: specializationName ?? 'Umum',
      clinicName: clinicName ?? 'Klinik Test',
      clinicAddress: 'Jl. Test No. 123',
      clinicPhone: '021-1234567',
    );
  }

  // ── Appointment Slot (nested in AppointmentEntity) ──
  // lib/features/booking/domain/entity/appointment_entity.dart:158-194
  // Constructor: {required slotDate, required startTime, required endTime}
  static AppointmentSlotEntity mockAppointmentSlot({
    DateTime? slotDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return AppointmentSlotEntity(
      slotDate: slotDate ?? DateTime(2026, 6, 15),
      startTime: startTime ?? const TimeOfDay(hour: 9, minute: 0),
      endTime: endTime ?? const TimeOfDay(hour: 9, minute: 30),
    );
  }

  // ── Notification (Profile) ──
  // lib/features/profile/domain/entity/notification_entity.dart
  // Constructor: {required id, required userId, appointmentId?,
  // required type, required title, required body, required isRead,
  // required sentAt, createdAt?}
  static NotificationEntity mockNotification({
    String? id,
    String? title,
    String? body,
    bool? isRead,
  }) {
    return NotificationEntity(
      id: id ?? 'notif-test-1',
      userId: 'user-test-1',
      type: 'booking_confirmed',
      title: title ?? 'Test Notification',
      body: body ?? 'This is a test notification body',
      isRead: isRead ?? false,
      sentAt: DateTime(2026, 6, 15, 9, 0),
    );
  }

  /// List mock notifications untuk test list rendering.
  static List<NotificationEntity> mockNotificationList({int count = 3}) =>
      List.generate(count, (i) => mockNotification(
        id: 'notif-test-$i',
        title: 'Notification $i',
        body: 'Body $i',
        isRead: i % 2 == 0,
      ));

  /// List mock appointments untuk test history + pagination.
  static List<AppointmentEntity> mockAppointmentList({int count = 3}) =>
      List.generate(count, (i) => mockAppointment(
        id: 'appointment-test-$i',
        status: i == 0 ? 'upcoming' : (i == 1 ? 'completed' : 'cancelled'),
      ));
}

// ══════════════════════════════════════════════════════════════════
//   HELPER FUNCTIONS
// ══════════════════════════════════════════════════════════════════

/// Wait untuk Future microtask selesai (untuk debouncer / stream testing).
Future<void> waitForMicrotasks() async {
  await Future<void>.delayed(Duration.zero);
}

/// Wait untuk durasi spesifik (untuk loading state).
Future<void> waitForLoading({
  Duration duration = const Duration(milliseconds: 100),
}) {
  return Future<void>.delayed(duration);
}
