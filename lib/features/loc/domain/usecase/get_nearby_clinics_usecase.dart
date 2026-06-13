// lib/features/loc/domain/usecase/get_nearby_clinics_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/clinic_entity.dart';
import '../repository/loc_repository.dart';

@injectable
class GetNearbyClinicsUseCase {
  final LocRepository _repository;

  GetNearbyClinicsUseCase(this._repository);

  Future<Result<List<ClinicEntity>>> call({
    required double lat,
    required double lng,
    double radiusKm = 10.0,
  }) {
    return _repository.getNearbyClinics(
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
    );
  }
}
