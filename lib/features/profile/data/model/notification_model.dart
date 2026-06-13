// lib/features/profile/data/model/notification_model.dart
//
// Model untuk notification (API §8.1).
// Manual fromJson/toJson (sesuai pattern yang dipakai UserModel).

import '../../domain/entity/notification_entity.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String? appointmentId;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime sentAt;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    this.appointmentId,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.sentAt,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      appointmentId: json['appointment_id'] as String?,
      type: json['type'] as String? ?? 'general',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      sentAt: DateTime.parse(json['sent_at'] as String),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'appointment_id': appointmentId,
        'type': type,
        'title': title,
        'body': body,
        'is_read': isRead,
        'sent_at': sentAt.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
      };

  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        userId: userId,
        appointmentId: appointmentId,
        type: type,
        title: title,
        body: body,
        isRead: isRead,
        sentAt: sentAt,
        createdAt: createdAt,
      );
}
