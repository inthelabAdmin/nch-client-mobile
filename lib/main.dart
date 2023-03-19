import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:national_calendar_hub_app/pages/details/details.dart';
import 'package:national_calendar_hub_app/pages/main_navigation_page.dart';
import 'package:national_calendar_hub_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'pages/settings/theme/theme_settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  final themeProvider = ThemeProvider();
  await themeProvider.fetchSavedTheme();
  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.themeProvider});

  final ThemeProvider themeProvider;
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainNavigationPage(),
        routes: [
          GoRoute(
              path: 'details/:id',
              builder: (context, state) =>
                  DetailsPage(id: state.params['id'].toString()),
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                      state: state,
                      context: context,
                      child: DetailsPage(id: state.params['id'].toString()))),
          GoRoute(
              path: 'themeSettings',
              builder: (context, state) => const ThemeSettingsPage(),
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                      state: state,
                      context: context,
                      child: const ThemeSettingsPage()))
        ],
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => themeProvider,
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'National Calendar Hub',
          themeMode: themeProvider.themeMode,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          routerConfig: _router,
        );
      });
}

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      });
}
