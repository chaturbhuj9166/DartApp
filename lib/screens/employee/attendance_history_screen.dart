import 'package:flutter/material.dart';

class AttendanceHistoryScreen
extends StatefulWidget {

  const AttendanceHistoryScreen({
    super.key,
  });

  @override
  State<AttendanceHistoryScreen>
  createState() =>
  _AttendanceHistoryScreenState();

}

class _AttendanceHistoryScreenState
extends State<AttendanceHistoryScreen> {

  // =========================
  // DUMMY DATA
  // =========================

  final List attendanceList = [

    {

      "date":
      "15 May 2026",

      "punchIn":
      "09:00 AM",

      "punchOut":
      "06:00 PM",

      "totalHours":
      "9h 0m",

      "status":
      "Present",

    },

    {

      "date":
      "14 May 2026",

      "punchIn":
      "09:15 AM",

      "punchOut":
      "06:10 PM",

      "totalHours":
      "8h 55m",

      "status":
      "Present",

    },

    {

      "date":
      "13 May 2026",

      "punchIn":
      "09:30 AM",

      "punchOut":
      "05:45 PM",

      "totalHours":
      "8h 15m",

      "status":
      "Present",

    },

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F172A),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Attendance History",

          style: TextStyle(
            color: Colors.white,
          ),

        ),

      ),

      body:

      attendanceList.isEmpty

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
          attendanceList.length,

          itemBuilder:
          (context, index) {

            final attendance =
            attendanceList[index];

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

                  // =========================
                  // TOP ROW
                  // =========================

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment
                    .spaceBetween,

                    children: [

                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(

                            "Date",

                            style: TextStyle(

                              color:
                              Colors.white54,

                              fontSize: 14,

                            ),

                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(

                            attendance["date"],

                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontSize: 20,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),

                        ],

                      ),

                      Container(

                        padding:
                        const EdgeInsets
                        .symmetric(

                          horizontal: 16,

                          vertical: 8,

                        ),

                        decoration:
                        BoxDecoration(

                          color:

                          attendance["status"]
                          ==
                          "Present"

                          ? Colors.green

                          : Colors.orange,

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
                    height: 25,
                  ),

                  // =========================
                  // PUNCH IN / OUT
                  // =========================

                  Row(

                    children: [

                      // PUNCH IN
                      Expanded(

                        child: attendanceCard(

                          title:
                          "Punch In",

                          value:
                          attendance["punchIn"],

                          icon:
                          Icons.login,

                          color:
                          Colors.green,

                        ),

                      ),

                      const SizedBox(
                        width: 15,
                      ),

                      // PUNCH OUT
                      Expanded(

                        child: attendanceCard(

                          title:
                          "Punch Out",

                          value:
                          attendance["punchOut"],

                          icon:
                          Icons.logout,

                          color:
                          Colors.red,

                        ),

                      ),

                    ],

                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // =========================
                  // TOTAL HOURS
                  // =========================

                  Container(

                    width: double.infinity,

                    padding:
                    const EdgeInsets.all(18),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.black26,

                      borderRadius:
                      BorderRadius.circular(20),

                    ),

                    child: Row(

                      children: [

                        Container(

                          padding:
                          const EdgeInsets
                          .all(12),

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.blue,

                            borderRadius:
                            BorderRadius
                            .circular(15),

                          ),

                          child: const Icon(

                            Icons.timer,

                            color:
                            Colors.white,

                          ),

                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            const Text(

                              "Total Working Hours",

                              style: TextStyle(

                                color:
                                Colors.white54,

                              ),

                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(

                              attendance["totalHours"],

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

                      ],

                    ),

                  ),

                ],

              ),

            );

          },

        ),

    );

  }

  // =========================
  // ATTENDANCE CARD
  // =========================

  Widget attendanceCard({

    required String title,

    required String value,

    required IconData icon,

    required Color color,

  }) {

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(

        color:
        Colors.black26,

        borderRadius:
        BorderRadius.circular(20),

      ),

      child: Column(

        children: [

          Container(

            padding:
            const EdgeInsets.all(12),

            decoration:
            BoxDecoration(

              color:
              color,

              borderRadius:
              BorderRadius.circular(15),

            ),

            child: Icon(

              icon,

              color:
              Colors.white,

            ),

          ),

          const SizedBox(
            height: 15,
          ),

          Text(

            title,

            style:
            const TextStyle(

              color:
              Colors.white54,

            ),

          ),

          const SizedBox(
            height: 8,
          ),

          Text(

            value,

            style:
            const TextStyle(

              color:
              Colors.white,

              fontWeight:
              FontWeight.bold,

              fontSize: 18,

            ),

          ),

        ],

      ),

    );

  }

}