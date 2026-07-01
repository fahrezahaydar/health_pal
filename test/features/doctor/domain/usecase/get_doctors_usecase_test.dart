// C9
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/doctor/domain/repository/doctor_repository.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_entity.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctors_usecase.dart';
class _M extends Mock implements DoctorRepository {}
void main() {
  test('delegates', () async {
    final r = _M(); final u = GetDoctorsUseCase(r);
    when(() => r.getDoctors()).thenAnswer((_) async => const Success(<DoctorEntity>[]));
    expect(await u(), isA<Success<List<DoctorEntity>>>());
  });
}
