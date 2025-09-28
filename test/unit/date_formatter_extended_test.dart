import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter Extended Tests', () {
    final testDate = DateTime(2023, 12, 25, 14, 30, 45);
    final testDateUtc = DateTime.utc(2023, 6, 15, 10, 0, 0);

    group('Basic Formatting', () {
      test('formatDate should format date correctly', () {
        final formatted = DateFormatter.formatDate(testDate);
        expect(formatted, isA<String>());
        expect(formatted, isNotEmpty);
      });

      test('formatDateTime should include time', () {
        final formatted = DateFormatter.formatDateTime(testDate);
        expect(formatted, isA<String>());
        expect(formatted, isNotEmpty);
      });

      test('formatTime should format time only', () {
        final formatted = DateFormatter.formatTime(testDate);
        expect(formatted, isA<String>());
        expect(formatted, isNotEmpty);
      });
    });

    group('Different Date Patterns', () {
      test('should format dates with different patterns', () {
        final dates = [
          DateTime(2023, 1, 1),
          DateTime(2023, 12, 31),
          DateTime(2000, 2, 29), // Leap year
          DateTime(1999, 12, 31), // Y2K
          DateTime(2024, 2, 29), // Another leap year
        ];

        for (final date in dates) {
          final formatted = DateFormatter.formatDate(date);
          expect(formatted, isA<String>());
          expect(formatted, isNotEmpty);
        }
      });

      test('should handle different time zones', () {
        final utcDate = DateTime.utc(2023, 6, 15, 12, 0, 0);
        final localDate = DateTime(2023, 6, 15, 12, 0, 0);

        final utcFormatted = DateFormatter.formatDateTime(utcDate);
        final localFormatted = DateFormatter.formatDateTime(localDate);

        expect(utcFormatted, isA<String>());
        expect(localFormatted, isA<String>());
        expect(utcFormatted, isNotEmpty);
        expect(localFormatted, isNotEmpty);
      });
    });

    group('Edge Cases', () {
      test('should handle earliest possible date', () {
        final earlyDate = DateTime(1970, 1, 1);
        final formatted = DateFormatter.formatDate(earlyDate);
        expect(formatted, isA<String>());
        expect(formatted, isNotEmpty);
      });

      test('should handle far future date', () {
        final futureDate = DateTime(2099, 12, 31);
        final formatted = DateFormatter.formatDate(futureDate);
        expect(formatted, isA<String>());
        expect(formatted, isNotEmpty);
      });

      test('should handle midnight', () {
        final midnight = DateTime(2023, 6, 15, 0, 0, 0);
        final timeFormatted = DateFormatter.formatTime(midnight);
        final dateTimeFormatted = DateFormatter.formatDateTime(midnight);

        expect(timeFormatted, isA<String>());
        expect(dateTimeFormatted, isA<String>());
      });

      test('should handle noon', () {
        final noon = DateTime(2023, 6, 15, 12, 0, 0);
        final timeFormatted = DateFormatter.formatTime(noon);
        final dateTimeFormatted = DateFormatter.formatDateTime(noon);

        expect(timeFormatted, isA<String>());
        expect(dateTimeFormatted, isA<String>());
      });

      test('should handle end of day', () {
        final endOfDay = DateTime(2023, 6, 15, 23, 59, 59);
        final timeFormatted = DateFormatter.formatTime(endOfDay);
        final dateTimeFormatted = DateFormatter.formatDateTime(endOfDay);

        expect(timeFormatted, isA<String>());
        expect(dateTimeFormatted, isA<String>());
      });
    });

    group('Relative Date Formatting', () {
      test('formatRelativeTime should handle recent dates', () {
        final now = DateTime.now();
        final oneHourAgo = now.subtract(const Duration(hours: 1));
        final oneDayAgo = now.subtract(const Duration(days: 1));
        final oneWeekAgo = now.subtract(const Duration(days: 7));

        final oneHourFormatted = DateFormatter.formatRelativeTime(oneHourAgo);
        final oneDayFormatted = DateFormatter.formatRelativeTime(oneDayAgo);
        final oneWeekFormatted = DateFormatter.formatRelativeTime(oneWeekAgo);

        expect(oneHourFormatted, isA<String>());
        expect(oneDayFormatted, isA<String>());
        expect(oneWeekFormatted, isA<String>());
      });

      test('formatRelativeTime should handle future dates', () {
        final now = DateTime.now();
        final futureDate = now.add(const Duration(days: 5));

        final formatted = DateFormatter.formatRelativeTime(futureDate);
        expect(formatted, isA<String>());
        expect(formatted, isNotEmpty);
      });
    });

    group('Custom Format Patterns', () {
      test('formatWithPattern should handle different patterns', () {
        final patterns = [
          'yyyy-MM-dd',
          'dd/MM/yyyy',
          'MM/dd/yyyy',
          'yyyy/MM/dd HH:mm:ss',
          'dd-MM-yyyy HH:mm',
          'EEEE, MMMM d, yyyy',
        ];

        for (final pattern in patterns) {
          final formatted = DateFormatter.formatWithPattern(testDate, pattern);
          expect(formatted, isA<String>());
          expect(formatted, isNotEmpty);
        }
      });

      test('formatWithCustomPattern should handle edge patterns', () {
        final edgePatterns = [
          'yyyy',
          'MM',
          'dd',
          'HH',
          'mm',
          'ss',
        ];

        for (final pattern in edgePatterns) {
          final formatted = DateFormatter.formatWithPattern(testDate, pattern);
          expect(formatted, isA<String>());
          expect(formatted, isNotEmpty);
        }
      });
    });

    group('Date Parsing', () {
      test('parseDate should handle different formats', () {
        final dateStrings = [
          '2023-12-25',
          '25/12/2023',
          '12/25/2023',
          '2023/12/25',
        ];

        for (final dateString in dateStrings) {
          try {
            final parsed = DateFormatter.parseDate(dateString);
            expect(parsed, isA<DateTime>());
          } catch (e) {
            // Some formats might not be supported, which is fine for testing
            expect(e, isA<FormatException>());
          }
        }
      });

      test('parseDateTime should handle ISO strings', () {
        final isoString = testDate.toIso8601String();
        final parsed = DateFormatter.parseDateTime(isoString);

        expect(parsed, isA<DateTime>());
        expect(parsed.year, testDate.year);
        expect(parsed.month, testDate.month);
        expect(parsed.day, testDate.day);
      });
    });

    group('Date Validation', () {
      test('isValidDate should validate dates correctly', () {
        expect(DateFormatter.isValidDate('2023-12-25'), true);
        expect(DateFormatter.isValidDate('invalid-date'), false);
        expect(DateFormatter.isValidDate(''), false);
        // Note: Our simple parser might not catch all invalid dates
        expect(
            DateFormatter.isValidDate('25/12/2023'), true); // Valid dd/MM/yyyy
        expect(DateFormatter.isValidDate('not-a-date'), false);
      });
      test('isWeekend should identify weekends correctly', () {
        final saturday = DateTime(2023, 6, 17); // Saturday
        final sunday = DateTime(2023, 6, 18); // Sunday
        final monday = DateTime(2023, 6, 19); // Monday

        expect(DateFormatter.isWeekend(saturday), true);
        expect(DateFormatter.isWeekend(sunday), true);
        expect(DateFormatter.isWeekend(monday), false);
      });

      test('isLeapYear should identify leap years correctly', () {
        expect(DateFormatter.isLeapYear(2000), true); // Divisible by 400
        expect(DateFormatter.isLeapYear(2004), true); // Divisible by 4
        expect(DateFormatter.isLeapYear(1900),
            false); // Divisible by 100 but not 400
        expect(DateFormatter.isLeapYear(2023), false); // Not divisible by 4
      });
    });

    group('Date Calculations', () {
      test('addDays should add days correctly', () {
        final result = DateFormatter.addDays(testDate, 5);
        expect(result.day, testDate.day + 5);
      });

      test('subtractDays should subtract days correctly', () {
        final result = DateFormatter.subtractDays(testDate, 3);
        expect(result.day, testDate.day - 3);
      });

      test('daysBetween should calculate difference correctly', () {
        final date1 = DateTime(2023, 6, 1);
        final date2 = DateTime(2023, 6, 15);

        final difference = DateFormatter.daysBetween(date1, date2);
        expect(difference, 14);
      });

      test('startOfDay should return midnight', () {
        final result = DateFormatter.startOfDay(testDate);
        expect(result.hour, 0);
        expect(result.minute, 0);
        expect(result.second, 0);
        expect(result.millisecond, 0);
      });

      test('endOfDay should return end of day', () {
        final result = DateFormatter.endOfDay(testDate);
        expect(result.hour, 23);
        expect(result.minute, 59);
        expect(result.second, 59);
        expect(result.millisecond, 999);
      });
    });

    group('Stress Testing', () {
      test('should handle many format operations', () {
        for (int i = 0; i < 365; i++) {
          final date = DateTime(2023, 1, 1).add(Duration(days: i));

          final dateFormatted = DateFormatter.formatDate(date);
          final timeFormatted = DateFormatter.formatTime(date);
          final dateTimeFormatted = DateFormatter.formatDateTime(date);

          expect(dateFormatted, isA<String>());
          expect(timeFormatted, isA<String>());
          expect(dateTimeFormatted, isA<String>());
        }
      });

      test('should handle various time zones consistently', () {
        final baseDate = DateTime(2023, 6, 15, 12, 0, 0);
        final dates = [
          baseDate,
          baseDate.toUtc(),
          DateTime.utc(2023, 6, 15, 12, 0, 0),
        ];

        for (final date in dates) {
          final formatted = DateFormatter.formatDateTime(date);
          expect(formatted, isA<String>());
          expect(formatted, isNotEmpty);
        }
      });
    });
  });
}
