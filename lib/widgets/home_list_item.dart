import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:national_calendar_hub_app/models/national_day.dart';

abstract class HomeListItem {
  Widget build(BuildContext context);
}

class HeadingItem extends HomeListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 18,
        top: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,
              style:
                  const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
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
          context.go('/details/$id');
        },
        child: Container(
            margin: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 10.0, bottom: 18.0),
            child: Column(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: "$imageUrl?width=600",
                    width: double.infinity,
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
                        style: const TextStyle(height: 1.5, letterSpacing: 0.5),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  )),
            ])));
  }
}
