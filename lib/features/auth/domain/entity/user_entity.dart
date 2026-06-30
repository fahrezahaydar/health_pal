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
  final String? phoneNumber;
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
    this.phoneNumber,
    this.isProfileComplete = false,
  });

  static UserEntity mock() => const UserEntity(
        id: 'sk-1',
        authId: 'sk-auth',
        fullName: 'Loading Name',
        email: 'loading@email.com',
        nickname: 'Loading',
        phoneNumber: '+123 456 789',
      );

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
        phoneNumber,
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
    String? phoneNumber,
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
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
