class SvgIconAssets {
  static final SvgIconAssets _instance = SvgIconAssets._internal();

  factory SvgIconAssets() {
    return _instance;
  }

  SvgIconAssets._internal();

  Map<AssetName, String> assets = {
    AssetName.search: "assets/icons/search.svg",
    AssetName.share: "assets/icons/share.svg",
    AssetName.favorite_unselected: "assets/icons/favorite_unselected.svg",
    AssetName.facebook: "assets/icons/facebook.svg",
    AssetName.instagram: "assets/icons/instagram.svg",
    AssetName.twitter: "assets/icons/twitter.svg"
  };
}

enum AssetName {
  search,
  share,
  favorite_unselected,
  facebook,
  instagram,
  twitter
}
