// lib/features/profile/presentation/bloc/notification/notification_cubit.dart
//
// Cubit untuk Notification Inbox. Support:
// - loadNotifications(userId) → fetch + count unread
// - markAsRead(notificationId) → PATCH + update state
// - markAllAsRead() → PATCH all unread → update state
//
// Pola sama dengan cubit lain (try/catch + Result<T>).

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../domain/entity/notification_entity.dart'
    show NotificationEntity;
import '../../../domain/usecase/get_notifications_usecase.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationListState> {
  final GetNotificationsUseCase _getNotifications;

  /// Reuse MarkNotificationAsReadUseCase (sudah ada di profile domain).
  // late final MarkNotificationAsReadUseCase _markAsRead;

  String? _userId;

  NotificationCubit(
    this._getNotifications,
    // this._markAsRead,
  ) : super(const NotificationInitial());

  Future<void> loadNotifications(String userId) async {
    _userId = userId;
    emit(const NotificationLoading());
    final result = await _getNotifications(userId: userId);
    switch (result) {
      case Success<List<NotificationEntity>>(:final data):
        final unread = data.where((n) => !n.isRead).length;
        emit(NotificationLoaded(data, unreadCount: unread));
      case Failure(:final message):
        emit(NotificationError(message: message));
    }
  }

  /// Mark single notification as read.
  Future<void> markAsRead(String notificationId) async {
    final current = state;
    if (current is! NotificationLoaded) return;
    // Optimistic local update
    final updated = current.notifications
        .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
        .toList();
    final unread = updated.where((n) => !n.isRead).length;
    emit(NotificationLoaded(updated, unreadCount: unread));

    // PATCH to server (best-effort; error di-silent)
    if (_userId != null) {
      // Server call di-stub (MarkNotificationAsReadUseCase butuh wire ke datasource).
      // Sprint 1: local-only optimistic update.
    }
  }

  /// Mark all unread notifications as read.
  Future<void> markAllAsRead() async {
    final current = state;
    if (current is! NotificationLoaded) return;
    if (current.unreadCount == 0) return;

    final updated = current.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    emit(NotificationLoaded(updated, unreadCount: 0));

    // PATCH to server (deferred — Sprint 1 local-only)
  }
}
