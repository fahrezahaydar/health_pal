// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => _DoctorModel(
  id: json['id'] as String,
  clinicId: json['clinic_id'] as String,
  specializationId: json['specialization_id'] as String,
  fullName: json['full_name'] as String,
  photoUrl: json['photo_url'] as String?,
  description: json['description'] as String?,
  experienceYears: (json['experience_years'] as num).toInt(),
  education: json['education'] as String?,
  consultationFee: (json['consultation_fee'] as num).toDouble(),
  ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 0.0,
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? true,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  clinic: json['clinic'] == null
      ? null
      : ClinicModel.fromJson(json['clinic'] as Map<String, dynamic>),
  specialization: json['specialization'] == null
      ? null
      : SpecializationModel.fromJson(
          json['specialization'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$DoctorModelToJson(_DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_id': instance.clinicId,
      'specialization_id': instance.specializationId,
      'full_name': instance.fullName,
      'photo_url': instance.photoUrl,
      'description': instance.description,
      'experience_years': instance.experienceYears,
      'education': instance.education,
      'consultation_fee': instance.consultationFee,
      'rating_avg': instance.ratingAvg,
      'rating_count': instance.ratingCount,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'clinic': instance.clinic,
      'specialization': instance.specialization,
    };
