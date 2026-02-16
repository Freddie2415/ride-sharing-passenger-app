import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/core/network/auth_interceptor.dart';

/// API base URL configured via `--dart-define=API_BASE_URL=...`.
/// Falls back to localhost for development.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://mydemoapp.cc/api/v1',
);

Dio createDioClient({required FlutterSecureStorage storage}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(storage: storage));

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
  }

  return dio;
}

ApiException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutException();

    case DioExceptionType.connectionError:
      return const NetworkException();

    case DioExceptionType.badResponse:
      return _mapStatusCode(e);

    case DioExceptionType.cancel:
      return const ApiException(message: 'Request was cancelled.');

    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      if (e.error is SocketException) {
        return const NetworkException();
      }
      return ApiException(
        message: e.message ?? 'An unexpected error occurred.',
        statusCode: e.response?.statusCode,
      );
  }
}

ApiException _mapStatusCode(DioException e) {
  final statusCode = e.response?.statusCode;
  final data = e.response?.data;

  final message = data is Map<String, dynamic>
      ? (data['message'] as String? ?? 'An error occurred.')
      : 'An error occurred.';

  final errors = data is Map<String, dynamic> && data['errors'] != null
      ? parseApiErrors(data['errors'])
      : <String, List<String>>{};

  switch (statusCode) {
    case 401:
      return UnauthorizedException(message: message);

    case 409:
      return ConflictException(message: message);

    case 422:
      return ValidationException(message: message, fieldErrors: errors);

    case 429:
      return RateLimitException(message: message);

    case 500:
    case 502:
    case 503:
      return ServerException(message: message);

    default:
      return ApiException(message: message, statusCode: statusCode);
  }
}

/// Safely casts response data to [Map<String, dynamic>].
/// Throws [ApiException] if the value is not a valid JSON map.
Map<String, dynamic> asResponseMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  throw const ApiException(message: 'Invalid response format.');
}

/// Parse API error response `errors` field into a typed map.
Map<String, List<String>> parseApiErrors(dynamic errors) {
  if (errors == null || errors is! Map) return {};
  final result = <String, List<String>>{};
  for (final entry in errors.entries) {
    final key = entry.key.toString();
    final value = entry.value;
    if (value is List) {
      result[key] = value.map((e) => e.toString()).toList();
    }
  }
  return result;
}
