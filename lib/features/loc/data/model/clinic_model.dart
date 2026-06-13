// lib/features/loc/data/model/clinic_model.dart
//
// Per API Contract §5.5 — ClinicModel untuk response get_nearby_clinics.
//
// Fields mirror dari response API (snake_case di JSON, @JsonKey mapping):
//   id, name, address, city, latitude, longitude, phone, imageUrl,
//   distanceMeters, doctorCount
//
// ADAPTASI DARI USER SPEC:
// - API pakai `radius_meters` (int, default 10000) — BUKAN `radius_km` (double).
//   Konversi di repository: km → m.
// - API response `distance_meters` (float) — BUKAN `distance` (double).
//   Convert ke km di entity layer (distanceKm).
// - API response `phone` (string) — pakai `phone` BUKAN `phoneNumber`.
// - API response `image_url` (nullable string) — pakai `imageUrl`.
// - API TIDAK return `specializations` — field ini opsional (default null),
//   di-populate di future endpoint (e.g. /rest/v1/clinics/:id/doctors).
// - API return `doctor_count` (int) — lebih relevan dari "specializations"
//   untuk display "5 dokter tersedia" di card.

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/clinic_entity.dart';

part 'clinic_model.freezed.dart';
part 'clinic_model.g.dart';

@freezed
abstract class ClinicModel with _$ClinicModel {
  // Lihat catatan di DoctorModel untuk rationale `abstract` + `._()`.
  const ClinicModel._();

  const factory ClinicModel({
    required String id,
    required String name,
    required String address,
    String? city,
    required double latitude,
    required double longitude,
    String? phone,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'distance_meters') @Default(0.0) double distanceMeters,
    @JsonKey(name: 'doctor_count') @Default(0) int doctorCount,
    // Opsional — belum di-return oleh API §5.5.
    List<String>? specializations,
  }) = _ClinicModel;

  factory ClinicModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicModelFromJson(json);
}

extension ClinicModelX on ClinicModel {
  ClinicEntity toEntity() => ClinicEntity(
        id: id,
        name: name,
        address: address,
        city: city,
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        imageUrl: imageUrl,
        distanceMeters: distanceMeters,
        doctorCount: doctorCount,
        specializations: specializations,
      );
}
