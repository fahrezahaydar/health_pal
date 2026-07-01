// test/features/profile/data/model/notification_model_test.dart
//
// Unit test untuk NotificationModel — @freezed + fromJson.
// Referensi: lib/features/profile/data/model/notification_model.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/features/profile/data/model/notification_model.dart';

void main() {
  final validJson = <String, dynamic>{
    'id': 'notif-1',
    'user_id': 'user-1',
    'appointment_id': 'appt-1',
    'type': 'booking_confirmed',
    'title': 'Booking Dikonfirmasi',
    'body': 'Janji temu dengan dr. Andi telah dikonfirmasi',
    'is_read': false,
    'sent_at': '2026-06-15T09:00:00.000Z',
    'created_at': '2026-06-15T09:00:00.000Z',
  };

  group('NotificationModel.fromJson', () {
    test('parses valid JSON correctly', () {
      final model = NotificationModel.fromJson(validJson);
      expect(model.id, 'notif-1');
      expect(model.userId, 'user-1');
      expect(model.type, 'booking_confirmed');
      expect(model.title, 'Booking Dikonfirmasi');
      expect(model.isRead, isFalse);
    });

    test('parses JSON without optional fields', () {
      final json = <String, dynamic>{
        'id': 'notif-2',
        'user_id': 'user-1',
        'type': 'general',
        'title': 'Info',
        'body': 'Pesan informasi',
        'is_read': true,
        'sent_at': '2026-06-15T10:00:00.000Z',
      };
      final model = NotificationModel.fromJson(json);
      expect(model.appointmentId, isNull);
      expect(model.createdAt, isNull);
      expect(model.isRead, isTrue);
    });
  });

  group('NotificationModel.toEntity', () {
    test('converts to NotificationEntity with matching fields', () {
      final model = NotificationModel.fromJson(validJson);
      final entity = model.toEntity();
      expect(entity.id, 'notif-1');
      expect(entity.title, 'Booking Dikonfirmasi');
      expect(entity.body, 'Janji temu dengan dr. Andi telah dikonfirmasi');
      expect(entity.isRead, isFalse);
    });
  });
}
