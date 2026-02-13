// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

 AuthStatus get status; User? get user; String? get errorMessage; Map<String, List<String>>? get fieldErrors; ErrorType? get errorType; AuthResult? get lastAuthResult;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.fieldErrors, fieldErrors)&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.lastAuthResult, lastAuthResult) || other.lastAuthResult == lastAuthResult));
}


@override
int get hashCode => Object.hash(runtimeType,status,user,errorMessage,const DeepCollectionEquality().hash(fieldErrors),errorType,lastAuthResult);

@override
String toString() {
  return 'AuthState(status: $status, user: $user, errorMessage: $errorMessage, fieldErrors: $fieldErrors, errorType: $errorType, lastAuthResult: $lastAuthResult)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 AuthStatus status, User? user, String? errorMessage, Map<String, List<String>>? fieldErrors, ErrorType? errorType, AuthResult? lastAuthResult
});


$UserCopyWith<$Res>? get user;$AuthResultCopyWith<$Res>? get lastAuthResult;

}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? user = freezed,Object? errorMessage = freezed,Object? fieldErrors = freezed,Object? errorType = freezed,Object? lastAuthResult = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthStatus,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,fieldErrors: freezed == fieldErrors ? _self.fieldErrors : fieldErrors // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,errorType: freezed == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as ErrorType?,lastAuthResult: freezed == lastAuthResult ? _self.lastAuthResult : lastAuthResult // ignore: cast_nullable_to_non_nullable
as AuthResult?,
  ));
}
/// Create a copy of AuthState
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
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthResultCopyWith<$Res>? get lastAuthResult {
    if (_self.lastAuthResult == null) {
    return null;
  }

  return $AuthResultCopyWith<$Res>(_self.lastAuthResult!, (value) {
    return _then(_self.copyWith(lastAuthResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthStatus status,  User? user,  String? errorMessage,  Map<String, List<String>>? fieldErrors,  ErrorType? errorType,  AuthResult? lastAuthResult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.status,_that.user,_that.errorMessage,_that.fieldErrors,_that.errorType,_that.lastAuthResult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthStatus status,  User? user,  String? errorMessage,  Map<String, List<String>>? fieldErrors,  ErrorType? errorType,  AuthResult? lastAuthResult)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.status,_that.user,_that.errorMessage,_that.fieldErrors,_that.errorType,_that.lastAuthResult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthStatus status,  User? user,  String? errorMessage,  Map<String, List<String>>? fieldErrors,  ErrorType? errorType,  AuthResult? lastAuthResult)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.status,_that.user,_that.errorMessage,_that.fieldErrors,_that.errorType,_that.lastAuthResult);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState extends AuthState {
  const _AuthState({this.status = AuthStatus.initial, this.user, this.errorMessage, final  Map<String, List<String>>? fieldErrors, this.errorType, this.lastAuthResult}): _fieldErrors = fieldErrors,super._();
  

@override@JsonKey() final  AuthStatus status;
@override final  User? user;
@override final  String? errorMessage;
 final  Map<String, List<String>>? _fieldErrors;
@override Map<String, List<String>>? get fieldErrors {
  final value = _fieldErrors;
  if (value == null) return null;
  if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  ErrorType? errorType;
@override final  AuthResult? lastAuthResult;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._fieldErrors, _fieldErrors)&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.lastAuthResult, lastAuthResult) || other.lastAuthResult == lastAuthResult));
}


@override
int get hashCode => Object.hash(runtimeType,status,user,errorMessage,const DeepCollectionEquality().hash(_fieldErrors),errorType,lastAuthResult);

@override
String toString() {
  return 'AuthState(status: $status, user: $user, errorMessage: $errorMessage, fieldErrors: $fieldErrors, errorType: $errorType, lastAuthResult: $lastAuthResult)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 AuthStatus status, User? user, String? errorMessage, Map<String, List<String>>? fieldErrors, ErrorType? errorType, AuthResult? lastAuthResult
});


@override $UserCopyWith<$Res>? get user;@override $AuthResultCopyWith<$Res>? get lastAuthResult;

}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? user = freezed,Object? errorMessage = freezed,Object? fieldErrors = freezed,Object? errorType = freezed,Object? lastAuthResult = freezed,}) {
  return _then(_AuthState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthStatus,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,fieldErrors: freezed == fieldErrors ? _self._fieldErrors : fieldErrors // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,errorType: freezed == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as ErrorType?,lastAuthResult: freezed == lastAuthResult ? _self.lastAuthResult : lastAuthResult // ignore: cast_nullable_to_non_nullable
as AuthResult?,
  ));
}

/// Create a copy of AuthState
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
}/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthResultCopyWith<$Res>? get lastAuthResult {
    if (_self.lastAuthResult == null) {
    return null;
  }

  return $AuthResultCopyWith<$Res>(_self.lastAuthResult!, (value) {
    return _then(_self.copyWith(lastAuthResult: value));
  });
}
}

// dart format on
