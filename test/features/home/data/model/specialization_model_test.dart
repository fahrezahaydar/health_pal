// test/features/home/data/model/specialization_model_test.dart
//
// Unit test untuk SpecializationModel — @freezed + JsonKey.
// Referensi: lib/features/home/data/model/specialization_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/home/data/model/specialization_model.dart';

void main() {
  group('SpecializationModel.fromJson', () {
    test('parses valid JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'spec-1',
        'name': 'Umum',
        'icon_url': 'https://example.com/icons/umum.svg',
        'color_hex': '#4A90D9',
      };
      final model = SpecializationModel.fromJson(json);
      expect(model.id, 'spec-1');
      expect(model.name, 'Umum');
      expect(model.iconUrl, 'https://example.com/icons/umum.svg');
      expect(model.colorHex, '#4A90D9');
    });

    test('parses JSON without optional fields', () {
      final json = <String, dynamic>{
        'id': 'spec-2',
        'name': 'Gigi',
      };
      final model = SpecializationModel.fromJson(json);
      expect(model.id, 'spec-2');
      expect(model.name, 'Gigi');
      expect(model.iconUrl, isNull);
      expect(model.colorHex, isNull);
    });
  });

  group('SpecializationModel.toEntity', () {
    test('converts to SpecializationEntity with matching fields', () {
      final json = <String, dynamic>{
        'id': 'spec-3',
        'name': 'Jantung',
        'icon_url': 'https://example.com/icons/jantung.svg',
        'color_hex': '#E74C3C',
      };
      final model = SpecializationModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, model.id);
      expect(entity.name, model.name);
      expect(entity.iconUrl, model.iconUrl);
      expect(entity.colorHex, model.colorHex);
    });

    test('toEntity handles missing optional fields', () {
      final json = <String, dynamic>{
        'id': 'spec-4',
        'name': 'Saraf',
      };
      final model = SpecializationModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.iconUrl, isNull);
    });
  });
}
