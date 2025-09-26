class DateFormatter {
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  static String formatDateTime(DateTime date) {
    final formattedDate = formatDate(date);
    final formattedTime = '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
    return '$formattedDate à $formattedTime';
  }

  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}:'
        '${date.second.toString().padLeft(2, '0')}';
  }

  static String formatRelativeTime(DateTime date) {
    return formatTimeAgo(date);
  }

  static String formatWithPattern(DateTime date, String pattern) {
    // Simple pattern matching for common cases
    switch (pattern) {
      case 'yyyy-MM-dd':
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      case 'dd/MM/yyyy':
        return formatDate(date);
      case 'MM/dd/yyyy':
        return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
      case 'yyyy':
        return date.year.toString();
      case 'MM':
        return date.month.toString().padLeft(2, '0');
      case 'dd':
        return date.day.toString().padLeft(2, '0');
      case 'HH':
        return date.hour.toString().padLeft(2, '0');
      case 'mm':
        return date.minute.toString().padLeft(2, '0');
      case 'ss':
        return date.second.toString().padLeft(2, '0');
      default:
        return formatDateTime(date);
    }
  }

  static DateTime parseDate(String dateString) {
    try {
      // Try different formats
      if (dateString.contains('-')) {
        return DateTime.parse(dateString);
      } else if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          // Try dd/MM/yyyy format
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }
      throw const FormatException('Unknown date format');
    } catch (e) {
      throw FormatException('Invalid date: $dateString');
    }
  }

  static DateTime parseDateTime(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }

  static bool isValidDate(String dateString) {
    try {
      parseDate(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  static DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }

  static int daysBetween(DateTime date1, DateTime date2) {
    return date2.difference(date1).inDays;
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}
