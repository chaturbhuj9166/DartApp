import 'dart:convert';

import 'package:http/http.dart'
as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class AttendanceService {

  // =========================
  // TOKEN
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
  // PUNCH IN
  // =========================

  Future<Map<String, dynamic>>
  punchIn() async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/attendance/punchin",

      );

      final response =
      await http.post(

        url,

        headers: {

          "Authorization":
          "Bearer $token",

        },

      );

      return jsonDecode(
        response.body,
      );

    }

    catch(error){

      return {

        "success": false,

        "message":
        error.toString(),

      };

    }

  }

  // =========================
  // PUNCH OUT
  // =========================

  Future<Map<String, dynamic>>
  punchOut() async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/attendance/punchout",

      );

      final response =
      await http.post(

        url,

        headers: {

          "Authorization":
          "Bearer $token",

        },

      );

      return jsonDecode(
        response.body,
      );

    }

    catch(error){

      return {

        "success": false,

        "message":
        error.toString(),

      };

    }

  }

  // =========================
  // TODAY ATTENDANCE
  // =========================

  Future<Map<String, dynamic>>
  getTodayAttendance()
  async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/attendance/today",

      );

      final response =
      await http.get(

        url,

        headers: {

          "Authorization":
          "Bearer $token",

        },

      );

      return jsonDecode(
        response.body,
      );

    }

    catch(error){

      return {

        "success": false,

        "message":
        error.toString(),

      };

    }

  }

  // =========================
  // GET ALL ATTENDANCE
  // =========================

  Future<Map<String, dynamic>>
  getAllAttendance()
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

      return jsonDecode(
        response.body,
      );

    }

    catch(error){

      return {

        "success": false,

        "message":
        error.toString(),

      };

    }

  }

}