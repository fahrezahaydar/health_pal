// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoctorModel {

 String get id;@JsonKey(name: 'clinic_id') String get clinicId;@JsonKey(name: 'specialization_id') String get specializationId;@JsonKey(name: 'full_name') String get fullName;@JsonKey(name: 'photo_url') String? get photoUrl; String? get description;@JsonKey(name: 'experience_years') int get experienceYears; String? get education;@JsonKey(name: 'consultation_fee') double get consultationFee;@JsonKey(name: 'rating_avg') double get ratingAvg;@JsonKey(name: 'rating_count') int get ratingCount;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;// ── Nested Objects (dari PostgREST select=*,clinics(*),specializations(*)) ──
// @JsonKey name WAJIB match nama tabel (plural) karena PostgREST
// selalu pakai nama tabel sebagai JSON key untuk nested object.
@JsonKey(name: 'clinics') ClinicModel? get clinic;@JsonKey(name: 'specializations') SpecializationModel? get specialization;
/// Create a copy of DoctorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorModelCopyWith<DoctorModel> get copyWith => _$DoctorModelCopyWithImpl<DoctorModel>(this as DoctorModel, _$identity);

  /// Serializes this DoctorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.specializationId, specializationId) || other.specializationId == specializationId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.education, education) || other.education == education)&&(identical(other.consultationFee, consultationFee) || other.consultationFee == consultationFee)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.clinic, clinic) || other.clinic == clinic)&&(identical(other.specialization, specialization) || other.specialization == specialization));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,specializationId,fullName,photoUrl,description,experienceYears,education,consultationFee,ratingAvg,ratingCount,isActive,createdAt,updatedAt,clinic,specialization);

@override
String toString() {
  return 'DoctorModel(id: $id, clinicId: $clinicId, specializationId: $specializationId, fullName: $fullName, photoUrl: $photoUrl, description: $description, experienceYears: $experienceYears, education: $education, consultationFee: $consultationFee, ratingAvg: $ratingAvg, ratingCount: $ratingCount, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, clinic: $clinic, specialization: $specialization)';
}


}

/// @nodoc
abstract mixin class $DoctorModelCopyWith<$Res>  {
  factory $DoctorModelCopyWith(DoctorModel value, $Res Function(DoctorModel) _then) = _$DoctorModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'specialization_id') String specializationId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'photo_url') String? photoUrl, String? description,@JsonKey(name: 'experience_years') int experienceYears, String? education,@JsonKey(name: 'consultation_fee') double consultationFee,@JsonKey(name: 'rating_avg') double ratingAvg,@JsonKey(name: 'rating_count') int ratingCount,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'clinics') ClinicModel? clinic,@JsonKey(name: 'specializations') SpecializationModel? specialization
});


$SpecializationModelCopyWith<$Res>? get specialization;

}
/// @nodoc
class _$DoctorModelCopyWithImpl<$Res>
    implements $DoctorModelCopyWith<$Res> {
  _$DoctorModelCopyWithImpl(this._self, this._then);

  final DoctorModel _self;
  final $Res Function(DoctorModel) _then;

/// Create a copy of DoctorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clinicId = null,Object? specializationId = null,Object? fullName = null,Object? photoUrl = freezed,Object? description = freezed,Object? experienceYears = null,Object? education = freezed,Object? consultationFee = null,Object? ratingAvg = null,Object? ratingCount = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? clinic = freezed,Object? specialization = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,specializationId: null == specializationId ? _self.specializationId : specializationId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,consultationFee: null == consultationFee ? _self.consultationFee : consultationFee // ignore: cast_nullable_to_non_nullable
as double,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,clinic: freezed == clinic ? _self.clinic : clinic // ignore: cast_nullable_to_non_nullable
as ClinicModel?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as SpecializationModel?,
  ));
}
/// Create a copy of DoctorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpecializationModelCopyWith<$Res>? get specialization {
    if (_self.specialization == null) {
    return null;
  }

  return $SpecializationModelCopyWith<$Res>(_self.specialization!, (value) {
    return _then(_self.copyWith(specialization: value));
  });
}
}


