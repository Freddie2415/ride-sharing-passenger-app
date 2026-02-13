// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 ProfileStatus get status; User? get user; String? get errorMessage; bool get isRefreshing; bool get isSaving; String? get saveError;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode => Object.hash(runtimeType,status,user,errorMessage,isRefreshing,isSaving,saveError);

@override
String toString() {
  return 'ProfileState(status: $status, user: $user, errorMessage: $errorMessage, isRefreshing: $isRefreshing, isSaving: $isSaving, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 ProfileStatus status, User? user, String? errorMessage, bool isRefreshing, bool isSaving, String? saveError
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? user = freezed,Object? errorMessage = freezed,Object? isRefreshing = null,Object? isSaving = null,Object? saveError = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileStatus,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileStatus status,  User? user,  String? errorMessage,  bool isRefreshing,  bool isSaving,  String? saveError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.status,_that.user,_that.errorMessage,_that.isRefreshing,_that.isSaving,_that.saveError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileStatus status,  User? user,  String? errorMessage,  bool isRefreshing,  bool isSaving,  String? saveError)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.status,_that.user,_that.errorMessage,_that.isRefreshing,_that.isSaving,_that.saveError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileStatus status,  User? user,  String? errorMessage,  bool isRefreshing,  bool isSaving,  String? saveError)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.status,_that.user,_that.errorMessage,_that.isRefreshing,_that.isSaving,_that.saveError);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState extends ProfileState {
  const _ProfileState({this.status = ProfileStatus.initial, this.user, this.errorMessage, this.isRefreshing = false, this.isSaving = false, this.saveError}): super._();
  

@override@JsonKey() final  ProfileStatus status;
@override final  User? user;
@override final  String? errorMessage;
@override@JsonKey() final  bool isRefreshing;
@override@JsonKey() final  bool isSaving;
@override final  String? saveError;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveError, saveError) || other.saveError == saveError));
}


@override
int get hashCode => Object.hash(runtimeType,status,user,errorMessage,isRefreshing,isSaving,saveError);

@override
String toString() {
  return 'ProfileState(status: $status, user: $user, errorMessage: $errorMessage, isRefreshing: $isRefreshing, isSaving: $isSaving, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 ProfileStatus status, User? user, String? errorMessage, bool isRefreshing, bool isSaving, String? saveError
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? user = freezed,Object? errorMessage = freezed,Object? isRefreshing = null,Object? isSaving = null,Object? saveError = freezed,}) {
  return _then(_ProfileState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileStatus,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
