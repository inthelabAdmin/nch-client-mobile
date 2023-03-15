import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:national_calendar_hub_app/models/detail_day_item.dart';
import 'package:national_calendar_hub_app/network/details_repository.dart';
import 'package:national_calendar_hub_app/pages/details/hashtag_dialog.dart';
import 'package:national_calendar_hub_app/utils/add_event_helper.dart';
import 'package:national_calendar_hub_app/utils/datetime_utils.dart';
import 'package:national_calendar_hub_app/widgets/error_state.dart';
import 'package:share_plus/share_plus.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final DateTimeUtil _dateTimeUtil = const DateTimeUtil();
  final DetailsRepository _detailsRepository = DetailsRepository();
  final AddEventHelper _addEventHelper = AddEventHelper();
  DetailPageState _currentStata = DetailPageState.loading;
  late DetailDayItem _data;

  @override
  void initState() {
    super.initState();
    _fetchData(widget.id);
  }

  void setCurrentPageState(DetailPageState state) {
    setState(() {
      _currentStata = state;
    });
  }

  Future<void> _fetchData(String id) async {
    setCurrentPageState(DetailPageState.loading);

    final responseData = await _detailsRepository.fetchDetails(id);
    if (responseData is DetailSuccessResponse) {
      setState(() {
        _data = responseData.data;
        _currentStata = DetailPageState.success;
      });
    } else {
      setCurrentPageState(DetailPageState.error);
    }
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
    return _currentStata == DetailPageState.loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : _currentStata == DetailPageState.error
            ? Scaffold(
                appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.background),
                body: const Center(child: ErrorState()))
            : Scaffold(
                appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    actions: <Widget>[
                      IconButton(
                          onPressed: () {
                            _addEventHelper.addToCalendar(
                                _data.name, _data.date);
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
                                left: 16.0,
                                right: 16.0,
                                top: 10.0,
                                bottom: 18.0),
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
                                        _dateTimeUtil
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
                                          letterSpacing: 0.5),
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

enum DetailPageState { loading, success, error }
