import '../../domain/entity/banner_entity.dart';

class BannerModel {
  final String id;
  final String title;
  final String? imageUrl;
  final String? actionUrl;
  final int displayOrder;

  const BannerModel({
    required this.id,
    required this.title,
    this.imageUrl,
    this.actionUrl,
    this.displayOrder = 0,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String?,
      actionUrl: json['action_url'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'display_order': displayOrder,
    };
  }

  BannerEntity toEntity() => BannerEntity(
        id: id,
        title: title,
        imageUrl: imageUrl,
        actionUrl: actionUrl,
        displayOrder: displayOrder,
      );

  factory BannerModel.fromEntity(BannerEntity entity) => BannerModel(
        id: entity.id,
        title: entity.title,
        imageUrl: entity.imageUrl,
        actionUrl: entity.actionUrl,
        displayOrder: entity.displayOrder,
      );
}
