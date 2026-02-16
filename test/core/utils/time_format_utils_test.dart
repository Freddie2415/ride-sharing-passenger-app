import 'package:flutter_test/flutter_test.dart';
import 'package:passenger/core/utils/time_format_utils.dart';

void main() {
  group('formatTimeAgo', () {
    test('returns "Just now" for less than 1 minute ago', () {
      final now = DateTime.now();

      expect(formatTimeAgo(now), 'Just now');
      expect(
        formatTimeAgo(now.subtract(const Duration(seconds: 30))),
        'Just now',
      );
      expect(
        formatTimeAgo(now.subtract(const Duration(seconds: 59))),
        'Just now',
      );
    });

    test('returns minutes ago for less than 1 hour', () {
      final now = DateTime.now();

      expect(
        formatTimeAgo(now.subtract(const Duration(minutes: 1))),
        '1m ago',
      );
      expect(
        formatTimeAgo(now.subtract(const Duration(minutes: 30))),
        '30m ago',
      );
      expect(
        formatTimeAgo(now.subtract(const Duration(minutes: 59))),
        '59m ago',
      );
    });

    test('returns hours ago for less than 24 hours', () {
      final now = DateTime.now();

      expect(
        formatTimeAgo(now.subtract(const Duration(hours: 1))),
        '1h ago',
      );
      expect(
        formatTimeAgo(now.subtract(const Duration(hours: 12))),
        '12h ago',
      );
      expect(
        formatTimeAgo(now.subtract(const Duration(hours: 23))),
        '23h ago',
      );
    });

    test('returns days ago for less than 7 days', () {
      final now = DateTime.now();

      expect(
        formatTimeAgo(now.subtract(const Duration(days: 1))),
        '1d ago',
      );
      expect(
        formatTimeAgo(now.subtract(const Duration(days: 3))),
        '3d ago',
      );
      expect(
        formatTimeAgo(now.subtract(const Duration(days: 6))),
        '6d ago',
      );
    });

    test('returns formatted date for 7+ days ago', () {
      // Use a fixed date to avoid flakiness
      final date = DateTime(2026, 1, 5, 12, 0);
      final result = formatTimeAgo(date);

      expect(result, '05.01.2026');
    });

    test('pads single-digit day and month with zero', () {
      final date = DateTime(2025, 3, 7);
      final result = formatTimeAgo(date);

      expect(result, '07.03.2025');
    });

    test('does not pad double-digit day and month', () {
      final date = DateTime(2025, 12, 25);
      final result = formatTimeAgo(date);

      expect(result, '25.12.2025');
    });
  });
}
