class SvgIconAssets {
  static final SvgIconAssets _instance = SvgIconAssets._internal();

  factory SvgIconAssets() {
    return _instance;
  }

  SvgIconAssets._internal();

  Map<AssetName, String> assets = {AssetName.search: "assets/icons/search.svg"};
}

enum AssetName {
  search,
}
