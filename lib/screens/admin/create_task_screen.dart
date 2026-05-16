import 'package:flutter/material.dart';

import '../../services/task_service.dart';

import '../../services/user_service.dart';

class CreateTaskScreen
extends StatefulWidget {

  const CreateTaskScreen({
    super.key,
  });

  @override
  State<CreateTaskScreen>
  createState() =>
  _CreateTaskScreenState();

}

class _CreateTaskScreenState
extends State<CreateTaskScreen> {

  final TextEditingController
  titleController =
  TextEditingController();

  final TextEditingController
  descriptionController =
  TextEditingController();

  final TextEditingController
  dueDateController =
  TextEditingController();

  final TaskService
  taskService =
  TaskService();

  final UserService
  userService =
  UserService();

  List users = [];

  Map? selectedUser;

  bool isLoading = false;

  // =========================
  // GET USERS
  // =========================

  Future<void> getUsers()
  async {

    final response =
    await userService
    .getUsers();

    if(response["success"] == true){

      setState(() {

        users =
        response["users"];

      });

    }

  }

  // =========================
  // INIT
  // =========================

  @override
  void initState() {

    super.initState();

    getUsers();

  }

  // =========================
  // SELECT DATE
  // =========================

  Future<void> selectDate()
  async {

    DateTime? pickedDate =
    await showDatePicker(

      context: context,

      firstDate:
      DateTime.now(),

      lastDate:
      DateTime(2030),

      initialDate:
      DateTime.now(),

    );

    if(pickedDate != null){

      dueDateController.text =
      pickedDate.toIso8601String();

      setState(() {});

    }

  }

  // =========================
  // CREATE TASK
  // =========================

  Future<void> createTask()
  async {

    if(

      titleController.text.isEmpty ||

      descriptionController
      .text
      .isEmpty ||

      selectedUser == null ||

      dueDateController
      .text
      .isEmpty

    ){

      ScaffoldMessenger.of(context)
      .showSnackBar(

        const SnackBar(

          content: Text(
            "Please fill all fields",
          ),

        ),

      );

      return;

    }

    setState(() {

      isLoading = true;

    });

    final response =
    await taskService.createTask(

      title:
      titleController.text.trim(),

      description:
      descriptionController
      .text
      .trim(),

      assignedTo:
      selectedUser!["_id"],

      dueDate:
      dueDateController.text,

    );

    setState(() {

      isLoading = false;

    });

    ScaffoldMessenger.of(context)
    .showSnackBar(

      SnackBar(

        content: Text(
          response["message"],
        ),

      ),

    );

    if(response["success"] == true){

      Navigator.pop(context);

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Create Task",
        ),

      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller:
              titleController,

              decoration:
              const InputDecoration(

                labelText:
                "Task Title",

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            TextField(

              controller:
              descriptionController,

              maxLines: 5,

              decoration:
              const InputDecoration(

                labelText:
                "Task Description",

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            DropdownButtonFormField(

              value:
              selectedUser,

              items:

              users.map((user) {

                return DropdownMenuItem(

                  value: user,

                  child: Text(
                    user["name"],
                  ),

                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  selectedUser =
                  value as Map;

                });

              },

              decoration:
              const InputDecoration(

                labelText:
                "Assign User",

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            TextField(

              controller:
              dueDateController,

              readOnly: true,

              onTap: selectDate,

              decoration:
              const InputDecoration(

                labelText:
                "Due Date",

                suffixIcon:
                Icon(Icons.calendar_month),

              ),

            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed:

                isLoading
                ? null
                : createTask,

                child:

                isLoading

                ? const CircularProgressIndicator()

                : const Text(
                  "Assign Task",
                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}