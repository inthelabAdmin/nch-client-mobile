import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:national_calendar_hub_app/models/response/search_response.dart';
import 'package:national_calendar_hub_app/pages/details/details.dart';
import 'package:national_calendar_hub_app/utils/datetime_utils.dart';
import 'package:national_calendar_hub_app/utils/network_utils.dart';
import 'package:national_calendar_hub_app/widgets/empty_state.dart';
import 'package:national_calendar_hub_app/widgets/error_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  final String restorationId = "explore";
  static const routeName = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with RestorationMixin {
  List<SearchItem> _data = [];
  NetworkUtils networkUtils = const NetworkUtils();
  DateTimeUtil dateTimeUtil = const DateTimeUtil();
  final fieldText = TextEditingController();
  bool _isLoading = false;
  bool _hasValue = false;
  bool _showNotFoundMessage = false;
  bool _disableTextField = false;
  String _displayDate = "";
  String searchMessage = "";
  bool showError = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchDataForDate(String date) async {
    setState(() {
      _isLoading = true;
      showError = false;
    });

    try {
      final response =
          await http.get(Uri.parse(networkUtils.getFetchDaysUrl(date)));
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["success"]) {
        final searchResults = jsonData['result'] as List;
        final resultItems = searchResults
            .map((e) => SearchItem(e["id"], e["name"], e["imageUrl"]))
            .toList();

        setState(() {
          _data = resultItems;
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

  Future<void> _fetchDataForSearch(String keyword) async {
    setState(() {
      _isLoading = true;
      showError = false;
    });

    try {
      final response =
          await http.get(Uri.parse(networkUtils.getSearchUrl(keyword)));
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["success"]) {
        final responseData = SearchResponse.fromJson(jsonData);

        setState(() {
          _data = responseData.items;
          if (responseData.items.isEmpty) {
            _showNotFoundMessage = true;
            searchMessage = responseData.message;
          } else {
            _showNotFoundMessage = false;
            searchMessage = "";
          }
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

  void onCalendarButtonClick() {
    _restorableDatePickerRouteFuture.present();
  }

  void onTextChange(String s) {
    _hasValue = s.isNotEmpty;
    if (s.length > 1) {
      _fetchDataForSearch(s);
    }
  }

  void onClearTextField() {
    fieldText.clear();
    setState(() {
      _showNotFoundMessage = false;
      showError = false;
      _hasValue = false;
      _data = [];
    });
  }

  void onClearDate() {
    setState(() {
      _displayDate = "";
      _disableTextField = false;
      showError = false;
      _data = [];
    });
  }

  // TODO Initial Page And Results not found

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: double.infinity,
            height: 40,
            child: Center(
              child: TextField(
                enabled: !_disableTextField,
                onChanged: onTextChange,
                textInputAction: TextInputAction.search,
                controller: fieldText,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _hasValue
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: onClearTextField,
                          )
                        : null,
                    hintText: 'Search...',
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
            ),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: _disableTextField
                    ? InputChip(
                        label: Text(_displayDate),
                        onDeleted: onClearDate,
                      )
                    : null),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: onCalendarButtonClick,
                    style: IconButton.styleFrom(
                        focusColor: colors.onSurfaceVariant.withOpacity(0.12),
                        highlightColor: colors.onSurface.withOpacity(0.12),
                        side: BorderSide(color: colors.outline))))
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : showError
                ? const Center(child: ErrorState())
                : _showNotFoundMessage
                    ? EmptyState(headerTitle: searchMessage)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          final currentItem = _data[index];
                          return ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(35.0),
                                child: CachedNetworkImage(
                                  imageUrl: "${currentItem.imageUrl}?width=100",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey),
                                  errorWidget: (context, url, error) =>
                                      Container(color: Colors.grey),
                                )),
                            title: Text(currentItem.name),
                            onTap: () {
                              Navigator.of(context).push(
                                  DetailsPage.createRoute(currentItem.id));
                            },
                          );
                        }));
  }

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        final thisYear = DateTime.now().year;
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.parse("$thisYear-01-01"),
          lastDate: DateTime.parse("$thisYear-12-31"),
        );
      },
    );
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      onClearTextField();
      setState(() {
        _disableTextField = true;
        _displayDate = dateTimeUtil.formatDisplayDateFromDate(newSelectedDate);
        _selectedDate.value = newSelectedDate;
      });
      _fetchDataForDate(dateTimeUtil.formatEndpointDate(newSelectedDate));
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }
}
