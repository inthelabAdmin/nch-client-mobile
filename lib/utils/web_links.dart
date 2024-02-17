class WebLinksHelper {
  String getUrlForKey(String key) {
    var url = "";
    switch (key) {
      case 'terms':
        url = "https://www.nationalcalendarhub.com/termsOfLegalServices/mobile";
        break;
      case 'privacy':
        url = "https://www.nationalcalendarhub.com/privacyPolicy/mobile";
        break;
      case 'about':
        url = "https://www.nationalcalendarhub.com/aboutUs/mobile";
        break;
      default:
        url = "https://www.nationalcalendarhub.com";
    }
    return url;
  }
}

enum WebLinks { privacy, terms, about }
