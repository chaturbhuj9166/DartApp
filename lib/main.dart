import 'package:flutter/material.dart';

import 'routes/app_routes.dart';

import 'theme/app_theme.dart';

void main() {

  runApp(
    const MyApp(),
  );

}

class MyApp
extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner:
      false,

      title:
      "PunchIn Pro",

      // =========================
      // THEME
      // =========================

      theme:
      AppTheme.lightTheme,

      darkTheme:
      AppTheme.darkTheme,

      themeMode:
      ThemeMode.dark,

      // =========================
      // ROUTES
      // =========================

      initialRoute:
      AppRoutes.splash,

      routes:
      AppRoutes.routes,

    );

  }

}