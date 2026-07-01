// C23-C31
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:health_pal/features/home/domain/entity/banner_entity.dart';
import 'package:health_pal/features/home/domain/entity/specialization_entity.dart';
import 'package:health_pal/features/home/domain/entity/upcoming_appointment_entity.dart';
import 'package:health_pal/features/home/domain/entity/user_profile_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_schedule_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_slot_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/clinic_entity.dart' as doc_clinic;
import 'package:health_pal/features/booking/domain/entity/appointment_entity.dart';
import 'package:health_pal/core/enums/booking_status.dart';

void main() {
  group('C23 BannerEntity', () {
    test('Equatable', () {
      expect(const BannerEntity(id: '1', title: 'A'), const BannerEntity(id: '1', title: 'A'));
    });
    test('mock()', () { expect(BannerEntity.mock().length, 3); });
  });

  group('C24 SpecializationEntity', () {
    test('Equatable', () {
      expect(const SpecializationEntity(id: '1', name: 'A'), const SpecializationEntity(id: '1', name: 'A'));
    });
  });

  group('C25 UpcomingAppointmentEntity', () {
    test('Equatable', () {
      final a = UpcomingAppointmentEntity(id: '1', doctorName: 'Dr', clinicName: 'C', specializationName: 'S', slotDate: DateTime(2026,1,1), slotStart: const TimeOfDay(hour:9,minute:0), slotEnd: const TimeOfDay(hour:9,minute:30), status: BookingStatus.upcoming);
      final b = UpcomingAppointmentEntity(id: '1', doctorName: 'Dr', clinicName: 'C', specializationName: 'S', slotDate: DateTime(2026,1,1), slotStart: const TimeOfDay(hour:9,minute:0), slotEnd: const TimeOfDay(hour:9,minute:30), status: BookingStatus.upcoming);
      expect(a, b);
    });
    test('props length', () { expect(UpcomingAppointmentEntity(id: '1', doctorName: 'Dr', clinicName: 'C', specializationName: 'S', slotDate: DateTime(2026,1,1), slotStart: const TimeOfDay(hour:9,minute:0), slotEnd: const TimeOfDay(hour:9,minute:30), status: BookingStatus.upcoming).props.length, 9); });
  });

  group('C26 UserProfileEntity', () {
    test('Equatable', () {
      expect(const UserProfileEntity(id: '1', nickname: 'T'), const UserProfileEntity(id: '1', nickname: 'T'));
    });
  });

  group('C27 DoctorEntity', () {
    test('Equatable', () {
      const a = DoctorEntity(id: '1', clinicId: 'c', specializationId: 's', fullName: 'Dr', experienceYears: 0, consultationFee: 0);
      const b = DoctorEntity(id: '1', clinicId: 'c', specializationId: 's', fullName: 'Dr', experienceYears: 0, consultationFee: 0);
      expect(a, b);
    });
    test('workingTimeDisplay returns "No schedule available" when empty', () {
      const e = DoctorEntity(id: '1', clinicId: 'c', specializationId: 's', fullName: 'Dr', experienceYears: 0, consultationFee: 0);
      expect(e.workingTimeDisplay, 'No schedule available');
    });
    test('workingTimeDisplay with schedules', () {
      const e = DoctorEntity(id: '1', clinicId: 'c', specializationId: 's', fullName: 'Dr', experienceYears: 0, consultationFee: 0, schedules: [
        DoctorScheduleEntity(id: 's1', doctorId: 'd1', dayOfWeek: 1, startTime: '08:00:00', endTime: '17:00:00'),
      ]);
      expect(e.workingTimeDisplay, contains('Senin'));
    });
    test('mock() creates non-null', () { expect(DoctorEntity.mock().id, isNotEmpty); });
    test('mockList() creates 3 items', () { expect(DoctorEntity.mockList().length, 3); });
  });

  group('C28 DoctorScheduleEntity', () {
    test('Equatable', () { expect(const DoctorScheduleEntity(id: '1', doctorId: 'd', dayOfWeek: 1, startTime: '08:00', endTime: '17:00'), const DoctorScheduleEntity(id: '1', doctorId: 'd', dayOfWeek: 1, startTime: '08:00', endTime: '17:00')); });
    test('dayName returns correct day', () { expect(const DoctorScheduleEntity(id: '1', doctorId: 'd', dayOfWeek: 1, startTime: '08:00', endTime: '17:00').dayName, 'Senin'); });
  });

  group('C29 DoctorSlotEntity', () {
    test('Equatable', () {
      final a = DoctorSlotEntity(id: '1', doctorId: 'd', slotDate: DateTime(2026,1,1), startTime: const TimeOfDay(hour:9,minute:0), endTime: const TimeOfDay(hour:9,minute:30));
      final b = DoctorSlotEntity(id: '1', doctorId: 'd', slotDate: DateTime(2026,1,1), startTime: const TimeOfDay(hour:9,minute:0), endTime: const TimeOfDay(hour:9,minute:30));
      expect(a, b);
    });
    test('durationMinutes', () {
      expect(DoctorSlotEntity(id: '1', doctorId: 'd', slotDate: DateTime(2026,1,1), startTime: const TimeOfDay(hour:9,minute:0), endTime: const TimeOfDay(hour:9,minute:30)).durationMinutes, 30);
    });
  });

  group('C30 ClinicEntity (Doctor)', () {
    test('Equatable', () { expect(const doc_clinic.ClinicEntity(id: '1', name: 'K'), const doc_clinic.ClinicEntity(id: '1', name: 'K')); });
  });

  group('C31 AppointmentEntity', () {
    test('Equatable', () {
      const a = AppointmentEntity(id: '1', patientId: 'p', doctorId: 'd', slotId: 's', status: 'pending', consultationFeeSnapshot: 0);
      const b = AppointmentEntity(id: '1', patientId: 'p', doctorId: 'd', slotId: 's', status: 'pending', consultationFeeSnapshot: 0);
      expect(a, b);
    });
    test('doctorName returns "Dokter" when doctor null', () {
      expect(const AppointmentEntity(id: '1', patientId: 'p', doctorId: 'd', slotId: 's', status: 'pending', consultationFeeSnapshot: 0).doctorName, 'Dokter');
    });
    test('clinicName returns "Klinik" when doctor null', () {
      expect(const AppointmentEntity(id: '1', patientId: 'p', doctorId: 'd', slotId: 's', status: 'pending', consultationFeeSnapshot: 0).clinicName, 'Klinik');
    });
  });
}
