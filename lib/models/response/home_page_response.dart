import 'package:national_calendar_hub_app/models/national_day.dart';
import 'package:national_calendar_hub_app/utils/icons.dart';
import 'package:national_calendar_hub_app/widgets/home_list_item.dart';

class HomePageResponse {
  final List<NationalDay> days;
  final List<NationalDay> months;

  const HomePageResponse({
    required this.days,
    required this.months,
  });

  factory HomePageResponse.fromJson(dynamic json) {
    var daysList = json['result']["days"] as List;
    var monthsList = json['result']["months"] as List;
    List<NationalDay> daysObj =
        daysList.map((dayJson) => NationalDay.fromJson(dayJson)).toList();
    List<NationalDay> monthsObj =
        monthsList.map((dayJson) => NationalDay.fromJson(dayJson)).toList();

    return HomePageResponse(
      days: daysObj,
      months: monthsObj,
    );
  }
}

class HomePageResponseConverter {
  const HomePageResponseConverter();

  List<HomeListItem> toListOfHomeListItem(HomePageResponse homePageResponse) {
    // Map `National Days` to `DayHomeListItem`s
    List<DayHomeListItem> dayItems = homePageResponse.days
        .map((e) => DayHomeListItem.fromNationalDay(e))
        .toList();

    List<DayHomeListItem> monthItems = homePageResponse.months
        .map((e) => DayHomeListItem.fromNationalDay(e))
        .toList();

    List<HomeListItem> homePageList = [];
    homePageList.add(HeadingIconItem("Today", AssetName.search));
    homePageList.addAll(dayItems);
    homePageList.add(HeadingItem("This Month"));
    homePageList.addAll(monthItems);

    return homePageList;
  }
}