/// Adds pattern-matching-related methods to [DoctorModel].
extension DoctorModelPatterns on DoctorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoctorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoctorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoctorModel value)  $default,){
final _that = this;
switch (_that) {
case _DoctorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoctorModel value)?  $default,){
final _that = this;
switch (_that) {
case _DoctorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'specialization_id')  String specializationId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'photo_url')  String? photoUrl,  String? description, @JsonKey(name: 'experience_years')  int experienceYears,  String? education, @JsonKey(name: 'consultation_fee')  double consultationFee, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'clinics')  ClinicModel? clinic, @JsonKey(name: 'specializations')  SpecializationModel? specialization)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoctorModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.specializationId,_that.fullName,_that.photoUrl,_that.description,_that.experienceYears,_that.education,_that.consultationFee,_that.ratingAvg,_that.ratingCount,_that.isActive,_that.createdAt,_that.updatedAt,_that.clinic,_that.specialization);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'specialization_id')  String specializationId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'photo_url')  String? photoUrl,  String? description, @JsonKey(name: 'experience_years')  int experienceYears,  String? education, @JsonKey(name: 'consultation_fee')  double consultationFee, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'clinics')  ClinicModel? clinic, @JsonKey(name: 'specializations')  SpecializationModel? specialization)  $default,) {final _that = this;
switch (_that) {
case _DoctorModel():
return $default(_that.id,_that.clinicId,_that.specializationId,_that.fullName,_that.photoUrl,_that.description,_that.experienceYears,_that.education,_that.consultationFee,_that.ratingAvg,_that.ratingCount,_that.isActive,_that.createdAt,_that.updatedAt,_that.clinic,_that.specialization);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'clinic_id')  String clinicId, @JsonKey(name: 'specialization_id')  String specializationId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'photo_url')  String? photoUrl,  String? description, @JsonKey(name: 'experience_years')  int experienceYears,  String? education, @JsonKey(name: 'consultation_fee')  double consultationFee, @JsonKey(name: 'rating_avg')  double ratingAvg, @JsonKey(name: 'rating_count')  int ratingCount, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'clinics')  ClinicModel? clinic, @JsonKey(name: 'specializations')  SpecializationModel? specialization)?  $default,) {final _that = this;
switch (_that) {
case _DoctorModel() when $default != null:
return $default(_that.id,_that.clinicId,_that.specializationId,_that.fullName,_that.photoUrl,_that.description,_that.experienceYears,_that.education,_that.consultationFee,_that.ratingAvg,_that.ratingCount,_that.isActive,_that.createdAt,_that.updatedAt,_that.clinic,_that.specialization);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoctorModel extends DoctorModel {
  const _DoctorModel({required this.id, @JsonKey(name: 'clinic_id') required this.clinicId, @JsonKey(name: 'specialization_id') required this.specializationId, @JsonKey(name: 'full_name') required this.fullName, @JsonKey(name: 'photo_url') this.photoUrl, this.description, @JsonKey(name: 'experience_years') required this.experienceYears, this.education, @JsonKey(name: 'consultation_fee') required this.consultationFee, @JsonKey(name: 'rating_avg') this.ratingAvg = 0.0, @JsonKey(name: 'rating_count') this.ratingCount = 0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'clinics') this.clinic, @JsonKey(name: 'specializations') this.specialization}): super._();
  factory _DoctorModel.fromJson(Map<String, dynamic> json) => _$DoctorModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'clinic_id') final  String clinicId;
@override@JsonKey(name: 'specialization_id') final  String specializationId;
@override@JsonKey(name: 'full_name') final  String fullName;
@override@JsonKey(name: 'photo_url') final  String? photoUrl;
@override final  String? description;
@override@JsonKey(name: 'experience_years') final  int experienceYears;
@override final  String? education;
@override@JsonKey(name: 'consultation_fee') final  double consultationFee;
@override@JsonKey(name: 'rating_avg') final  double ratingAvg;
@override@JsonKey(name: 'rating_count') final  int ratingCount;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
// ── Nested Objects (dari PostgREST select=*,clinics(*),specializations(*)) ──
// @JsonKey name WAJIB match nama tabel (plural) karena PostgREST
// selalu pakai nama tabel sebagai JSON key untuk nested object.
@override@JsonKey(name: 'clinics') final  ClinicModel? clinic;
@override@JsonKey(name: 'specializations') final  SpecializationModel? specialization;

/// Create a copy of DoctorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorModelCopyWith<_DoctorModel> get copyWith => __$DoctorModelCopyWithImpl<_DoctorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoctorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.specializationId, specializationId) || other.specializationId == specializationId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.education, education) || other.education == education)&&(identical(other.consultationFee, consultationFee) || other.consultationFee == consultationFee)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.clinic, clinic) || other.clinic == clinic)&&(identical(other.specialization, specialization) || other.specialization == specialization));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clinicId,specializationId,fullName,photoUrl,description,experienceYears,education,consultationFee,ratingAvg,ratingCount,isActive,createdAt,updatedAt,clinic,specialization);

@override
String toString() {
  return 'DoctorModel(id: $id, clinicId: $clinicId, specializationId: $specializationId, fullName: $fullName, photoUrl: $photoUrl, description: $description, experienceYears: $experienceYears, education: $education, consultationFee: $consultationFee, ratingAvg: $ratingAvg, ratingCount: $ratingCount, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, clinic: $clinic, specialization: $specialization)';
}


}

