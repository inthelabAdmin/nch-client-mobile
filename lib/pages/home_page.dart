import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:national_calendar_hub_app/models/response/home_page_response.dart';
import 'package:national_calendar_hub_app/utils/network_utils.dart';
import 'package:national_calendar_hub_app/widgets/home_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeListItem> _listItems = [];
  NetworkUtils networkUtils = const NetworkUtils();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(networkUtils.getHomPageUrl()));
      final jsonData = jsonDecode(response.body);
      final responseData = HomePageResponse.fromJson(jsonData);
      setState(() {
        _listItems = const HomePageResponseConverter()
            .toListOfHomeListItem(responseData);
      });
    } catch (e) {
      // TODO ERROR HANDLING
      print('Error fetching remote data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO better loading
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _listItems.length,
                    itemBuilder: (context, index) {
                      return _listItems[index].build(context);
                    })));
  }
}
