// lib/features/profile/presentation/bloc/notification/notification_state.dart

import 'package:equatable/equatable.dart';

import '../../../domain/entity/notification_entity.dart';

sealed class NotificationListState extends Equatable {
  const NotificationListState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationListState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationListState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationListState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationLoaded(
    this.notifications, {
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationError extends NotificationListState {
  final String message;
  const NotificationError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
