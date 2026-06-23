part of 'create_profile_cubit.dart';

enum CubitStatus { idle, loading, success, failure }

class CreateProfileState extends Equatable {
  final String fullName;
  final String email;
  final String nickname;
  final String gender;
  final DateTime dateOfBirth;
  final File? photo;
  final CubitStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const CreateProfileState({
    required this.fullName,
    required this.email,
    this.nickname = '',
    this.gender = '',
    required this.dateOfBirth,
    this.photo,
    this.status = CubitStatus.idle,
    this.user,
    this.errorMessage,
  });

  CreateProfileState copyWith({
    String? fullName,
    String? email,
    String? nickname,
    String? gender,
    DateTime? dateOfBirth,
    File? photo,
    CubitStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return CreateProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      photo: photo ?? this.photo,
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    nickname,
    gender,
    dateOfBirth,
    photo,
    status,
    user,
    errorMessage,
  ];
}
