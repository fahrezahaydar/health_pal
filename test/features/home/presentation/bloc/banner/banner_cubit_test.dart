// D5 — BannerCubit
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/home/domain/entity/banner_entity.dart';
import 'package:health_pal/features/home/domain/usecase/get_banners_usecase.dart';
import 'package:health_pal/features/home/presentation/bloc/banner/banner_cubit.dart';
import 'package:health_pal/features/home/presentation/bloc/banner/banner_state.dart';
class _M extends Mock implements GetBannersUseCase {}
void main() {
  group('BannerCubit', () {
    late _M u; late BannerCubit c;
    setUp(() { u = _M(); c = BannerCubit(u); });
    tearDown(() => c.close());
    test('initial', () => expect(c.state, const BannerInitial()));
    test('loadBanners success', () async {
      when(() => u()).thenAnswer((_) async => const Success(<BannerEntity>[]));
      await c.loadBanners();
      expect(c.state, isA<BannerLoaded>());
    });
    test('loadBanners error', () async {
      when(() => u()).thenAnswer((_) async => const Failure(FailureCode.serverError, 'err'));
      await c.loadBanners();
      expect(c.state, isA<BannerError>());
    });
  });
}
