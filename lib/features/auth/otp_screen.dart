import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/widgets.dart';

class OtpScreen extends StatefulWidget {
  /// Phone number in API format: +1XXXXXXXXXX
  final String apiPhone;
  /// Phone number for display: +1 (XXX) XXX-XXXX
  final String displayPhone;

  const OtpScreen({
    super.key,
    required this.apiPhone,
    required this.displayPhone,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResend = false;
  bool _isVerifying = false;
  String? _errorText;

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

  void _onOtpCompleted(String otp) {
    _verifyOtp();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) return;

    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    // Mock verification - always succeeds for UI demo
    // Real API call: POST /api/v1/auth/verify-otp
    // Body: { phone: widget.apiPhone, code: _otpController.text, app_type: "passenger" }
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isVerifying = false;
      });

      // Mock: is_new_user = true, navigate to profile setup
      // In real app: check is_new_user from API response
      // if is_new_user -> /profile-setup
      // else -> /home
      context.go('/profile-setup');
    }
  }

  void _onResendPressed() {
    if (_canResend) {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New code sent!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
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

    return Scaffold(
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.gray600,
                      ),
                  children: [
                    const TextSpan(text: 'We sent a code to '),
                    TextSpan(
                      text: widget.displayPhone,
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
                  onCompleted: _onOtpCompleted,
                  errorText: _errorText,
                  errorTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Timer
              Center(
                child: Text(
                  _canResend
                      ? "Didn't receive the code?"
                      : 'Code expires in $_formattedTime',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.gray500,
                      ),
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
              AppButton(
                onPressed:
                    _otpController.text.length == 6 && !_isVerifying
                        ? _verifyOtp
                        : null,
                label: 'Verify',
                isLoading: _isVerifying,
                isDisabled: _otpController.text.length != 6,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
