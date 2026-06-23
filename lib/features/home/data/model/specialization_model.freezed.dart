// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'specialization_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpecializationModel {

 String get id; String get name;@JsonKey(name: 'icon_url') String? get iconUrl;@JsonKey(name: 'color_hex') String? get colorHex;
/// Create a copy of SpecializationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecializationModelCopyWith<SpecializationModel> get copyWith => _$SpecializationModelCopyWithImpl<SpecializationModel>(this as SpecializationModel, _$identity);

  /// Serializes this SpecializationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecializationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,iconUrl,colorHex);

@override
String toString() {
  return 'SpecializationModel(id: $id, name: $name, iconUrl: $iconUrl, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class $SpecializationModelCopyWith<$Res>  {
  factory $SpecializationModelCopyWith(SpecializationModel value, $Res Function(SpecializationModel) _then) = _$SpecializationModelCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'icon_url') String? iconUrl,@JsonKey(name: 'color_hex') String? colorHex
});




}
/// @nodoc
class _$SpecializationModelCopyWithImpl<$Res>
    implements $SpecializationModelCopyWith<$Res> {
  _$SpecializationModelCopyWithImpl(this._self, this._then);

  final SpecializationModel _self;
  final $Res Function(SpecializationModel) _then;

/// Create a copy of SpecializationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? iconUrl = freezed,Object? colorHex = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpecializationModel].
extension SpecializationModelPatterns on SpecializationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpecializationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpecializationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpecializationModel value)  $default,){
final _that = this;
switch (_that) {
case _SpecializationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpecializationModel value)?  $default,){
final _that = this;
switch (_that) {
case _SpecializationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'icon_url')  String? iconUrl, @JsonKey(name: 'color_hex')  String? colorHex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpecializationModel() when $default != null:
return $default(_that.id,_that.name,_that.iconUrl,_that.colorHex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'icon_url')  String? iconUrl, @JsonKey(name: 'color_hex')  String? colorHex)  $default,) {final _that = this;
switch (_that) {
case _SpecializationModel():
return $default(_that.id,_that.name,_that.iconUrl,_that.colorHex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'icon_url')  String? iconUrl, @JsonKey(name: 'color_hex')  String? colorHex)?  $default,) {final _that = this;
switch (_that) {
case _SpecializationModel() when $default != null:
return $default(_that.id,_that.name,_that.iconUrl,_that.colorHex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpecializationModel extends SpecializationModel {
  const _SpecializationModel({required this.id, required this.name, @JsonKey(name: 'icon_url') this.iconUrl, @JsonKey(name: 'color_hex') this.colorHex}): super._();
  factory _SpecializationModel.fromJson(Map<String, dynamic> json) => _$SpecializationModelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'icon_url') final  String? iconUrl;
@override@JsonKey(name: 'color_hex') final  String? colorHex;

/// Create a copy of SpecializationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpecializationModelCopyWith<_SpecializationModel> get copyWith => __$SpecializationModelCopyWithImpl<_SpecializationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpecializationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpecializationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,iconUrl,colorHex);

@override
String toString() {
  return 'SpecializationModel(id: $id, name: $name, iconUrl: $iconUrl, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class _$SpecializationModelCopyWith<$Res> implements $SpecializationModelCopyWith<$Res> {
  factory _$SpecializationModelCopyWith(_SpecializationModel value, $Res Function(_SpecializationModel) _then) = __$SpecializationModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'icon_url') String? iconUrl,@JsonKey(name: 'color_hex') String? colorHex
});




}
/// @nodoc
class __$SpecializationModelCopyWithImpl<$Res>
    implements _$SpecializationModelCopyWith<$Res> {
  __$SpecializationModelCopyWithImpl(this._self, this._then);

  final _SpecializationModel _self;
  final $Res Function(_SpecializationModel) _then;

/// Create a copy of SpecializationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? iconUrl = freezed,Object? colorHex = freezed,}) {
  return _then(_SpecializationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
