import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/network/api_client.dart';
import 'package:passenger/core/network/connectivity_service.dart';

/// Registers third-party dependencies that cannot be annotated directly.
@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get storage => const FlutterSecureStorage();

  @lazySingleton
  ConnectivityService get connectivity => ConnectivityService();

  @lazySingleton
  Dio dio(FlutterSecureStorage storage) => createDioClient(storage: storage);
}
