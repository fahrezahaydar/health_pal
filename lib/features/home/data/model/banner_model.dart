import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/banner_entity.dart';

part 'banner_model.freezed.dart';
part 'banner_model.g.dart';

@freezed
abstract class BannerModel with _$BannerModel {
  const BannerModel._();

  const factory BannerModel({
    required String id,
    required String title,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'action_url') String? actionUrl,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
  }) = _BannerModel;

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  factory BannerModel.fromEntity(BannerEntity entity) => BannerModel(
        id: entity.id,
        title: entity.title,
        imageUrl: entity.imageUrl,
        actionUrl: entity.actionUrl,
        displayOrder: entity.displayOrder,
      );

  BannerEntity toEntity() => BannerEntity(
        id: id,
        title: title,
        imageUrl: imageUrl,
        actionUrl: actionUrl,
        displayOrder: displayOrder,
      );
}
