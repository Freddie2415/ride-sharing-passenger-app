import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passenger/core/constants/error_messages.dart';
import 'package:passenger/core/network/api_exceptions.dart';
import 'package:passenger/core/network/connectivity_service.dart';
import 'package:passenger/core/services/passenger_service.dart';
import 'package:passenger/features/profile/cubit/profile_state.dart';

export 'package:passenger/features/profile/cubit/profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required PassengerService passengerService,
    required ConnectivityService connectivity,
  }) : _passengerService = passengerService,
       _connectivity = connectivity,
       super(const ProfileState());

  final PassengerService _passengerService;
  final ConnectivityService _connectivity;

  /// Load profile with loading indicator.
  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));

    if (!await _connectivity.checkConnectivity()) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: ErrorMessages.noConnection,
        ),
      );
      return;
    }

    try {
      final user = await _passengerService.getProfile();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          errorMessage: null,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.message),
      );
    }
  }

  /// Silent refresh without loading indicator.
  Future<void> refreshProfile() async {
    if (!await _connectivity.checkConnectivity()) return;

    emit(state.copyWith(isRefreshing: true));

    try {
      final user = await _passengerService.getProfile();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          isRefreshing: false,
        ),
      );
    } on ApiException {
      if (isClosed) return;
      emit(state.copyWith(isRefreshing: false));
    }
  }

  /// Update profile with save indicator.
  Future<void> updateProfile(ProfileUpdateRequest request) async {
    emit(state.copyWith(isSaving: true, saveError: null));

    if (!await _connectivity.checkConnectivity()) {
      if (isClosed) return;
      emit(
        state.copyWith(isSaving: false, saveError: ErrorMessages.noConnection),
      );
      return;
    }

    try {
      final user = await _passengerService.updateProfile(request);
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          isSaving: false,
          saveError: null,
        ),
      );
    } on ValidationException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isSaving: false, saveError: e.firstError));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isSaving: false, saveError: e.message));
    }
  }

  void clearError() {
    emit(
      state.copyWith(
        status: state.user != null
            ? ProfileStatus.loaded
            : ProfileStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void clearSaveError() {
    emit(state.copyWith(saveError: null));
  }
}
