import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:passenger/core/constants/app_spacing.dart';

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
        if (label case final labelText?) ...[
          Text(
            labelText,
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
