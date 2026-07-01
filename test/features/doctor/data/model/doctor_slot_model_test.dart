// test/features/doctor/data/model/doctor_slot_model_test.dart
//
// Unit test untuk DoctorSlotModel — @freezed + custom converters.
// Referensi: lib/features/doctor/data/model/doctor_slot_model.dart

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/doctor/data/model/doctor_slot_model.dart';

void main() {
  group('DoctorSlotModel.fromJson', () {
    test('parses valid JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'slot-1',
        'doctor_id': 'doctor-1',
        'schedule_id': 'schedule-1',
        'slot_date': '2026-06-15',
        'slot_start': '09:00:00',
        'slot_end': '09:30:00',
        'is_booked': false,
      };
      final model = DoctorSlotModel.fromJson(json);
      expect(model.id, 'slot-1');
      expect(model.doctorId, 'doctor-1');
      expect(model.slotDate, DateTime(2026, 6, 15));
      expect(model.startTime, const TimeOfDay(hour: 9, minute: 0));
      expect(model.endTime, const TimeOfDay(hour: 9, minute: 30));
      expect(model.isBooked, isFalse);
    });

    test('parses booked slot correctly', () {
      final json = <String, dynamic>{
        'id': 'slot-2',
        'doctor_id': 'doctor-1',
        'slot_date': '2026-06-15',
        'slot_start': '10:00:00',
        'slot_end': '10:30:00',
        'is_booked': true,
      };
      final model = DoctorSlotModel.fromJson(json);
      expect(model.isBooked, isTrue);
    });

    test('throws FormatException when slot_date is null', () {
      final json = <String, dynamic>{
        'id': 'slot-3',
        'doctor_id': 'doctor-1',
        'slot_start': '09:00:00',
        'slot_end': '09:30:00',
      };
      expect(
        () => DoctorSlotModel.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when slot_start is null', () {
      final json = <String, dynamic>{
        'id': 'slot-4',
        'doctor_id': 'doctor-1',
        'slot_date': '2026-06-15',
        'slot_end': '09:30:00',
      };
      expect(
        () => DoctorSlotModel.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('DoctorSlotModel.toEntity', () {
    test('converts to DoctorSlotEntity with matching fields', () {
      final json = <String, dynamic>{
        'id': 'slot-5',
        'doctor_id': 'doctor-2',
        'slot_date': '2026-06-20',
        'slot_start': '14:00:00',
        'slot_end': '14:30:00',
        'is_booked': true,
      };
      final model = DoctorSlotModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'slot-5');
      expect(entity.doctorId, 'doctor-2');
      expect(entity.slotDate, DateTime(2026, 6, 20));
      expect(entity.isBooked, isTrue);
    });
  });
}
