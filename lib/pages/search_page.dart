import 'package:flutter/material.dart';
import 'package:national_calendar_hub_app/models/response/search_response.dart';
import 'package:national_calendar_hub_app/pages/details/detail_screen_arguments.dart';
import 'package:national_calendar_hub_app/pages/details/details.dart';
import 'package:national_calendar_hub_app/utils/network_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const routeName = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchItem> _data = [];
  NetworkUtils networkUtils = const NetworkUtils();
  final fieldText = TextEditingController();
  bool _isLoading = false;
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchData(String keyword) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse(networkUtils.getSearchUrl(keyword)));
      final jsonData = jsonDecode(response.body);
      final responseData = SearchResponse.fromJson(jsonData);

      setState(() {
        _data = responseData.items;
      });
    } catch (e) {
      // TODO ERROR HANDLING
      print('Error fetching remote data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // TODO Initial Page And Results not found

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // The search area here
            title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              onChanged: (String s) {
                _hasValue = s.isNotEmpty;
                if (s.length > 1) {
                  _fetchData(s);
                }
              },
              textInputAction: TextInputAction.search,
              controller: fieldText,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _hasValue
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            fieldText.clear();
                            setState(() {
                              _hasValue = false;
                              _data = [];
                            });
                          },
                        )
                      : null,
                  hintText: 'Search...',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
          ),
        )),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final currentItem = _data[index];
                  return ListTile(
                    title: Text(currentItem.name),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DetailsPage.routeName,
                        arguments: DetailScreenArguments(
                          currentItem.id,
                          "search",
                        ),
                      );
                    },
                  );
                }));
  }
}
