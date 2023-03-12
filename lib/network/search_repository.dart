import 'dart:convert';
import 'package:national_calendar_hub_app/models/response/search_response.dart';
import 'package:national_calendar_hub_app/utils/network_utils.dart';
import 'package:http/http.dart' as http;

class ExploreSearchRepository {
  NetworkUtils networkUtils = const NetworkUtils();

  Future<ExploreSearchResponseType> fetchSelectedDateItems(String date) async {
    try {
      final response =
          await http.get(Uri.parse(networkUtils.getFetchDaysUrl(date)));
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["success"]) {
        final searchResults = jsonData['result'] as List;
        final resultItems = searchResults
            .map((e) => ExploreSearchItem(e["id"], e["name"], e["imageUrl"]))
            .toList();

        return ExploreSearchSuccessResponse(resultItems, "");
      } else {
        return ExploreSearchErrorResponse();
      }
    } catch (e) {
      return ExploreSearchErrorResponse();
    }
  }

  Future<ExploreSearchResponseType> fetchSearchItems(String keyword) async {
    try {
      final response =
          await http.get(Uri.parse(networkUtils.getSearchUrl(keyword)));
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["success"]) {
        final responseData = ExploreSearchResponse.fromJson(jsonData);
        return ExploreSearchSuccessResponse(
            responseData.items, responseData.message);
      } else {
        return ExploreSearchErrorResponse();
      }
    } catch (e) {
      return ExploreSearchErrorResponse();
    }
  }
}

abstract class ExploreSearchResponseType {}

class ExploreSearchSuccessResponse with ExploreSearchResponseType {
  final List<ExploreSearchItem> items;
  final String message;

  ExploreSearchSuccessResponse(this.items, this.message);
}

class ExploreSearchErrorResponse with ExploreSearchResponseType {}
