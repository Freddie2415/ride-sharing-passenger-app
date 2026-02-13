import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/constants/error_messages.dart';
import 'package:passenger/core/theme/app_colors.dart';
import 'package:passenger/core/widgets/widgets.dart';
import 'package:passenger/features/auth/cubit/auth_cubit.dart';
import 'package:pinput/pinput.dart';

/// Typed route data for OTP screen navigation.
class OtpRouteData {
  const OtpRouteData({required this.apiPhone, required this.displayPhone});

  /// Phone number in API format: +1XXXXXXXXXX
  final String apiPhone;

  /// Phone number for display: +1 (XXX) XXX-XXXX
  final String displayPhone;
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({required this.routeData, super.key});
  final OtpRouteData routeData;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResend = false;
  bool _isOtpComplete = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _verifyOtp() {
    if (_otpController.text.length != 6) return;
    context.read<AuthCubit>().verifyOtp(
      widget.routeData.apiPhone,
      _otpController.text,
    );
  }

  void _onResendPressed() {
    if (!_canResend) return;
    _startTimer();
    context.read<AuthCubit>().sendOtp(widget.routeData.apiPhone);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outlineLight),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primary600, width: 2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.error),
      ),
    );

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          final isNewUser = state.lastAuthResult?.isNewUser ?? true;
          if (isNewUser) {
            context.go(AppRoutes.profileSetup);
          } else {
            context.go(AppRoutes.home);
          }
        } else if (state.status == AuthStatus.error) {
          _otpController.clear();
          _isOtpComplete = false;
          _focusNode.requestFocus();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? ErrorMessages.unknownError),
            ),
          );
          context.read<AuthCubit>().clearError();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                // Title
                Text(
                  'Enter Code',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Subtitle with phone number
                RichText(
                  text: TextSpan(
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
                    children: [
                      const TextSpan(text: 'We sent a code to '),
                      TextSpan(
                        text: widget.routeData.displayPhone,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                // OTP Input
                Center(
                  child: Pinput(
                    controller: _otpController,
                    focusNode: _focusNode,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    errorPinTheme: errorPinTheme,
                    onCompleted: (_) => _verifyOtp(),
                    onChanged: (value) {
                      final complete = value.length == 6;
                      if (complete != _isOtpComplete) {
                        setState(() {
                          _isOtpComplete = complete;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Timer
                Center(
                  child: Text(
                    _canResend
                        ? "Didn't receive the code?"
                        : 'Code expires in $_formattedTime',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.gray500),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Resend link
                Center(
                  child: GestureDetector(
                    onTap: _canResend ? _onResendPressed : null,
                    child: Text(
                      'Resend Code',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _canResend
                            ? AppColors.primary600
                            : AppColors.gray400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Verify button
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
                  builder: (context, state) {
                    return AppButton(
                      onPressed: _isOtpComplete && !state.isLoading
                          ? _verifyOtp
                          : null,
                      label: 'Verify',
                      isLoading: state.isLoading,
                      isDisabled: !_isOtpComplete,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
