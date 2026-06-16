import 'package:equatable/equatable.dart';

class SpecializationEntity extends Equatable {
  final String id;
  final String name;
  final String? iconUrl;

  const SpecializationEntity({
    required this.id,
    required this.name,
    this.iconUrl,
  });

  static List<SpecializationEntity> mock() => const [
        SpecializationEntity(id: 'sk-1', name: 'Loading spec 1'),
        SpecializationEntity(id: 'sk-2', name: 'Loading spec 2'),
        SpecializationEntity(id: 'sk-3', name: 'Loading spec 3'),
        SpecializationEntity(id: 'sk-4', name: 'Loading spec 4'),
        SpecializationEntity(id: 'sk-5', name: 'Loading spec 5'),
        SpecializationEntity(id: 'sk-6', name: 'Loading spec 6'),
        SpecializationEntity(id: 'sk-7', name: 'Loading spec 7'),
        SpecializationEntity(id: 'sk-8', name: 'Loading spec 8'),
      ];

  @override
  List<Object?> get props => [id, name, iconUrl];
}
