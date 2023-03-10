class TagsItem {
  final String label;
  final String twitterLink;
  final String facebookLink;
  final String instagramLink;

  const TagsItem({
    required this.label,
    required this.twitterLink,
    required this.facebookLink,
    required this.instagramLink,
  });

  factory TagsItem.fromJson(dynamic json) {
    return TagsItem(
      label: json['label'],
      twitterLink: json['twitterLink'],
      facebookLink: json['facebookLink'],
      instagramLink: json['instagramLink'],
    );
  }
}
