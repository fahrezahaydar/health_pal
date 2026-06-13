// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_slot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoctorSlotModel {

 String get id;@JsonKey(name: 'doctor_id') String get doctorId;@JsonKey(name: 'schedule_id') String? get scheduleId;@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) DateTime get slotDate;@JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay get startTime;@JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay get endTime;@JsonKey(name: 'is_booked') bool get isBooked;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of DoctorSlotModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorSlotModelCopyWith<DoctorSlotModel> get copyWith => _$DoctorSlotModelCopyWithImpl<DoctorSlotModel>(this as DoctorSlotModel, _$identity);

  /// Serializes this DoctorSlotModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorSlotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.slotDate, slotDate) || other.slotDate == slotDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isBooked, isBooked) || other.isBooked == isBooked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,scheduleId,slotDate,startTime,endTime,isBooked,createdAt);

@override
String toString() {
  return 'DoctorSlotModel(id: $id, doctorId: $doctorId, scheduleId: $scheduleId, slotDate: $slotDate, startTime: $startTime, endTime: $endTime, isBooked: $isBooked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DoctorSlotModelCopyWith<$Res>  {
  factory $DoctorSlotModelCopyWith(DoctorSlotModel value, $Res Function(DoctorSlotModel) _then) = _$DoctorSlotModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'schedule_id') String? scheduleId,@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) DateTime slotDate,@JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay startTime,@JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay endTime,@JsonKey(name: 'is_booked') bool isBooked,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$DoctorSlotModelCopyWithImpl<$Res>
    implements $DoctorSlotModelCopyWith<$Res> {
  _$DoctorSlotModelCopyWithImpl(this._self, this._then);

  final DoctorSlotModel _self;
  final $Res Function(DoctorSlotModel) _then;

/// Create a copy of DoctorSlotModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? doctorId = null,Object? scheduleId = freezed,Object? slotDate = null,Object? startTime = null,Object? endTime = null,Object? isBooked = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,slotDate: null == slotDate ? _self.slotDate : slotDate // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,isBooked: null == isBooked ? _self.isBooked : isBooked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DoctorSlotModel].
extension DoctorSlotModelPatterns on DoctorSlotModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoctorSlotModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoctorSlotModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoctorSlotModel value)  $default,){
final _that = this;
switch (_that) {
case _DoctorSlotModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoctorSlotModel value)?  $default,){
final _that = this;
switch (_that) {
case _DoctorSlotModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'schedule_id')  String? scheduleId, @JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson)  DateTime slotDate, @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay startTime, @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay endTime, @JsonKey(name: 'is_booked')  bool isBooked, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoctorSlotModel() when $default != null:
return $default(_that.id,_that.doctorId,_that.scheduleId,_that.slotDate,_that.startTime,_that.endTime,_that.isBooked,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'schedule_id')  String? scheduleId, @JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson)  DateTime slotDate, @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay startTime, @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay endTime, @JsonKey(name: 'is_booked')  bool isBooked, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DoctorSlotModel():
return $default(_that.id,_that.doctorId,_that.scheduleId,_that.slotDate,_that.startTime,_that.endTime,_that.isBooked,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'schedule_id')  String? scheduleId, @JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson)  DateTime slotDate, @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay startTime, @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay endTime, @JsonKey(name: 'is_booked')  bool isBooked, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DoctorSlotModel() when $default != null:
return $default(_that.id,_that.doctorId,_that.scheduleId,_that.slotDate,_that.startTime,_that.endTime,_that.isBooked,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoctorSlotModel extends DoctorSlotModel {
  const _DoctorSlotModel({required this.id, @JsonKey(name: 'doctor_id') required this.doctorId, @JsonKey(name: 'schedule_id') this.scheduleId, @JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) required this.slotDate, @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) required this.startTime, @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) required this.endTime, @JsonKey(name: 'is_booked') this.isBooked = false, @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _DoctorSlotModel.fromJson(Map<String, dynamic> json) => _$DoctorSlotModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'doctor_id') final  String doctorId;
@override@JsonKey(name: 'schedule_id') final  String? scheduleId;
@override@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime slotDate;
@override@JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) final  TimeOfDay startTime;
@override@JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) final  TimeOfDay endTime;
@override@JsonKey(name: 'is_booked') final  bool isBooked;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of DoctorSlotModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoctorSlotModelCopyWith<_DoctorSlotModel> get copyWith => __$DoctorSlotModelCopyWithImpl<_DoctorSlotModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoctorSlotModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoctorSlotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.slotDate, slotDate) || other.slotDate == slotDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isBooked, isBooked) || other.isBooked == isBooked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,doctorId,scheduleId,slotDate,startTime,endTime,isBooked,createdAt);

@override
String toString() {
  return 'DoctorSlotModel(id: $id, doctorId: $doctorId, scheduleId: $scheduleId, slotDate: $slotDate, startTime: $startTime, endTime: $endTime, isBooked: $isBooked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DoctorSlotModelCopyWith<$Res> implements $DoctorSlotModelCopyWith<$Res> {
  factory _$DoctorSlotModelCopyWith(_DoctorSlotModel value, $Res Function(_DoctorSlotModel) _then) = __$DoctorSlotModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'schedule_id') String? scheduleId,@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) DateTime slotDate,@JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay startTime,@JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay endTime,@JsonKey(name: 'is_booked') bool isBooked,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$DoctorSlotModelCopyWithImpl<$Res>
    implements _$DoctorSlotModelCopyWith<$Res> {
  __$DoctorSlotModelCopyWithImpl(this._self, this._then);

  final _DoctorSlotModel _self;
  final $Res Function(_DoctorSlotModel) _then;

/// Create a copy of DoctorSlotModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? doctorId = null,Object? scheduleId = freezed,Object? slotDate = null,Object? startTime = null,Object? endTime = null,Object? isBooked = null,Object? createdAt = freezed,}) {
  return _then(_DoctorSlotModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,slotDate: null == slotDate ? _self.slotDate : slotDate // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,isBooked: null == isBooked ? _self.isBooked : isBooked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
