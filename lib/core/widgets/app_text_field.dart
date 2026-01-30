import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool autocorrect;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          autofocus: autofocus,
          autocorrect: autocorrect,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : prefix,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon) : suffix,
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.textInputAction,
    this.enabled = true,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool autofocus;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      obscureText: _obscureText,
      prefixIcon: Icons.lock_outline,
      suffix: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.gray500,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}

class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint = '(555) 123-4567',
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.textInputAction,
    this.enabled = true,
    this.autofocus = false,
    this.countryCode = '+1',
    this.countryFlag = '🇺🇸',
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool autofocus;
  final String countryCode;
  final String countryFlag;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hint: hint,
      errorText: errorText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      textInputAction: textInputAction,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.phone,
      prefix: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              countryFlag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              countryCode,
              style: Theme.of(context).textTheme.bodyLarge,
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
    );
  }
}
