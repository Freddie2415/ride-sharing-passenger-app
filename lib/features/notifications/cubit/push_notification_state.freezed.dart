// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PushNotificationState {

 PushNotificationStatus get status; String? get fcmToken; int? get serverTokenId; String? get errorMessage;
/// Create a copy of PushNotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushNotificationStateCopyWith<PushNotificationState> get copyWith => _$PushNotificationStateCopyWithImpl<PushNotificationState>(this as PushNotificationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushNotificationState&&(identical(other.status, status) || other.status == status)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.serverTokenId, serverTokenId) || other.serverTokenId == serverTokenId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,fcmToken,serverTokenId,errorMessage);

@override
String toString() {
  return 'PushNotificationState(status: $status, fcmToken: $fcmToken, serverTokenId: $serverTokenId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PushNotificationStateCopyWith<$Res>  {
  factory $PushNotificationStateCopyWith(PushNotificationState value, $Res Function(PushNotificationState) _then) = _$PushNotificationStateCopyWithImpl;
@useResult
$Res call({
 PushNotificationStatus status, String? fcmToken, int? serverTokenId, String? errorMessage
});




}
/// @nodoc
class _$PushNotificationStateCopyWithImpl<$Res>
    implements $PushNotificationStateCopyWith<$Res> {
  _$PushNotificationStateCopyWithImpl(this._self, this._then);

  final PushNotificationState _self;
  final $Res Function(PushNotificationState) _then;

/// Create a copy of PushNotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? fcmToken = freezed,Object? serverTokenId = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PushNotificationStatus,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,serverTokenId: freezed == serverTokenId ? _self.serverTokenId : serverTokenId // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PushNotificationState].
extension PushNotificationStatePatterns on PushNotificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushNotificationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushNotificationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushNotificationState value)  $default,){
final _that = this;
switch (_that) {
case _PushNotificationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushNotificationState value)?  $default,){
final _that = this;
switch (_that) {
case _PushNotificationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PushNotificationStatus status,  String? fcmToken,  int? serverTokenId,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushNotificationState() when $default != null:
return $default(_that.status,_that.fcmToken,_that.serverTokenId,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PushNotificationStatus status,  String? fcmToken,  int? serverTokenId,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PushNotificationState():
return $default(_that.status,_that.fcmToken,_that.serverTokenId,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PushNotificationStatus status,  String? fcmToken,  int? serverTokenId,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PushNotificationState() when $default != null:
return $default(_that.status,_that.fcmToken,_that.serverTokenId,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PushNotificationState implements PushNotificationState {
  const _PushNotificationState({this.status = PushNotificationStatus.initial, this.fcmToken, this.serverTokenId, this.errorMessage});
  

@override@JsonKey() final  PushNotificationStatus status;
@override final  String? fcmToken;
@override final  int? serverTokenId;
@override final  String? errorMessage;

/// Create a copy of PushNotificationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushNotificationStateCopyWith<_PushNotificationState> get copyWith => __$PushNotificationStateCopyWithImpl<_PushNotificationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushNotificationState&&(identical(other.status, status) || other.status == status)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.serverTokenId, serverTokenId) || other.serverTokenId == serverTokenId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,fcmToken,serverTokenId,errorMessage);

@override
String toString() {
  return 'PushNotificationState(status: $status, fcmToken: $fcmToken, serverTokenId: $serverTokenId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PushNotificationStateCopyWith<$Res> implements $PushNotificationStateCopyWith<$Res> {
  factory _$PushNotificationStateCopyWith(_PushNotificationState value, $Res Function(_PushNotificationState) _then) = __$PushNotificationStateCopyWithImpl;
@override @useResult
$Res call({
 PushNotificationStatus status, String? fcmToken, int? serverTokenId, String? errorMessage
});




}
/// @nodoc
class __$PushNotificationStateCopyWithImpl<$Res>
    implements _$PushNotificationStateCopyWith<$Res> {
  __$PushNotificationStateCopyWithImpl(this._self, this._then);

  final _PushNotificationState _self;
  final $Res Function(_PushNotificationState) _then;

/// Create a copy of PushNotificationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? fcmToken = freezed,Object? serverTokenId = freezed,Object? errorMessage = freezed,}) {
  return _then(_PushNotificationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PushNotificationStatus,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,serverTokenId: freezed == serverTokenId ? _self.serverTokenId : serverTokenId // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
