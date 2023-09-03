import 'package:quick_actions/quick_actions.dart';

class AppQuickActionAssets {
  static final AppQuickActionAssets _instance =
      AppQuickActionAssets._internal();

  factory AppQuickActionAssets() {
    return _instance;
  }

  AppQuickActionAssets._internal();

  final Map<QuickActionType, String> _icons = {
    QuickActionType.home: "ic_today",
    QuickActionType.explore: "ic_search",
    QuickActionType.news: "ic_news",
  };

  final Map<QuickActionType, String> _titles = {
    QuickActionType.home: "Today",
    QuickActionType.explore: "Explore",
    QuickActionType.news: "News",
  };

  List<ShortcutItem> getShortCutItemsList() {
    const values = QuickActionType.values;
    List<ShortcutItem> results = [];
    for (var i = 0; i < values.length; i++) {
      var type = values[i];
      results.add(ShortcutItem(
          type: type.name,
          localizedTitle: _titles[type]!,
          icon: _icons[type]!));
    }
    return results;
  }
}

enum QuickActionType { home, explore, news }
