class SearchResponse {
  final String message;
  final List<SearchItem> items;

  SearchResponse(this.message, this.items);

  factory SearchResponse.fromJson(dynamic json) {
    final searchMessage = json['result']["message"];
    final searchResults = json['result']["result"] as List;

    final searchItems = searchResults
        .map((e) => SearchItem(e["id"], e["name"], e["imageUrl"]))
        .toList();
    return SearchResponse(searchMessage, searchItems);
  }
}

class SearchItem {
  final String id;
  final String name;
  final String imageUrl;

  SearchItem(this.id, this.name, this.imageUrl);
}
