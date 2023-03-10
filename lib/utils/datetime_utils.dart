import 'package:intl/intl.dart';

class DateTimeUtil {
  const DateTimeUtil();

  String getDateToday() {
    var dt = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(dt);
  }

  String formatDisplayDate(String date) {
    final parsedDate = DateTime.parse(date);
    final newFormat = DateFormat("MMMM d, yyyy");
    return newFormat.format(parsedDate);
  }

  String formatDatePickerArgs(DateTime value) {
    var newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(value);
  }
}
