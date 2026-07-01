// test/features/booking/data/repository/booking_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/booking/data/datasource/booking_remote_datasource.dart';
import 'package:health_pal/features/booking/data/model/appointment_model.dart';
import 'package:health_pal/features/booking/data/repository/booking_repository_impl.dart';
import 'package:health_pal/features/booking/domain/entity/appointment_entity.dart';

class MockRemote extends Mock implements BookingRemoteDataSource {}

void main() {
  late MockRemote remote;
  late BookingRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(const AppointmentModel(
      id: 'fb', patientId: 'fb', doctorId: 'fb', slotId: 'fb',
      status: 'pending', consultationFeeSnapshot: 0,
    ));
  });

  setUp(() {
    remote = MockRemote();
    repo = BookingRepositoryImpl(remote);
  });

  group('getAppointmentHistory', () {
    test('returns appointment list on success', () async {
      when(() => remote.getAppointmentHistory(
        patientId: any(named: 'patientId'),
        status: any(named: 'status'),
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      )).thenAnswer((_) async => [
        const AppointmentModel(id: 'a1', patientId: 'p1', doctorId: 'd1',
          slotId: 's1', status: 'upcoming', consultationFeeSnapshot: 150000),
      ]);

      final result = await repo.getAppointmentHistory(patientId: 'p1');
      expect(result, isA<Success<List<AppointmentEntity>>>());
    });
  });

  group('getAppointmentDetail', () {
    test('returns appointment on success', () async {
      when(() => remote.getAppointmentDetail(
        patientId: any(named: 'patientId'),
        appointmentId: any(named: 'appointmentId'),
      )).thenAnswer((_) async =>
        const AppointmentModel(id: 'a1', patientId: 'p1', doctorId: 'd1',
          slotId: 's1', status: 'upcoming', consultationFeeSnapshot: 150000));

      final result = await repo.getAppointmentDetail(
        patientId: 'p1', appointmentId: 'a1');
      expect(result, isA<Success<AppointmentEntity>>());
    });
  });

  group('createAppointment', () {
    test('returns created appointment on success', () async {
      when(() => remote.createAppointment(
        doctorId: any(named: 'doctorId'),
        slotId: any(named: 'slotId'),
        complaintNote: any(named: 'complaintNote'),
      )).thenAnswer((_) async =>
        const AppointmentModel(id: 'a2', patientId: 'p1', doctorId: 'd1',
          slotId: 's1', status: 'pending', consultationFeeSnapshot: 150000));

      final result = await repo.createAppointment(
        doctorId: 'd1', slotId: 's1');
      expect(result, isA<Success<AppointmentEntity>>());
    });
  });

  group('cancelAppointment', () {
    test('returns Success on cancel', () async {
      when(() => remote.cancelAppointment(
        appointmentId: any(named: 'appointmentId'),
        cancellationReason: any(named: 'cancellationReason'),
      )).thenAnswer((_) async => const AppointmentModel(
        id: 'a1', patientId: 'p1', doctorId: 'd1',
        slotId: 's1', status: 'cancelled', consultationFeeSnapshot: 150000));

      final result = await repo.cancelAppointment(
        appointmentId: 'a1', cancellationReason: 'reason');
      expect(result, isA<Success<AppointmentEntity>>());
    });
  });
}
