import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:national_calendar_hub_app/models/response/search_response.dart';
import 'package:national_calendar_hub_app/network/search_repository.dart';
import 'package:national_calendar_hub_app/utils/datetime_utils.dart';
import 'package:national_calendar_hub_app/widgets/empty_state.dart';
import 'package:national_calendar_hub_app/widgets/error_state.dart';
import 'package:national_calendar_hub_app/widgets/search_initial_screen.dart';

class ExploreSearchPage extends StatefulWidget {
  const ExploreSearchPage({Key? key}) : super(key: key);

  final String restorationId = "explore";

  @override
  State<ExploreSearchPage> createState() => _ExploreSearchPageState();
}

class _ExploreSearchPageState extends State<ExploreSearchPage>
    with RestorationMixin {
  final _debounce = Debounce();
  List<ExploreSearchItem> _data = [];
  final DateTimeUtil _dateTimeUtil = const DateTimeUtil();
  final ExploreSearchRepository _exploreSearchRepository =
      ExploreSearchRepository();
  final _fieldText = TextEditingController();
  ExplorePageState _currentState = ExplorePageState.initial;
  bool _hasTextFieldValue = false;
  String _displayDate = "";
  String _searchMessage = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colors.background,
          title: SizedBox(
            width: double.infinity,
            height: 40,
            child: Center(
              child: TextField(
                enabled: _currentState != ExplorePageState.calendarMode,
                onChanged: _onTextChange,
                textInputAction: TextInputAction.search,
                controller: _fieldText,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _hasTextFieldValue
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _onClearTextField,
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
                child: _currentState == ExplorePageState.calendarMode
                    ? InputChip(
                        label: Text(_displayDate),
                        onDeleted: _onClearDate,
                      )
                    : null),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: _onCalendarButtonClick,
                    style: IconButton.styleFrom(
                        focusColor: colors.onSurfaceVariant.withOpacity(0.12),
                        highlightColor: colors.onSurface.withOpacity(0.12),
                        side: BorderSide(color: colors.outline))))
          ],
        ),
        body: _currentState == ExplorePageState.initial
            ? const Center(child: SearchInitialPage())
            : _currentState == ExplorePageState.loading
                ? const Center(child: CircularProgressIndicator())
                : _currentState == ExplorePageState.error
                    ? const Center(child: ErrorState())
                    : _currentState == ExplorePageState.empty
                        ? EmptyState(headerTitle: _searchMessage)
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
                              final currentItem = _data[index];
                              return ListTile(
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(35.0),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${currentItem.imageUrl}?width=100",
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
                                  context.go('/details/${currentItem.id}');
                                },
                              );
                            }));
  }

  /// Fetch calls **********/
  Future<void> _fetchDataForDate(String date) async {
    _setCurrentPageState(ExplorePageState.loading);

    final response =
        await _exploreSearchRepository.fetchSelectedDateItems(date);
    if (response is ExploreSearchSuccessResponse) {
      setState(() {
        _data = response.items;
        _currentState = ExplorePageState.calendarMode;
      });
    } else {
      FirebaseCrashlytics.instance.log("Error loading data for date: $date");
      _setCurrentPageState(ExplorePageState.error);
    }
  }

  Future<void> _fetchDataForSearch(String keyword) async {
    _setCurrentPageState(ExplorePageState.loading);

    final response = await _exploreSearchRepository.fetchSearchItems(keyword);
    if (response is ExploreSearchSuccessResponse) {
      setState(() {
        _data = response.items;
        _searchMessage = response.message;
        if (_data.isEmpty) {
          _currentState = ExplorePageState.empty;
        } else {
          _currentState = ExplorePageState.searchMode;
        }
      });
    } else {
      FirebaseCrashlytics.instance.log("Error loading data for keyword: $keyword");
      _setCurrentPageState(ExplorePageState.error);
    }
  }

  /// Helper functions **********/
  void _setCurrentPageState(ExplorePageState state) {
    setState(() {
      _currentState = state;
    });
  }

  void _onCalendarButtonClick() {
    _restorableDatePickerRouteFuture.present();
  }

  void _onTextChange(String s) {
    _hasTextFieldValue = s.isNotEmpty;
    if (s.length > 1) {
      _debounce.run(() {
        _fetchDataForSearch(s);
      });
    } else if (s.isEmpty) {
      setState(() {
        _currentState = ExplorePageState.initial;
      });
    }
  }

  void _onClearTextField() {
    _fieldText.clear();
    setState(() {
      _currentState = ExplorePageState.initial;
      _hasTextFieldValue = false;
      _data = [];
    });
  }

  void _onClearDate() {
    setState(() {
      _displayDate = "";
      _currentState = ExplorePageState.initial;
      _data = [];
    });
  }

  /// DatePicker functions **********/
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
      _onClearTextField();
      setState(() {
        _displayDate = _dateTimeUtil.formatDisplayDateFromDate(newSelectedDate);
        _selectedDate.value = newSelectedDate;
      });
      _fetchDataForDate(_dateTimeUtil.formatEndpointDate(newSelectedDate));
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }
}

class Debounce {
  final int milliseconds;
  Timer? _timer;

  Debounce({this.milliseconds = 500});

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() => _timer?.cancel();
}

enum ExplorePageState {
  initial,
  loading,
  searchMode,
  calendarMode,
  empty,
  error
}
