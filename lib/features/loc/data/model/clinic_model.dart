import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/clinic_entity.dart';

part 'clinic_model.freezed.dart';
part 'clinic_model.g.dart';

@freezed
abstract class ClinicModel with _$ClinicModel {
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
    @JsonKey(name: 'rating_avg') @Default(0.0) double ratingAvg,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @JsonKey(name: 'category') String? category,
    @JsonKey(name: 'duration_minutes') @Default(0) int durationMinutes,
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
        ratingAvg: ratingAvg,
        reviewCount: reviewCount,
        category: category,
        durationMinutes: durationMinutes,
        specializations: specializations,
      );
}
