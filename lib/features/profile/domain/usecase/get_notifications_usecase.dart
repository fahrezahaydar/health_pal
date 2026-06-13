// lib/features/profile/domain/usecase/get_notifications_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/notification_entity.dart';
import '../repository/profile_repository.dart';

@injectable
class GetNotificationsUseCase {
  final ProfileRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<Result<List<NotificationEntity>>> call({
    required String userId,
    int limit = 30,
    int offset = 0,
  }) {
    return _repository.getNotifications(
      userId: userId,
      limit: limit,
      offset: offset,
    );
  }
}

@injectable
class MarkNotificationAsReadUseCase {
  final ProfileRepository _repository;

  MarkNotificationAsReadUseCase(this._repository);

  Future<Result<void>> call({
    required String userId,
    required String notificationId,
  }) {
    return _repository.markNotificationAsRead(
      userId: userId,
      notificationId: notificationId,
    );
  }
}
