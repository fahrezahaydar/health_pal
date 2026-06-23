import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

@injectable
class CreateProfileUseCase {
  final AuthRepository _repository;

  CreateProfileUseCase(this._repository);

  Future<Result<UserEntity>> call({
    required String email,
    required String fullName,
    required String nickname,
    required String gender,
    required DateTime dateOfBirth,
    required String createdAuthId,
    File? photo,
  }) {
    return _repository.createProfile({
      'auth_id': createdAuthId,
      'full_name': fullName,
      'nickname': nickname,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String().split('T').first,
      'is_profile_complete': true,
    }, photo: photo);
  }
}
