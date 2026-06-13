// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppointmentModel {

 String get id;@JsonKey(name: 'patient_id') String get patientId;@JsonKey(name: 'doctor_id') String get doctorId;@JsonKey(name: 'slot_id') String get slotId; String get status;// 'pending' | 'upcoming' | 'completed' | 'cancelled'
@JsonKey(name: 'complaint_note') String? get complaintNote;@JsonKey(name: 'consultation_fee_snapshot') double get consultationFeeSnapshot;@JsonKey(name: 'booked_at') DateTime? get bookedAt;@JsonKey(name: 'confirmed_at') DateTime? get confirmedAt;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'cancelled_at') DateTime? get cancelledAt;@JsonKey(name: 'cancellation_reason') String? get cancellationReason;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;// ── Nested Objects (dari PostgREST nested select) ──
 AppointmentDoctorModel? get doctors; AppointmentSlotModel? get doctorSlots;
/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentModelCopyWith<AppointmentModel> get copyWith => _$AppointmentModelCopyWithImpl<AppointmentModel>(this as AppointmentModel, _$identity);

  /// Serializes this AppointmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.slotId, slotId) || other.slotId == slotId)&&(identical(other.status, status) || other.status == status)&&(identical(other.complaintNote, complaintNote) || other.complaintNote == complaintNote)&&(identical(other.consultationFeeSnapshot, consultationFeeSnapshot) || other.consultationFeeSnapshot == consultationFeeSnapshot)&&(identical(other.bookedAt, bookedAt) || other.bookedAt == bookedAt)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.doctors, doctors) || other.doctors == doctors)&&(identical(other.doctorSlots, doctorSlots) || other.doctorSlots == doctorSlots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,doctorId,slotId,status,complaintNote,consultationFeeSnapshot,bookedAt,confirmedAt,completedAt,cancelledAt,cancellationReason,createdAt,updatedAt,doctors,doctorSlots);

@override
String toString() {
  return 'AppointmentModel(id: $id, patientId: $patientId, doctorId: $doctorId, slotId: $slotId, status: $status, complaintNote: $complaintNote, consultationFeeSnapshot: $consultationFeeSnapshot, bookedAt: $bookedAt, confirmedAt: $confirmedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, createdAt: $createdAt, updatedAt: $updatedAt, doctors: $doctors, doctorSlots: $doctorSlots)';
}


}

/// @nodoc
abstract mixin class $AppointmentModelCopyWith<$Res>  {
  factory $AppointmentModelCopyWith(AppointmentModel value, $Res Function(AppointmentModel) _then) = _$AppointmentModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'slot_id') String slotId, String status,@JsonKey(name: 'complaint_note') String? complaintNote,@JsonKey(name: 'consultation_fee_snapshot') double consultationFeeSnapshot,@JsonKey(name: 'booked_at') DateTime? bookedAt,@JsonKey(name: 'confirmed_at') DateTime? confirmedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'cancelled_at') DateTime? cancelledAt,@JsonKey(name: 'cancellation_reason') String? cancellationReason,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, AppointmentDoctorModel? doctors, AppointmentSlotModel? doctorSlots
});


