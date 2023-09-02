import 'package:national_calendar_hub_app/models/detail_day_item.dart';
import 'package:http/http.dart' as http;
import '../utils/network_utils.dart';
import 'dart:convert';

class DetailsRepository {
  NetworkUtils networkUtils = const NetworkUtils();

  Future<DetailsResponseType> fetchDetails(String id) async {
    try {
      final response =
          await http.get(Uri.parse(networkUtils.getDetailsUrl(id)));
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["success"]) {
        final responseData = DetailDayItem.fromJson(jsonData);
        return DetailSuccessResponse(responseData);
      } else {
        return DetailErrorResponse();
      }
    } catch (e) {
      return DetailErrorResponse();
    }
  }
}

abstract class DetailsResponseType {}

class DetailSuccessResponse extends DetailsResponseType {
  final DetailDayItem data;

  DetailSuccessResponse(this.data);
}

class DetailErrorResponse extends DetailsResponseType {}
