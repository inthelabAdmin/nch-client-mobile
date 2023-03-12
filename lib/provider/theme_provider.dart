import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:national_calendar_hub_app/color_schemes.g.dart';
import 'package:national_calendar_hub_app/pages/settings/theme/theme_prefereneces.dart';
import 'package:national_calendar_hub_app/storage/shared_preferences_manager.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  Future<void> fetchSavedTheme() async {
    int savedTheme =
        await SharedPrefsManager.getInt(ThemePreferences.KEY_PREF_THEME) ?? 0;
    setTheme(savedTheme);
  }

  void setTheme(int value) {
    switch (value) {
      case 1:
        themeMode = ThemeMode.light;
        break;
      case 2:
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    notifyListeners();
  }
}

class AppThemes {
  static final darkTheme = ThemeData(
      useMaterial3: true, colorScheme: darkColorScheme, fontFamily: 'Urbanist');

  static final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: 'Urbanist',
      textTheme:
          TextTheme(bodyMedium: TextStyle(color: lightColorScheme.primary)));
}