/// @nodoc
abstract mixin class _$DoctorModelCopyWith<$Res> implements $DoctorModelCopyWith<$Res> {
  factory _$DoctorModelCopyWith(_DoctorModel value, $Res Function(_DoctorModel) _then) = __$DoctorModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'clinic_id') String clinicId,@JsonKey(name: 'specialization_id') String specializationId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'photo_url') String? photoUrl, String? description,@JsonKey(name: 'experience_years') int experienceYears, String? education,@JsonKey(name: 'consultation_fee') double consultationFee,@JsonKey(name: 'rating_avg') double ratingAvg,@JsonKey(name: 'rating_count') int ratingCount,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'clinics') ClinicModel? clinic,@JsonKey(name: 'specializations') SpecializationModel? specialization
});


@override $SpecializationModelCopyWith<$Res>? get specialization;

}
/// @nodoc
class __$DoctorModelCopyWithImpl<$Res>
    implements _$DoctorModelCopyWith<$Res> {
  __$DoctorModelCopyWithImpl(this._self, this._then);

  final _DoctorModel _self;
  final $Res Function(_DoctorModel) _then;

/// Create a copy of DoctorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clinicId = null,Object? specializationId = null,Object? fullName = null,Object? photoUrl = freezed,Object? description = freezed,Object? experienceYears = null,Object? education = freezed,Object? consultationFee = null,Object? ratingAvg = null,Object? ratingCount = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? clinic = freezed,Object? specialization = freezed,}) {
  return _then(_DoctorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clinicId: null == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String,specializationId: null == specializationId ? _self.specializationId : specializationId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: null == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,consultationFee: null == consultationFee ? _self.consultationFee : consultationFee // ignore: cast_nullable_to_non_nullable
as double,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,clinic: freezed == clinic ? _self.clinic : clinic // ignore: cast_nullable_to_non_nullable
as ClinicModel?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as SpecializationModel?,
  ));
}

/// Create a copy of DoctorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpecializationModelCopyWith<$Res>? get specialization {
    if (_self.specialization == null) {
    return null;
  }

  return $SpecializationModelCopyWith<$Res>(_self.specialization!, (value) {
    return _then(_self.copyWith(specialization: value));
  });
}
}

// dart format on
