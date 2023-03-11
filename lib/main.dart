import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:national_calendar_hub_app/pages/main_navigation_page.dart';
import 'color_schemes.g.dart';
import 'pages/details/details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (BuildContext context, child) => MaterialApp(
              routes: {
                DetailsPage.routeName: (context) => const DetailsPage(),
              },
              debugShowCheckedModeBanner: false,
              title: 'National Calendar Hub',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                fontFamily: 'Urbanist',
                textTheme: TextTheme(
                    bodyMedium: TextStyle(
                      color: lightColorScheme.primary
                    )
                )
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                fontFamily: 'Urbanist',
              ),
              home: const MainNavigationPage(),
            ));
  }
}
