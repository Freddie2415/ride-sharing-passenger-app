import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/network/api_client.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/core/services/device_token_service.dart';

@LazySingleton(as: DeviceTokenService)
class DeviceTokenServiceImpl implements DeviceTokenService {
  DeviceTokenServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<int> registerToken({
    required String token,
    required String platform,
    String? deviceName,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/device/token',
        data: {
          'token': token,
          'platform': platform,
          if (deviceName != null) 'device_name': deviceName,
        },
      );

      final body = _asMap(response.data);
      final data = _asMap(body['data']);
      final deviceToken = _asMap(data['device_token']);
      final id = deviceToken['id'];
      if (id is! int) {
        throw const ApiException(message: 'Invalid token ID in response.');
      }
      return id;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> removeToken(int tokenId) async {
    try {
      await _dio.delete<dynamic>('/device/token/$tokenId');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  throw const ApiException(message: 'Invalid response format.');
}
