import 'package:equatable/equatable.dart';

class User extends Equatable {
  static const mFullName = "FullName";
  static const mEmail = "Email";
  static const mDateOfBirth = "DateOfBirth";
  static const mGender = "Gender";
  static const mPhotoUrl = "PhotoUrl";
  static const mNickname = "Nickname";

  final String fullName;
  final String email;
  final DateTime dateOfBirth;
  final String gender;
  final String? photourl;
  final String? nickname;

  const User({
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    this.photourl,
    this.nickname,
  });

  @override
  List<Object?> get props => [
    fullName,
    photourl,
    email,
    nickname,
    dateOfBirth,
    gender,
  ];

  Map<String, dynamic> toMap() {
    return {
      mFullName: fullName,
      mEmail: email,
      mDateOfBirth: dateOfBirth.toIso8601String(),
      mGender: gender,
      mPhotoUrl: photourl,
      mNickname: nickname,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fullName: map[mFullName] ?? '',
      email: map[mEmail] ?? '',
      dateOfBirth: DateTime.parse(
        map[mDateOfBirth] ?? DateTime.now().toIso8601String(),
      ),
      gender: map[mGender] ?? '',
      photourl: map[mPhotoUrl],
      nickname: map[mNickname],
    );
  }
}
