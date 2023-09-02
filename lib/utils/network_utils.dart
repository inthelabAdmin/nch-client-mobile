import 'datetime_utils.dart';
import 'package:flutter/foundation.dart';

class NetworkUtils {
  final DateTimeUtil dateTimeUtil = const DateTimeUtil();

  static const String _devEndpoint = "https://dev-nca-client-be.herokuapp.com/api/v2";
  static const String _prodEndpoint = "https://api-nationalcalendarhub-840f979bf501.herokuapp.com/api/v2";

  static const String _baseUrl = kReleaseMode?_prodEndpoint:_devEndpoint;

  const NetworkUtils();

  String getHomPageUrl() {
    var today = dateTimeUtil.getDateToday();
    return "$_baseUrl/homePage?date=$today";
  }

  String getDetailsUrl(String id) {
    return "$_baseUrl/details?id=$id";
  }

  String getSearchUrl(String keyword) {
    return "$_baseUrl/search?keyword=$keyword";
  }

  String getFetchDaysUrl(String date) {
    return "$_baseUrl/days?date=$date";
  }

  String getArticlesUrl(int page) {
    return "$_baseUrl/articles?page=$page";
  }
}
