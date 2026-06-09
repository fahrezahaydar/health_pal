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

  @override
  List<Object?> get props => [id, title, imageUrl, actionUrl, displayOrder];
}
