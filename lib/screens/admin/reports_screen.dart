import 'package:flutter/material.dart';

import '../../services/report_service.dart';

import 'attendance_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportService reportService = ReportService();

  bool isLoading = true;

  Map reports = {};

  // =========================
  // GET REPORTS
  // =========================

  Future<void> getReports() async {
    final response = await reportService.getReports();

    if (response["success"] == true) {
      setState(() {
        reports = response["reports"];

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================
  // INIT
  // =========================

  @override
  void initState() {
    super.initState();

    getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text("Reports", style: TextStyle(color: Colors.white)),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),

              child: GridView.count(
                crossAxisCount: 2,

                childAspectRatio: 0.82,

                crossAxisSpacing: 15,

                mainAxisSpacing: 15,

                children: [
                  // USERS
                  reportCard(
                    title: "Total Users",

                    value: reports["totalUsers"].toString(),

                    color: Colors.blue,

                    icon: Icons.people,

                    onTap: () {},
                  ),

                  // ADMINS
                  reportCard(
                    title: "Admins",

                    value: reports["totalAdmins"].toString(),

                    color: Colors.purple,

                    icon: Icons.admin_panel_settings,

                    onTap: () {},
                  ),

                  // ANNOUNCEMENTS
                  reportCard(
                    title: "Total Announcements",

                    value: reports["totalAnnouncements"].toString(),

                    color: Colors.orange,

                    icon: Icons.campaign,

                    onTap: () {},
                  ),

                  // EMPLOYEES
                  reportCard(
                    title: "Employees",

                    value: reports["totalEmployees"].toString(),

                    color: Colors.green,

                    icon: Icons.people,

                    onTap: () {},
                  ),

                  // PRESENT TODAY
                  reportCard(
                    title: "Present Today",

                    value: reports["presentEmployees"].toString(),

                    color: Colors.purple,

                    icon: Icons.how_to_reg,

                    onTap: () {},
                  ),

                  // ATTENDANCE
                  reportCard(
                    title: "Attendance",

                    value: reports["totalAttendance"].toString(),

                    color: Colors.cyan,

                    icon: Icons.calendar_month,

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => const AttendanceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  // =========================
  // REPORT CARD
  // =========================

  Widget reportCard({
    required String title,

    required String value,

    required Color color,

    required IconData icon,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white10,

          borderRadius: BorderRadius.circular(25),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: color,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Icon(icon, color: Colors.white, size: 35),
            ),

            Text(
              value,

              style: const TextStyle(
                color: Colors.white,

                fontSize: 28,

                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              title,

              textAlign: TextAlign.center,

              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
