import 'package:flutter/material.dart';

import '../services/task_service.dart';

class TaskProvider
extends ChangeNotifier {

  final TaskService
  taskService =
  TaskService();

  bool isLoading = false;

  List tasks = [];

  // =========================
  // GET TASKS
  // =========================

  Future<void> getTasks()
  async {

    isLoading = true;

    notifyListeners();

    final response =
    await taskService
    .getUserTasks();

    if(response["success"] == true){

      tasks =
      response["tasks"];

    }

    isLoading = false;

    notifyListeners();

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

    final response =
    await taskService.replyTask(

      taskId: taskId,

      reply: reply,

      status: status,

    );

    await getTasks();

    return response;

  }

}