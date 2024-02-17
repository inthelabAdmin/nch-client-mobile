import 'package:flutter/material.dart';
import 'package:national_calendar_hub_app/utils/web_links.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsWebViewPage extends StatefulWidget {
  const SettingsWebViewPage({Key? key, required this.pageType})
      : super(key: key);

  final String pageType;

  @override
  State<SettingsWebViewPage> createState() => _SettingsWebViewPageState();
}

class _SettingsWebViewPageState extends State<SettingsWebViewPage> {
  late final WebViewController controller;
  final WebLinksHelper _webLinksHelper = WebLinksHelper();

  @override
  void initState() {
    super.initState();
    var url = _webLinksHelper.getUrlForKey(widget.pageType);
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
