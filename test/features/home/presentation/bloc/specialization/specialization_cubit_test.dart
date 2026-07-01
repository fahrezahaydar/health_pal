// D6 — SpecializationCubit
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/home/domain/entity/specialization_entity.dart';
import 'package:health_pal/features/home/domain/usecase/get_specializations_usecase.dart';
import 'package:health_pal/features/home/presentation/bloc/specialization/specialization_cubit.dart';
import 'package:health_pal/features/home/presentation/bloc/specialization/specialization_state.dart';
class _M extends Mock implements GetSpecializationsUseCase {}
void main() {
  group('SpecializationCubit', () {
    late _M u; late SpecializationCubit c;
    setUp(() { u = _M(); c = SpecializationCubit(u); });
    tearDown(() => c.close());
    test('initial', () => expect(c.state, const SpecializationInitial()));
    test('load success', () async {
      when(() => u()).thenAnswer((_) async => const Success(<SpecializationEntity>[]));
      await c.loadSpecializations();
      expect(c.state, isA<SpecializationLoaded>());
    });
    test('load error', () async {
      when(() => u()).thenAnswer((_) async => const Failure(FailureCode.serverError, 'err'));
      await c.loadSpecializations();
      expect(c.state, isA<SpecializationError>());
    });
  });
}
