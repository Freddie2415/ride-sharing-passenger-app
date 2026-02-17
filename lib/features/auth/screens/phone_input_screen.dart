import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/constants/app_urls.dart';
import 'package:passenger/core/constants/error_messages.dart';
import 'package:passenger/core/theme/app_colors.dart';
import 'package:passenger/core/utils/phone_utils.dart';
import 'package:passenger/core/utils/url_utils.dart';
import 'package:passenger/core/widgets/widgets.dart';
import 'package:passenger/features/auth/cubit/auth_cubit.dart';
import 'package:passenger/features/auth/screens/otp_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController
      ..removeListener(_onPhoneChanged)
      ..dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final phone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    setState(() {
      _isButtonEnabled = phone.length >= 10;
    });
  }

  void _onGetCodePressed() {
    if (!_isButtonEnabled) return;
    final apiPhone = cleanPhoneNumber(_phoneController.text);
    context.read<AuthCubit>().sendOtp(apiPhone);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.otpSent) {
          final apiPhone = cleanPhoneNumber(_phoneController.text);
          final displayPhone = '+1 ${_phoneController.text}';
          context.push(
            AppRoutes.otp,
            extra: OtpRouteData(apiPhone: apiPhone, displayPhone: displayPhone),
          );
        } else if (state.status == AuthStatus.error) {
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
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.onboarding);
              }
            },
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
                  'Welcome',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Subtitle
                Text(
                  'Enter your phone number to sign in or create an account',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
                ),
                const SizedBox(height: AppSpacing.xxl),
                // Phone input
                _PhoneInputField(controller: _phoneController),
                const SizedBox(height: AppSpacing.md),
                // Helper text
                Text(
                  "We'll send you a verification code via SMS",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.gray500),
                ),
                const Spacer(),
                // Get Code button
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
                  builder: (context, state) {
                    return AppButton(
                      onPressed: _isButtonEnabled && !state.isLoading
                          ? _onGetCodePressed
                          : null,
                      label: 'Get Code',
                      isLoading: state.isLoading,
                      isDisabled: !_isButtonEnabled,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                // Terms and Privacy
                const _LegalDisclaimer(),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalDisclaimer extends StatefulWidget {
  const _LegalDisclaimer();

  @override
  State<_LegalDisclaimer> createState() => _LegalDisclaimerState();
}

class _LegalDisclaimerState extends State<_LegalDisclaimer> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => openUrl(AppUrls.termsOfService);
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => openUrl(AppUrls.privacyPolicy);
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.gray500,
            ),
            children: [
              const TextSpan(text: 'By continuing, you agree to our '),
              TextSpan(
                text: 'Terms of Service',
                style: const TextStyle(
                  color: AppColors.primary600,
                  fontWeight: FontWeight.w500,
                ),
                recognizer: _termsRecognizer,
              ),
              const TextSpan(text: ' & '),
              TextSpan(
                text: 'Privacy Policy',
                style: const TextStyle(
                  color: AppColors.primary600,
                  fontWeight: FontWeight.w500,
                ),
                recognizer: _privacyRecognizer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneInputField extends StatelessWidget {
  const _PhoneInputField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Row(
        children: [
          // Country code prefix
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '\u{1F1FA}\u{1F1F8}',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '+1',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(width: 1, height: 24, color: AppColors.gray300),
              ],
            ),
          ),
          // Phone input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: '(555) 123-4567',
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.gray400),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(usPhoneDigitCount),
                USPhoneNumberFormatter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
