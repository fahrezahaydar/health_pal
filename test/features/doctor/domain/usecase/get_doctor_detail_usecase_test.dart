import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_entity.dart';
import 'package:health_pal/features/doctor/domain/repository/doctor_repository.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_detail_usecase.dart';

class _M extends Mock implements DoctorRepository {}

void main() {
  test('returns Success and delegates to repository with doctorId', () async {
    final r = _M();
    final u = GetDoctorDetailUseCase(r);
    when(() => r.getDoctorDetail(any())).thenAnswer(
      (_) async => const Success(
        DoctorEntity(
          id: 'd1',
          clinicId: 'c1',
          specializationId: 's1',
          fullName: 'Dr Test',
          experienceYears: 5,
          consultationFee: 100000,
        ),
      ),
    );
    final result = await u('d1');
    expect(result, isA<Success<DoctorEntity>>());
    verify(() => r.getDoctorDetail('d1')).called(1);
  });

  test('returns Failure when repository fails', () async {
    final r = _M();
    final u = GetDoctorDetailUseCase(r);
    when(() => r.getDoctorDetail(any())).thenAnswer(
      (_) async => const Failure(FailureCode.notFound, 'doctor not found'),
    );
    final result = await u('d1');
    expect(result, isA<Failure<DoctorEntity>>());
    expect((result as Failure).code, FailureCode.notFound);
  });
}
