// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClinicModel _$ClinicModelFromJson(Map<String, dynamic> json) => _ClinicModel(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  city: json['city'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  phone: json['phone'] as String?,
  imageUrl: json['image_url'] as String?,
  distanceMeters: (json['distance_meters'] as num?)?.toDouble() ?? 0.0,
  doctorCount: (json['doctor_count'] as num?)?.toInt() ?? 0,
  specializations: (json['specializations'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ClinicModelToJson(_ClinicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'image_url': instance.imageUrl,
      'distance_meters': instance.distanceMeters,
      'doctor_count': instance.doctorCount,
      'specializations': instance.specializations,
    };
