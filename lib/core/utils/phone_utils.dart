import 'package:flutter/services.dart';

/// Number of digits in a US phone number (without country code).
const int usPhoneDigitCount = 10;

/// Strips phone formatting and returns E.164 format.
///
/// Examples:
/// - "(555) 123-4567" → "+15551234567"
/// - "15551234567"    → "+15551234567"
String cleanPhoneNumber(String phone) {
  final digits = phone.replaceAll(RegExp('[^0-9]'), '');
  if (digits.length == usPhoneDigitCount) return '+1$digits';
  if (digits.startsWith('1') && digits.length == 11) return '+$digits';
  return '+$digits';
}

/// Formats US phone number input as (XXX) XXX-XXXX.
class USPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 3) buffer.write(') ');
      if (i == 6) buffer.write('-');
      buffer.write(text[i]);
    }

    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
