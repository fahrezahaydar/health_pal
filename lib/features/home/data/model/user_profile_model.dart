import '../../domain/entity/user_profile_entity.dart';

class UserProfileModel {
  final String id;
  final String nickname;
  final bool isProfileComplete;

  const UserProfileModel({
    required this.id,
    required this.nickname,
    this.isProfileComplete = false,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String? ?? json['full_name'] as String,
      isProfileComplete: json['is_profile_complete'] as bool? ?? false,
    );
  }

  UserProfileEntity toEntity() => UserProfileEntity(
        id: id,
        nickname: nickname,
        isProfileComplete: isProfileComplete,
      );
}
