// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get uuid; String get phone;@JsonKey(name: 'created_at') DateTime get createdAt; String? get name;@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'middle_name') String? get middleName;@JsonKey(name: 'last_name') String? get lastName; String? get email; String? get avatar; String? get locale; String? get timezone;@JsonKey(name: 'phone_verified') bool get phoneVerified;@JsonKey(name: 'email_verified') bool get emailVerified; List<String> get roles;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.middleName, middleName) || other.middleName == middleName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.phoneVerified, phoneVerified) || other.phoneVerified == phoneVerified)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&const DeepCollectionEquality().equals(other.roles, roles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,phone,createdAt,name,firstName,middleName,lastName,email,avatar,locale,timezone,phoneVerified,emailVerified,const DeepCollectionEquality().hash(roles));

@override
String toString() {
  return 'User(uuid: $uuid, phone: $phone, createdAt: $createdAt, name: $name, firstName: $firstName, middleName: $middleName, lastName: $lastName, email: $email, avatar: $avatar, locale: $locale, timezone: $timezone, phoneVerified: $phoneVerified, emailVerified: $emailVerified, roles: $roles)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String uuid, String phone,@JsonKey(name: 'created_at') DateTime createdAt, String? name,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'middle_name') String? middleName,@JsonKey(name: 'last_name') String? lastName, String? email, String? avatar, String? locale, String? timezone,@JsonKey(name: 'phone_verified') bool phoneVerified,@JsonKey(name: 'email_verified') bool emailVerified, List<String> roles
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? phone = null,Object? createdAt = null,Object? name = freezed,Object? firstName = freezed,Object? middleName = freezed,Object? lastName = freezed,Object? email = freezed,Object? avatar = freezed,Object? locale = freezed,Object? timezone = freezed,Object? phoneVerified = null,Object? emailVerified = null,Object? roles = null,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,middleName: freezed == middleName ? _self.middleName : middleName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,phoneVerified: null == phoneVerified ? _self.phoneVerified : phoneVerified // ignore: cast_nullable_to_non_nullable
as bool,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  String phone, @JsonKey(name: 'created_at')  DateTime createdAt,  String? name, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'middle_name')  String? middleName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  String? avatar,  String? locale,  String? timezone, @JsonKey(name: 'phone_verified')  bool phoneVerified, @JsonKey(name: 'email_verified')  bool emailVerified,  List<String> roles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.uuid,_that.phone,_that.createdAt,_that.name,_that.firstName,_that.middleName,_that.lastName,_that.email,_that.avatar,_that.locale,_that.timezone,_that.phoneVerified,_that.emailVerified,_that.roles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  String phone, @JsonKey(name: 'created_at')  DateTime createdAt,  String? name, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'middle_name')  String? middleName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  String? avatar,  String? locale,  String? timezone, @JsonKey(name: 'phone_verified')  bool phoneVerified, @JsonKey(name: 'email_verified')  bool emailVerified,  List<String> roles)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.uuid,_that.phone,_that.createdAt,_that.name,_that.firstName,_that.middleName,_that.lastName,_that.email,_that.avatar,_that.locale,_that.timezone,_that.phoneVerified,_that.emailVerified,_that.roles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  String phone, @JsonKey(name: 'created_at')  DateTime createdAt,  String? name, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'middle_name')  String? middleName, @JsonKey(name: 'last_name')  String? lastName,  String? email,  String? avatar,  String? locale,  String? timezone, @JsonKey(name: 'phone_verified')  bool phoneVerified, @JsonKey(name: 'email_verified')  bool emailVerified,  List<String> roles)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.uuid,_that.phone,_that.createdAt,_that.name,_that.firstName,_that.middleName,_that.lastName,_that.email,_that.avatar,_that.locale,_that.timezone,_that.phoneVerified,_that.emailVerified,_that.roles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({required this.uuid, required this.phone, @JsonKey(name: 'created_at') required this.createdAt, this.name, @JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'middle_name') this.middleName, @JsonKey(name: 'last_name') this.lastName, this.email, this.avatar, this.locale, this.timezone, @JsonKey(name: 'phone_verified') this.phoneVerified = false, @JsonKey(name: 'email_verified') this.emailVerified = false, final  List<String> roles = const []}): _roles = roles,super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String uuid;
@override final  String phone;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override final  String? name;
@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'middle_name') final  String? middleName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String? email;
@override final  String? avatar;
@override final  String? locale;
@override final  String? timezone;
@override@JsonKey(name: 'phone_verified') final  bool phoneVerified;
@override@JsonKey(name: 'email_verified') final  bool emailVerified;
 final  List<String> _roles;
@override@JsonKey() List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.middleName, middleName) || other.middleName == middleName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.phoneVerified, phoneVerified) || other.phoneVerified == phoneVerified)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&const DeepCollectionEquality().equals(other._roles, _roles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,phone,createdAt,name,firstName,middleName,lastName,email,avatar,locale,timezone,phoneVerified,emailVerified,const DeepCollectionEquality().hash(_roles));

@override
String toString() {
  return 'User(uuid: $uuid, phone: $phone, createdAt: $createdAt, name: $name, firstName: $firstName, middleName: $middleName, lastName: $lastName, email: $email, avatar: $avatar, locale: $locale, timezone: $timezone, phoneVerified: $phoneVerified, emailVerified: $emailVerified, roles: $roles)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String uuid, String phone,@JsonKey(name: 'created_at') DateTime createdAt, String? name,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'middle_name') String? middleName,@JsonKey(name: 'last_name') String? lastName, String? email, String? avatar, String? locale, String? timezone,@JsonKey(name: 'phone_verified') bool phoneVerified,@JsonKey(name: 'email_verified') bool emailVerified, List<String> roles
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? phone = null,Object? createdAt = null,Object? name = freezed,Object? firstName = freezed,Object? middleName = freezed,Object? lastName = freezed,Object? email = freezed,Object? avatar = freezed,Object? locale = freezed,Object? timezone = freezed,Object? phoneVerified = null,Object? emailVerified = null,Object? roles = null,}) {
  return _then(_User(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,middleName: freezed == middleName ? _self.middleName : middleName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,phoneVerified: null == phoneVerified ? _self.phoneVerified : phoneVerified // ignore: cast_nullable_to_non_nullable
as bool,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
