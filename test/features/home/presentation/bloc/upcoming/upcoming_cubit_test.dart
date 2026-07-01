// D7 — UpcomingCubit
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/home/domain/entity/upcoming_appointment_entity.dart';
import 'package:health_pal/features/home/domain/usecase/get_upcoming_appointment_usecase.dart';
import 'package:health_pal/features/home/presentation/bloc/upcoming/upcoming_cubit.dart';
import 'package:health_pal/features/home/presentation/bloc/upcoming/upcoming_state.dart';
class _M extends Mock implements GetUpcomingAppointmentUseCase {}
void main() {
  group('UpcomingCubit', () {
    late _M u; late UpcomingCubit c;
    setUp(() { u = _M(); c = UpcomingCubit(u); });
    tearDown(() => c.close());
    test('initial', () => expect(c.state, const UpcomingInitial()));
    test('load success', () async {
      when(() => u('pid')).thenAnswer((_) async => const Success<UpcomingAppointmentEntity?>(null));
      await c.loadUpcoming('pid');
      expect(c.state, isA<UpcomingLoaded>());
    });
    test('load error', () async {
      when(() => u('pid')).thenAnswer((_) async => const Failure(FailureCode.serverError, 'err'));
      await c.loadUpcoming('pid');
      expect(c.state, isA<UpcomingError>());
    });
  });
}
