// lib/features/loc/data/datasource/loc_remote_datasource.dart
//
// DataSource untuk nearby clinics endpoint. Pattern sama dengan
// DoctorRemoteDataSource — pakai Supabase PostgREST.
//
// Per API Contract §5.5 — `POST /rest/v1/rpc/get_nearby_clinics`.
// Memanggil PostgreSQL function dengan Haversine formula (di SQL).
//
// RLS: public read (tidak perlu auth — sesuai ERD §8 clinic table policy).

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/clinic_model.dart';

@injectable
class LocRemoteDataSource {
  final SupabaseClient _client;

  LocRemoteDataSource(this._client);

  // ── API §5.5 Get Nearby Clinics (PostgREST RPC) ──────────────────────────
  /// `radiusKm` di-convert ke `radius_meters` di sini (API pakai int meters).
  Future<List<ClinicModel>> getNearbyClinics({
    required double lat,
    required double lng,
    double radiusKm = 10.0,
  }) async {
    final radiusMeters = (radiusKm * 1000).toInt();
    final result = await _client.rpc<List<dynamic>>(
      'get_nearby_clinics',
      params: {
        'user_lat': lat,
        'user_lng': lng,
        'radius_meters': radiusMeters,
      },
    );

    return result
        .map((e) => ClinicModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
