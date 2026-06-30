import '../../domain/entity/user_entity.dart';

class UserModel {
  final String id;
  final String authId;
  final String fullName;
  final String email;
  final String? nickname;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? phoneNumber;
  final bool isProfileComplete;

  const UserModel({
    required this.id,
    required this.authId,
    required this.fullName,
    required this.email,
    this.nickname,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.isProfileComplete = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      authId: json['auth_id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String? ?? '',
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isProfileComplete: json['is_profile_complete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_id': authId,
      'full_name': fullName,
      'email': email,
      'nickname': nickname,
      'avatar_url': avatarUrl,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'phone_number': phoneNumber,
      'is_profile_complete': isProfileComplete,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      authId: authId,
      fullName: fullName,
      email: email,
      nickname: nickname,
      avatarUrl: avatarUrl,
      dateOfBirth: dateOfBirth,
      gender: gender,
      phoneNumber: phoneNumber,
      isProfileComplete: isProfileComplete,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      nickname: entity.nickname,
      avatarUrl: entity.avatarUrl,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      phoneNumber: entity.phoneNumber,
      isProfileComplete: entity.isProfileComplete,
    );
  }
}
