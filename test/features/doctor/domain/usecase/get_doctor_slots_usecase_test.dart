import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_slot_entity.dart';
import 'package:health_pal/features/doctor/domain/repository/doctor_repository.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_slots_usecase.dart';

class _M extends Mock implements DoctorRepository {}

void main() {
  test('returns Success and delegates to repository with both params', () async {
    final r = _M();
    final u = GetDoctorSlotsUseCase(r);
    final date = DateTime(2026, 7, 1);
    when(() => r.getDoctorSlots(any(), any()))
        .thenAnswer((_) async => const Success(<DoctorSlotEntity>[]));
    final result = await u('d1', date);
    expect(result, isA<Success<List<DoctorSlotEntity>>>());
    verify(() => r.getDoctorSlots('d1', date)).called(1);
  });

  test('returns Failure when repository fails', () async {
    final r = _M();
    final u = GetDoctorSlotsUseCase(r);
    when(() => r.getDoctorSlots(any(), any())).thenAnswer(
      (_) async => const Failure(FailureCode.serverError, 'err'),
    );
    final result = await u('d1', DateTime(2026, 7, 1));
    expect(result, isA<Failure<List<DoctorSlotEntity>>>());
    expect((result as Failure).code, FailureCode.serverError);
  });
}
