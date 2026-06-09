import '../../domain/entity/specialization_entity.dart';

class SpecializationModel {
  final String id;
  final String name;
  final String? iconUrl;

  const SpecializationModel({
    required this.id,
    required this.name,
    this.iconUrl,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_url': iconUrl,
    };
  }

  SpecializationEntity toEntity() => SpecializationEntity(
        id: id,
        name: name,
        iconUrl: iconUrl,
      );

  factory SpecializationModel.fromEntity(SpecializationEntity entity) =>
      SpecializationModel(
        id: entity.id,
        name: entity.name,
        iconUrl: entity.iconUrl,
      );
}