$AppointmentDoctorModelCopyWith<$Res>? get doctors;$AppointmentSlotModelCopyWith<$Res>? get doctorSlots;

}
/// @nodoc
class _$AppointmentModelCopyWithImpl<$Res>
    implements $AppointmentModelCopyWith<$Res> {
  _$AppointmentModelCopyWithImpl(this._self, this._then);

  final AppointmentModel _self;
  final $Res Function(AppointmentModel) _then;

/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientId = null,Object? doctorId = null,Object? slotId = null,Object? status = null,Object? complaintNote = freezed,Object? consultationFeeSnapshot = null,Object? bookedAt = freezed,Object? confirmedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? doctors = freezed,Object? doctorSlots = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,slotId: null == slotId ? _self.slotId : slotId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,complaintNote: freezed == complaintNote ? _self.complaintNote : complaintNote // ignore: cast_nullable_to_non_nullable
as String?,consultationFeeSnapshot: null == consultationFeeSnapshot ? _self.consultationFeeSnapshot : consultationFeeSnapshot // ignore: cast_nullable_to_non_nullable
as double,bookedAt: freezed == bookedAt ? _self.bookedAt : bookedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doctors: freezed == doctors ? _self.doctors : doctors // ignore: cast_nullable_to_non_nullable
as AppointmentDoctorModel?,doctorSlots: freezed == doctorSlots ? _self.doctorSlots : doctorSlots // ignore: cast_nullable_to_non_nullable
as AppointmentSlotModel?,
  ));
}
/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentDoctorModelCopyWith<$Res>? get doctors {
    if (_self.doctors == null) {
    return null;
  }

  return $AppointmentDoctorModelCopyWith<$Res>(_self.doctors!, (value) {
    return _then(_self.copyWith(doctors: value));
  });
}/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentSlotModelCopyWith<$Res>? get doctorSlots {
    if (_self.doctorSlots == null) {
    return null;
  }

  return $AppointmentSlotModelCopyWith<$Res>(_self.doctorSlots!, (value) {
    return _then(_self.copyWith(doctorSlots: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppointmentModel].
extension AppointmentModelPatterns on AppointmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentModel value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'slot_id')  String slotId,  String status, @JsonKey(name: 'complaint_note')  String? complaintNote, @JsonKey(name: 'consultation_fee_snapshot')  double consultationFeeSnapshot, @JsonKey(name: 'booked_at')  DateTime? bookedAt, @JsonKey(name: 'confirmed_at')  DateTime? confirmedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt, @JsonKey(name: 'cancellation_reason')  String? cancellationReason, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  AppointmentDoctorModel? doctors,  AppointmentSlotModel? doctorSlots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentModel() when $default != null:
return $default(_that.id,_that.patientId,_that.doctorId,_that.slotId,_that.status,_that.complaintNote,_that.consultationFeeSnapshot,_that.bookedAt,_that.confirmedAt,_that.completedAt,_that.cancelledAt,_that.cancellationReason,_that.createdAt,_that.updatedAt,_that.doctors,_that.doctorSlots);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'slot_id')  String slotId,  String status, @JsonKey(name: 'complaint_note')  String? complaintNote, @JsonKey(name: 'consultation_fee_snapshot')  double consultationFeeSnapshot, @JsonKey(name: 'booked_at')  DateTime? bookedAt, @JsonKey(name: 'confirmed_at')  DateTime? confirmedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt, @JsonKey(name: 'cancellation_reason')  String? cancellationReason, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  AppointmentDoctorModel? doctors,  AppointmentSlotModel? doctorSlots)  $default,) {final _that = this;
switch (_that) {
case _AppointmentModel():
return $default(_that.id,_that.patientId,_that.doctorId,_that.slotId,_that.status,_that.complaintNote,_that.consultationFeeSnapshot,_that.bookedAt,_that.confirmedAt,_that.completedAt,_that.cancelledAt,_that.cancellationReason,_that.createdAt,_that.updatedAt,_that.doctors,_that.doctorSlots);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'patient_id')  String patientId, @JsonKey(name: 'doctor_id')  String doctorId, @JsonKey(name: 'slot_id')  String slotId,  String status, @JsonKey(name: 'complaint_note')  String? complaintNote, @JsonKey(name: 'consultation_fee_snapshot')  double consultationFeeSnapshot, @JsonKey(name: 'booked_at')  DateTime? bookedAt, @JsonKey(name: 'confirmed_at')  DateTime? confirmedAt, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'cancelled_at')  DateTime? cancelledAt, @JsonKey(name: 'cancellation_reason')  String? cancellationReason, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  AppointmentDoctorModel? doctors,  AppointmentSlotModel? doctorSlots)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentModel() when $default != null:
return $default(_that.id,_that.patientId,_that.doctorId,_that.slotId,_that.status,_that.complaintNote,_that.consultationFeeSnapshot,_that.bookedAt,_that.confirmedAt,_that.completedAt,_that.cancelledAt,_that.cancellationReason,_that.createdAt,_that.updatedAt,_that.doctors,_that.doctorSlots);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentModel extends AppointmentModel {
  const _AppointmentModel({required this.id, @JsonKey(name: 'patient_id') required this.patientId, @JsonKey(name: 'doctor_id') required this.doctorId, @JsonKey(name: 'slot_id') required this.slotId, required this.status, @JsonKey(name: 'complaint_note') this.complaintNote, @JsonKey(name: 'consultation_fee_snapshot') required this.consultationFeeSnapshot, @JsonKey(name: 'booked_at') this.bookedAt, @JsonKey(name: 'confirmed_at') this.confirmedAt, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'cancelled_at') this.cancelledAt, @JsonKey(name: 'cancellation_reason') this.cancellationReason, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.doctors, this.doctorSlots}): super._();
  factory _AppointmentModel.fromJson(Map<String, dynamic> json) => _$AppointmentModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'patient_id') final  String patientId;
