import '../../domain/entity/user_profile_entity.dart';

class UserProfileModel {
  final String id;
  final String nickname;

  const UserProfileModel({
    required this.id,
    required this.nickname,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String? ?? json['full_name'] as String,
    );
  }

  UserProfileEntity toEntity() => UserProfileEntity(
        id: id,
        nickname: nickname,
      );
}
