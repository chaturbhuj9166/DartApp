import 'dart:convert';

import 'package:http/http.dart'
as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class UserService {

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
  // GET USERS
  // =========================

  Future<Map<String, dynamic>>
  getUsers()
  async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/auth/users",

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
  // DELETE USER
  // =========================

  Future<Map<String, dynamic>>
  deleteUser(String id)
  async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/auth/users/$id",

      );

      final response =
      await http.delete(

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