// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpecializationModel _$SpecializationModelFromJson(Map<String, dynamic> json) =>
    _SpecializationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      colorHex: json['color_hex'] as String?,
    );

Map<String, dynamic> _$SpecializationModelToJson(
  _SpecializationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon_url': instance.iconUrl,
  'color_hex': instance.colorHex,
};
