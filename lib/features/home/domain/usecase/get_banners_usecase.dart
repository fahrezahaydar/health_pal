import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/banner_entity.dart';
import '../repository/home_repository.dart';

@injectable
class GetBannersUseCase {
  final HomeRepository _repository;

  GetBannersUseCase(this._repository);

  Future<Result<List<BannerEntity>>> call() => _repository.getBanners();
}
