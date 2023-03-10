class NationalDay {
  final String id;
  final String name;
  final String description;
  final String date;
  final String imageUrl;
  final String type;

  const NationalDay({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.type,
  });

  factory NationalDay.fromJson(dynamic json) {
    return NationalDay(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: json['date'],
      imageUrl: json['imageUrl'],
      type: json['type'],
    );
  }
}
