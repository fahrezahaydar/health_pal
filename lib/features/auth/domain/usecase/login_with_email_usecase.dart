import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

@injectable
class LoginWithEmailUseCase {
  final AuthRepository _repository;

  LoginWithEmailUseCase(this._repository);

  Future<Result<UserEntity>> call(String email, String password) {
    return _repository.signInWithEmail(email, password);
  }
}
