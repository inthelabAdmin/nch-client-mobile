import 'package:national_calendar_hub_app/storage/shared_preferences_manager.dart';

class ThemePreferences {
  static const KEY_PREF_THEME = "KEY_PREF_THEME";

getTheme() async {
    final value =
        await SharedPrefsManager.getInt(ThemePreferences.KEY_PREF_THEME) ?? 0;
    return value;
  }

  setTheme(int value) async {
    await SharedPrefsManager.setInt(KEY_PREF_THEME, value);
  }
}
