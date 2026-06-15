import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String nickname;
  final String? avatarUrl;
  final bool isProfileComplete;

  const UserProfileEntity({
    required this.id,
    required this.nickname,
    this.avatarUrl,
    this.isProfileComplete = false,
  });

  @override
  List<Object?> get props => [id, nickname, avatarUrl, isProfileComplete];
}
