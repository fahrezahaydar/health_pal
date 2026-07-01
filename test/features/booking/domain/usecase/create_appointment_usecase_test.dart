import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/booking/domain/entity/appointment_entity.dart';
import 'package:health_pal/features/booking/domain/repository/booking_repository.dart';
import 'package:health_pal/features/booking/domain/usecase/create_appointment_usecase.dart';

class _M extends Mock implements BookingRepository {}

void main() {
  test('returns Success and delegates to repository with all params', () async {
    final r = _M();
    final u = CreateAppointmentUseCase(r);
    when(() => r.createAppointment(
          doctorId: any(named: 'doctorId'),
          slotId: any(named: 'slotId'),
          complaintNote: any(named: 'complaintNote'),
        )).thenAnswer(
      (_) async => const Success(
        AppointmentEntity(
          id: 'a1',
          patientId: 'p1',
          doctorId: 'd1',
          slotId: 's1',
          status: 'pending',
          consultationFeeSnapshot: 0,
        ),
      ),
    );
    final result = await u(doctorId: 'd1', slotId: 's1', complaintNote: 'note');
    expect(result, isA<Success<AppointmentEntity>>());
    verify(() => r.createAppointment(
          doctorId: 'd1',
          slotId: 's1',
          complaintNote: 'note',
        )).called(1);
  });

  test('returns Failure on slot conflict (SLOT_ALREADY_BOOKED)', () async {
    final r = _M();
    final u = CreateAppointmentUseCase(r);
    when(() => r.createAppointment(
          doctorId: any(named: 'doctorId'),
          slotId: any(named: 'slotId'),
          complaintNote: any(named: 'complaintNote'),
        )).thenAnswer(
      (_) async => const Failure(FailureCode.conflict, 'slot already booked'),
    );
    final result = await u(doctorId: 'd1', slotId: 's1');
    expect(result, isA<Failure<AppointmentEntity>>());
    expect((result as Failure).code, FailureCode.conflict);
  });
}
