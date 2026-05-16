import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart'
as tz;

import 'routes/app_routes.dart';

import 'theme/app_theme.dart';

// =========================
// NOTIFICATION PLUGIN
// =========================

final FlutterLocalNotificationsPlugin
flutterLocalNotificationsPlugin =

FlutterLocalNotificationsPlugin();

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // =========================
  // TIMEZONE INIT
  // =========================

  tz.initializeTimeZones();

  // =========================
  // ANDROID SETTINGS
  // =========================

  const AndroidInitializationSettings
  androidSettings =

  AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  // =========================
  // INIT SETTINGS
  // =========================

  const InitializationSettings
  initializationSettings =

  InitializationSettings(

    android:
    androidSettings,

  );

  // =========================
  // INIT NOTIFICATION
  // =========================

  await flutterLocalNotificationsPlugin
  .initialize(

    initializationSettings,

  );

  // =========================
  // RUN APP
  // =========================

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