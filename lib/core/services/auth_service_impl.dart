import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/models/auth_result.dart';
import 'package:passenger/core/network/api_client.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/core/network/token_storage.dart';
import 'package:passenger/core/services/auth_service.dart';

@LazySingleton(as: AuthService)
class AuthServiceImpl implements AuthService {
  AuthServiceImpl(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  @override
  Future<void> sendOtp({required String phone}) async {
    try {
      await _dio.post<dynamic>('/auth/send-otp', data: {'phone': phone});
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AuthResult> verifyOtp({
    required String phone,
    required String code,
    required String deviceName,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/verify-otp',
        data: {
          'phone': phone,
          'code': code,
          'app_type': 'passenger',
          'device_name': deviceName,
        },
      );

      final body = _asMap(response.data);
      final data = _asMap(body['data']);
      final meta = _asMap(body['meta']);

      return AuthResult.fromResponse(data, meta);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post<dynamic>('/auth/logout');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> logoutAll() async {
    try {
      await _dio.post<dynamic>('/auth/logout-all');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> saveToken(String token) => _tokenStorage.saveToken(token);

  @override
  Future<bool> hasToken() => _tokenStorage.hasToken();

  @override
  Future<void> clearToken() => _tokenStorage.clearToken();
}

/// Safely casts response data to Map, throws [ApiException] on failure.
Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  throw const ApiException(message: 'Invalid response format.');
}
