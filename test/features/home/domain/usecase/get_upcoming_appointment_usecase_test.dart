import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/home/domain/repository/home_repository.dart';
import 'package:health_pal/features/home/domain/entity/upcoming_appointment_entity.dart';
import 'package:health_pal/features/home/domain/usecase/get_upcoming_appointment_usecase.dart';
class _M extends Mock implements HomeRepository {}
void main() {
  test('delegates', () async {
    final r = _M(); final u = GetUpcomingAppointmentUseCase(r);
    when(() => r.getUpcoming(any())).thenAnswer((_) async => const Success<UpcomingAppointmentEntity?>(null));
    expect(await u('pid'), isA<Success<UpcomingAppointmentEntity?>>());
  });
}
