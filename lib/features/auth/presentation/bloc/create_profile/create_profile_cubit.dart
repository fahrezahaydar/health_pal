import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../auth/domain/usecase/register_and_create_profile_usecase.dart';
import '../../../domain/entity/user_entity.dart';

sealed class CreateProfileState extends Equatable {
  const CreateProfileState();

  @override
  List<Object?> get props => [];
}

final class CreateProfileInitial extends CreateProfileState {
  const CreateProfileInitial();
}

final class CreateProfileLoading extends CreateProfileState {
  const CreateProfileLoading();
}

final class CreateProfileSuccess extends CreateProfileState {
  final UserEntity user;

  const CreateProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class CreateProfileFailure extends CreateProfileState {
  final String message;

  const CreateProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}

@injectable
class CreateProfileCubit extends Cubit<CreateProfileState> {
  final RegisterAndCreateProfileUseCase _registerAndCreateProfileUseCase;

  CreateProfileCubit(this._registerAndCreateProfileUseCase)
    : super(const CreateProfileInitial());

  Future<void> registerAndCreateProfile({
    required String email,
    required String password,
    required String fullName,
    required String nickname,
    required String gender,
    required DateTime dob,
    File? photo,
  }) async {
    emit(const CreateProfileLoading());
    final result = await _registerAndCreateProfileUseCase(
      email: email,
      password: password,
      fullName: fullName,
      nickname: nickname,
      gender: gender,
      dob: dob,
      photo: photo,
    );
    switch (result) {
      case Success<UserEntity>():
        emit(CreateProfileSuccess(result.data));
      case Failure<UserEntity>():
        emit(CreateProfileFailure(result.message));
    }
  }
}
