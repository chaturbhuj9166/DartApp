import 'package:flutter/material.dart';

import '../services/attendance_service.dart';

class AttendanceProvider
extends ChangeNotifier {

  final AttendanceService
  attendanceService =
  AttendanceService();

  bool isLoading = false;

  Map<String, dynamic>? attendance;

  // TODAY ATTENDANCE
  Future<void>
  getTodayAttendance()
  async {

    isLoading = true;

    notifyListeners();

    final response =
      await attendanceService
      .getTodayAttendance();

    if(response["success"] == true){

      attendance =
      response["attendance"];

    }

    isLoading = false;

    notifyListeners();

  }

  // PUNCH IN
  Future<Map<String, dynamic>>
  punchIn() async {

    final response =
      await attendanceService
      .punchIn();

    notifyListeners();

    return response;
  }

  // PUNCH OUT
  Future<Map<String, dynamic>>
  punchOut() async {

    final response =
      await attendanceService
      .punchOut();

    notifyListeners();

    return response;
  }

}