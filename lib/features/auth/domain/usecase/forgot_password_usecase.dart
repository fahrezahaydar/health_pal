import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../repository/auth_repository.dart';

@injectable
class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<Result<void>> call(String email) {
    return _repository.sendResetPasswordEmail(email);
  }
}
