import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/models/user.dart';
import 'package:passenger/core/network/api_client.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/core/services/passenger_service.dart';

@LazySingleton(as: PassengerService)
class PassengerServiceImpl implements PassengerService {
  PassengerServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<User> register({
    required String firstName,
    required String lastName,
    String? middleName,
    String? email,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/passenger/register',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          if (middleName != null) 'middle_name': middleName,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );

      return _parseUserResponse(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      final response = await _dio.get<dynamic>('/passenger/profile');

      return _parseUserResponse(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<User> updateProfile(ProfileUpdateRequest request) async {
    try {
      final formData = FormData();

      _addFieldIfNotNull(formData, 'first_name', request.firstName);
      _addFieldIfNotNull(formData, 'last_name', request.lastName);
      _addFieldIfNotNull(formData, 'middle_name', request.middleName);
      _addFieldIfNotNull(formData, 'email', request.email);
      _addFieldIfNotNull(formData, 'locale', request.locale);
      _addFieldIfNotNull(formData, 'timezone', request.timezone);

      final avatar = request.avatar;
      if (avatar != null) {
        formData.files.add(
          MapEntry(
            'avatar',
            await MultipartFile.fromFile(avatar.path),
          ),
        );
      }

      final response = await _dio.put<dynamic>(
        '/passenger/profile',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return _parseUserResponse(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}

User _parseUserResponse(dynamic responseData) {
  final body = _asMap(responseData);
  final data = _asMap(body['data']);
  return User.fromJson(_asMap(data['user']));
}

void _addFieldIfNotNull(FormData formData, String key, String? value) {
  if (value != null) {
    formData.fields.add(MapEntry(key, value));
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  throw const ApiException(message: 'Invalid response format.');
}
