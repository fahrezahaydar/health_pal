// lib/features/profile/presentation/bloc/notification/notification_cubit.dart

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

  NotificationCubit(this._getNotifications)
    : super(const NotificationInitial());

  Future<void> loadNotifications(String userId) async {
    emit(const NotificationLoading());
    final result = await _getNotifications(userId: userId);
    switch (result) {
      case Success<List<NotificationEntity>>(:final data):
        emit(NotificationLoaded(data));
      case Failure(:final message):
        emit(NotificationError(message: message));
    }
  }
}
