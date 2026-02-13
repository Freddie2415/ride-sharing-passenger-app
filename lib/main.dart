import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passenger/app/app.dart';
import 'package:passenger/app/di/injection.dart';
import 'package:passenger/core/network/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await configureDependencies();
  await getIt<ConnectivityService>().initialize();

  runApp(const PassengerApp());
}