@override@JsonKey(name: 'doctor_id') final  String doctorId;
@override@JsonKey(name: 'slot_id') final  String slotId;
@override final  String status;
// 'pending' | 'upcoming' | 'completed' | 'cancelled'
@override@JsonKey(name: 'complaint_note') final  String? complaintNote;
@override@JsonKey(name: 'consultation_fee_snapshot') final  double consultationFeeSnapshot;
@override@JsonKey(name: 'booked_at') final  DateTime? bookedAt;
@override@JsonKey(name: 'confirmed_at') final  DateTime? confirmedAt;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'cancelled_at') final  DateTime? cancelledAt;
@override@JsonKey(name: 'cancellation_reason') final  String? cancellationReason;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
// ── Nested Objects (dari PostgREST nested select) ──
@override final  AppointmentDoctorModel? doctors;
@override final  AppointmentSlotModel? doctorSlots;

/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentModelCopyWith<_AppointmentModel> get copyWith => __$AppointmentModelCopyWithImpl<_AppointmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.doctorId, doctorId) || other.doctorId == doctorId)&&(identical(other.slotId, slotId) || other.slotId == slotId)&&(identical(other.status, status) || other.status == status)&&(identical(other.complaintNote, complaintNote) || other.complaintNote == complaintNote)&&(identical(other.consultationFeeSnapshot, consultationFeeSnapshot) || other.consultationFeeSnapshot == consultationFeeSnapshot)&&(identical(other.bookedAt, bookedAt) || other.bookedAt == bookedAt)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.doctors, doctors) || other.doctors == doctors)&&(identical(other.doctorSlots, doctorSlots) || other.doctorSlots == doctorSlots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,doctorId,slotId,status,complaintNote,consultationFeeSnapshot,bookedAt,confirmedAt,completedAt,cancelledAt,cancellationReason,createdAt,updatedAt,doctors,doctorSlots);

@override
String toString() {
  return 'AppointmentModel(id: $id, patientId: $patientId, doctorId: $doctorId, slotId: $slotId, status: $status, complaintNote: $complaintNote, consultationFeeSnapshot: $consultationFeeSnapshot, bookedAt: $bookedAt, confirmedAt: $confirmedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, createdAt: $createdAt, updatedAt: $updatedAt, doctors: $doctors, doctorSlots: $doctorSlots)';
}


}

/// @nodoc
abstract mixin class _$AppointmentModelCopyWith<$Res> implements $AppointmentModelCopyWith<$Res> {
  factory _$AppointmentModelCopyWith(_AppointmentModel value, $Res Function(_AppointmentModel) _then) = __$AppointmentModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'patient_id') String patientId,@JsonKey(name: 'doctor_id') String doctorId,@JsonKey(name: 'slot_id') String slotId, String status,@JsonKey(name: 'complaint_note') String? complaintNote,@JsonKey(name: 'consultation_fee_snapshot') double consultationFeeSnapshot,@JsonKey(name: 'booked_at') DateTime? bookedAt,@JsonKey(name: 'confirmed_at') DateTime? confirmedAt,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'cancelled_at') DateTime? cancelledAt,@JsonKey(name: 'cancellation_reason') String? cancellationReason,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, AppointmentDoctorModel? doctors, AppointmentSlotModel? doctorSlots
});


