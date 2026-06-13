// lib/features/profile/presentation/bloc/edit_profile/edit_profile_state.dart

import 'package:equatable/equatable.dart';

import '../../../../auth/domain/entity/user_entity.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();
  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

class EditProfileLoading extends EditProfileState {
  /// Initial data untuk populate form.
  final UserEntity user;
  const EditProfileLoading(this.user);

  @override
  List<Object?> get props => [user];
}

class EditProfileLoaded extends EditProfileState {
  final UserEntity user;
  const EditProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class EditProfileSaving extends EditProfileState {
  final UserEntity current;
  const EditProfileSaving(this.current);

  @override
  List<Object?> get props => [current];
}

class EditProfileSuccess extends EditProfileState {
  final UserEntity user;
  const EditProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class EditProfileError extends EditProfileState {
  final String message;
  const EditProfileError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
