// test/features/doctor/data/model/clinic_model_test.dart
//
// Unit test untuk ClinicModel (Doctor) — manual fromJson/toJson.
// Referensi: lib/features/doctor/data/model/clinic_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/doctor/data/model/clinic_model.dart';

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
  };

  group('ClinicModel.fromJson', () {
    test('parses valid JSON correctly', () {
      final model = ClinicModel.fromJson(validJson);
      expect(model.id, 'clinic-1');
      expect(model.name, 'Klinik Sehat');
      expect(model.address, 'Jl. Sehat No. 1');
      expect(model.city, 'Jakarta');
      expect(model.latitude, -6.2);
      expect(model.longitude, 106.8);
    });

    test('parses JSON without optional fields', () {
      final json = <String, dynamic>{
        'id': 'clinic-2',
        'name': 'Klinik Minimal',
      };
      final model = ClinicModel.fromJson(json);
      expect(model.id, 'clinic-2');
      expect(model.address, isNull);
      expect(model.city, isNull);
      expect(model.latitude, isNull);
      expect(model.phone, isNull);
    });
  });

  group('ClinicModel.toJson', () {
    test('serializes to JSON correctly', () {
      final model = ClinicModel.fromJson(validJson);
      final json = model.toJson();
      expect(json['id'], 'clinic-1');
      expect(json['name'], 'Klinik Sehat');
      expect(json['image_url'], 'https://example.com/clinic.jpg');
    });
  });

  group('ClinicModel.toEntity', () {
    test('converts to ClinicEntity with matching fields', () {
      final model = ClinicModel.fromJson(validJson);
      final entity = model.toEntity();
      expect(entity.id, 'clinic-1');
      expect(entity.name, 'Klinik Sehat');
      expect(entity.address, 'Jl. Sehat No. 1');
    });
  });

  group('ClinicModel.fromEntity', () {
    test('creates model from ClinicEntity', () {
      final model = ClinicModel.fromJson(validJson);
      final entity = model.toEntity();
      final backToModel = ClinicModel.fromEntity(entity);
      expect(backToModel.id, 'clinic-1');
      expect(backToModel.name, 'Klinik Sehat');
    });
  });
}
