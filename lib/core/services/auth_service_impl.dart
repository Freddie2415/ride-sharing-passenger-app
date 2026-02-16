import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/models/auth_result.dart';
import 'package:passenger/core/network/api_client.dart';
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

      final body = asResponseMap(response.data);
      final data = asResponseMap(body['data']);
      final meta = asResponseMap(body['meta']);

      return AuthResult.fromResponse(data, meta);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> logout({String? deviceToken}) async {
    try {
      await _dio.post<dynamic>(
        '/auth/logout',
        data: {
          if (deviceToken != null) 'device_token': deviceToken,
        },
      );
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
