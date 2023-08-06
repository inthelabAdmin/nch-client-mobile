import 'package:national_calendar_hub_app/storage/shared_preferences_manager.dart';

class ThemePreferences {
  static const keyPrefTheme = "KEY_PREF_THEME";

getTheme() async {
    final value =
        await SharedPrefsManager.getInt(ThemePreferences.keyPrefTheme) ?? 0;
    return value;
  }

  setTheme(int value) async {
    await SharedPrefsManager.setInt(keyPrefTheme, value);
  }
}
