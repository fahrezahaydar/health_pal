// test/features/home/data/model/banner_model_test.dart
//
// Unit test untuk BannerModel — @freezed + JsonKey.
// Referensi: lib/features/home/data/model/banner_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/home/data/model/banner_model.dart';

void main() {
  final validJson = <String, dynamic>{
    'id': 'banner-1',
    'title': 'Promo Spesial',
    'image_url': 'https://example.com/banner.jpg',
    'action_url': 'https://example.com/promo',
    'display_order': 1,
  };

  group('BannerModel.fromJson', () {
    test('parses valid JSON correctly', () {
      final model = BannerModel.fromJson(validJson);
      expect(model.id, 'banner-1');
      expect(model.title, 'Promo Spesial');
      expect(model.imageUrl, 'https://example.com/banner.jpg');
      expect(model.actionUrl, 'https://example.com/promo');
      expect(model.displayOrder, 1);
    });

    test('parses JSON without optional fields', () {
      final json = <String, dynamic>{
        'id': 'banner-2',
        'title': 'Minimal',
      };
      final model = BannerModel.fromJson(json);
      expect(model.id, 'banner-2');
      expect(model.title, 'Minimal');
      expect(model.imageUrl, isNull);
      expect(model.actionUrl, isNull);
      expect(model.displayOrder, 0); // @Default(0)
    });
  });

  group('BannerModel.toEntity', () {
    test('converts to BannerEntity with matching fields', () {
      final model = BannerModel.fromJson(validJson);
      final entity = model.toEntity();
      expect(entity.id, model.id);
      expect(entity.title, model.title);
      expect(entity.imageUrl, model.imageUrl);
      expect(entity.actionUrl, model.actionUrl);
      expect(entity.displayOrder, model.displayOrder);
    });
  });
}
