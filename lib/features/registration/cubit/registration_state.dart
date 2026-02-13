import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:passenger/core/models/user.dart';

part 'registration_state.freezed.dart';

enum RegistrationStatus { initial, loading, success, error }

@Freezed(fromJson: false, toJson: false)
abstract class RegistrationState with _$RegistrationState {
  const factory RegistrationState({
    @Default(RegistrationStatus.initial) RegistrationStatus status,
    User? user,
    String? errorMessage,
    Map<String, List<String>>? fieldErrors,
  }) = _RegistrationState;

  const RegistrationState._();

  bool get isLoading => status == RegistrationStatus.loading;
}
