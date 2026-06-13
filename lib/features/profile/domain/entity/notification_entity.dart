// lib/features/profile/domain/entity/notification_entity.dart

import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String? appointmentId;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime sentAt;
  final DateTime? createdAt;

  const NotificationEntity({
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

  NotificationEntity copyWith({bool? isRead}) => NotificationEntity(
        id: id,
        userId: userId,
        appointmentId: appointmentId,
        type: type,
        title: title,
        body: body,
        isRead: isRead ?? this.isRead,
        sentAt: sentAt,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [
        id,
        userId,
        appointmentId,
        type,
        title,
        body,
        isRead,
        sentAt,
        createdAt,
      ];
}
