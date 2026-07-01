// C6
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/home/domain/repository/home_repository.dart';
import 'package:health_pal/features/home/domain/entity/specialization_entity.dart';
import 'package:health_pal/features/home/domain/usecase/get_specializations_usecase.dart';
class _M extends Mock implements HomeRepository {}
void main() {
  test('delegates', () async {
    final r = _M(); final u = GetSpecializationsUseCase(r);
    when(() => r.getSpecializations()).thenAnswer((_) async => const Success(<SpecializationEntity>[]));
    expect(await u(), isA<Success<List<SpecializationEntity>>>());
  });
}
