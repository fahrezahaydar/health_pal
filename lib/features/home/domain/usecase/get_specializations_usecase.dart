import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/specialization_entity.dart';
import '../repository/home_repository.dart';

@injectable
class GetSpecializationsUseCase {
  final HomeRepository _repository;

  GetSpecializationsUseCase(this._repository);

  Future<Result<List<SpecializationEntity>>> call() =>
      _repository.getSpecializations();
}
