import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/user_profile_entity.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    required String id,
    required String nickname,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_profile_complete') @Default(false) bool isProfileComplete,
  }) = _UserProfileModel;

  /// Custom fromJson karena `nickname` nullable di DB (ERD §2.2).
  /// Fallback ke `full_name` jika nickname null.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'] as String,
        nickname: json['nickname'] as String? ?? json['full_name'] as String,
        // Sprint 2 — C4: avatar_url nullable dari DB.
        avatarUrl: json['avatar_url'] as String?,
        isProfileComplete: json['is_profile_complete'] as bool? ?? false,
      );

  UserProfileEntity toEntity() => UserProfileEntity(
        id: id,
        nickname: nickname,
        avatarUrl: avatarUrl,
        isProfileComplete: isProfileComplete,
      );
}
