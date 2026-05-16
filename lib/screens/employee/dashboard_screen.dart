import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../services/attendance_service.dart';

import '../../services/auth_service.dart';

import '../../services/task_service.dart';

import '../../routes/app_routes.dart';

import 'task_detail_screen.dart';

import 'profile_screen.dart';

class DashboardScreen
extends StatefulWidget {

  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen>
  createState() =>
  _DashboardScreenState();

}

class _DashboardScreenState
extends State<DashboardScreen> {

  final AttendanceService
  attendanceService =
  AttendanceService();

  final AuthService
  authService =
  AuthService();

  final TaskService
  taskService =
  TaskService();

  bool isLoading = false;

  String attendanceStatus =
  "Not Punched In";

  String currentTime = "";

  String userName = "Employee";

  String profileImage = "";

  Timer? timer;

  List latestTasks = [];

  // =========================
  // INIT STATE
  // =========================

  @override
  void initState() {

    super.initState();

    startClock();

    getUserData();

    getLatestTasks();

  }

  // =========================
  // GET USER DATA
  // =========================

  Future<void> getUserData()
  async {

    String name =
    await authService
    .getUserName();

    SharedPreferences prefs =
    await SharedPreferences
    .getInstance();

    if(!mounted) return;

    setState(() {

      userName = name;

      profileImage =
      prefs.getString(
        "profileImage",
      ) ?? "";

    });

  }

  // =========================
  // GET LATEST TASKS
  // =========================

  Future<void> getLatestTasks()
  async {

    final tasks =
    await taskService
    .getLatestTasks();

    if(!mounted) return;

    setState(() {

      latestTasks =
      tasks;

    });

  }

  // =========================
  // CLOCK
  // =========================

  void startClock() {

    updateClock();

    timer = Timer.periodic(

      const Duration(seconds: 1),

      (timer) {

        updateClock();

      },

    );

  }

  void updateClock() {

    final now = DateTime.now();

    if(!mounted) return;

    setState(() {

      currentTime =

      "${now.hour.toString().padLeft(2, '0')}:"
      "${now.minute.toString().padLeft(2, '0')}:"
      "${now.second.toString().padLeft(2, '0')}";

    });

  }

  // =========================
  // PUNCH IN
  // =========================



void punchIn() async {

  // =========================
  // TIME CHECK
  // =========================

  final now = DateTime.now();

  // BLOCK BEFORE 9 AM
  if(now.hour < 9){

    ScaffoldMessenger.of(context)
    .showSnackBar(

      const SnackBar(

        content: Text(

          "Punch In allowed after 9:00 AM",

        ),

      ),

    );

    return;

  }

  try {

    setState(() {

      isLoading = true;

    });

    // API CALL
    final response =
    await attendanceService
    .punchIn();

    if(!mounted) return;

    setState(() {

      isLoading = false;

      attendanceStatus =
      "Present";

    });

    // SUCCESS MESSAGE
    ScaffoldMessenger.of(context)
    .showSnackBar(

      SnackBar(

        content: Text(

          response["message"]
          ?? "Punch In Success",

        ),

      ),

    );

  }

  catch(e){

    if(!mounted) return;

    setState(() {

      isLoading = false;

    });

    // ERROR MESSAGE
    ScaffoldMessenger.of(context)
    .showSnackBar(

      SnackBar(

        content: Text(
          e.toString(),
        ),

      ),

    );

  }

}
  // =========================
  // PUNCH OUT
  // =========================

  void punchOut() async {

    try {

      setState(() {

        isLoading = true;

      });

      final response =
      await attendanceService
      .punchOut();

      if(!mounted) return;

      setState(() {

        isLoading = false;

      });

      ScaffoldMessenger.of(context)
      .showSnackBar(

        SnackBar(

          content: Text(

            response["message"]
            ?? "Punch Out Success",

          ),

        ),

      );

    }

    catch(e){

      if(!mounted) return;

      setState(() {

        isLoading = false;

      });

    }

  }

  // =========================
  // LOGOUT
  // =========================

  void logout() async {

    await authService
    .logoutUser();

    if(!mounted) return;

    Navigator.pushNamedAndRemoveUntil(

      context,

      AppRoutes.login,

      (route) => false,

    );

  }

  @override
  void dispose() {

    timer?.cancel();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F172A),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
            const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // =========================
                // HEADER
                // =========================

                Row(

                  children: [

                    // PROFILE IMAGE
                    GestureDetector(

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (context) =>

                            const ProfileScreen(),

                          ),

                        ).then((_) {

                          getUserData();

                        });

                      },

                      child: CircleAvatar(

                        radius: 28,

                        backgroundColor:
                        Colors.blue,

                        backgroundImage:

                        profileImage.isNotEmpty

                        ? FileImage(
                            File(profileImage),
                          )

                        : null,

                        child:

                        profileImage.isEmpty

                        ? Text(

                            userName.isNotEmpty

                            ? userName[0]
                            .toUpperCase()

                            : "E",

                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          )

                        : null,

                      ),

                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(

                            "Welcome Back 👋",

                            maxLines: 1,

                            overflow:
                            TextOverflow.ellipsis,

                            style: TextStyle(

                              color:
                              Colors.white70,

                              fontSize: 14,

                            ),

                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(

                            userName.isEmpty
                            ? "Employee"
                            : userName,

                            overflow:
                            TextOverflow.ellipsis,

                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontSize: 22,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),

                        ],

                      ),

                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    // ADMIN BUTTON
                    IconButton(

                      onPressed: () {

                        Navigator.pushNamed(

                          context,

                          AppRoutes.adminPin,

                        );

                      },

                      icon: const Icon(

                        Icons.admin_panel_settings,

                        color: Colors.white,

                      ),

                    ),

                    // NOTIFICATION BUTTON
                    IconButton(

                      onPressed: () {

                        Navigator.pushNamed(

                          context,

                          AppRoutes.notifications,

                        );

                      },

                      icon: const Icon(

                        Icons.notifications,

                        color: Colors.white,

                      ),

                    ),

                    // LOGOUT BUTTON
                    IconButton(

                      onPressed: logout,

                      icon: const Icon(

                        Icons.logout,

                        color: Colors.white,

                      ),

                    ),

                  ],

                ),

                const SizedBox(
                  height: 30,
                ),

                // CLOCK CARD
                Container(

                  width: double.infinity,

                  padding:
                  const EdgeInsets.all(25),

                  decoration:
                  BoxDecoration(

                    gradient:
                    const LinearGradient(

                      colors: [

                        Color(0xFF2563EB),

                        Color(0xFF06B6D4),

                      ],

                    ),

                    borderRadius:
                    BorderRadius.circular(30),

                  ),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Text(

                        "Current Time",

                        style: TextStyle(

                          color:
                          Colors.white70,

                          fontSize: 16,

                        ),

                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(

                        currentTime,

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style:
                        const TextStyle(

                          color:
                          Colors.white,

                          fontSize: 40,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Text(

                        attendanceStatus,

                        style:
                        const TextStyle(

                          color:
                          Colors.white,

                          fontSize: 18,

                        ),

                      ),

                    ],

                  ),

                ),

                const SizedBox(
                  height: 30,
                ),

                // BUTTONS
                Row(

                  children: [

                    Expanded(

                      child: actionButton(

                        title:
                        "Punch In",

                        color:
                        Colors.green,

                        icon:
                        Icons.login,

                        onTap:
                        isLoading

                        ? () {}

                        : punchIn,

                      ),

                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    Expanded(

                      child: actionButton(

                        title:
                        "Punch Out",

                        color:
                        Colors.red,

                        icon:
                        Icons.logout,

                        onTap:
                        isLoading

                        ? () {}

                        : punchOut,

                      ),

                    ),

                  ],

                ),

                const SizedBox(
                  height: 35,
                ),

                // TASK TITLE
                const Text(

                  "Today's Tasks",

                  style: TextStyle(

                    color:
                    Colors.white,

                    fontSize: 24,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

                const SizedBox(
                  height: 20,
                ),

                // REAL TASKS
                latestTasks.isEmpty

                ? taskCard(

                    title:
                    "No Tasks Yet",

                    status:
                    "Waiting For Tasks",

                  )

                : Column(

                    children:

                    latestTasks.map((task) {

                      return Padding(

                        padding:
                        const EdgeInsets.only(
                          bottom: 15,
                        ),

                        child: taskCard(

                          title:
                          task["title"]
                          ?? "Task",

                          status:
                          task["status"]
                          ?? "Pending",

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

  // ACTION BUTTON
  Widget actionButton({

    required String title,

    required Color color,

    required IconData icon,

    required VoidCallback onTap,

  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding:
        const EdgeInsets.symmetric(

          vertical: 22,

        ),

        decoration:
        BoxDecoration(

          color:
          color,

          borderRadius:
          BorderRadius.circular(25),

        ),

        child: Column(

          children: [

            Icon(

              icon,

              color:
              Colors.white,

              size: 30,

            ),

            const SizedBox(
              height: 10,
            ),

            FittedBox(

              fit:
              BoxFit.scaleDown,

              child: Text(

                title,

                maxLines: 1,

                overflow:
                TextOverflow.ellipsis,

                style:
                const TextStyle(

                  color:
                  Colors.white,

                  fontWeight:
                  FontWeight.bold,

                  fontSize: 18,

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

  // TASK CARD
  Widget taskCard({

    required String title,

    required String status,

    Map? task,

  }) {

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration:
      BoxDecoration(

        color:
        Colors.white10,

        borderRadius:
        BorderRadius.circular(25),

      ),

      child: Row(

        children: [

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  maxLines: 2,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  const TextStyle(

                    color:
                    Colors.white,

                    fontSize: 18,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

                const SizedBox(
                  height: 8,
                ),

                Text(

                  status,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  TextStyle(

                    color:

                    status == "Completed"

                    ? Colors.green

                    : Colors.orange,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

              ],

            ),

          ),

          const SizedBox(
            width: 10,
          ),

          SizedBox(

            width: 90,

            height: 45,

            child: ElevatedButton(

              style:
              ElevatedButton.styleFrom(

                minimumSize:
                const Size(
                  0,
                  40,
                ),

                padding:
                const EdgeInsets.symmetric(

                  horizontal: 12,

                ),

              ),

              onPressed: () {

                if(task != null){

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (context) =>

                      TaskDetailScreen(

                        task: task,

                      ),

                    ),

                  );

                }

                else {

                  Navigator.pushNamed(

                    context,

                    AppRoutes.tasks,

                  );

                }

              },

              child: const FittedBox(

                fit:
                BoxFit.scaleDown,

                child: Text(

                  "Open",

                  maxLines: 1,

                ),

              ),

            ),

          ),

        ],

      ),

    );

  }

}