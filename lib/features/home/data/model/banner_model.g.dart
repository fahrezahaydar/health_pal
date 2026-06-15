// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => _BannerModel(
  id: json['id'] as String,
  title: json['title'] as String,
  imageUrl: json['image_url'] as String?,
  actionUrl: json['action_url'] as String?,
  displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BannerModelToJson(_BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image_url': instance.imageUrl,
      'action_url': instance.actionUrl,
      'display_order': instance.displayOrder,
    };
