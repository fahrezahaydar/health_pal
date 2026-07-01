import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/booking/domain/entity/appointment_entity.dart';
import 'package:health_pal/features/booking/domain/repository/booking_repository.dart';
import 'package:health_pal/features/booking/domain/usecase/get_appointment_history_usecase.dart';

class _M extends Mock implements BookingRepository {}

void main() {
  test('returns Success and delegates to repository with all params', () async {
    final r = _M();
    final u = GetAppointmentHistoryUseCase(r);
    when(() => r.getAppointmentHistory(
          patientId: any(named: 'patientId'),
          status: any(named: 'status'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        )).thenAnswer((_) async => const Success(<AppointmentEntity>[]));
    final result = await u(patientId: 'p1', status: 'upcoming');
    expect(result, isA<Success<List<AppointmentEntity>>>());
    verify(() => r.getAppointmentHistory(
          patientId: 'p1',
          status: 'upcoming',
          limit: 20,
          offset: 0,
        )).called(1);
  });

  test('returns Failure when repository fails', () async {
    final r = _M();
    final u = GetAppointmentHistoryUseCase(r);
    when(() => r.getAppointmentHistory(
          patientId: any(named: 'patientId'),
          status: any(named: 'status'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        )).thenAnswer(
      (_) async => const Failure(FailureCode.serverError, 'err'),
    );
    final result = await u(patientId: 'p1');
    expect(result, isA<Failure<List<AppointmentEntity>>>());
    expect((result as Failure).code, FailureCode.serverError);
  });
}
