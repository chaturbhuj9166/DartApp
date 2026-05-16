import 'dart:convert';

import 'package:http/http.dart'
as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class ReportService {

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
  // GET REPORTS
  // =========================

  Future<Map<String, dynamic>>
  getReports()
  async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/reports",

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