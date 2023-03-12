import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:national_calendar_hub_app/pages/main_navigation_page.dart';
import 'package:national_calendar_hub_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (BuildContext context, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'National Calendar Hub',
                  themeMode: themeProvider.themeMode,
                  theme: AppThemes.lightTheme,
                  darkTheme: AppThemes.darkTheme,
                  home: const MainNavigationPage(),
                ));
      });
}
