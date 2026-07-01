// test/features/home/data/model/upcoming_appointment_model_test.dart
//
// Unit test untuk UpcomingAppointmentModel — nested JSON + converters.
// Referensi: lib/features/home/data/model/upcoming_appointment_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/enums/booking_status.dart';
import 'package:health_pal/features/home/data/model/upcoming_appointment_model.dart';

void main() {
  final validNestedJson = <String, dynamic>{
    'id': 'appt-1',
    'status': 'upcoming',
    'doctors': <String, dynamic>{
      'full_name': 'dr. Budi',
      'photo_url': 'https://example.com/doctor.jpg',
      'clinics': <String, dynamic>{
        'name': 'Klinik Sehat',
      },
      'specializations': <String, dynamic>{
        'name': 'Umum',
      },
    },
    'doctor_slots': <String, dynamic>{
      'slot_date': '2026-06-15',
      'slot_start': '09:00:00',
      'slot_end': '09:30:00',
    },
  };

  group('UpcomingAppointmentModel.fromJson', () {
    test('parses valid nested JSON correctly', () {
      final model = UpcomingAppointmentModel.fromJson(validNestedJson);
      expect(model.id, 'appt-1');
      expect(model.doctorName, 'dr. Budi');
      expect(model.doctorPhoto, 'https://example.com/doctor.jpg');
      expect(model.clinicName, 'Klinik Sehat');
      expect(model.specializationName, 'Umum');
      expect(model.slotDate, DateTime(2026, 6, 15));
      expect(model.status, BookingStatus.upcoming);
    });

    test('parses JSON with null nested slots (nullable fields)', () {
      final json = <String, dynamic>{
        'id': 'appt-2',
        'status': 'pending',
        'doctors': <String, dynamic>{
          'full_name': 'dr. Sari',
          'clinics': <String, dynamic>{'name': 'Klinik B'},
          'specializations': <String, dynamic>{'name': 'Gigi'},
        },
      };
      final model = UpcomingAppointmentModel.fromJson(json);
      expect(model.id, 'appt-2');
      expect(model.slotDate, isNull);
      expect(model.slotStart, isNull);
      expect(model.slotEnd, isNull);
      expect(model.status, BookingStatus.pending);
    });

    test('handles missing nested objects with defaults', () {
      final json = <String, dynamic>{
        'id': 'appt-3',
        'status': 'upcoming',
      };
      final model = UpcomingAppointmentModel.fromJson(json);
      expect(model.id, 'appt-3');
      expect(model.doctorName, '');
      expect(model.clinicName, '');
      expect(model.specializationName, '');
    });
  });

  group('UpcomingAppointmentModel.toEntity', () {
    test('converts to entity with matching fields', () {
      final model = UpcomingAppointmentModel.fromJson(validNestedJson);
      final entity = model.toEntity();
      expect(entity.id, model.id);
      expect(entity.doctorName, model.doctorName);
      expect(entity.doctorPhoto, model.doctorPhoto);
      expect(entity.clinicName, model.clinicName);
      expect(entity.specializationName, model.specializationName);
      expect(entity.slotDate, model.slotDate);
      expect(entity.status, model.status);
    });
  });
}
