import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/user_profile_entity.dart';
import '../repository/home_repository.dart';

@injectable
class GetUserProfileUseCase {
  final HomeRepository _repository;

  GetUserProfileUseCase(this._repository);

  Future<Result<UserProfileEntity>> call(String authId) =>
      _repository.getUserProfile(authId);
}
