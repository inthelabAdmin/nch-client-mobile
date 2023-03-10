import 'datetime_utils.dart';

class NetworkUtils {
  final DateTimeUtil dateTimeUtil = const DateTimeUtil();
  final String _baseUrl = "https://dev-nca-client-be.herokuapp.com/api/v2";

  const NetworkUtils();

  String getHomPageUrl() {
    var today = dateTimeUtil.getDateToday();
    return "$_baseUrl/homePage?date=$today";
  }

  String getDetailsUrl(String id){
    return "$_baseUrl/details?id=$id";
  }

}