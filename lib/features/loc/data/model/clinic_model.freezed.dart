// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClinicModel {

 String get id; String get name; String get address; String? get city; double get latitude; double get longitude; String? get phone;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'distance_meters') double get distanceMeters;@JsonKey(name: 'doctor_count') int get doctorCount;// Opsional — belum di-return oleh API §5.5.
 List<String>? get specializations;
/// Create a copy of ClinicModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClinicModelCopyWith<ClinicModel> get copyWith => _$ClinicModelCopyWithImpl<ClinicModel>(this as ClinicModel, _$identity);

  /// Serializes this ClinicModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClinicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.doctorCount, doctorCount) || other.doctorCount == doctorCount)&&const DeepCollectionEquality().equals(other.specializations, specializations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,latitude,longitude,phone,imageUrl,distanceMeters,doctorCount,const DeepCollectionEquality().hash(specializations));

@override
String toString() {
  return 'ClinicModel(id: $id, name: $name, address: $address, city: $city, latitude: $latitude, longitude: $longitude, phone: $phone, imageUrl: $imageUrl, distanceMeters: $distanceMeters, doctorCount: $doctorCount, specializations: $specializations)';
}


}

/// @nodoc
abstract mixin class $ClinicModelCopyWith<$Res>  {
  factory $ClinicModelCopyWith(ClinicModel value, $Res Function(ClinicModel) _then) = _$ClinicModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String address, String? city, double latitude, double longitude, String? phone,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'distance_meters') double distanceMeters,@JsonKey(name: 'doctor_count') int doctorCount, List<String>? specializations
});




}
/// @nodoc
class _$ClinicModelCopyWithImpl<$Res>
    implements $ClinicModelCopyWith<$Res> {
  _$ClinicModelCopyWithImpl(this._self, this._then);

  final ClinicModel _self;
  final $Res Function(ClinicModel) _then;

/// Create a copy of ClinicModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? city = freezed,Object? latitude = null,Object? longitude = null,Object? phone = freezed,Object? imageUrl = freezed,Object? distanceMeters = null,Object? doctorCount = null,Object? specializations = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,doctorCount: null == doctorCount ? _self.doctorCount : doctorCount // ignore: cast_nullable_to_non_nullable
as int,specializations: freezed == specializations ? _self.specializations : specializations // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClinicModel].
extension ClinicModelPatterns on ClinicModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClinicModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClinicModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClinicModel value)  $default,){
final _that = this;
switch (_that) {
case _ClinicModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClinicModel value)?  $default,){
final _that = this;
switch (_that) {
case _ClinicModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String? city,  double latitude,  double longitude,  String? phone, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'distance_meters')  double distanceMeters, @JsonKey(name: 'doctor_count')  int doctorCount,  List<String>? specializations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClinicModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.latitude,_that.longitude,_that.phone,_that.imageUrl,_that.distanceMeters,_that.doctorCount,_that.specializations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String? city,  double latitude,  double longitude,  String? phone, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'distance_meters')  double distanceMeters, @JsonKey(name: 'doctor_count')  int doctorCount,  List<String>? specializations)  $default,) {final _that = this;
switch (_that) {
case _ClinicModel():
return $default(_that.id,_that.name,_that.address,_that.city,_that.latitude,_that.longitude,_that.phone,_that.imageUrl,_that.distanceMeters,_that.doctorCount,_that.specializations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String address,  String? city,  double latitude,  double longitude,  String? phone, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'distance_meters')  double distanceMeters, @JsonKey(name: 'doctor_count')  int doctorCount,  List<String>? specializations)?  $default,) {final _that = this;
switch (_that) {
case _ClinicModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.latitude,_that.longitude,_that.phone,_that.imageUrl,_that.distanceMeters,_that.doctorCount,_that.specializations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClinicModel extends ClinicModel {
  const _ClinicModel({required this.id, required this.name, required this.address, this.city, required this.latitude, required this.longitude, this.phone, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'distance_meters') this.distanceMeters = 0.0, @JsonKey(name: 'doctor_count') this.doctorCount = 0, final  List<String>? specializations}): _specializations = specializations,super._();
  factory _ClinicModel.fromJson(Map<String, dynamic> json) => _$ClinicModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String address;
@override final  String? city;
@override final  double latitude;
@override final  double longitude;
@override final  String? phone;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'distance_meters') final  double distanceMeters;
@override@JsonKey(name: 'doctor_count') final  int doctorCount;
// Opsional — belum di-return oleh API §5.5.
 final  List<String>? _specializations;
// Opsional — belum di-return oleh API §5.5.
@override List<String>? get specializations {
  final value = _specializations;
  if (value == null) return null;
  if (_specializations is EqualUnmodifiableListView) return _specializations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ClinicModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClinicModelCopyWith<_ClinicModel> get copyWith => __$ClinicModelCopyWithImpl<_ClinicModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClinicModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClinicModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.doctorCount, doctorCount) || other.doctorCount == doctorCount)&&const DeepCollectionEquality().equals(other._specializations, _specializations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,latitude,longitude,phone,imageUrl,distanceMeters,doctorCount,const DeepCollectionEquality().hash(_specializations));

@override
String toString() {
  return 'ClinicModel(id: $id, name: $name, address: $address, city: $city, latitude: $latitude, longitude: $longitude, phone: $phone, imageUrl: $imageUrl, distanceMeters: $distanceMeters, doctorCount: $doctorCount, specializations: $specializations)';
}


}

/// @nodoc
abstract mixin class _$ClinicModelCopyWith<$Res> implements $ClinicModelCopyWith<$Res> {
  factory _$ClinicModelCopyWith(_ClinicModel value, $Res Function(_ClinicModel) _then) = __$ClinicModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String address, String? city, double latitude, double longitude, String? phone,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'distance_meters') double distanceMeters,@JsonKey(name: 'doctor_count') int doctorCount, List<String>? specializations
});




}
/// @nodoc
class __$ClinicModelCopyWithImpl<$Res>
    implements _$ClinicModelCopyWith<$Res> {
  __$ClinicModelCopyWithImpl(this._self, this._then);

  final _ClinicModel _self;
  final $Res Function(_ClinicModel) _then;

/// Create a copy of ClinicModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? city = freezed,Object? latitude = null,Object? longitude = null,Object? phone = freezed,Object? imageUrl = freezed,Object? distanceMeters = null,Object? doctorCount = null,Object? specializations = freezed,}) {
  return _then(_ClinicModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,doctorCount: null == doctorCount ? _self.doctorCount : doctorCount // ignore: cast_nullable_to_non_nullable
as int,specializations: freezed == specializations ? _self._specializations : specializations // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
