import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// Returns a human-readable device name (e.g. "Samsung Galaxy S21").
/// Falls back to 'Unknown Device' on error.
Future<String> getDeviceName() async {
  try {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return ios.utsname.machine;
    } else if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return '${android.brand} ${android.model}';
    }
  } on Object catch (_) {
    // Fallback
  }
  return 'Unknown Device';
}
