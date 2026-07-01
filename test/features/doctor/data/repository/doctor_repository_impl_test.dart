// test/features/doctor/data/repository/doctor_repository_impl_test.dart

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/doctor/data/datasource/doctor_remote_datasource.dart';
import 'package:health_pal/features/doctor/data/model/doctor_model.dart';
import 'package:health_pal/features/doctor/data/model/doctor_schedule_model.dart';
import 'package:health_pal/features/doctor/data/model/doctor_slot_model.dart';
import 'package:health_pal/features/doctor/data/repository/doctor_repository_impl.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_schedule_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_slot_entity.dart';

class MockRemote extends Mock implements DoctorRemoteDataSource {}

void main() {
  late MockRemote remote;
  late DoctorRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(const DoctorModel(
      id: 'fb', clinicId: 'fb', specializationId: 'fb',
      fullName: 'fb', experienceYears: 0, consultationFee: 0,
    ));
  });

  setUp(() {
    remote = MockRemote();
    repo = DoctorRepositoryImpl(remote);
  });

  group('getDoctors', () {
    test('returns doctor list on success', () async {
      when(() => remote.searchDoctors(
        specializationId: any(named: 'specializationId'),
        query: any(named: 'query'),
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      )).thenAnswer((_) async => [
        const DoctorModel(id: 'd1', clinicId: 'c1', specializationId: 's1',
          fullName: 'Dr. A', experienceYears: 5, consultationFee: 100000),
      ]);

      final result = await repo.getDoctors();
      expect(result, isA<Success<List<DoctorEntity>>>());
    });

    test('returns failure on error', () async {
      when(() => remote.searchDoctors(
        specializationId: any(named: 'specializationId'),
        query: any(named: 'query'),
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      )).thenThrow(Exception('error'));

      final result = await repo.getDoctors();
      expect(result, isA<Failure<List<DoctorEntity>>>());
    });
  });

  group('getDoctorDetail', () {
    test('returns doctor entity on success', () async {
      when(() => remote.getDoctorDetail('d1')).thenAnswer((_) async =>
        const DoctorModel(id: 'd1', clinicId: 'c1', specializationId: 's1',
          fullName: 'Dr. B', experienceYears: 10, consultationFee: 200000));

      final result = await repo.getDoctorDetail('d1');
      expect(result, isA<Success<DoctorEntity>>());
    });
  });

  group('getDoctorSchedules', () {
    test('returns schedule list on success', () async {
      when(() => remote.getDoctorSchedules('d1')).thenAnswer((_) async => [
        const DoctorScheduleModel(id: 'sch1', doctorId: 'd1',
          dayOfWeek: 1, startTime: '08:00', endTime: '17:00'),
      ]);

      final result = await repo.getDoctorSchedules('d1');
      expect(result, isA<Success<List<DoctorScheduleEntity>>>());
    });
  });

  group('getDoctorSlots', () {
    test('returns slot list on success', () async {
      when(() => remote.getDoctorSlots('d1', DateTime(2026, 6, 15)))
          .thenAnswer((_) async => [
        DoctorSlotModel(id: 'sl1', doctorId: 'd1',
          slotDate: DateTime(2026, 6, 15),
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 30)),
      ]);

      final result = await repo.getDoctorSlots('d1', DateTime(2026, 6, 15));
      expect(result, isA<Success<List<DoctorSlotEntity>>>());
    });
  });

  group('getAvailableSlotCount', () {
    test('returns count on success', () async {
      when(() => remote.getAvailableSlotCount(
        doctorId: any(named: 'doctorId'),
        daysAhead: any(named: 'daysAhead'),
      )).thenAnswer((_) async => 5);

      final result = await repo.getAvailableSlotCount(doctorId: 'd1');
      expect(result, isA<Success<int>>());
    });
  });
}
