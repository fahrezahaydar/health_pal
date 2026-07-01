// C5
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/home/domain/repository/home_repository.dart';
import 'package:health_pal/features/home/domain/entity/banner_entity.dart';
import 'package:health_pal/features/home/domain/usecase/get_banners_usecase.dart';
class _M extends Mock implements HomeRepository {}
void main() {
  test('delegates to repository', () async {
    final r = _M(); final u = GetBannersUseCase(r);
    when(() => r.getBanners()).thenAnswer((_) async => const Success(<BannerEntity>[]));
    expect(await u(), isA<Success<List<BannerEntity>>>());
  });
}
