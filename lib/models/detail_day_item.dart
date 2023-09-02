import 'package:national_calendar_hub_app/models/tags.dart';

class DetailDayItem {
  final String id;
  final String name;
  final String description;
  final String date;
  final String imageUrl;
  final String type;
  final List<TagsItem> tags;
  final String shareUrl;

  const DetailDayItem({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.type,
    required this.tags,
    required this.shareUrl,
  });

  factory DetailDayItem.fromJson(dynamic json) {
    var result = json['result'];
    var tagsList = result["tags"] as List;

    List<TagsItem> tags = tagsList.map((e) => TagsItem.fromJson(e)).toList();

    return DetailDayItem(
      id: result['id'],
      name: result['name'],
      description: result['description'],
      date: result['date'],
      imageUrl: result['imageUrl'],
      type: result['type'],
      tags: tags,
      shareUrl: result['shareUrl'],
    );
  }
}
