// test/features/home/data/model/user_profile_model_test.dart
//
// Unit test untuk UserProfileModel — @freezed with custom fromJson (not generated).
// Referensi: lib/features/home/data/model/user_profile_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/home/data/model/user_profile_model.dart';

void main() {
  group('UserProfileModel.fromJson', () {
    test('parses valid JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'profile-1',
        'nickname': 'Budi',
        'avatar_url': 'https://example.com/avatar.jpg',
        'is_profile_complete': true,
        'notif_reminder_enabled': false,
      };
      final model = UserProfileModel.fromJson(json);
      expect(model.id, 'profile-1');
      expect(model.nickname, 'Budi');
      expect(model.avatarUrl, 'https://example.com/avatar.jpg');
      expect(model.isProfileComplete, isTrue);
      expect(model.notifReminderEnabled, isFalse);
    });

    test('falls back nickname to full_name when nickname is null', () {
      final json = <String, dynamic>{
        'id': 'profile-2',
        'full_name': 'Budi Santoso',
      };
      final model = UserProfileModel.fromJson(json);
      expect(model.nickname, 'Budi Santoso');
    });

    test('uses defaults for missing optional fields', () {
      final json = <String, dynamic>{
        'id': 'profile-3',
        'nickname': 'Test',
      };
      final model = UserProfileModel.fromJson(json);
      expect(model.avatarUrl, isNull);
      expect(model.isProfileComplete, isFalse);
      expect(model.notifReminderEnabled, isTrue);
    });
  });

  group('UserProfileModel.toEntity', () {
    test('converts to UserProfileEntity with matching fields', () {
      final json = <String, dynamic>{
        'id': 'profile-4',
        'nickname': 'Sari',
        'avatar_url': 'https://example.com/sari.jpg',
        'is_profile_complete': true,
      };
      final model = UserProfileModel.fromJson(json);
      final entity = model.toEntity();
      expect(entity.id, 'profile-4');
      expect(entity.nickname, 'Sari');
      expect(entity.avatarUrl, 'https://example.com/sari.jpg');
      expect(entity.isProfileComplete, isTrue);
    });
  });
}
