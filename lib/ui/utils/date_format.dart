import 'package:intl/intl.dart';

class DateFormatter {
  static String formatRideDate(DateTime date) => DateFormat('dd/MM/yyyy HH:mm').format(date);

  static String formatPassExpiry(DateTime date) => DateFormat('d / MMMM / y').format(date);
}