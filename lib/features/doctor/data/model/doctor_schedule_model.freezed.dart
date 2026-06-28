// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoctorScheduleModel {

 String get id;@JsonKey(name: 'doctor_id') String get doctorId;@JsonKey(name: 'day_of_week') int get dayOfWeek;@JsonKey(name: 'start_time') String get startTime;@JsonKey(name: 'end_time') String get endTime;@JsonKey(name: 'slot_duration_minutes') int get slotDurationMinutes;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of DoctorScheduleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorScheduleModelCopyWith<DoctorScheduleModel> get copyWith => _$DoctorScheduleModelCopyWithImpl<DoctorScheduleModel>(this as DoctorScheduleModel, _$identity);

  /// Serializes this DoctorScheduleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorScheduleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.slotDurationMinutes, slotDurationMinutes) || other.slotDurationMinutes == slotDurationMinutes)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,dayOfWeek,startTime,endTime,slotDurationMinutes,isActive);

@override
String toString() {
  return 'DoctorScheduleModel(id: $id, doctorId: $doctorId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, slotDurationMinutes: $slotDurationMinutes, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $DoctorScheduleModelCopyWith<$Res>  {
  factory $DoctorScheduleModelCopyWith(DoctorScheduleModel value, $Res Function(DoctorScheduleModel) _then) = _$DoctorScheduleModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'slot_duration_minutes') int slotDurationMinutes,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$DoctorScheduleModelCopyWithImpl<$Res>
    implements $DoctorScheduleModelCopyWith<$Res> {
  _$DoctorScheduleModelCopyWithImpl(this._self, this._then);

  final DoctorScheduleModel _self;
  final $Res Function(DoctorScheduleModel) _then;

/// Create a copy of DoctorScheduleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? doctorId = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? slotDurationMinutes = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,slotDurationMinutes: null == slotDurationMinutes ? _self.slotDurationMinutes : slotDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DoctorScheduleModel].
extension DoctorScheduleModelPatterns on DoctorScheduleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoctorScheduleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoctorScheduleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoctorScheduleModel value)  $default,){
final _that = this;
switch (_that) {
case _DoctorScheduleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoctorScheduleModel value)?  $default,){
final _that = this;
switch (_that) {
case _DoctorScheduleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'slot_duration_minutes')  int slotDurationMinutes, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoctorScheduleModel() when $default != null:
return $default(_that.id,_that.doctorId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.slotDurationMinutes,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'slot_duration_minutes')  int slotDurationMinutes, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _DoctorScheduleModel():
return $default(_that.id,_that.doctorId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.slotDurationMinutes,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'slot_duration_minutes')  int slotDurationMinutes, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _DoctorScheduleModel() when $default != null:
return $default(_that.id,_that.doctorId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.slotDurationMinutes,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoctorScheduleModel extends DoctorScheduleModel {
  const _DoctorScheduleModel({required this.id, @JsonKey(name: 'doctor_id') required this.doctorId, @JsonKey(name: 'day_of_week') required this.dayOfWeek, @JsonKey(name: 'start_time') required this.startTime, @JsonKey(name: 'end_time') required this.endTime, @JsonKey(name: 'slot_duration_minutes') this.slotDurationMinutes = 30, @JsonKey(name: 'is_active') this.isActive = true}): super._();
  factory _DoctorScheduleModel.fromJson(Map<String, dynamic> json) => _$DoctorScheduleModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'doctor_id') final  String doctorId;
@override@JsonKey(name: 'day_of_week') final  int dayOfWeek;
@override@JsonKey(name: 'start_time') final  String startTime;
@override@JsonKey(name: 'end_time') final  String endTime;
@override@JsonKey(name: 'slot_duration_minutes') final  int slotDurationMinutes;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of DoctorScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorScheduleModelCopyWith<_DoctorScheduleModel> get copyWith => __$DoctorScheduleModelCopyWithImpl<_DoctorScheduleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorScheduleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoctorScheduleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.slotDurationMinutes, slotDurationMinutes) || other.slotDurationMinutes == slotDurationMinutes)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,dayOfWeek,startTime,endTime,slotDurationMinutes,isActive);

@override
String toString() {
  return 'DoctorScheduleModel(id: $id, doctorId: $doctorId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, slotDurationMinutes: $slotDurationMinutes, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$DoctorScheduleModelCopyWith<$Res> implements $DoctorScheduleModelCopyWith<$Res> {
  factory _$DoctorScheduleModelCopyWith(_DoctorScheduleModel value, $Res Function(_DoctorScheduleModel) _then) = __$DoctorScheduleModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'slot_duration_minutes') int slotDurationMinutes,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$DoctorScheduleModelCopyWithImpl<$Res>
    implements _$DoctorScheduleModelCopyWith<$Res> {
  __$DoctorScheduleModelCopyWithImpl(this._self, this._then);

  final _DoctorScheduleModel _self;
  final $Res Function(_DoctorScheduleModel) _then;

/// Create a copy of DoctorScheduleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? doctorId = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? slotDurationMinutes = null,Object? isActive = null,}) {
  return _then(_DoctorScheduleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,slotDurationMinutes: null == slotDurationMinutes ? _self.slotDurationMinutes : slotDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
