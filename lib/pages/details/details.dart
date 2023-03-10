import 'package:flutter/material.dart';
import 'package:national_calendar_hub_app/models/detail_day_item.dart';
import 'package:national_calendar_hub_app/pages/details/detail_screen_arguments.dart';
import 'package:national_calendar_hub_app/pages/details/hashtag_dialog.dart';
import 'package:national_calendar_hub_app/utils/datetime_utils.dart';
import 'package:national_calendar_hub_app/utils/icons.dart';
import 'package:national_calendar_hub_app/widgets/svg_asset.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import '../../utils/network_utils.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  static const routeName = '/details';

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late DetailDayItem _data;
  DateTimeUtil dateTimeUtil = const DateTimeUtil();
  NetworkUtils networkUtils = const NetworkUtils();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchData(String id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse(networkUtils.getDetailsUrl(id)));
      final jsonData = jsonDecode(response.body);
      final responseData = DetailDayItem.fromJson(jsonData);

      setState(() {
        _data = responseData;
      });
    } catch (e) {
      // TO DO ERROR HANDLING
      print('Error fetching remote data: $e');
    }

    setState(() {
      _isLoading = false;
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
    final args =
        ModalRoute.of(context)!.settings.arguments as DetailScreenArguments;

    // TODO Error/Null CHeck
    if (_isLoading) {
      _fetchData(args.id);
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          appBar: AppBar(actions: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(360),
              onTap: () {
                onShare(context, _data.shareUrl);
              },
              child: SizedBox(
                height: 35.w,
                width: 35.w,
                child: Center(
                  child: SvgAsset(
                    assetName: AssetName.share,
                    height: 24.w,
                    width: 24.w,
                  ),
                ),
              ),
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
                                  fontSize: 32.0, fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                            width: double.infinity,
                            child: Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0, bottom: 20.0),
                                child: Text(
                                  dateTimeUtil.formatDisplayDate(_data.date),
                                ))),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              "${_data.imageUrl}?width=600",
                              width: 500,
                              height: 250,
                              fit: BoxFit.cover,
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
