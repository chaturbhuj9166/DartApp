import 'dart:convert';

import 'package:http/http.dart'
as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class AdminService {

  // GET TOKEN
  Future<String?> getToken()
  async {

    SharedPreferences prefs =
    await SharedPreferences
    .getInstance();

    return prefs.getString(
      "token",
    );

  }

  // VERIFY ADMIN PIN
  Future<Map<String, dynamic>>
  verifyAdminPin({

    required String pin,

  }) async {

    String? token =
    await getToken();

    final url = Uri.parse(

      "${ApiService.baseUrl}/auth/admin-access",

    );

    final response =
    await http.post(

      url,

      headers: {

        "Content-Type":
        "application/json",

        "Authorization":
        "Bearer $token",

      },

      body: jsonEncode({

        "pin": pin,

      }),

    );

    return jsonDecode(
      response.body,
    );

  }

}