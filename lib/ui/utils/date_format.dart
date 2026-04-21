import 'package:intl/intl.dart';

class DateFormatter {
  static String formatRideDate(DateTime date) => DateFormat('dd/MM/yyyy HH:mm').format(date);

  static String formatPassExpiry(DateTime date) => DateFormat('d / MMMM / y').format(date);

  static DateTime? tryParseIsoDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  static bool isFutureDate(String? value) {
    final date = tryParseIsoDate(value);
    if (date == null) {
      return false;
    }

    return date.isAfter(DateTime.now());
  }
}