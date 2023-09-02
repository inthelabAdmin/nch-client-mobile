class ExploreSearchResponse {
  final String message;
  final List<ExploreSearchItem> items;

  ExploreSearchResponse(this.message, this.items);

  factory ExploreSearchResponse.fromJson(dynamic json) {
    final searchMessage = json['result']["message"];
    final searchResults = json['result']["result"] as List;

    final searchItems = searchResults
        .map((e) => ExploreSearchItem(e["id"], e["name"], e["imageUrl"]))
        .toList();
    return ExploreSearchResponse(searchMessage, searchItems);
  }
}

class ExploreSearchItem {
  final String id;
  final String name;
  final String imageUrl;

  ExploreSearchItem(this.id, this.name, this.imageUrl);
}
