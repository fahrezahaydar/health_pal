// lib/features/profile/domain/usecase/get_profile_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../repository/profile_repository.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Result<UserEntity>> call() => _repository.getProfile();
}
