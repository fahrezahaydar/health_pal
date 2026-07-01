// test/features/booking/data/model/appointment_model_test.dart
//
// Unit test untuk AppointmentModel — @freezed + deeply nested objects.
// Referensi: lib/features/booking/data/model/appointment_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/booking/data/model/appointment_model.dart';

void main() {
  final validNestedJson = <String, dynamic>{
    'id': 'appt-1',
    'patient_id': 'patient-1',
    'doctor_id': 'doctor-1',
    'slot_id': 'slot-1',
    'status': 'upcoming',
    'complaint_note': 'Sakit kepala',
    'consultation_fee_snapshot': 150000,
    'booked_at': '2026-06-15T09:00:00.000Z',
    'doctors': <String, dynamic>{
      'id': 'doctor-1',
      'full_name': 'dr. Andi',
      'photo_url': 'https://example.com/doctor.jpg',
      'experience_years': 10,
      'specializations': <String, dynamic>{
        'name': 'Umum',
      },
      'clinics': <String, dynamic>{
        'name': 'Klinik Sehat',
        'address': 'Jl. Sehat No. 1',
        'phone': '021-1234567',
      },
    },
    'doctor_slots': <String, dynamic>{
      'slot_date': '2026-06-15',
      'slot_start': '09:00:00',
      'slot_end': '09:30:00',
    },
  };

  group('AppointmentModel.fromJson', () {
    test('parses valid deeply nested JSON', () {
      final model = AppointmentModel.fromJson(validNestedJson);
      expect(model.id, 'appt-1');
      expect(model.patientId, 'patient-1');
      expect(model.status, 'upcoming');
      expect(model.consultationFeeSnapshot, 150000);

      // Nested doctor
      expect(model.doctors, isNotNull);
      expect(model.doctors!.fullName, 'dr. Andi');
      expect(model.doctors!.specializations!.name, 'Umum');
      expect(model.doctors!.clinics!.name, 'Klinik Sehat');

      // Nested slot
      expect(model.doctorSlots, isNotNull);
      expect(model.doctorSlots!.slotDate, DateTime(2026, 6, 15));
    });

    test('handles missing nested objects', () {
      final json = <String, dynamic>{
        'id': 'appt-2',
        'patient_id': 'patient-1',
        'doctor_id': 'doctor-1',
        'slot_id': 'slot-1',
        'status': 'cancelled',
        'consultation_fee_snapshot': 100000,
      };
      final model = AppointmentModel.fromJson(json);
      expect(model.status, 'cancelled');
      expect(model.doctors, isNull);
      expect(model.doctorSlots, isNull);
    });

    test('parses status as string (not enum)', () {
      final json = <String, dynamic>{
        'id': 'appt-3',
        'patient_id': 'patient-1',
        'doctor_id': 'doctor-1',
        'slot_id': 'slot-1',
        'status': 'completed',
        'consultation_fee_snapshot': 200000,
      };
      final model = AppointmentModel.fromJson(json);
      expect(model.status, 'completed');
    });
  });

  group('AppointmentModel.toEntity', () {
    test('converts to AppointmentEntity with all nested data', () {
      final model = AppointmentModel.fromJson(validNestedJson);
      final entity = model.toEntity();
      expect(entity.id, 'appt-1');
      expect(entity.doctorName, 'dr. Andi');
      expect(entity.specializationName, 'Umum');
      expect(entity.clinicName, 'Klinik Sehat');
      expect(entity.slotDate, DateTime(2026, 6, 15));
    });
  });
}
