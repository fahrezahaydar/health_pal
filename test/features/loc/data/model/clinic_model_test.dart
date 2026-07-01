// test/features/loc/data/model/clinic_model_test.dart
//
// Unit test untuk ClinicModel (Loc) — @freezed + @JsonKey.
// Referensi: lib/features/loc/data/model/clinic_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/loc/data/model/clinic_model.dart';

void main() {
  final validJson = <String, dynamic>{
    'id': 'clinic-1',
    'name': 'Klinik Sehat',
    'address': 'Jl. Sehat No. 1',
    'city': 'Jakarta',
    'latitude': -6.2,
    'longitude': 106.8,
    'phone': '021-1234567',
    'image_url': 'https://example.com/clinic.jpg',
    'distance_meters': 1500,
    'doctor_count': 5,
    'rating_avg': 4.5,
    'review_count': 100,
    'category': 'Clinic',
    'duration_minutes': 10,
    'specializations': ['Umum', 'Gigi'],
  };

  group('ClinicModel.fromJson', () {
    test('parses valid JSON with all fields', () {
      final model = ClinicModel.fromJson(validJson);
      expect(model.id, 'clinic-1');
      expect(model.name, 'Klinik Sehat');
      expect(model.latitude, -6.2);
      expect(model.doctorCount, 5);
      expect(model.ratingAvg, 4.5);
      expect(model.specializations, ['Umum', 'Gigi']);
    });

    test('uses defaults for missing optional fields', () {
      final json = <String, dynamic>{
        'id': 'clinic-2',
        'name': 'Minimal',
        'address': 'Jl. Minimal',
        'latitude': -6.0,
        'longitude': 106.0,
      };
      final model = ClinicModel.fromJson(json);
      expect(model.distanceMeters, 0.0);
      expect(model.doctorCount, 0);
      expect(model.ratingAvg, 0.0);
      expect(model.reviewCount, 0);
      expect(model.durationMinutes, 0);
      expect(model.specializations, isNull);
    });
  });

  group('ClinicModel.toEntity', () {
    test('converts to LocClinicEntity with matching fields', () {
      final model = ClinicModel.fromJson(validJson);
      final entity = model.toEntity();
      expect(entity.id, 'clinic-1');
      expect(entity.name, 'Klinik Sehat');
      expect(entity.latitude, -6.2);
      expect(entity.doctorCount, 5);
      expect(entity.distanceMeters, 1500);
      expect(entity.specializations, ['Umum', 'Gigi']);
    });
  });
}
