import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../routes/app_routes.dart';

import '../../services/attendance_service.dart';
import '../../services/auth_service.dart';
import '../../services/announcement_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AttendanceService attendanceService = AttendanceService();

  final AuthService authService = AuthService();

  final AnnouncementService announcementService = AnnouncementService();

  final double officeLat = 26.942596;

  final double officeLng = 75.726550;

  bool isLoading = false;

  bool reminderShown = false;

  String attendanceStatus = "Not Punched In";

  String currentTime = "";

  String userName = "Employee";

  String profileImage = "";

  Timer? timer;

  Timer? reminderTimer;

  List latestAnnouncements = [];

  @override
  void initState() {
    super.initState();

    reminderShown = false;

    startClock();

    getUserData();

    getLatestAnnouncements();

    getTodayAttendance();

    _requestNotificationPermission();

    _startPunchReminderWatcher();
  }

  // =====================================
  // USER DATA
  // =====================================

  Future<void> getUserData() async {
    final name = await authService.getUserName();

    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      userName = name;

      profileImage = prefs.getString("profileImage") ?? "";
    });
  }

  // =====================================
  // GET ANNOUNCEMENTS
  // =====================================

  Future<void> getLatestAnnouncements() async {
    final announcements = await announcementService.getLatestAnnouncements();

    if (!mounted) return;

    setState(() {
      latestAnnouncements = announcements;
    });
  }

  // =====================================
  // GET ATTENDANCE
  // =====================================

  Future<void> getTodayAttendance() async {
    try {
      final response = await attendanceService.getTodayAttendance();

      final attendance = response["attendance"];

      if (!mounted) return;

      setState(() {
        if (attendance == null) {
          attendanceStatus = "Not Punched In";
        } else if (attendance["punchOutTime"] == null) {
          attendanceStatus = "Present";
        } else {
          attendanceStatus = "Punched Out";
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        attendanceStatus = "Not Punched In";
      });
    }
  }

  // =====================================
  // CLOCK
  // =====================================

  void startClock() {
    updateClock();

    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateClock());
  }

  void updateClock() {
    final now = DateTime.now();

    if (!mounted) return;

    setState(() {
      currentTime =
          "${now.hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')}:"
          "${now.second.toString().padLeft(2, '0')}";
    });
  }

  // =====================================
  // PUNCH IN
  // =====================================

  Future<void> punchIn() async {
    if (attendanceStatus == "Present") {
      _showMessage("Already Punched In");

      return;
    }

    if (!_isPunchInTimeAllowed()) {
      _showMessage("Punch In allowed after 9:00 AM");

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final insideOffice = await _isInsideOfficeRange();

      if (!insideOffice) {
        _showMessage("You are outside office range");

        return;
      }

      final response = await attendanceService.punchIn();

      final success = response["success"] != false;

      if (!mounted) return;

      if (success) {
        await getTodayAttendance();
      }

      _showMessage(response["message"] ?? "Punch In Success");
    } catch (error) {
      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =====================================
  // PUNCH OUT
  // =====================================

  Future<void> punchOut() async {
    if (attendanceStatus == "Punched Out") {
      _showMessage("Already Punched Out");

      return;
    }

    if (attendanceStatus != "Present") {
      _showMessage("Please Punch In First");

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await attendanceService.punchOut();

      final success = response["success"] != false;

      if (!mounted) return;

      if (success) {
        await getTodayAttendance();
      }

      _showMessage(response["message"] ?? "Punch Out Success");
    } catch (error) {
      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =====================================
  // TIME CHECK
  // =====================================

  bool _isPunchInTimeAllowed() {
    final now = DateTime.now();

    return now.hour >= 9 && now.hour < 19;
  }

  // =====================================
  // LOCATION
  // =====================================

  Future<Position> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<bool> _isInsideOfficeRange() async {
    final position = await _getCurrentPosition();

    final distance = Geolocator.distanceBetween(
      position.latitude,

      position.longitude,

      officeLat,

      officeLng,
    );

    return distance <= 300;
  }

  // =====================================
  // REMINDER
  // =====================================

  void _startPunchReminderWatcher() {
    checkPunchReminder();

    reminderTimer = Timer.periodic(
      const Duration(minutes: 1),

      (_) => checkPunchReminder(),
    );
  }

  Future<void> checkPunchReminder() async {
    final now = DateTime.now();

    if (now.hour != 10 || now.minute > 5 || reminderShown) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final todayKey = _dateKey(now);

    if (prefs.getString("lastPunchReminderDate") == todayKey) {
      reminderShown = true;

      return;
    }

    try {
      final insideOffice = await _isInsideOfficeRange();

      if (!insideOffice) return;

      reminderShown = true;

      await prefs.setString("lastPunchReminderDate", todayKey);

      await _showPunchReminderNotification();
    } catch (_) {}
  }

  Future<void> _showPunchReminderNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "punch_in_reminder_channel",

      "Punch In Reminder",

      channelDescription: "Reminder shown near office",

      importance: Importance.high,

      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      1001,

      "Punch In Reminder",

      "You are near office. Please Punch In.",

      notificationDetails,
    );
  }

  Future<void> _requestNotificationPermission() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();
  }

  String _dateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  // =====================================
  // LOGOUT
  // =====================================

  void logout() async {
    await authService.logoutUser();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,

      AppRoutes.login,

      (route) => false,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    timer?.cancel();

    reminderTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      body: const Center(
        child: Text(
          "Dashboard Ready ✅",

          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
