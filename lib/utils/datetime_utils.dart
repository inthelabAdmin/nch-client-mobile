import 'dart:ffi';

import 'package:intl/intl.dart';

class DateTimeUtil {
  const DateTimeUtil();

  String getDateToday() {
    var dt = DateTime.now();
    return formatEndpointDate(dt);
  }

  String formatEndpointDate(DateTime dateTime) {
    var newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(dateTime);
  }

  String formatDisplayDate(String date, bool isMonth) {
    final parsedDate = DateTime.parse(date);
    final newFormat = isMonth? DateFormat("MMMM yyyy") : DateFormat("MMMM d, yyyy");
    return newFormat.format(parsedDate);
  }

  String formatDisplayDateFromDate(DateTime date) {
    final newFormat = DateFormat("MMMM d, yyyy");
    return newFormat.format(date);
  }

  String formatDatePickerArgs(DateTime value) {
    var newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(value);
  }

  DateTime getCalendarStartDateTime(String date) {
    final formattedDate = "$date 00:01:00";
    return DateTime.parse(formattedDate);
  }

  DateTime getCalendarEndDateTime(String date) {
    final formattedDate = "$date 23:59:00Z";
    return DateTime.parse(formattedDate);
  }
}
