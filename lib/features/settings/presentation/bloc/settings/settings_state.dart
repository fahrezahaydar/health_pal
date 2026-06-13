// lib/features/settings/presentation/bloc/settings/settings_state.dart

import 'package:equatable/equatable.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  /// Push notification preference (mirrored dari user_profiles.notif_*_enabled).
  final bool notifEnabled;

  /// Dark mode preference (v2 — saat ini selalu false).
  final bool darkMode;

  /// Email user yang sedang login (read-only display).
  final String email;

  const SettingsLoaded({
    required this.notifEnabled,
    required this.darkMode,
    required this.email,
  });

  SettingsLoaded copyWith({bool? notifEnabled, bool? darkMode, String? email}) =>
      SettingsLoaded(
        notifEnabled: notifEnabled ?? this.notifEnabled,
        darkMode: darkMode ?? this.darkMode,
        email: email ?? this.email,
      );

  @override
  List<Object?> get props => [notifEnabled, darkMode, email];
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
