// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileModel {

 String get id; String get nickname;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'is_profile_complete') bool get isProfileComplete;@JsonKey(name: 'notif_reminder_enabled') bool get notifReminderEnabled;
/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileModelCopyWith<UserProfileModel> get copyWith => _$UserProfileModelCopyWithImpl<UserProfileModel>(this as UserProfileModel, _$identity);

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.notifReminderEnabled, notifReminderEnabled) || other.notifReminderEnabled == notifReminderEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickname,avatarUrl,isProfileComplete,notifReminderEnabled);

@override
String toString() {
  return 'UserProfileModel(id: $id, nickname: $nickname, avatarUrl: $avatarUrl, isProfileComplete: $isProfileComplete, notifReminderEnabled: $notifReminderEnabled)';
}


}

/// @nodoc
abstract mixin class $UserProfileModelCopyWith<$Res>  {
  factory $UserProfileModelCopyWith(UserProfileModel value, $Res Function(UserProfileModel) _then) = _$UserProfileModelCopyWithImpl;
@useResult
$Res call({
 String id, String nickname,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_profile_complete') bool isProfileComplete,@JsonKey(name: 'notif_reminder_enabled') bool notifReminderEnabled
});




}
/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._self, this._then);

  final UserProfileModel _self;
  final $Res Function(UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nickname = null,Object? avatarUrl = freezed,Object? isProfileComplete = null,Object? notifReminderEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,notifReminderEnabled: null == notifReminderEnabled ? _self.notifReminderEnabled : notifReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileModel].
extension UserProfileModelPatterns on UserProfileModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nickname, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_profile_complete')  bool isProfileComplete, @JsonKey(name: 'notif_reminder_enabled')  bool notifReminderEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.id,_that.nickname,_that.avatarUrl,_that.isProfileComplete,_that.notifReminderEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nickname, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_profile_complete')  bool isProfileComplete, @JsonKey(name: 'notif_reminder_enabled')  bool notifReminderEnabled)  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel():
return $default(_that.id,_that.nickname,_that.avatarUrl,_that.isProfileComplete,_that.notifReminderEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nickname, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_profile_complete')  bool isProfileComplete, @JsonKey(name: 'notif_reminder_enabled')  bool notifReminderEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.id,_that.nickname,_that.avatarUrl,_that.isProfileComplete,_that.notifReminderEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfileModel extends UserProfileModel {
  const _UserProfileModel({required this.id, required this.nickname, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'is_profile_complete') this.isProfileComplete = false, @JsonKey(name: 'notif_reminder_enabled') this.notifReminderEnabled = true}): super._();
  factory _UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

@override final  String id;
@override final  String nickname;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'is_profile_complete') final  bool isProfileComplete;
@override@JsonKey(name: 'notif_reminder_enabled') final  bool notifReminderEnabled;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileModelCopyWith<_UserProfileModel> get copyWith => __$UserProfileModelCopyWithImpl<_UserProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.notifReminderEnabled, notifReminderEnabled) || other.notifReminderEnabled == notifReminderEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickname,avatarUrl,isProfileComplete,notifReminderEnabled);

@override
String toString() {
  return 'UserProfileModel(id: $id, nickname: $nickname, avatarUrl: $avatarUrl, isProfileComplete: $isProfileComplete, notifReminderEnabled: $notifReminderEnabled)';
}


}

/// @nodoc
abstract mixin class _$UserProfileModelCopyWith<$Res> implements $UserProfileModelCopyWith<$Res> {
  factory _$UserProfileModelCopyWith(_UserProfileModel value, $Res Function(_UserProfileModel) _then) = __$UserProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String nickname,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_profile_complete') bool isProfileComplete,@JsonKey(name: 'notif_reminder_enabled') bool notifReminderEnabled
});




}
/// @nodoc
class __$UserProfileModelCopyWithImpl<$Res>
    implements _$UserProfileModelCopyWith<$Res> {
  __$UserProfileModelCopyWithImpl(this._self, this._then);

  final _UserProfileModel _self;
  final $Res Function(_UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nickname = null,Object? avatarUrl = freezed,Object? isProfileComplete = null,Object? notifReminderEnabled = null,}) {
  return _then(_UserProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,notifReminderEnabled: null == notifReminderEnabled ? _self.notifReminderEnabled : notifReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
