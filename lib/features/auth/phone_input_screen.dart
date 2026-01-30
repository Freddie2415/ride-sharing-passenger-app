import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/widgets.dart';

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
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final phone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    setState(() {
      _isButtonEnabled = phone.length >= 10;
    });
  }

  void _onGetCodePressed() {
    if (_isButtonEnabled) {
      // API format: +1XXXXXXXXXX (no spaces, brackets, dashes)
      final digitsOnly = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
      final apiPhone = '+1$digitsOnly';
      // Display format for UI: +1 (XXX) XXX-XXXX
      final displayPhone = '+1 ${_phoneController.text}';
      context.push('/otp', extra: {
        'apiPhone': apiPhone,
        'displayPhone': displayPhone,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Welcome',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Subtitle
              Text(
                'Enter your phone number to sign in or create an account',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.gray600,
                    ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Phone input
              _PhoneInputField(
                controller: _phoneController,
              ),
              const SizedBox(height: AppSpacing.md),
              // Helper text
              Text(
                "We'll send you a verification code via SMS",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray500,
                    ),
              ),
              const Spacer(),
              // Get Code button
              AppButton(
                onPressed: _isButtonEnabled ? _onGetCodePressed : null,
                label: 'Get Code',
                isDisabled: !_isButtonEnabled,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Terms and Privacy
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
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
                          style: TextStyle(
                            color: AppColors.primary600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppColors.primary600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneInputField extends StatelessWidget {
  final TextEditingController controller;

  const _PhoneInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  '🇺🇸',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '+1',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.gray300,
                ),
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
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.gray400,
                    ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _PhoneNumberFormatter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted = '';

    if (digits.length <= 3) {
      formatted = '($digits';
    } else if (digits.length <= 6) {
      formatted = '(${digits.substring(0, 3)}) ${digits.substring(3)}';
    } else {
      final part1 = digits.substring(0, 3);
      final part2 = digits.substring(3, 6);
      final part3 = digits.substring(6, digits.length > 10 ? 10 : digits.length);
      formatted = '($part1) $part2-$part3';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
