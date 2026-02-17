import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in an external browser.
Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    debugPrint('Could not launch $url');
  }
}
