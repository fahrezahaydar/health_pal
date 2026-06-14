import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

@injectable
class RegisterAndCreateProfileUseCase {
  final AuthRepository _repository;

  RegisterAndCreateProfileUseCase(this._repository);

  Future<Result<UserEntity>> call({
    required String email,
    required String password,
    required String fullName,
    required String nickname,
    required String gender,
    required DateTime dateOfBirth,
    File? photo,
  }) {
    return _repository.registerAndCreateProfile(
      email: email,
      password: password,
      fullName: fullName,
      nickname: nickname,
      gender: gender,
      dateOfBirth: dateOfBirth,
      photo: photo,
    );
  }
}
