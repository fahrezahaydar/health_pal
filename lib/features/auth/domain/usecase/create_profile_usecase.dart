import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

@injectable
class CreateProfileUseCase {
  final AuthRepository _repository;

  CreateProfileUseCase(this._repository);

  Future<Result<UserEntity>> call(Map<String, dynamic> data, {File? photo}) {
    return _repository.createProfile(data, photo: photo);
  }
}
