import 'package:national_calendar_hub_app/utils/datetime_utils.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class AddEventHelper {
  DateTimeUtil dateTimeUtil = const DateTimeUtil();

  void addToCalendar(String name, String date) {
    final Event event = Event(
        title: name,
        description: "Added from National Calendar Hub app",
        startDate: dateTimeUtil.getCalendarStartDateTime(date),
        endDate: dateTimeUtil.getCalendarEndDateTime(date),
        allDay: true);
    Add2Calendar.addEvent2Cal(event);
  }
}
