import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:national_calendar_hub_app/pages/explore_search_page.dart';
import 'package:national_calendar_hub_app/pages/home_page.dart';
import 'package:national_calendar_hub_app/pages/news_page.dart';
import 'package:national_calendar_hub_app/pages/settings/settings_page.dart';
import 'package:national_calendar_hub_app/utils/quick_actions_helper.dart';
import 'package:quick_actions/quick_actions.dart';

import '../color_schemes.g.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    HomePage(),
    ExploreSearchPage(),
    NewsPage(),
    SettingsPage()
  ];

  @override
  void initState() {
    super.initState();
    const QuickActions quickActions = QuickActions();
    quickActions
        .setShortcutItems(AppQuickActionAssets().getShortCutItemsList());
    quickActions.initialize((type) {
      var pageIndex = 0;
      if (type == QuickActionType.explore.name) {
        pageIndex = 1;
      } else if (type == QuickActionType.news.name) {
        pageIndex = 2;
      }
      _onItemTapped(pageIndex);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LazyLoadIndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: lightColorScheme.primary,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.4),
        enableFeedback: true,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/home_unselected.png'),
            ),
            activeIcon: ImageIcon(
              AssetImage('assets/icons/home_selected.png'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/search.png'),
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/news_unselected.png'),
            ),
            activeIcon: ImageIcon(
              AssetImage('assets/icons/news_selected.png'),
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/settings_unselected.png'),
            ),
            activeIcon: ImageIcon(
              AssetImage('assets/icons/settings_selected.png'),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
