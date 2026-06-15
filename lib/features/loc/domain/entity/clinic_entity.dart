// lib/features/loc/domain/entity/clinic_entity.dart

import 'package:equatable/equatable.dart';

class ClinicEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String? city;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? imageUrl;
  final double distanceMeters;
  final int doctorCount;
  final List<String>? specializations;

  const ClinicEntity({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.imageUrl,
    required this.distanceMeters,
    required this.doctorCount,
    this.specializations,
  });

  /// Derived: jarak dalam km (display-friendly).
  double get distanceKm => distanceMeters / 1000.0;

  /// Derived: jarak diformat "1.2 km" atau "850 m" untuk display.
  String get distanceDisplay {
    if (distanceMeters < 1000) {
      return '${distanceMeters.toStringAsFixed(0)} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  /// Derived: ringkasan count dokter "5 dokter tersedia" / "1 dokter tersedia".
  String get doctorCountDisplay =>
      doctorCount == 1 ? '1 dokter tersedia' : '$doctorCount dokter tersedia';

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    city,
    latitude,
    longitude,
    phone,
    imageUrl,
    distanceMeters,
    doctorCount,
    specializations,
  ];

  static List<ClinicEntity> mock() {
    return const [
      ClinicEntity(
        id: 'sk-1',
        name: 'Loading Clinic Name Placeholder',
        address: 'Loading address placeholder',
        latitude: 0,
        longitude: 0,
        distanceMeters: 1500,
        doctorCount: 5,
      ),
      ClinicEntity(
        id: 'sk-2',
        name: 'Loading Clinic Name Placeholder 2',
        address: 'Loading address placeholder 2',
        latitude: 0,
        longitude: 0,
        distanceMeters: 2500,
        doctorCount: 3,
      ),
      ClinicEntity(
        id: 'sk-3',
        name: 'Loading Clinic Name Placeholder 3',
        address: 'Loading address placeholder 3',
        latitude: 0,
        longitude: 0,
        distanceMeters: 3500,
        doctorCount: 8,
      ),
    ];
  }
}
