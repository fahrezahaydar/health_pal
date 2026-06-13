// lib/features/doctor/data/model/clinic_model.dart
//
// Model untuk nested `clinics` object di response API Contract §5.1/5.3.
// Disimpan lokal di doctor feature karena belum ada clinic feature module.
//
// Per TDD 02: ClinicModel juga akan dipakai oleh booking + location feature.
// Bisa di-promote ke lib/features/clinic/ di Sprint 2.

import '../../domain/entity/clinic_entity.dart';

class ClinicModel {
  final String id;
  final String name;
  final String? address;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? imageUrl;

  const ClinicModel({
    required this.id,
    required this.name,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.phone,
    this.imageUrl,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        'image_url': imageUrl,
      };

  // ── Mapper ──────────────────────────────────────────────
  factory ClinicModel.fromEntity(ClinicEntity entity) => ClinicModel(
        id: entity.id,
        name: entity.name,
        address: entity.address,
        city: entity.city,
        latitude: entity.latitude,
        longitude: entity.longitude,
        phone: entity.phone,
        imageUrl: entity.imageUrl,
      );

  ClinicEntity toEntity() => ClinicEntity(
        id: id,
        name: name,
        address: address,
        city: city,
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        imageUrl: imageUrl,
      );
}
