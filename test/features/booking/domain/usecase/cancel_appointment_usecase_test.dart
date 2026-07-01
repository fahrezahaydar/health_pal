import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/booking/domain/entity/appointment_entity.dart';
import 'package:health_pal/features/booking/domain/repository/booking_repository.dart';
import 'package:health_pal/features/booking/domain/usecase/cancel_appointment_usecase.dart';

class _M extends Mock implements BookingRepository {}

void main() {
  test('returns Success and delegates to repository with all params', () async {
    final r = _M();
    final u = CancelAppointmentUseCase(r);
    when(() => r.cancelAppointment(
          appointmentId: any(named: 'appointmentId'),
          cancellationReason: any(named: 'cancellationReason'),
        )).thenAnswer(
      (_) async => const Success(
        AppointmentEntity(
          id: 'a1',
          patientId: 'p1',
          doctorId: 'd1',
          slotId: 's1',
          status: 'cancelled',
          consultationFeeSnapshot: 0,
        ),
      ),
    );
    final result = await u(appointmentId: 'a1', cancellationReason: 'r');
    expect(result, isA<Success<AppointmentEntity>>());
    verify(() => r.cancelAppointment(
          appointmentId: 'a1',
          cancellationReason: 'r',
        )).called(1);
  });

  test('returns Failure when repository fails (e.g. conflict — too late to cancel)', () async {
    final r = _M();
    final u = CancelAppointmentUseCase(r);
    when(() => r.cancelAppointment(
          appointmentId: any(named: 'appointmentId'),
          cancellationReason: any(named: 'cancellationReason'),
        )).thenAnswer(
      (_) async => const Failure(FailureCode.conflict, 'cannot cancel'),
    );
    final result = await u(appointmentId: 'a1');
    expect(result, isA<Failure<AppointmentEntity>>());
    expect((result as Failure).code, FailureCode.conflict);
  });
}
