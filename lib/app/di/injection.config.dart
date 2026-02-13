// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:passenger/app/di/register_module.dart' as _i832;
import 'package:passenger/core/network/connectivity_service.dart' as _i165;
import 'package:passenger/core/network/token_storage.dart' as _i297;
import 'package:passenger/core/services/auth_service.dart' as _i272;
import 'package:passenger/core/services/auth_service_impl.dart' as _i931;
import 'package:passenger/core/services/passenger_service.dart' as _i197;
import 'package:passenger/core/services/passenger_service_impl.dart' as _i903;
import 'package:passenger/features/auth/cubit/auth_cubit.dart' as _i318;
import 'package:passenger/features/profile/cubit/profile_cubit.dart' as _i33;
import 'package:passenger/features/registration/cubit/registration_cubit.dart'
    as _i484;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => registerModule.storage);
    gh.lazySingleton<_i165.ConnectivityService>(
      () => registerModule.connectivity,
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i197.PassengerService>(
      () => _i903.PassengerServiceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i297.TokenStorage>(
      () => _i297.TokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i33.ProfileCubit>(
      () => _i33.ProfileCubit(
        passengerService: gh<_i197.PassengerService>(),
        connectivity: gh<_i165.ConnectivityService>(),
      ),
    );
    gh.factory<_i484.RegistrationCubit>(
      () => _i484.RegistrationCubit(
        passengerService: gh<_i197.PassengerService>(),
        connectivity: gh<_i165.ConnectivityService>(),
      ),
    );
    gh.lazySingleton<_i272.AuthService>(
      () => _i931.AuthServiceImpl(gh<_i361.Dio>(), gh<_i297.TokenStorage>()),
    );
    gh.factory<_i318.AuthCubit>(
      () => _i318.AuthCubit(
        authService: gh<_i272.AuthService>(),
        connectivity: gh<_i165.ConnectivityService>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i832.RegisterModule {}
