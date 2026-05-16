import 'package:flutter/material.dart';

import '../../services/task_service.dart';

class TaskDetailScreen
extends StatefulWidget {

  final Map task;

  const TaskDetailScreen({

    super.key,

    required this.task,

  });

  @override
  State<TaskDetailScreen>
  createState() =>
  _TaskDetailScreenState();

}

class _TaskDetailScreenState
extends State<TaskDetailScreen> {

  final TaskService
  taskService =
  TaskService();

  final TextEditingController
  replyController =
  TextEditingController();

  bool isLoading = false;

  // =========================
  // SUBMIT REPLY
  // =========================

  void submitReply()
  async {

    if(replyController.text
    .trim()
    .isEmpty){

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          content:
          Text(
            "Please write a reply",
          ),

        ),

      );

      return;

    }

    setState(() {

      isLoading = true;

    });

    final response =
    await taskService.replyTask(

      taskId:
      widget.task["_id"] ?? "",

      reply:
      replyController.text.trim(),

      status:
      "Completed",

    );

    if(!mounted) return;

    setState(() {

      isLoading = false;

    });

    ScaffoldMessenger.of(context)
    .showSnackBar(

      SnackBar(

        content: Text(

          response["message"] ??
          "Reply Submitted",

        ),

      ),

    );

    if(response["success"] == true){

      Navigator.pop(context);

    }

  }

  @override
  void dispose() {

    replyController.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final String title =
    widget.task["title"] ??
    "No Title";

    final String description =
    widget.task["description"] ??
    "No Description";

    final String status =
    widget.task["status"] ??
    "Pending";

    final String reply =
    widget.task["reply"] ?? "";

    final String dueDate =
    widget.task["dueDate"] ??
    "No Due Date";

    final String priority =
    widget.task["priority"] ??
    "Normal";

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F172A),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Task Details",

          style: TextStyle(
            color: Colors.white,
          ),

        ),

      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // =========================
            // TASK CARD
            // =========================

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(25),

              decoration:
              BoxDecoration(

                color:
                Colors.white10,

                borderRadius:
                BorderRadius.circular(30),

              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // TITLE
                  Text(

                    title,

                    softWrap: true,

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize: 28,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // STATUS
                  Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal: 18,

                      vertical: 10,

                    ),

                    decoration:
                    BoxDecoration(

                      color:

                      status == "Completed"

                      ? Colors.green

                      : Colors.orange,

                      borderRadius:
                      BorderRadius.circular(20),

                    ),

                    child: Text(

                      status,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // =========================
                  // TASK INFO
                  // =========================

                  Container(

                    width: double.infinity,

                    padding:
                    const EdgeInsets.all(18),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.black26,

                      borderRadius:
                      BorderRadius.circular(20),

                    ),

                    child: Column(

                      children: [

                        taskInfoRow(

                          Icons.calendar_month,

                          "Due Date",

                          dueDate,

                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        taskInfoRow(

                          Icons.priority_high,

                          "Priority",

                          priority,

                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        taskInfoRow(

                          Icons.fingerprint,

                          "Task ID",

                          widget.task["_id"],

                        ),

                      ],

                    ),

                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // DESCRIPTION TITLE
                  const Text(

                    "Description",

                    style: TextStyle(

                      color:
                      Colors.white,

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // DESCRIPTION
                  Text(

                    description,

                    style:
                    const TextStyle(

                      color:
                      Colors.white70,

                      fontSize: 16,

                      height: 1.5,

                    ),

                  ),

                ],

              ),

            ),

            const SizedBox(
              height: 30,
            ),

            // =========================
            // CURRENT REPLY
            // =========================

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(20),

              decoration:
              BoxDecoration(

                color:

                reply.isEmpty

                ? Colors.white10

                : Colors.green.withOpacity(0.15),

                borderRadius:
                BorderRadius.circular(25),

              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(

                    "Current Reply",

                    style: TextStyle(

                      color:
                      Colors.white,

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Text(

                    reply.isEmpty

                    ? "No Reply Yet"

                    : reply,

                    style:
                    const TextStyle(

                      color:
                      Colors.white70,

                      fontSize: 16,

                    ),

                  ),

                ],

              ),

            ),

            const SizedBox(
              height: 30,
            ),

            // REPLY TITLE
            const Text(

              "Write Reply",

              style: TextStyle(

                color:
                Colors.white,

                fontSize: 18,

                fontWeight:
                FontWeight.bold,

              ),

            ),

            const SizedBox(
              height: 15,
            ),

            // REPLY FIELD
            TextField(

              controller:
              replyController,

              maxLines: 6,

              style:
              const TextStyle(

                color:
                Colors.white,

              ),

              decoration:
              InputDecoration(

                hintText:
                "Write your reply here...",

                hintStyle:
                const TextStyle(

                  color:
                  Colors.white54,

                ),

                filled: true,

                fillColor:
                Colors.white10,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(25),

                  borderSide:
                  BorderSide.none,

                ),

              ),

            ),

            const SizedBox(
              height: 30,
            ),

            // SUBMIT BUTTON
            SizedBox(

              width: double.infinity,

              height: 60,

              child:
              ElevatedButton.icon(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:

                  status == "Completed"

                  ? Colors.green

                  : Colors.blue,

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(22),

                  ),

                ),

                onPressed:

                isLoading

                ? null

                : submitReply,

                icon:

                isLoading

                ? const SizedBox(

                    width: 20,

                    height: 20,

                    child:
                    CircularProgressIndicator(

                      color:
                      Colors.white,

                      strokeWidth: 2,

                    ),

                  )

                : const Icon(
                    Icons.send,
                  ),

                label: Text(

                  isLoading

                  ? "Submitting..."

                  : "Submit Reply",

                  overflow:
                  TextOverflow.ellipsis,

                  maxLines: 1,

                  style:
                  const TextStyle(

                    fontSize: 18,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

  // =========================
  // TASK INFO ROW
  // =========================

  Widget taskInfoRow(

    IconData icon,

    String title,

    String value,

  ){

    return Row(

      children: [

        Icon(

          icon,

          color:
          Colors.white,

        ),

        const SizedBox(
          width: 12,
        ),

        Text(

          "$title : ",

          style:
          const TextStyle(

            color:
            Colors.white,

            fontWeight:
            FontWeight.bold,

          ),

        ),

        Expanded(

          child: Text(

            value,

            overflow:
            TextOverflow.ellipsis,

            style:
            const TextStyle(

              color:
              Colors.white70,

            ),

          ),

        ),

      ],

    );

  }

}