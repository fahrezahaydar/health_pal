// lib/features/doctor/domain/entity/clinic_entity.dart

import 'package:equatable/equatable.dart';

class ClinicEntity extends Equatable {
  final String id;
  final String name;
  final String? address;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? imageUrl;

  const ClinicEntity({
    required this.id,
    required this.name,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.phone,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, address, city, phone];
}
