import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    group('formatDate', () {
      test('should format date correctly', () {
        final date = DateTime(2024, 1, 15);
        expect(DateFormatter.formatDate(date), '15/01/2024');
      });

      test('should pad single digit day and month', () {
        final date = DateTime(2024, 3, 5);
        expect(DateFormatter.formatDate(date), '05/03/2024');
      });
    });

    group('formatDateTime', () {
      test('should format date and time correctly', () {
        final date = DateTime(2024, 1, 15, 14, 30);
        expect(DateFormatter.formatDateTime(date), '15/01/2024 à 14:30');
      });

      test('should pad single digit time components', () {
        final date = DateTime(2024, 3, 5, 9, 5);
        expect(DateFormatter.formatDateTime(date), '05/03/2024 à 09:05');
      });
    });

    group('formatTimeAgo', () {
      test('should return "À l\'instant" for very recent dates', () {
        final now = DateTime.now();
        final recent = now.subtract(const Duration(seconds: 30));

        expect(DateFormatter.formatTimeAgo(recent), 'À l\'instant');
      });

      test('should format minutes ago correctly', () {
        final now = DateTime.now();
        final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));

        expect(DateFormatter.formatTimeAgo(fiveMinutesAgo), 'Il y a 5 minutes');
      });

      test('should format one minute ago correctly', () {
        final now = DateTime.now();
        final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

        expect(DateFormatter.formatTimeAgo(oneMinuteAgo), 'Il y a 1 minute');
      });

      test('should format hours ago correctly', () {
        final now = DateTime.now();
        final twoHoursAgo = now.subtract(const Duration(hours: 2));

        expect(DateFormatter.formatTimeAgo(twoHoursAgo), 'Il y a 2 heures');
      });

      test('should format one hour ago correctly', () {
        final now = DateTime.now();
        final oneHourAgo = now.subtract(const Duration(hours: 1));

        expect(DateFormatter.formatTimeAgo(oneHourAgo), 'Il y a 1 heure');
      });

      test('should format days ago correctly', () {
        final now = DateTime.now();
        final threeDaysAgo = now.subtract(const Duration(days: 3));

        expect(DateFormatter.formatTimeAgo(threeDaysAgo), 'Il y a 3 jours');
      });

      test('should format one day ago correctly', () {
        final now = DateTime.now();
        final oneDayAgo = now.subtract(const Duration(days: 1));

        expect(DateFormatter.formatTimeAgo(oneDayAgo), 'Il y a 1 jour');
      });

      test('should return formatted date for dates over a week old', () {
        final now = DateTime.now();
        final oldDate = now.subtract(const Duration(days: 10));

        expect(DateFormatter.formatTimeAgo(oldDate),
            DateFormatter.formatDate(oldDate));
      });
    });

    group('isSameDay', () {
      test('should return true for same day', () {
        final date1 = DateTime(2024, 1, 15, 10, 30);
        final date2 = DateTime(2024, 1, 15, 18, 45);

        expect(DateFormatter.isSameDay(date1, date2), true);
      });

      test('should return false for different days', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2024, 1, 16);

        expect(DateFormatter.isSameDay(date1, date2), false);
      });

      test('should return false for different months', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2024, 2, 15);

        expect(DateFormatter.isSameDay(date1, date2), false);
      });

      test('should return false for different years', () {
        final date1 = DateTime(2024, 1, 15);
        final date2 = DateTime(2023, 1, 15);

        expect(DateFormatter.isSameDay(date1, date2), false);
      });
    });
  });
}