@override $AppointmentDoctorModelCopyWith<$Res>? get doctors;@override $AppointmentSlotModelCopyWith<$Res>? get doctorSlots;

}
/// @nodoc
class __$AppointmentModelCopyWithImpl<$Res>
    implements _$AppointmentModelCopyWith<$Res> {
  __$AppointmentModelCopyWithImpl(this._self, this._then);

  final _AppointmentModel _self;
  final $Res Function(_AppointmentModel) _then;

/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientId = null,Object? doctorId = null,Object? slotId = null,Object? status = null,Object? complaintNote = freezed,Object? consultationFeeSnapshot = null,Object? bookedAt = freezed,Object? confirmedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? doctors = freezed,Object? doctorSlots = freezed,}) {
  return _then(_AppointmentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,doctorId: null == doctorId ? _self.doctorId : doctorId // ignore: cast_nullable_to_non_nullable
as String,slotId: null == slotId ? _self.slotId : slotId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,complaintNote: freezed == complaintNote ? _self.complaintNote : complaintNote // ignore: cast_nullable_to_non_nullable
as String?,consultationFeeSnapshot: null == consultationFeeSnapshot ? _self.consultationFeeSnapshot : consultationFeeSnapshot // ignore: cast_nullable_to_non_nullable
as double,bookedAt: freezed == bookedAt ? _self.bookedAt : bookedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,doctors: freezed == doctors ? _self.doctors : doctors // ignore: cast_nullable_to_non_nullable
as AppointmentDoctorModel?,doctorSlots: freezed == doctorSlots ? _self.doctorSlots : doctorSlots // ignore: cast_nullable_to_non_nullable
as AppointmentSlotModel?,
  ));
}

/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentDoctorModelCopyWith<$Res>? get doctors {
    if (_self.doctors == null) {
    return null;
  }

  return $AppointmentDoctorModelCopyWith<$Res>(_self.doctors!, (value) {
    return _then(_self.copyWith(doctors: value));
  });
}/// Create a copy of AppointmentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentSlotModelCopyWith<$Res>? get doctorSlots {
    if (_self.doctorSlots == null) {
    return null;
  }

  return $AppointmentSlotModelCopyWith<$Res>(_self.doctorSlots!, (value) {
    return _then(_self.copyWith(doctorSlots: value));
  });
}
}


/// @nodoc
mixin _$AppointmentDoctorModel {

 String get id;@JsonKey(name: 'full_name') String get fullName;@JsonKey(name: 'photo_url') String? get photoUrl;@JsonKey(name: 'experience_years') int? get experienceYears; AppointmentSpecializationModel? get specializations; AppointmentClinicModel? get clinics;
/// Create a copy of AppointmentDoctorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentDoctorModelCopyWith<AppointmentDoctorModel> get copyWith => _$AppointmentDoctorModelCopyWithImpl<AppointmentDoctorModel>(this as AppointmentDoctorModel, _$identity);

  /// Serializes this AppointmentDoctorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentDoctorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.specializations, specializations) || other.specializations == specializations)&&(identical(other.clinics, clinics) || other.clinics == clinics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,photoUrl,experienceYears,specializations,clinics);

@override
String toString() {
  return 'AppointmentDoctorModel(id: $id, fullName: $fullName, photoUrl: $photoUrl, experienceYears: $experienceYears, specializations: $specializations, clinics: $clinics)';
}


}

/// @nodoc
abstract mixin class $AppointmentDoctorModelCopyWith<$Res>  {
  factory $AppointmentDoctorModelCopyWith(AppointmentDoctorModel value, $Res Function(AppointmentDoctorModel) _then) = _$AppointmentDoctorModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'experience_years') int? experienceYears, AppointmentSpecializationModel? specializations, AppointmentClinicModel? clinics
});


