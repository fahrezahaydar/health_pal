// lib/features/loc/data/repository/loc_repository_impl.dart
//
// Implementasi LocRepository. Pattern sama dengan repository lain
// (try/catch + Result<T>).

import 'package:injectable/injectable.dart';

import '../../../../core/network/error_handler.dart';
import '../../../../core/network/result.dart';
import '../../domain/entity/clinic_entity.dart';
import '../../domain/repository/loc_repository.dart';
import '../datasource/loc_remote_datasource.dart';
import '../model/clinic_model.dart';

@Injectable(as: LocRepository)
class LocRepositoryImpl implements LocRepository {
  final LocRemoteDataSource _remote;

  LocRepositoryImpl(this._remote);

  @override
  Future<Result<List<ClinicEntity>>> getNearbyClinics({
    required double lat,
    required double lng,
    double radiusKm = 10.0,
  }) async {
    try {
      final remote = await _remote.getNearbyClinics(
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
      );
      return Result.success(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }
}
