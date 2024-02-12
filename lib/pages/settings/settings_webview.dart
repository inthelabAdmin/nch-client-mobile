import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsWebViewPage extends StatefulWidget {
  const SettingsWebViewPage({Key? key, required this.pageType}) : super(key: key);

  final String pageType;

  @override
  State<SettingsWebViewPage> createState() => _SettingsWebViewPageState();
}

class _SettingsWebViewPageState extends State<SettingsWebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    var url = "";
    switch (widget.pageType) {
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
    controller = WebViewController()
      ..loadRequest(Uri.parse(url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
