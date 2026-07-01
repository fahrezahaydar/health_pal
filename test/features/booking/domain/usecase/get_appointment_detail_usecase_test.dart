import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/booking/domain/entity/appointment_entity.dart';
import 'package:health_pal/features/booking/domain/repository/booking_repository.dart';
import 'package:health_pal/features/booking/domain/usecase/get_appointment_detail_usecase.dart';

class _M extends Mock implements BookingRepository {}

void main() {
  test('returns Success and delegates to repository with both params', () async {
    final r = _M();
    final u = GetAppointmentDetailUseCase(r);
    when(() => r.getAppointmentDetail(
          patientId: any(named: 'patientId'),
          appointmentId: any(named: 'appointmentId'),
        )).thenAnswer(
      (_) async => const Success(
        AppointmentEntity(
          id: 'a1',
          patientId: 'p1',
          doctorId: 'd1',
          slotId: 's1',
          status: 'upcoming',
          consultationFeeSnapshot: 0,
        ),
      ),
    );
    final result = await u(patientId: 'p1', appointmentId: 'a1');
    expect(result, isA<Success<AppointmentEntity>>());
    verify(() => r.getAppointmentDetail(
          patientId: 'p1',
          appointmentId: 'a1',
        )).called(1);
  });

  test('returns Failure when repository fails (e.g. unauthorized)', () async {
    final r = _M();
    final u = GetAppointmentDetailUseCase(r);
    when(() => r.getAppointmentDetail(
          patientId: any(named: 'patientId'),
          appointmentId: any(named: 'appointmentId'),
        )).thenAnswer(
      (_) async => const Failure(FailureCode.unauthorized, 'not your appointment'),
    );
    final result = await u(patientId: 'p1', appointmentId: 'a1');
    expect(result, isA<Failure<AppointmentEntity>>());
    expect((result as Failure).code, FailureCode.unauthorized);
  });
}
