import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String title;
  final String? imageUrl;
  final String? actionUrl;
  final int displayOrder;

  const BannerEntity({
    required this.id,
    required this.title,
    this.imageUrl,
    this.actionUrl,
    this.displayOrder = 0,
  });

  static List<BannerEntity> mock() => const [
        BannerEntity(id: 'sk-1', title: 'Loading banner placeholder 1'),
        BannerEntity(id: 'sk-2', title: 'Loading banner placeholder 2'),
        BannerEntity(id: 'sk-3', title: 'Loading banner placeholder 3'),
      ];

  @override
  List<Object?> get props => [id, title, imageUrl, actionUrl, displayOrder];
}
