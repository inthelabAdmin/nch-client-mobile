import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:national_calendar_hub_app/widgets/error_state.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:national_calendar_hub_app/utils/network_utils.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final controller = ScrollController();
  NetworkUtils networkUtils = const NetworkUtils();
  final List<dynamic> _items = [];
  bool _isLoading = false;
  bool _hasNext = true;
  int _page = 1;
  bool showError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        _loadData();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse(networkUtils.getArticlesUrl(_page)));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData["success"]) {
        setState(() {
          _isLoading = false;
          _page += 1;
          _hasNext = responseData['hasNext'];
          _items.addAll(responseData['result']);
        });
      } else if (_items.isEmpty) {
        setShowError();
      }
    } catch (e) {
      setShowError();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void setShowError() {
    setState(() {
      showError = true;
    });
  }

  _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (index == _items.length) {
      return _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container();
    } else {
      if (index < _items.length) {
        final item = _items[index];
        return ListTile(
          onTap: () {
            _launchURL(item["link"]);
          },
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: item["image"],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) =>
                    Container(color: Colors.grey),
              )),
          title: Text(
            item['title'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(item['source']),
        );
      } else {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: _hasNext ? const CircularProgressIndicator() : Container(),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "News",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: SafeArea(
            child: showError
                ? const Center(child: ErrorState())
                : ListView.builder(
                    controller: controller,
                    itemCount: _items.length + 1,
                    itemBuilder: _buildListItem,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 10),
                  )));
  }
}
