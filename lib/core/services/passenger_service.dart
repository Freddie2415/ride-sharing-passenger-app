import 'dart:io';

import 'package:passenger/core/models/user.dart';

/// Request object for updating passenger profile.
class ProfileUpdateRequest {
  const ProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.middleName,
    this.email,
    this.avatar,
    this.locale,
    this.timezone,
  });

  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? email;
  final File? avatar;
  final String? locale;
  final String? timezone;
}

/// Passenger profile management service.
abstract class PassengerService {
  /// Register a new passenger (first-time setup).
  Future<User> register({
    required String firstName,
    required String lastName,
    String? middleName,
    String? email,
  });

  /// Get current passenger profile.
  Future<User> getProfile();

  /// Update passenger profile (supports multipart avatar upload).
  Future<User> updateProfile(ProfileUpdateRequest request);
}
