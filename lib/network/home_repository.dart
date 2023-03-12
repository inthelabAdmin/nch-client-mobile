import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:national_calendar_hub_app/models/response/home_page_response.dart';
import 'package:national_calendar_hub_app/utils/network_utils.dart';
import 'package:national_calendar_hub_app/widgets/home_list_item.dart';

class HomeRepository {
  NetworkUtils networkUtils = const NetworkUtils();

  Future<HomeResponseType> fetchHomePageItems() async {
    try {
      final response = await http.get(Uri.parse(networkUtils.getHomPageUrl()));
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["success"]) {
        final responseData = HomePageResponse.fromJson(jsonData);
        final response = const HomePageResponseConverter()
            .toListOfHomeListItem(responseData);

        return HomeSuccessResponse(response);
      } else {
        return HomeErrorResponse();
      }
    } catch (e) {
      return HomeErrorResponse();
    }
  }
}

abstract class HomeResponseType {}

class HomeSuccessResponse extends HomeResponseType {
  final List<HomeListItem> listItems;

  HomeSuccessResponse(this.listItems);
}

class HomeErrorResponse extends HomeResponseType {}
