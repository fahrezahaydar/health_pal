// lib/features/profile/domain/usecase/get_favorites_usecase.dart
//
// Favorites adalah placeholder v1.1 (per Fase 8 task 8.13). Endpoint ini
// selalu return list kosong — UI menampilkan empty state.

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../../../doctor/domain/entity/doctor_entity.dart';
import '../repository/profile_repository.dart';

@injectable
class GetFavoritesUseCase {
  final ProfileRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<Result<List<DoctorEntity>>> call() => _repository.getFavorites();
}
