import 'package:intl/intl.dart';

class DateFormatter {

  static String formatPassExpiry(DateTime date) => DateFormat('d / MMMM / y').format(date);

  static DateTime? parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  static bool isFutureDate(String? value) {
    final date = parseDate(value);
    if (date == null) {
      return false;
    }

    return date.isAfter(DateTime.now());
  }
}