import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String authId;
  final String fullName;
  final String email;
  final String? nickname;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final bool isProfileComplete;

  const UserEntity({
    required this.id,
    required this.authId,
    required this.fullName,
    required this.email,
    this.nickname,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.isProfileComplete = false,
  });

  @override
  List<Object?> get props => [
        id,
        authId,
        fullName,
        email,
        nickname,
        avatarUrl,
        dateOfBirth,
        gender,
        isProfileComplete,
      ];

  UserEntity copyWith({
    String? id,
    String? authId,
    String? fullName,
    String? email,
    String? nickname,
    String? avatarUrl,
    DateTime? dateOfBirth,
    String? gender,
    bool? isProfileComplete,
  }) {
    return UserEntity(
      id: id ?? this.id,
      authId: authId ?? this.authId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
