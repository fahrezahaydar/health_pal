import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/profile/domain/entity/notification_entity.dart';
import 'package:health_pal/features/profile/domain/repository/profile_repository.dart';
import 'package:health_pal/features/profile/domain/usecase/get_notifications_usecase.dart';

class _M extends Mock implements ProfileRepository {}

void main() {
  test('returns Success and delegates to repository with userId', () async {
    final r = _M();
    final u = GetNotificationsUseCase(r);
    when(() => r.getNotifications(
          userId: any(named: 'userId'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        )).thenAnswer((_) async => const Success(<NotificationEntity>[]));
    final result = await u(userId: 'u1');
    expect(result, isA<Success<List<NotificationEntity>>>());
    verify(() => r.getNotifications(
          userId: 'u1',
          limit: 30,
          offset: 0,
        )).called(1);
  });

  test('returns Failure when repository fails', () async {
    final r = _M();
    final u = GetNotificationsUseCase(r);
    when(() => r.getNotifications(
          userId: any(named: 'userId'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        )).thenAnswer(
      (_) async => const Failure(FailureCode.serverError, 'err'),
    );
    final result = await u(userId: 'u1');
    expect(result, isA<Failure<List<NotificationEntity>>>());
    expect((result as Failure).code, FailureCode.serverError);
  });
}
