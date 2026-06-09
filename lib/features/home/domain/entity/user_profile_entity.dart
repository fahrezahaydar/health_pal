import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String nickname;

  const UserProfileEntity({
    required this.id,
    required this.nickname,
  });

  @override
  List<Object?> get props => [id, nickname];
}
