import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:national_calendar_hub_app/models/response/home_page_response.dart';
import 'package:national_calendar_hub_app/utils/network_utils.dart';
import 'package:national_calendar_hub_app/widgets/error_state.dart';
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
  bool showError = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      showError = false;
    });

    try {
      final response = await http.get(Uri.parse(networkUtils.getHomPageUrl()));
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["success"]) {
        final responseData = HomePageResponse.fromJson(jsonData);
        setState(() {
          _listItems = const HomePageResponseConverter()
              .toListOfHomeListItem(responseData);
        });
      } else {
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

  @override
  Widget build(BuildContext context) {
    // TODO better loading
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : showError
            ? const ErrorState()
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
