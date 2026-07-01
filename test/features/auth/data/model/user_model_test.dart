// test/features/auth/data/model/user_model_test.dart
//
// Unit test untuk UserModel — manual fromJson/toJson (bukan @freezed).
// Referensi: lib/features/auth/data/model/user_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/auth/data/model/user_model.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  final validJson = <String, dynamic>{
    'id': 'user-1',
    'auth_id': 'auth-1',
    'full_name': 'John Doe',
    'email': 'john@example.com',
    'nickname': 'Johnny',
    'avatar_url': 'https://example.com/avatar.jpg',
    'date_of_birth': '1990-01-15',
    'gender': 'male',
    'phone_number': '08123456789',
    'is_profile_complete': true,
  };

  group('UserModel.fromJson', () {
    test('parses valid JSON correctly', () {
      final model = UserModel.fromJson(validJson);
      expect(model.id, 'user-1');
      expect(model.authId, 'auth-1');
      expect(model.fullName, 'John Doe');
      expect(model.email, 'john@example.com');
      expect(model.nickname, 'Johnny');
      expect(model.dateOfBirth, DateTime(1990, 1, 15));
      expect(model.gender, 'male');
      expect(model.phoneNumber, '08123456789');
      expect(model.isProfileComplete, isTrue);
    });

    test('parses JSON without optional fields', () {
      final json = <String, dynamic>{
        'id': 'user-2',
        'auth_id': 'auth-2',
        'full_name': 'Jane Doe',
        'email': 'jane@example.com',
        'gender': 'female',
      };
      final model = UserModel.fromJson(json);
      expect(model.id, 'user-2');
      expect(model.nickname, isNull);
      expect(model.avatarUrl, isNull);
      expect(model.dateOfBirth, isNull);
      expect(model.phoneNumber, isNull);
      expect(model.isProfileComplete, isFalse);
    });

    test('handles missing email with empty string fallback', () {
      final json = <String, dynamic>{
        'id': 'user-3',
        'auth_id': 'auth-3',
        'full_name': 'No Email',
        'gender': 'female',
      };
      final model = UserModel.fromJson(json);
      expect(model.email, '');
    });

    test('handles missing is_profile_complete with false fallback', () {
      final json = <String, dynamic>{
        'id': 'user-4',
        'auth_id': 'auth-4',
        'full_name': 'Test',
        'email': 'test@test.com',
        'gender': 'male',
      };
      final model = UserModel.fromJson(json);
      expect(model.isProfileComplete, isFalse);
    });
  });

  group('UserModel.toJson', () {
    test('roundtrip: toJson after fromJson produces same keys', () {
      final model = UserModel.fromJson(validJson);
      final json = model.toJson();
      expect(json['id'], 'user-1');
      expect(json['auth_id'], 'auth-1');
      expect(json['full_name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['date_of_birth'], '1990-01-15T00:00:00.000');
    });

    test('omits null optional fields', () {
      final model = UserModel.fromJson(<String, dynamic>{
        'id': 'user-5',
        'auth_id': 'auth-5',
        'full_name': 'Nulls',
        'email': 'nulls@test.com',
        'gender': 'female',
      });
      final json = model.toJson();
      expect(json['nickname'], isNull);
      expect(json['avatar_url'], isNull);
      expect(json['date_of_birth'], isNull);
      expect(json['phone_number'], isNull);
    });
  });

  group('UserModel.toEntity', () {
    test('converts to UserEntity with matching fields', () {
      final model = UserModel.fromJson(validJson);
      final entity = model.toEntity();
      expect(entity.id, model.id);
      expect(entity.authId, model.authId);
      expect(entity.fullName, model.fullName);
      expect(entity.email, model.email);
      expect(entity.nickname, model.nickname);
    });
  });

  group('UserModel.fromEntity', () {
    test('creates model from UserEntity', () {
      final user = TestData.mockUser(id: 'entity-id', email: 'entity@test.com');
      final model = UserModel.fromEntity(user);
      expect(model.id, 'entity-id');
      expect(model.email, 'entity@test.com');
    });
  });
}
