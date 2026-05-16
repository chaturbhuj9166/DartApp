import 'dart:convert';

import 'package:http/http.dart'
as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class TaskService {

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
  // GET USER TASKS
  // =========================

  Future<Map<String, dynamic>>
  getUserTasks()
  async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/tasks/user",

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
  // GET LATEST TASKS
  // =========================

  Future<List>
  getLatestTasks()
  async {

    try {

      final response =
      await getUserTasks();

      if(response["success"] == true){

        List tasks =
        response["tasks"] ?? [];

        // LATEST 2 TASKS
        return tasks.take(2).toList();

      }

      return [];

    }

    catch(error){

      return [];

    }

  }

  // =========================
  // REPLY TASK
  // =========================

  Future<Map<String, dynamic>>
  replyTask({

    required String taskId,

    required String reply,

    required String status,

  }) async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/tasks/reply",

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

          "taskId":
          taskId,

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
  // CREATE TASK
  // =========================

  Future<Map<String, dynamic>>
  createTask({

    required String title,

    required String description,

    required String assignedTo,

    required String dueDate,

  }) async {

    try {

      String? token =
      await getToken();

      final url = Uri.parse(

        "${ApiService.baseUrl}/tasks/create",

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

          "dueDate":
          dueDate,

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

}