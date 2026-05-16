import 'dart:convert';

import 'package:http/http.dart'
as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class AuthService {

  // =========================
  // REGISTER
  // =========================

  Future<Map<String, dynamic>>
  registerUser({

    required String name,

    required String email,

    required String password,

  }) async {

    try {

      final url = Uri.parse(

        "${ApiService.baseUrl}/auth/register",

      );

      final response =
      await http.post(

        url,

        headers: {

          "Content-Type":
          "application/json",

        },

        body: jsonEncode({

          "name": name,

          "email": email,

          "password": password,

        }),

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
  // LOGIN
  // =========================

  Future<Map<String, dynamic>>
  loginUser({

    required String email,

    required String password,

  }) async {

    try {

      final url = Uri.parse(

        "${ApiService.baseUrl}/auth/login",

      );

      final response =
      await http.post(

        url,

        headers: {

          "Content-Type":
          "application/json",

        },

        body: jsonEncode({

          "email": email,

          "password": password,

        }),

      );

      final data =
      jsonDecode(response.body);

      // SAVE USER DATA
      if(data["token"] != null){

        SharedPreferences prefs =
        await SharedPreferences
        .getInstance();

        // TOKEN
        await prefs.setString(

          "token",

          data["token"],

        );

        // USER NAME
        await prefs.setString(

          "userName",

          data["user"]["name"],

        );

        // EMAIL
        await prefs.setString(

          "userEmail",

          data["user"]["email"],

        );

        // ROLE
        await prefs.setString(

          "userRole",

          data["user"]["role"],

        );

      }

      return data;

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
  // GET USER NAME
  // =========================

  Future<String> getUserName()
  async {

    SharedPreferences prefs =
    await SharedPreferences
    .getInstance();

    return prefs.getString(
      "userName",
    ) ?? "Employee";

  }

  // =========================
  // GET USER ROLE
  // =========================

  Future<String> getUserRole()
  async {

    SharedPreferences prefs =
    await SharedPreferences
    .getInstance();

    return prefs.getString(
      "userRole",
    ) ?? "employee";

  }

  // =========================
// UPDATE PROFILE
// =========================

Future<Map<String, dynamic>>
updateProfile({

  required String name,

  required String email,

  required String profileImage,

}) async {

  try {

    String? token =
    await getToken();

    final url = Uri.parse(

      "${ApiService.baseUrl}/auth/profile",

    );

    final response =
    await http.put(

      url,

      headers: {

        "Content-Type":
        "application/json",

        "Authorization":
        "Bearer $token",

      },

      body: jsonEncode({

        "name":
        name,

        "email":
        email,

        "profileImage":
        profileImage,

      }),

    );

    final data =
    jsonDecode(response.body);

    // SAVE UPDATED DATA
    if(data["success"] == true){

      SharedPreferences prefs =
      await SharedPreferences
      .getInstance();

      // SAVE NAME
      await prefs.setString(

        "userName",

        data["user"]["name"],

      );

      // SAVE EMAIL
      await prefs.setString(

        "userEmail",

        data["user"]["email"],

      );

      // SAVE IMAGE
      await prefs.setString(

        "profileImage",

        data["user"]["profileImage"]
        ?? "",

      );

    }

    return data;

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
  // LOGOUT
  // =========================

  Future<void> logoutUser()
  async {

    SharedPreferences prefs =
    await SharedPreferences
    .getInstance();

    await prefs.clear();

  }

}