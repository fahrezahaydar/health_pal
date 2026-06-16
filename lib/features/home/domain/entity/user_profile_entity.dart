import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String nickname;
  final String? avatarUrl;
  final bool isProfileComplete;
  final bool notifReminderEnabled;

  const UserProfileEntity({
    required this.id,
    required this.nickname,
    this.avatarUrl,
    this.isProfileComplete = false,
    this.notifReminderEnabled = true,
  });

  static const UserProfileEntity mock = UserProfileEntity(
    id: 'sk-1',
    nickname: 'Loading',
  );

  @override
  List<Object?> get props =>
      [id, nickname, avatarUrl, isProfileComplete, notifReminderEnabled];
}
