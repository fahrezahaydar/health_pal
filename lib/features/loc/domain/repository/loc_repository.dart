// lib/features/loc/domain/repository/loc_repository.dart

import '../../../../core/network/result.dart';
import '../entity/clinic_entity.dart';

abstract class LocRepository {
  /// API §5.5 — Get nearby clinics dari PostgREST RPC.
  /// `radiusKm` default 10 km, max 50 km (API enforce 50000 m).
  Future<Result<List<ClinicEntity>>> getNearbyClinics({
    required double lat,
    required double lng,
    double radiusKm = 10.0,
  });
}
