import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/constants/error_messages.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/core/network/connectivity_service.dart';
import 'package:passenger/core/services/passenger_service.dart';
import 'package:passenger/features/registration/cubit/registration_state.dart';

export 'package:passenger/features/registration/cubit/registration_state.dart';

@injectable
class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit({
    required PassengerService passengerService,
    required ConnectivityService connectivity,
  }) : _passengerService = passengerService,
       _connectivity = connectivity,
       super(const RegistrationState());

  final PassengerService _passengerService;
  final ConnectivityService _connectivity;

  /// Register passenger, then upload avatar if provided.
  Future<void> register({
    required String firstName,
    required String lastName,
    String? email,
    File? avatar,
  }) async {
    await _withErrorHandling(() async {
      var user = await _passengerService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );

      // Upload avatar as a separate call after registration
      if (avatar != null) {
        user = await _passengerService.updateProfile(
          ProfileUpdateRequest(avatar: avatar),
        );
      }

      if (isClosed) return;
      emit(
        state.copyWith(
          status: RegistrationStatus.success,
          user: user,
          errorMessage: null,
          fieldErrors: null,
        ),
      );
    });
  }

  void clearError() {
    emit(
      state.copyWith(
        status: RegistrationStatus.initial,
        errorMessage: null,
        fieldErrors: null,
      ),
    );
  }

  Future<void> _withErrorHandling(Future<void> Function() action) async {
    emit(
      state.copyWith(
        status: RegistrationStatus.loading,
        errorMessage: null,
        fieldErrors: null,
      ),
    );

    if (!await _connectivity.checkConnectivity()) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: RegistrationStatus.error,
          errorMessage: ErrorMessages.noConnection,
        ),
      );
      return;
    }

    try {
      await action();
    } on ValidationException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: RegistrationStatus.error,
          errorMessage: e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
    } on NetworkException {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: RegistrationStatus.error,
          errorMessage: ErrorMessages.noConnection,
        ),
      );
    } on TimeoutException {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: RegistrationStatus.error,
          errorMessage: ErrorMessages.timeout,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: RegistrationStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }
}
