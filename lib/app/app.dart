import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/app/di/injection.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/theme/app_theme.dart';
import 'package:passenger/features/auth/cubit/auth_cubit.dart';
import 'package:passenger/features/profile/cubit/profile_cubit.dart';

class PassengerApp extends StatelessWidget {
  const PassengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Intercity Rideshare',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
