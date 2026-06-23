import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/specialization_entity.dart';

part 'specialization_model.freezed.dart';
part 'specialization_model.g.dart';

@freezed
abstract class SpecializationModel with _$SpecializationModel {
  const SpecializationModel._();

  const factory SpecializationModel({
    required String id,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'color_hex') String? colorHex,
  }) = _SpecializationModel;

  factory SpecializationModel.fromJson(Map<String, dynamic> json) =>
      _$SpecializationModelFromJson(json);

  factory SpecializationModel.fromEntity(SpecializationEntity entity) =>
      SpecializationModel(
        id: entity.id,
        name: entity.name,
        iconUrl: entity.iconUrl,
        colorHex: entity.colorHex,
      );

  SpecializationEntity toEntity() => SpecializationEntity(
        id: id,
        name: name,
        iconUrl: iconUrl,
        colorHex: colorHex,
      );
}
