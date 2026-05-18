import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hold_down_button/hold_down_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../routes/app_routes.dart';
import '../../services/attendance_service.dart';
import '../../services/auth_service.dart';
import '../../services/task_service.dart';
import 'profile_screen.dart';
import 'task_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AttendanceService attendanceService = AttendanceService();
  final AuthService authService = AuthService();
  final TaskService taskService = TaskService();

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

  List latestTasks = [];

  @override
  void initState() {
    super.initState();
    startClock();
    getUserData();
    getLatestTasks();
    _requestNotificationPermission();
    _startPunchReminderWatcher();
  }

  Future<void> getUserData() async {
    final name = await authService.getUserName();
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      userName = name;
      profileImage = prefs.getString("profileImage") ?? "";
    });
  }

  Future<void> getLatestTasks() async {
    final tasks = await taskService.getLatestTasks();

    if (!mounted) return;

    setState(() {
      latestTasks = tasks;
    });
  }

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

 Future<void> punchIn() async {

  // =========================
  // ALREADY PUNCHED IN
  // =========================

  if (attendanceStatus == "Present") {

    _showMessage("Already Punched In");

    return;

  }

  // =========================
  // TIME CHECK
  // =========================

  if (!_isPunchInTimeAllowed()) {

    _showMessage("Punch In allowed after 9:00 AM");

    return;

  }

  setState(() {

    isLoading = true;

  });

  try {

    // =========================
    // OFFICE RANGE CHECK
    // =========================

    final insideOffice = await _isInsideOfficeRange();

    if (!insideOffice) {

      _showMessage("You are outside office range");

      return;

    }

    // =========================
    // API CALL
    // =========================

    final response = await attendanceService.punchIn();

    final success = response["success"] != false;

    if (!mounted) return;

    setState(() {

      if (success) {

        attendanceStatus = "Present";

      }

    });

    // =========================
    // SUCCESS MESSAGE
    // =========================

    _showMessage(

      response["message"] ?? "Punch In Success",

    );

  }

  catch (error) {

    _showMessage(error.toString());

  }

  finally {

    if (mounted) {

      setState(() {

        isLoading = false;

      });

    }

  }

}

 Future<void> punchOut() async {

  // =========================
  // ALREADY PUNCHED OUT
  // =========================

  if (attendanceStatus == "Punched Out") {

    _showMessage("Already Punched Out");

    return;

  }

  // =========================
  // NOT PUNCHED IN YET
  // =========================

  if (attendanceStatus != "Present") {

    _showMessage("Please Punch In First");

    return;

  }

  setState(() {

    isLoading = true;

  });

  try {

    // =========================
    // API CALL
    // =========================

    final response = await attendanceService.punchOut();

    final success = response["success"] != false;

    if (!mounted) return;

    setState(() {

      if (success) {

        attendanceStatus = "Punched Out";

      }

    });

    // =========================
    // SUCCESS MESSAGE
    // =========================

    _showMessage(

      response["message"] ?? "Punch Out Success",

    );

  }

  catch (error) {

    _showMessage(error.toString());

  }

  finally {

    if (mounted) {

      setState(() {

        isLoading = false;

      });

    }

  }

}
bool _isPunchInTimeAllowed() {

  final now = DateTime.now();

  return now.hour >= 9;

}

  Future<Position> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
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
    print("User Lat: ${position.latitude}");

    print("User Lng: ${position.longitude}");

    print("Office Lat: $officeLat");

    print("Office Lng: $officeLng");

    print("Distance: $distance");

    return distance <= 200; // 200 meters radius
  }

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
    } catch (_) {
      // Reminder checks should never interrupt the dashboard experience.
    }
  }

  Future<void> _showPunchReminderNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "punch_in_reminder_channel",
      "Punch In Reminder",
      channelDescription: "Reminder shown when employee is near office",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        ).then((_) => getUserData());
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue,
                        backgroundImage: profileImage.isNotEmpty
                            ? FileImage(File(profileImage))
                            : null,
                        child: profileImage.isEmpty
                            ? Text(
                                userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : "E",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome Back",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userName.isEmpty ? "Employee" : userName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.adminPin);
                      },
                      icon: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.notifications);
                      },
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Current Time",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        attendanceStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                _HoldPunchInButton(isLoading: isLoading, onCompleted: punchIn),
                const SizedBox(height: 15),
                actionButton(
                  title: "Punch Out",
                  color: Colors.red,
                  icon: Icons.logout,
                  onTap: isLoading ? () {} : punchOut,
                ),
                const SizedBox(height: 35),
                const Text(
                  "Today's Tasks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                latestTasks.isEmpty
                    ? taskCard(
                        title: "No Tasks Yet",
                        status: "Waiting For Tasks",
                      )
                    : Column(
                        children: latestTasks.map((task) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: taskCard(
                              title: task["title"] ?? "Task",
                              status: task["status"] ?? "Pending",
                              task: task,
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget actionButton({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskCard({required String title, required String status, Map? task}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: status == "Completed" ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: () {
                if (task != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(task: task),
                    ),
                  );
                } else {
                  Navigator.pushNamed(context, AppRoutes.tasks);
                }
              },
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("Open", maxLines: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoldPunchInButton extends StatefulWidget {
  const _HoldPunchInButton({
    required this.isLoading,
    required this.onCompleted,
  });

  final bool isLoading;
  final VoidCallback onCompleted;

  @override
  State<_HoldPunchInButton> createState() => _HoldPunchInButtonState();
}

class _HoldPunchInButtonState extends State<_HoldPunchInButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && !_completed) {
              _completed = true;
              widget.onCompleted();
            }
          });
  }

  @override
  void didUpdateWidget(covariant _HoldPunchInButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isLoading && widget.isLoading) {
      _resetProgress();
    }
  }

  void _startProgress() {
    if (widget.isLoading) return;

    _completed = false;
    _controller.forward(from: 0);
  }

  void _resetProgress() {
    if (_completed) return;

    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HoldDownButton(
      onHoldDown: () {},
      longWait: const Duration(seconds: 1),
      middleWait: const Duration(seconds: 1),
      minWait: const Duration(seconds: 1),
      holdWait: const Duration(seconds: 1),
      child: Listener(
        onPointerDown: (_) => _startProgress(),
        onPointerUp: (_) => _resetProgress(),
        onPointerCancel: (_) => _resetProgress(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF22C55E),
                    Color(0xFF16A34A),
                    Color(0xFF047857),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x5522C55E),
                    blurRadius: 28,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 58,
                    height: 58,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _controller.value,
                          strokeWidth: 4,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            color: Color(0xFF047857),
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isLoading
                              ? "Processing..."
                              : "Hold to Punch In",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isLoading
                              ? "Verifying attendance"
                              : "Hold fingerprint for 1 second",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: widget.isLoading
                        ? const SizedBox(
                            key: ValueKey("loader"),
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.arrow_forward_rounded,
                            key: ValueKey("arrow"),
                            color: Colors.white,
                            size: 28,
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
