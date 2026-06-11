import 'package:equatable/equatable.dart';

sealed class GreetingState extends Equatable {
  const GreetingState();

  @override
  List<Object?> get props => [];
}

class GreetingInitial extends GreetingState {
  const GreetingInitial();
}

class GreetingLoading extends GreetingState {
  const GreetingLoading();
}

class GreetingLoaded extends GreetingState {
  final String nickname;
  final String profileId;

  const GreetingLoaded({this.nickname = '', this.profileId = ''});

  @override
  List<Object?> get props => [nickname, profileId];
}

class GreetingError extends GreetingState {
  final String message;

  const GreetingError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
