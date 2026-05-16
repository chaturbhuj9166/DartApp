import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

import '../auth/login_screen.dart';

import 'attendance_screen.dart';

import 'create_task_screen.dart';

import 'manage_users_screen.dart';

import 'reports_screen.dart';

class AdminDashboard
extends StatelessWidget {

  const AdminDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final AuthService
    authService =
    AuthService();

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F172A),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Admin Dashboard",

          style: TextStyle(
            color: Colors.white,
          ),

        ),

        actions: [

          IconButton(

            onPressed: () async {

              await authService
              .logoutUser();

              Navigator.pushAndRemoveUntil(

                context,

                MaterialPageRoute(

                  builder: (context) =>
                  const LoginScreen(),

                ),

                (route) => false,

              );

            },

            icon: const Icon(

              Icons.logout,

              color: Colors.white,

            ),

          ),

        ],

      ),

      body: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // TITLE
            const Text(

              "Welcome Admin 👋",

              style: TextStyle(

                color:
                Colors.white,

                fontSize: 28,

                fontWeight:
                FontWeight.bold,

              ),

            ),

            const SizedBox(
              height: 10,
            ),

            const Text(

              "Manage employees, tasks & reports",

              style: TextStyle(

                color:
                Colors.white70,

                fontSize: 16,

              ),

            ),

            const SizedBox(
              height: 30,
            ),

            // DASHBOARD GRID
            Expanded(

              child: GridView.count(

                crossAxisCount: 2,

                crossAxisSpacing: 15,

                mainAxisSpacing: 15,

                childAspectRatio: 0.95,

                children: [

                  // CREATE TASK
                  dashboardCard(

                    context,

                    title:
                    "Create Task",

                    icon:
                    Icons.task,

                    color:
                    Colors.blue,

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const CreateTaskScreen(),

                        ),

                      );

                    },

                  ),

                  // MANAGE USERS
                  dashboardCard(

                    context,

                    title:
                    "Manage Users",

                    icon:
                    Icons.people,

                    color:
                    Colors.green,

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const ManageUsersScreen(),

                        ),

                      );

                    },

                  ),

                  // REPORTS
                  dashboardCard(

                    context,

                    title:
                    "Reports",

                    icon:
                    Icons.bar_chart,

                    color:
                    Colors.orange,

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const ReportsScreen(),

                        ),

                      );

                    },

                  ),

                  // ATTENDANCE
                  dashboardCard(

                    context,

                    title:
                    "Attendance",

                    icon:
                    Icons.calendar_month,

                    color:
                    Colors.purple,

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const AttendanceScreen(),

                        ),

                      );

                    },

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

  // =========================
  // DASHBOARD CARD
  // =========================

  Widget dashboardCard(

    BuildContext context, {

    required String title,

    required IconData icon,

    required Color color,

    required VoidCallback onTap,

  }) {

    return InkWell(

      onTap: onTap,

      borderRadius:
      BorderRadius.circular(25),

      child: Container(

        decoration: BoxDecoration(

          color:
          Colors.white10,

          borderRadius:
          BorderRadius.circular(25),

        ),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Container(

              padding:
              const EdgeInsets.all(18),

              decoration:
              BoxDecoration(

                color:
                color,

                borderRadius:
                BorderRadius.circular(20),

              ),

              child: Icon(

                icon,

                size: 40,

                color: Colors.white,

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            Text(

              title,

              style: const TextStyle(

                color:
                Colors.white,

                fontSize: 18,

                fontWeight:
                FontWeight.bold,

              ),

            ),

          ],

        ),

      ),

    );

  }

}