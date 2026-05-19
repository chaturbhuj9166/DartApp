import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'routes/app_routes.dart';

import 'theme/app_theme.dart';

// =========================
// NOTIFICATION PLUGIN
// =========================

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((message) async {
    final notification = message.notification;
    if (notification != null) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'fcm_channel',
            'FCM Notifications',
            importance: Importance.max,
            priority: Priority.high,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
      );
    }
  });

  // =========================
  // TIMEZONE INIT
  // =========================

  tz.initializeTimeZones();

  // =========================
  // ANDROID SETTINGS
  // =========================

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // =========================
  // INIT SETTINGS
  // =========================

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
  );

  // =========================
  // INIT NOTIFICATION
  // =========================

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // =========================
  // RUN APP
  // =========================

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "PunchIn Pro",

      // =========================
      // THEME
      // =========================
      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: ThemeMode.dark,

      // =========================
      // ROUTES
      // =========================
      initialRoute: AppRoutes.splash,

      routes: AppRoutes.routes,
    );
  }
}