$AppointmentSpecializationModelCopyWith<$Res>? get specializations;$AppointmentClinicModelCopyWith<$Res>? get clinics;

}
/// @nodoc
class _$AppointmentDoctorModelCopyWithImpl<$Res>
    implements $AppointmentDoctorModelCopyWith<$Res> {
  _$AppointmentDoctorModelCopyWithImpl(this._self, this._then);

  final AppointmentDoctorModel _self;
  final $Res Function(AppointmentDoctorModel) _then;

/// Create a copy of AppointmentDoctorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? photoUrl = freezed,Object? experienceYears = freezed,Object? specializations = freezed,Object? clinics = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,specializations: freezed == specializations ? _self.specializations : specializations // ignore: cast_nullable_to_non_nullable
as AppointmentSpecializationModel?,clinics: freezed == clinics ? _self.clinics : clinics // ignore: cast_nullable_to_non_nullable
as AppointmentClinicModel?,
  ));
}
/// Create a copy of AppointmentDoctorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentSpecializationModelCopyWith<$Res>? get specializations {
    if (_self.specializations == null) {
    return null;
  }

  return $AppointmentSpecializationModelCopyWith<$Res>(_self.specializations!, (value) {
    return _then(_self.copyWith(specializations: value));
  });
}/// Create a copy of AppointmentDoctorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentClinicModelCopyWith<$Res>? get clinics {
    if (_self.clinics == null) {
    return null;
  }

  return $AppointmentClinicModelCopyWith<$Res>(_self.clinics!, (value) {
    return _then(_self.copyWith(clinics: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppointmentDoctorModel].
extension AppointmentDoctorModelPatterns on AppointmentDoctorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentDoctorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentDoctorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentDoctorModel value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentDoctorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentDoctorModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentDoctorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'experience_years')  int? experienceYears,  AppointmentSpecializationModel? specializations,  AppointmentClinicModel? clinics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentDoctorModel() when $default != null:
return $default(_that.id,_that.fullName,_that.photoUrl,_that.experienceYears,_that.specializations,_that.clinics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'experience_years')  int? experienceYears,  AppointmentSpecializationModel? specializations,  AppointmentClinicModel? clinics)  $default,) {final _that = this;
switch (_that) {
case _AppointmentDoctorModel():
return $default(_that.id,_that.fullName,_that.photoUrl,_that.experienceYears,_that.specializations,_that.clinics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'experience_years')  int? experienceYears,  AppointmentSpecializationModel? specializations,  AppointmentClinicModel? clinics)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentDoctorModel() when $default != null:
return $default(_that.id,_that.fullName,_that.photoUrl,_that.experienceYears,_that.specializations,_that.clinics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentDoctorModel extends AppointmentDoctorModel {
  const _AppointmentDoctorModel({required this.id, @JsonKey(name: 'full_name') required this.fullName, @JsonKey(name: 'photo_url') this.photoUrl, @JsonKey(name: 'experience_years') this.experienceYears, this.specializations, this.clinics}): super._();
  factory _AppointmentDoctorModel.fromJson(Map<String, dynamic> json) => _$AppointmentDoctorModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'full_name') final  String fullName;
@override@JsonKey(name: 'photo_url') final  String? photoUrl;
@override@JsonKey(name: 'experience_years') final  int? experienceYears;
@override final  AppointmentSpecializationModel? specializations;
@override final  AppointmentClinicModel? clinics;

/// Create a copy of AppointmentDoctorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentDoctorModelCopyWith<_AppointmentDoctorModel> get copyWith => __$AppointmentDoctorModelCopyWithImpl<_AppointmentDoctorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentDoctorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentDoctorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.specializations, specializations) || other.specializations == specializations)&&(identical(other.clinics, clinics) || other.clinics == clinics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,photoUrl,experienceYears,specializations,clinics);

@override
String toString() {
  return 'AppointmentDoctorModel(id: $id, fullName: $fullName, photoUrl: $photoUrl, experienceYears: $experienceYears, specializations: $specializations, clinics: $clinics)';
}


}

/// @nodoc
abstract mixin class _$AppointmentDoctorModelCopyWith<$Res> implements $AppointmentDoctorModelCopyWith<$Res> {
  factory _$AppointmentDoctorModelCopyWith(_AppointmentDoctorModel value, $Res Function(_AppointmentDoctorModel) _then) = __$AppointmentDoctorModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'experience_years') int? experienceYears, AppointmentSpecializationModel? specializations, AppointmentClinicModel? clinics
});


