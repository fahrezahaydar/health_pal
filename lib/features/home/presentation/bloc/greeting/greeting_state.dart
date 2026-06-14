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
  final bool isProfileComplete;

  const GreetingLoaded({
    this.nickname = '',
    this.profileId = '',
    this.isProfileComplete = false,
  });

  @override
  List<Object?> get props => [nickname, profileId, isProfileComplete];
}

class GreetingError extends GreetingState {
  final String message;

  const GreetingError({this.message = ''});

  @override
  List<Object?> get props => [message];
}

/// Emit saat row `user_profiles` tidak ada untuk user saat ini (notFound).
/// Distinct dari [GreetingError] (network/timeout) sehingga HomePage
/// guard bisa membedakan "tidak ada profile" (wajib redirect ke
/// CreateProfile) vs "gagal fetch sesaat" (stay di Home, retry natural).
class GreetingNoProfile extends GreetingState {
  const GreetingNoProfile();
}
