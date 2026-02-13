import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:passenger/core/models/user.dart';

part 'profile_state.freezed.dart';

enum ProfileStatus { initial, loading, loaded, error }

@Freezed(fromJson: false, toJson: false)
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ProfileStatus.initial) ProfileStatus status,
    User? user,
    String? errorMessage,
    @Default(false) bool isRefreshing,
    @Default(false) bool isSaving,
    String? saveError,
  }) = _ProfileState;

  const ProfileState._();

  bool get isLoaded => status == ProfileStatus.loaded && user != null;
  bool get isLoading => status == ProfileStatus.loading;
  bool get hasError => status == ProfileStatus.error;
}