@override $AppointmentSpecializationModelCopyWith<$Res>? get specializations;@override $AppointmentClinicModelCopyWith<$Res>? get clinics;

}
/// @nodoc
class __$AppointmentDoctorModelCopyWithImpl<$Res>
    implements _$AppointmentDoctorModelCopyWith<$Res> {
  __$AppointmentDoctorModelCopyWithImpl(this._self, this._then);

  final _AppointmentDoctorModel _self;
  final $Res Function(_AppointmentDoctorModel) _then;

/// Create a copy of AppointmentDoctorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? photoUrl = freezed,Object? experienceYears = freezed,Object? specializations = freezed,Object? clinics = freezed,}) {
  return _then(_AppointmentDoctorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,specializations: freezed == specializations ? _self.specializations : specializations // ignore: cast_nullable_to_non_nullable
as AppointmentSpecializationModel?,clinics: freezed == clinics ? _self.clinics : clinics // ignore: cast_nullable_to_non_nullable
as AppointmentClinicModel?,
  ));
}

/// Create a copy of AppointmentDoctorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentSpecializationModelCopyWith<$Res>? get specializations {
    if (_self.specializations == null) {
    return null;
  }

  return $AppointmentSpecializationModelCopyWith<$Res>(_self.specializations!, (value) {
    return _then(_self.copyWith(specializations: value));
  });
}/// Create a copy of AppointmentDoctorModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentClinicModelCopyWith<$Res>? get clinics {
    if (_self.clinics == null) {
    return null;
  }

  return $AppointmentClinicModelCopyWith<$Res>(_self.clinics!, (value) {
    return _then(_self.copyWith(clinics: value));
  });
}
}


/// @nodoc
mixin _$AppointmentSpecializationModel {

 String get name;
/// Create a copy of AppointmentSpecializationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentSpecializationModelCopyWith<AppointmentSpecializationModel> get copyWith => _$AppointmentSpecializationModelCopyWithImpl<AppointmentSpecializationModel>(this as AppointmentSpecializationModel, _$identity);

  /// Serializes this AppointmentSpecializationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentSpecializationModel&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'AppointmentSpecializationModel(name: $name)';
}


}

