/// Service for managing push notification device tokens on the backend.
abstract class DeviceTokenService {
  /// Register FCM token. Returns the server-assigned token ID.
  Future<int> registerToken({
    required String token,
    required String platform,
    String? deviceName,
  });

  /// Remove a device token by its server-assigned ID.
  Future<void> removeToken(int tokenId);
}
