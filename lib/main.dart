import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_schemes.g.dart';
import 'pages/home_page.dart';

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
              debugShowCheckedModeBanner: false,
              title: 'National Calendar Hub',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                fontFamily: 'Urbanist',
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                fontFamily: 'Urbanist',
              ),
              home: const HomePage(),
            ));
  }
}
