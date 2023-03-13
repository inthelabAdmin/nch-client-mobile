import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:national_calendar_hub_app/widgets/error_state.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:national_calendar_hub_app/utils/network_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _controller = ScrollController();
  final NetworkUtils _networkUtils = const NetworkUtils();
  final List<dynamic> _items = [NewsHeaderItem("News")];
  NewsPageState _currentPageState = NewsPageState.initial;
  bool _hasNext = true;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        _loadData();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePageState(NewsPageState state) {
    setState(() {
      _currentPageState = state;
    });
  }

  Future<void> _loadData() async {
    if (_currentPageState == NewsPageState.loading) return;

    _updatePageState(NewsPageState.loading);
    
    try {
      final response =
          await http.get(Uri.parse(_networkUtils.getArticlesUrl(_page)));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData["success"]) {
        setState(() {
          _currentPageState = NewsPageState.success;
          _page += 1;
          _hasNext = responseData['hasNext'];
          _items.addAll(responseData['result']);
        });
      } else if (_items.isEmpty) {
        _updatePageState(NewsPageState.error);
      }
    } catch (e) {
      _updatePageState(NewsPageState.error);
    }
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
    if (index < _items.length) {
      final item = _items[index];
      return item is NewsHeaderItem
          ? Padding(
              padding: EdgeInsets.only(
                  left: 16.w, right: 18.w, top: 12.h, bottom: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.title,
                      style: TextStyle(
                          fontSize: 30.w, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : ListTile(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: _currentPageState == NewsPageState.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _currentPageState == NewsPageState.error
                    ? const Center(child: ErrorState())
                    : ListView.builder(
                        controller: _controller,
                        itemCount: _items.length + 1,
                        itemBuilder: _buildListItem,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 10),
                      )));
  }
}

class NewsHeaderItem {
  final String title;

  NewsHeaderItem(this.title);
}

enum NewsPageState { initial, loading, success, error }
