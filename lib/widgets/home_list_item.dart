import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:national_calendar_hub_app/models/national_day.dart';
import 'package:national_calendar_hub_app/pages/details/detail_screen_arguments.dart';
import 'package:national_calendar_hub_app/pages/details/details.dart';
import 'package:national_calendar_hub_app/pages/search_page.dart';
import 'package:national_calendar_hub_app/utils/icons.dart';
import 'package:national_calendar_hub_app/widgets/svg_asset.dart';

abstract class HomeListItem {
  Widget build(BuildContext context);
}

class HeadingIconItem extends HomeListItem {
  final AssetName assetName;
  final String heading;

  HeadingIconItem(this.heading, this.assetName);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 18.w,
        top: 36.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,
              style: TextStyle(fontSize: 34.w, fontWeight: FontWeight.bold)),
          InkWell(
            borderRadius: BorderRadius.circular(360),
            onTap: () {
              Navigator.pushNamed(
                context,
                SearchPage.routeName,
              );
            },
            child: SizedBox(
              height: 35.w,
              width: 35.w,
              child: Center(
                child: SvgAsset(
                  assetName: assetName,
                  height: 24.w,
                  width: 24.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeadingItem extends HomeListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 18.w,
        top: 36.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,
              style: TextStyle(fontSize: 34.w, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class DayHomeListItem extends StatelessWidget with HomeListItem {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;

  const DayHomeListItem({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  factory DayHomeListItem.fromNationalDay(NationalDay day) {
    return DayHomeListItem(
        id: day.id,
        imageUrl: day.imageUrl,
        title: day.name,
        subtitle: day.description);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailsPage.routeName,
            arguments: DetailScreenArguments(
              id,
              "home",
            ),
          );
        },
        child: Container(
            margin: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 10.0, bottom: 18.0),
            child: Column(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "$imageUrl?width=600",
                    width: 500,
                    height: 250,
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16.0, bottom: 10.0),
                    child: Text(title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600)),
                  )),
              SizedBox(
                  width: double.infinity,
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Text(subtitle,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis))),
            ])));
  }
}
