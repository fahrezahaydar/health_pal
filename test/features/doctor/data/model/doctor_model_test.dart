// test/features/doctor/data/model/doctor_model_test.dart
//
// Unit test untuk DoctorModel — @freezed + nested objects.
// Referensi: lib/features/doctor/data/model/doctor_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/doctor/data/model/doctor_model.dart';

void main() {
  final validNestedJson = <String, dynamic>{
    'id': 'doctor-1',
    'clinic_id': 'clinic-1',
    'specialization_id': 'spec-1',
    'full_name': 'dr. Andi Pratama',
    'photo_url': 'https://example.com/doctor.jpg',
    'description': 'Dokter umum berpengalaman',
    'experience_years': 10,
    'education': 'FK UI',
    'consultation_fee': 150000,
    'rating_avg': 4.5,
    'rating_count': 120,
    'is_active': true,
    'total_patients': 500,
    'clinics': <String, dynamic>{
      'id': 'clinic-1',
      'name': 'Klinik Sehat',
      'address': 'Jl. Sehat No. 1',
      'city': 'Jakarta',
      'latitude': -6.2,
      'longitude': 106.8,
      'phone': '021-1234567',
      'image_url': 'https://example.com/clinic.jpg',
    },
    'specializations': <String, dynamic>{
      'id': 'spec-1',
      'name': 'Umum',
      'icon_url': 'https://example.com/icons/umum.svg',
    },
  };

  group('DoctorModel.fromJson', () {
    test('parses valid JSON with nested objects', () {
      final model = DoctorModel.fromJson(validNestedJson);
      expect(model.id, 'doctor-1');
      expect(model.fullName, 'dr. Andi Pratama');
      expect(model.experienceYears, 10);
      expect(model.consultationFee, 150000);
      expect(model.isActive, isTrue);

      // Nested
      expect(model.clinic, isNotNull);
      expect(model.clinic!.name, 'Klinik Sehat');
      expect(model.clinic!.city, 'Jakarta');

      expect(model.specialization, isNotNull);
      expect(model.specialization!.name, 'Umum');
    });

    test('parses JSON without nested objects', () {
      final json = <String, dynamic>{
        'id': 'doctor-2',
        'clinic_id': 'clinic-2',
        'specialization_id': 'spec-2',
        'full_name': 'dr. Minimal',
        'experience_years': 5,
        'consultation_fee': 100000,
      };
      final model = DoctorModel.fromJson(json);
      expect(model.fullName, 'dr. Minimal');
      expect(model.clinic, isNull);
      expect(model.specialization, isNull);
      expect(model.ratingAvg, 0.0);
      expect(model.isActive, isTrue);
    });
  });

  group('DoctorModel.toEntity', () {
    test('converts to DoctorEntity with all nested data', () {
      final model = DoctorModel.fromJson(validNestedJson);
      final entity = model.toEntity();
      expect(entity.id, 'doctor-1');
      expect(entity.fullName, 'dr. Andi Pratama');
      expect(entity.clinic, isNotNull);
      expect(entity.clinic!.name, 'Klinik Sehat');
      expect(entity.specialization, isNotNull);
      expect(entity.specialization!.name, 'Umum');
    });
  });
}
