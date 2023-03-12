import 'dart:convert';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:national_calendar_hub_app/models/detail_day_item.dart';
import 'package:national_calendar_hub_app/pages/details/hashtag_dialog.dart';
import 'package:national_calendar_hub_app/utils/datetime_utils.dart';
import 'package:national_calendar_hub_app/utils/icons.dart';
import 'package:national_calendar_hub_app/widgets/error_state.dart';
import 'package:national_calendar_hub_app/widgets/svg_asset.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/network_utils.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.id}) : super(key: key);

  static const routeName = '/details';

  final String id;

  static Route createRoute(String id) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DetailsPage(id: id),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late DetailDayItem _data;
  DateTimeUtil dateTimeUtil = const DateTimeUtil();
  NetworkUtils networkUtils = const NetworkUtils();
  bool _isLoading = true;
  bool showError = false;

  @override
  void initState() {
    super.initState();
  }

  void addToCalendar() {
    final Event event = Event(
        title: _data.name,
        description: "Added from National Calendar Hub app",
        startDate: dateTimeUtil.getCalendarStartDateTime(_data.date),
        endDate: dateTimeUtil.getCalendarEndDateTime(_data.date),
        allDay: true);
    Add2Calendar.addEvent2Cal(event);
  }

  Future<void> _fetchData(String id) async {
    setState(() {
      _isLoading = true;
      showError = false;
    });

    try {
      final response =
          await http.get(Uri.parse(networkUtils.getDetailsUrl(id)));
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["success"]) {
        final responseData = DetailDayItem.fromJson(jsonData);
        setState(() {
          _data = responseData;
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

  Future<void> onShare(BuildContext context, String shareUrl) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      shareUrl,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      _fetchData(widget.id);
      return const Center(child: CircularProgressIndicator());
    } else {
      return showError
          ? Scaffold(appBar: AppBar(), body: const Center(child: ErrorState()))
          : Scaffold(
              appBar: AppBar(actions: <Widget>[
                IconButton(
                    onPressed: () {
                      addToCalendar();
                    },
                    icon: const Icon(Icons.calendar_today)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: IconButton(
                      onPressed: () {
                        onShare(context, _data.shareUrl);
                      },
                      icon: const Icon(Icons.share_outlined)),
                ),
              ]),
              body: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 10.0, bottom: 18.0),
                          child: Column(children: [
                            SizedBox(
                                width: double.infinity,
                                child: Text(
                                  _data.name,
                                  style: const TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                                width: double.infinity,
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 20.0, bottom: 20.0),
                                    child: Text(
                                      dateTimeUtil
                                          .formatDisplayDate(_data.date),
                                    ))),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: "${_data.imageUrl}?width=600",
                                  width: 500,
                                  height: 250,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(color: Colors.grey),
                                )),
                            SizedBox(
                                width: double.infinity,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 24.0, bottom: 10.0),
                                  child: Text(
                                    _data.description,
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      height: 1.5,
                                      letterSpacing: 0.5
                                    ),
                                  ),
                                )),
                            const Divider(thickness: 1.0),
                            SizedBox(
                              height: 60.h,
                              child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: _data.tags
                                      .map((e) => HashTagChip(tagsItem: e))
                                      .toList()),
                            ),
                          ]));
                    },
                    childCount: 1,
                  ))
                ],
              ));
    }
  }
}