/// @nodoc
abstract mixin class $AppointmentSpecializationModelCopyWith<$Res>  {
  factory $AppointmentSpecializationModelCopyWith(AppointmentSpecializationModel value, $Res Function(AppointmentSpecializationModel) _then) = _$AppointmentSpecializationModelCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$AppointmentSpecializationModelCopyWithImpl<$Res>
    implements $AppointmentSpecializationModelCopyWith<$Res> {
  _$AppointmentSpecializationModelCopyWithImpl(this._self, this._then);

  final AppointmentSpecializationModel _self;
  final $Res Function(AppointmentSpecializationModel) _then;

/// Create a copy of AppointmentSpecializationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentSpecializationModel].
extension AppointmentSpecializationModelPatterns on AppointmentSpecializationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentSpecializationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentSpecializationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentSpecializationModel value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentSpecializationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentSpecializationModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentSpecializationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentSpecializationModel() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _AppointmentSpecializationModel():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentSpecializationModel() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentSpecializationModel implements AppointmentSpecializationModel {
  const _AppointmentSpecializationModel({required this.name});
  factory _AppointmentSpecializationModel.fromJson(Map<String, dynamic> json) => _$AppointmentSpecializationModelFromJson(json);

@override final  String name;

/// Create a copy of AppointmentSpecializationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentSpecializationModelCopyWith<_AppointmentSpecializationModel> get copyWith => __$AppointmentSpecializationModelCopyWithImpl<_AppointmentSpecializationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentSpecializationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentSpecializationModel&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'AppointmentSpecializationModel(name: $name)';
}


}

/// @nodoc
abstract mixin class _$AppointmentSpecializationModelCopyWith<$Res> implements $AppointmentSpecializationModelCopyWith<$Res> {
  factory _$AppointmentSpecializationModelCopyWith(_AppointmentSpecializationModel value, $Res Function(_AppointmentSpecializationModel) _then) = __$AppointmentSpecializationModelCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$AppointmentSpecializationModelCopyWithImpl<$Res>
    implements _$AppointmentSpecializationModelCopyWith<$Res> {
  __$AppointmentSpecializationModelCopyWithImpl(this._self, this._then);

  final _AppointmentSpecializationModel _self;
  final $Res Function(_AppointmentSpecializationModel) _then;

/// Create a copy of AppointmentSpecializationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_AppointmentSpecializationModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AppointmentClinicModel {

 String get name; String? get address; String? get phone;
/// Create a copy of AppointmentClinicModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentClinicModelCopyWith<AppointmentClinicModel> get copyWith => _$AppointmentClinicModelCopyWithImpl<AppointmentClinicModel>(this as AppointmentClinicModel, _$identity);

  /// Serializes this AppointmentClinicModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentClinicModel&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,phone);

@override
String toString() {
  return 'AppointmentClinicModel(name: $name, address: $address, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $AppointmentClinicModelCopyWith<$Res>  {
  factory $AppointmentClinicModelCopyWith(AppointmentClinicModel value, $Res Function(AppointmentClinicModel) _then) = _$AppointmentClinicModelCopyWithImpl;
@useResult
$Res call({
 String name, String? address, String? phone
});




}
/// @nodoc
class _$AppointmentClinicModelCopyWithImpl<$Res>
    implements $AppointmentClinicModelCopyWith<$Res> {
  _$AppointmentClinicModelCopyWithImpl(this._self, this._then);

  final AppointmentClinicModel _self;
  final $Res Function(AppointmentClinicModel) _then;

/// Create a copy of AppointmentClinicModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = freezed,Object? phone = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentClinicModel].
extension AppointmentClinicModelPatterns on AppointmentClinicModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentClinicModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentClinicModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentClinicModel value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentClinicModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentClinicModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentClinicModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? address,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentClinicModel() when $default != null:
return $default(_that.name,_that.address,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? address,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _AppointmentClinicModel():
return $default(_that.name,_that.address,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? address,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentClinicModel() when $default != null:
return $default(_that.name,_that.address,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentClinicModel implements AppointmentClinicModel {
  const _AppointmentClinicModel({required this.name, this.address, this.phone});
  factory _AppointmentClinicModel.fromJson(Map<String, dynamic> json) => _$AppointmentClinicModelFromJson(json);

@override final  String name;
@override final  String? address;
@override final  String? phone;

/// Create a copy of AppointmentClinicModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentClinicModelCopyWith<_AppointmentClinicModel> get copyWith => __$AppointmentClinicModelCopyWithImpl<_AppointmentClinicModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentClinicModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentClinicModel&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,phone);

@override
String toString() {
  return 'AppointmentClinicModel(name: $name, address: $address, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$AppointmentClinicModelCopyWith<$Res> implements $AppointmentClinicModelCopyWith<$Res> {
  factory _$AppointmentClinicModelCopyWith(_AppointmentClinicModel value, $Res Function(_AppointmentClinicModel) _then) = __$AppointmentClinicModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String? address, String? phone
});




}
/// @nodoc
class __$AppointmentClinicModelCopyWithImpl<$Res>
    implements _$AppointmentClinicModelCopyWith<$Res> {
  __$AppointmentClinicModelCopyWithImpl(this._self, this._then);

  final _AppointmentClinicModel _self;
  final $Res Function(_AppointmentClinicModel) _then;

/// Create a copy of AppointmentClinicModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = freezed,Object? phone = freezed,}) {
  return _then(_AppointmentClinicModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AppointmentSlotModel {

@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) DateTime get slotDate;@JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay get slotStart;@JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay get slotEnd;
/// Create a copy of AppointmentSlotModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentSlotModelCopyWith<AppointmentSlotModel> get copyWith => _$AppointmentSlotModelCopyWithImpl<AppointmentSlotModel>(this as AppointmentSlotModel, _$identity);

  /// Serializes this AppointmentSlotModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentSlotModel&&(identical(other.slotDate, slotDate) || other.slotDate == slotDate)&&(identical(other.slotStart, slotStart) || other.slotStart == slotStart)&&(identical(other.slotEnd, slotEnd) || other.slotEnd == slotEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slotDate,slotStart,slotEnd);

@override
String toString() {
  return 'AppointmentSlotModel(slotDate: $slotDate, slotStart: $slotStart, slotEnd: $slotEnd)';
}


}

/// @nodoc
abstract mixin class $AppointmentSlotModelCopyWith<$Res>  {
  factory $AppointmentSlotModelCopyWith(AppointmentSlotModel value, $Res Function(AppointmentSlotModel) _then) = _$AppointmentSlotModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) DateTime slotDate,@JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay slotStart,@JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay slotEnd
});




}
/// @nodoc
class _$AppointmentSlotModelCopyWithImpl<$Res>
    implements $AppointmentSlotModelCopyWith<$Res> {
  _$AppointmentSlotModelCopyWithImpl(this._self, this._then);

  final AppointmentSlotModel _self;
  final $Res Function(AppointmentSlotModel) _then;

/// Create a copy of AppointmentSlotModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slotDate = null,Object? slotStart = null,Object? slotEnd = null,}) {
  return _then(_self.copyWith(
slotDate: null == slotDate ? _self.slotDate : slotDate // ignore: cast_nullable_to_non_nullable
as DateTime,slotStart: null == slotStart ? _self.slotStart : slotStart // ignore: cast_nullable_to_non_nullable
as TimeOfDay,slotEnd: null == slotEnd ? _self.slotEnd : slotEnd // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentSlotModel].
extension AppointmentSlotModelPatterns on AppointmentSlotModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentSlotModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentSlotModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentSlotModel value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentSlotModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentSlotModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentSlotModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson)  DateTime slotDate, @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay slotStart, @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay slotEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentSlotModel() when $default != null:
return $default(_that.slotDate,_that.slotStart,_that.slotEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson)  DateTime slotDate, @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay slotStart, @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay slotEnd)  $default,) {final _that = this;
switch (_that) {
case _AppointmentSlotModel():
return $default(_that.slotDate,_that.slotStart,_that.slotEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson)  DateTime slotDate, @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay slotStart, @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay slotEnd)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentSlotModel() when $default != null:
return $default(_that.slotDate,_that.slotStart,_that.slotEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentSlotModel implements AppointmentSlotModel {
  const _AppointmentSlotModel({@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) required this.slotDate, @JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) required this.slotStart, @JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) required this.slotEnd});
  factory _AppointmentSlotModel.fromJson(Map<String, dynamic> json) => _$AppointmentSlotModelFromJson(json);

@override@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime slotDate;
@override@JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) final  TimeOfDay slotStart;
@override@JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) final  TimeOfDay slotEnd;

/// Create a copy of AppointmentSlotModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentSlotModelCopyWith<_AppointmentSlotModel> get copyWith => __$AppointmentSlotModelCopyWithImpl<_AppointmentSlotModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentSlotModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentSlotModel&&(identical(other.slotDate, slotDate) || other.slotDate == slotDate)&&(identical(other.slotStart, slotStart) || other.slotStart == slotStart)&&(identical(other.slotEnd, slotEnd) || other.slotEnd == slotEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slotDate,slotStart,slotEnd);

@override
String toString() {
  return 'AppointmentSlotModel(slotDate: $slotDate, slotStart: $slotStart, slotEnd: $slotEnd)';
}


}

/// @nodoc
abstract mixin class _$AppointmentSlotModelCopyWith<$Res> implements $AppointmentSlotModelCopyWith<$Res> {
  factory _$AppointmentSlotModelCopyWith(_AppointmentSlotModel value, $Res Function(_AppointmentSlotModel) _then) = __$AppointmentSlotModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'slot_date', fromJson: _dateFromJson, toJson: _dateToJson) DateTime slotDate,@JsonKey(name: 'slot_start', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay slotStart,@JsonKey(name: 'slot_end', fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay slotEnd
});




}
/// @nodoc
class __$AppointmentSlotModelCopyWithImpl<$Res>
    implements _$AppointmentSlotModelCopyWith<$Res> {
  __$AppointmentSlotModelCopyWithImpl(this._self, this._then);

  final _AppointmentSlotModel _self;
  final $Res Function(_AppointmentSlotModel) _then;

/// Create a copy of AppointmentSlotModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slotDate = null,Object? slotStart = null,Object? slotEnd = null,}) {
  return _then(_AppointmentSlotModel(
slotDate: null == slotDate ? _self.slotDate : slotDate // ignore: cast_nullable_to_non_nullable
as DateTime,slotStart: null == slotStart ? _self.slotStart : slotStart // ignore: cast_nullable_to_non_nullable
as TimeOfDay,slotEnd: null == slotEnd ? _self.slotEnd : slotEnd // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

// dart format on
