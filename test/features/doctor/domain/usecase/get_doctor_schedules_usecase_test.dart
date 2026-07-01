import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_schedule_entity.dart';
import 'package:health_pal/features/doctor/domain/repository/doctor_repository.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_schedules_usecase.dart';

class _M extends Mock implements DoctorRepository {}

void main() {
  test('returns Success and delegates to repository with doctorId', () async {
    final r = _M();
    final u = GetDoctorSchedulesUseCase(r);
    when(() => r.getDoctorSchedules(any()))
        .thenAnswer((_) async => const Success(<DoctorScheduleEntity>[]));
    final result = await u('d1');
    expect(result, isA<Success<List<DoctorScheduleEntity>>>());
    verify(() => r.getDoctorSchedules('d1')).called(1);
  });

  test('returns Failure when repository fails', () async {
    final r = _M();
    final u = GetDoctorSchedulesUseCase(r);
    when(() => r.getDoctorSchedules(any())).thenAnswer(
      (_) async => const Failure(FailureCode.serverError, 'err'),
    );
    final result = await u('d1');
    expect(result, isA<Failure<List<DoctorScheduleEntity>>>());
    expect((result as Failure).code, FailureCode.serverError);
  });
}
