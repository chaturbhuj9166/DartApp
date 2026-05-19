import 'dart:convert';

import 'package:http/http.dart'
as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class AnnouncementService {

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
  // GET ANNOUNCEMENTS
  // =========================

  Future<Map<String, dynamic>>
  getAnnouncements()
  async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/announcements/user",

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
  // GET LATEST ANNOUNCEMENTS
  // =========================

  Future<List>
  getLatestAnnouncements()
  async {

    try {

      final response =
      await getAnnouncements();

      if(response["success"] == true){

        List announcements =
        response["announcements"] ?? [];

        return announcements
        .take(2)
        .toList();

      }

      return [];

    }

    catch(error){

      return [];

    }

  }

  // =========================
  // REPLY ANNOUNCEMENT
  // =========================

  Future<Map<String, dynamic>>
  replyAnnouncement({

    required String announcementId,

    required String reply,

    required String status,

  }) async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/announcements/reply",

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

          "announcementId":
          announcementId,

          "reply":
          reply,

          "status":
          status,

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
  // CREATE ANNOUNCEMENT
  // =========================

  Future<Map<String, dynamic>>
  createAnnouncement({

    required String title,

    required String description,

    required String assignedTo,

    required bool sendToAll,

  }) async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/announcements/create",

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

          "title":
          title,

          "description":
          description,

          "assignedTo":
          assignedTo,

          "sendToAll":
          sendToAll,

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
  // MARK AS SEEN
  // =========================

  Future<Map<String, dynamic>>
  markAsSeen(
    String id,
  ) async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/announcements/seen/$id",

      );

      final response =
      await http.put(

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