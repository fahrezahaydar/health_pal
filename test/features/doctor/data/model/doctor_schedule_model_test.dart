// test/features/doctor/data/model/doctor_schedule_model_test.dart
//
// Unit test untuk DoctorScheduleModel — @freezed + @JsonKey.
// Referensi: lib/features/doctor/data/model/doctor_schedule_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/doctor/data/model/doctor_schedule_model.dart';

void main() {
  group('DoctorScheduleModel.fromJson', () {
    test('parses valid JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'schedule-1',
        'doctor_id': 'doctor-1',
        'day_of_week': 1,
        'start_time': '08:00:00',
        'end_time': '17:00:00',
        'slot_duration_minutes': 30,
        'is_active': true,
      };
      final model = DoctorScheduleModel.fromJson(json);
      expect(model.id, 'schedule-1');
      expect(model.doctorId, 'doctor-1');
      expect(model.dayOfWeek, 1);
      expect(model.startTime, '08:00:00');
      expect(model.endTime, '17:00:00');
      expect(model.isActive, isTrue);
    });

    test('uses defaults for optional fields', () {
      final json = <String, dynamic>{
        'id': 'schedule-2',
        'doctor_id': 'doctor-1',
        'day_of_week': 2,
        'start_time': '09:00:00',
        'end_time': '18:00:00',
      };
      final model = DoctorScheduleModel.fromJson(json);
      expect(model.slotDurationMinutes, 30);
      expect(model.isActive, isTrue);
    });
  });

  group('DoctorScheduleModel.toEntity', () {
    test('converts to DoctorScheduleEntity with matching fields', () {
      final json = <String, dynamic>{
        'id': 'schedule-3',
        'doctor_id': 'doctor-2',
        'day_of_week': 3,
        'start_time': '10:00:00',
        'end_time': '19:00:00',
        'is_active': false,
      };
      final model = DoctorScheduleModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'schedule-3');
      expect(entity.doctorId, 'doctor-2');
      expect(entity.dayOfWeek, 3);
      expect(entity.isActive, isFalse);
    });
  });
}
