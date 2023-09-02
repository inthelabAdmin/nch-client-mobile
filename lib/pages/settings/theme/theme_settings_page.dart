import 'package:flutter/material.dart';
import 'package:national_calendar_hub_app/models/theme_settings.dart';
import 'package:national_calendar_hub_app/provider/theme_provider.dart';
import 'package:national_calendar_hub_app/storage/shared_preferences_manager.dart';
import 'package:provider/provider.dart';
import 'theme_prefereneces.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({Key? key}) : super(key: key);

  static Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ThemeSettingsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  ThemePreferences themePreferences = ThemePreferences();
  ThemeSetting? _themeSetting;

  @override
  void initState() {
    super.initState();
    _fetchSavedTheme();
  }

  Future<void> _fetchSavedTheme() async {
    int savedTheme =
        await SharedPrefsManager.getInt(ThemePreferences.keyPrefTheme) ?? 0;

    setState(() {
      switch (savedTheme) {
        case 1:
          _themeSetting = ThemeSetting.light;
          break;
        case 2:
          _themeSetting = ThemeSetting.dark;
          break;
        default:
          _themeSetting = ThemeSetting.system;
      }
    });
  }

  Future<void> _saveThemeToPreferences() async {
    final value = _themeSetting?.index ?? 0;
    themePreferences.setTheme(value);
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    provider.setTheme(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text("Theme"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: const Text('System'),
                leading: Radio<ThemeSetting>(
                  value: ThemeSetting.system,
                  groupValue: _themeSetting,
                  onChanged: (ThemeSetting? value) {
                    setState(() {
                      _themeSetting = value;
                    });
                    _saveThemeToPreferences();
                  },
                ),
              ),
              ListTile(
                title: const Text('Light'),
                leading: Radio<ThemeSetting>(
                  value: ThemeSetting.light,
                  groupValue: _themeSetting,
                  onChanged: (ThemeSetting? value) {
                    setState(() {
                      _themeSetting = value;
                    });
                    _saveThemeToPreferences();
                  },
                ),
              ),
              ListTile(
                title: const Text('Dark'),
                leading: Radio<ThemeSetting>(
                  value: ThemeSetting.dark,
                  groupValue: _themeSetting,
                  onChanged: (ThemeSetting? value) {
                    setState(() {
                      _themeSetting = value;
                    });
                    _saveThemeToPreferences();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
