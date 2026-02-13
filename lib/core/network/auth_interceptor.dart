import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:passenger/core/network/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required FlutterSecureStorage storage})
    : _tokenStorage = TokenStorage(storage);

  final TokenStorage _tokenStorage;

  bool _isHandling401 = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _handle401();
    }
    handler.next(err);
  }

  Future<void> _handle401() async {
    if (_isHandling401) return;
    _isHandling401 = true;

    try {
      await _tokenStorage.clearToken();
    } finally {
      _isHandling401 = false;
    }
  }
}
