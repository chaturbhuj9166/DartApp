import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart'
as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_service.dart';

class AttendanceScreen
extends StatefulWidget {

  const AttendanceScreen({
    super.key,
  });

  @override
  State<AttendanceScreen>
  createState() =>
  _AttendanceScreenState();

}

class _AttendanceScreenState
extends State<AttendanceScreen> {

  List attendanceList = [];

  List filteredAttendance = [];

  bool isLoading = true;

  final TextEditingController
  searchController =
  TextEditingController();

  // =========================
  // GET TOKEN
  // =========================

  Future<String?> getToken()
  async {

    SharedPreferences prefs =
    await SharedPreferences
    .getInstance();

    return prefs.getString(
      "token",
    );

  }

  // =========================
  // GET ALL ATTENDANCE
  // =========================

  Future<void> getAttendance()
  async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/attendance/all",

      );

      final response =
      await http.get(

        url,

        headers: {

          "Authorization":
          "Bearer $token",

        },

      );

      final data =
      jsonDecode(
        response.body,
      );

      if(data["success"] == true){

        setState(() {

          attendanceList =
          data["attendance"];

          filteredAttendance =
          attendanceList;

          isLoading = false;

        });

      }

      else {

        setState(() {

          isLoading = false;

        });

      }

    }

    catch(error){

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

    getAttendance();

  }

  // =========================
  // SEARCH ATTENDANCE
  // =========================

  void searchAttendance(
    String value,
  ){

    setState(() {

      filteredAttendance =
      attendanceList.where((attendance) {

        final user =
        attendance["user"];

        return user["name"]
        .toLowerCase()
        .contains(

          value.toLowerCase(),

        );

      }).toList();

    });

  }

  // =========================
  // FORMAT DATE
  // =========================

  String formatDate(String date){

    DateTime d =
    DateTime.parse(date);

    return

    "${d.day}/${d.month}/${d.year}";

  }

  // =========================
  // FORMAT TIME
  // =========================

  String formatTime(String? date){

    if(date == null){

      return "--";

    }

    DateTime d =
    DateTime.parse(date);

    return

    "${d.hour}:${d.minute.toString().padLeft(2, '0')}";

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F172A),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        title: const Text(

          "Attendance",

          style: TextStyle(
            color: Colors.white,
          ),

        ),

        centerTitle: true,

      ),

      body:

      isLoading

      ? const Center(

          child:
          CircularProgressIndicator(),

        )

      : Column(

          children: [

            // SEARCH
            Padding(

              padding:
              const EdgeInsets.all(15),

              child: TextField(

                controller:
                searchController,

                onChanged:
                searchAttendance,

                style:
                const TextStyle(

                  color:
                  Colors.white,

                ),

                decoration:
                InputDecoration(

                  hintText:
                  "Search Employee",

                  hintStyle:
                  const TextStyle(

                    color:
                    Colors.white54,

                  ),

                  prefixIcon:
                  const Icon(

                    Icons.search,

                    color:
                    Colors.white,

                  ),

                  filled: true,

                  fillColor:
                  Colors.white10,

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(20),

                    borderSide:
                    BorderSide.none,

                  ),

                ),

              ),

            ),

            // TOTAL RECORDS
            Padding(

              padding:
              const EdgeInsets.symmetric(

                horizontal: 20,

              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Text(

                    "Total Records: ${filteredAttendance.length}",

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize: 16,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                  IconButton(

                    onPressed:
                    getAttendance,

                    icon: const Icon(

                      Icons.refresh,

                      color:
                      Colors.white,

                    ),

                  ),

                ],

              ),

            ),

            // LIST
            Expanded(

              child:

              filteredAttendance.isEmpty

              ? const Center(

                  child: Text(

                    "No Attendance Found",

                    style: TextStyle(
                      color: Colors.white,
                    ),

                  ),

                )

              : ListView.builder(

                  padding:
                  const EdgeInsets.all(20),

                  itemCount:
                  filteredAttendance.length,

                  itemBuilder:
                  (context, index) {

                    final attendance =
                    filteredAttendance[index];

                    final user =
                    attendance["user"];

                    return Container(

                      margin:
                      const EdgeInsets.only(
                        bottom: 20,
                      ),

                      padding:
                      const EdgeInsets.all(20),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white10,

                        borderRadius:
                        BorderRadius.circular(25),

                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          // TOP ROW
                          Row(

                            children: [

                              CircleAvatar(

                                radius: 28,

                                backgroundColor:
                                Colors.blue,

                                child: Text(

                                  user["name"][0]
                                  .toUpperCase(),

                                  style:
                                  const TextStyle(

                                    color:
                                    Colors.white,

                                    fontSize: 22,

                                    fontWeight:
                                    FontWeight.bold,

                                  ),

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

                                    Text(

                                      user["name"],

                                      style:
                                      const TextStyle(

                                        color:
                                        Colors.white,

                                        fontSize: 22,

                                        fontWeight:
                                        FontWeight.bold,

                                      ),

                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(

                                      user["email"],

                                      style:
                                      const TextStyle(

                                        color:
                                        Colors.white70,

                                      ),

                                    ),

                                  ],

                                ),

                              ),

                              Container(

                                padding:
                                const EdgeInsets.symmetric(

                                  horizontal: 14,

                                  vertical: 8,

                                ),

                                decoration:
                                BoxDecoration(

                                  color:

                                  attendance["status"] == "Present"

                                  ? Colors.green

                                  : Colors.red,

                                  borderRadius:
                                  BorderRadius.circular(20),

                                ),

                                child: Text(

                                  attendance["status"],

                                  style:
                                  const TextStyle(

                                    color:
                                    Colors.white,

                                    fontWeight:
                                    FontWeight.bold,

                                  ),

                                ),

                              ),

                            ],

                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // DATE
                          attendanceRow(

                            Icons.calendar_month,

                            "Date",

                            formatDate(
                              attendance["date"],
                            ),

                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          // PUNCH IN
                          attendanceRow(

                            Icons.login,

                            "Punch In",

                            formatTime(
                              attendance["punchInTime"],
                            ),

                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          // PUNCH OUT
                          attendanceRow(

                            Icons.logout,

                            "Punch Out",

                            formatTime(
                              attendance["punchOutTime"],
                            ),

                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          // WORKING HOURS
                          attendanceRow(

                            Icons.timer,

                            "Working Hours",

                            attendance["totalHours"],

                          ),

                        ],

                      ),

                    );

                  },

                ),

            ),

          ],

        ),

    );

  }

  // =========================
  // ATTENDANCE ROW
  // =========================

  Widget attendanceRow(

    IconData icon,

    String title,

    String value,

  ) {

    return Row(

      children: [

        Icon(

          icon,

          color:
          Colors.white,

        ),

        const SizedBox(
          width: 12,
        ),

        Text(

          "$title : ",

          style:
          const TextStyle(

            color:
            Colors.white,

            fontWeight:
            FontWeight.bold,

          ),

        ),

        Expanded(

          child: Text(

            value,

            overflow:
            TextOverflow.ellipsis,

            style:
            const TextStyle(

              color:
              Colors.white70,

            ),

          ),

        ),

      ],

    );

  }

}