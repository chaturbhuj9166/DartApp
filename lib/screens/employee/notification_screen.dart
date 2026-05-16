import 'package:flutter/material.dart';

import '../../services/notification_service.dart';

import 'task_detail_screen.dart';

class NotificationScreen
extends StatefulWidget {

  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen>
  createState() =>
  _NotificationScreenState();

}

class _NotificationScreenState
extends State<NotificationScreen> {

  final NotificationService
  notificationService =
  NotificationService();

  List notifications = [];

  bool isLoading = true;

  // =========================
  // GET NOTIFICATIONS
  // =========================

  Future<void> getNotifications()
  async {

    final response =
    await notificationService
    .getNotifications();

    if(!mounted) return;

    if(response["success"] == true){

      setState(() {

        notifications =
        response["notifications"] ?? [];

        isLoading = false;

      });

    }

    else {

      setState(() {

        isLoading = false;

      });

    }

  }

  // =========================
  // MARK AS READ
  // =========================

  Future<void> markAsRead(
    String id,
  ) async {

    final response =
    await notificationService
    .markAsRead(id);

    if(!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(

      SnackBar(

        content: Text(

          response["message"],

        ),

      ),

    );

    getNotifications();

  }

  @override
  void initState() {

    super.initState();

    getNotifications();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F172A),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Notifications",

          style: TextStyle(
            color: Colors.white,
          ),

        ),

      ),

      body:

      isLoading

      ? const Center(

          child:
          CircularProgressIndicator(),

        )

      : notifications.isEmpty

      ? const Center(

          child: Text(

            "No Notifications",

            style: TextStyle(

              color:
              Colors.white,

              fontSize: 18,

            ),

          ),

        )

      : ListView.builder(

          padding:
          const EdgeInsets.all(20),

          itemCount:
          notifications.length,

          itemBuilder:
          (context, index) {

            final notification =
            notifications[index];

            final task =
            notification["taskId"];

            return Container(

              margin:
              const EdgeInsets.only(
                bottom: 20,
              ),

              padding:
              const EdgeInsets.all(20),

              decoration:
              BoxDecoration(

                color:

                notification["isRead"]

                ? Colors.white10

                : Colors.blue.withOpacity(0.15),

                borderRadius:
                BorderRadius.circular(25),

                border:

                notification["isRead"]

                ? null

                : Border.all(

                    color:
                    Colors.blue,

                    width: 1.5,

                  ),

              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // =========================
                  // TOP ROW
                  // =========================

                  Row(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      // ICON
                      Container(

                        padding:
                        const EdgeInsets.all(12),

                        decoration:
                        BoxDecoration(

                          color:

                          notification["isRead"]

                          ? Colors.grey

                          : Colors.blue,

                          borderRadius:
                          BorderRadius.circular(18),

                        ),

                        child: const Icon(

                          Icons.notifications,

                          color:
                          Colors.white,

                        ),

                      ),

                      const SizedBox(
                        width: 15,
                      ),

                      // CONTENT
                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(

                              notification["title"]
                              ?? "Notification",

                              maxLines: 2,

                              overflow:
                              TextOverflow.ellipsis,

                              style:
                              const TextStyle(

                                color:
                                Colors.white,

                                fontSize: 18,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(

                              notification["message"]
                              ?? "",

                              maxLines: 4,

                              overflow:
                              TextOverflow.ellipsis,

                              style:
                              const TextStyle(

                                color:
                                Colors.white70,

                                height: 1.4,

                              ),

                            ),

                            // TASK TITLE
                            if(task != null)
                            const SizedBox(
                              height: 12,
                            ),

                            if(task != null)
                            Container(

                              padding:
                              const EdgeInsets.symmetric(

                                horizontal: 14,

                                vertical: 10,

                              ),

                              decoration:
                              BoxDecoration(

                                color:
                                Colors.black26,

                                borderRadius:
                                BorderRadius.circular(18),

                              ),

                              child: Row(

                                children: [

                                  const Icon(

                                    Icons.task,

                                    color:
                                    Colors.orange,

                                    size: 20,

                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  Expanded(

                                    child: Text(

                                      task["title"]
                                      ?? "Task",

                                      maxLines: 2,

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

                                ],

                              ),

                            ),

                          ],

                        ),

                      ),

                      // UNREAD DOT
                      if(notification["isRead"] == false)
                      const SizedBox(
                        width: 12,
                      ),

                      if(notification["isRead"] == false)
                      Container(

                        width: 12,

                        height: 12,

                        decoration:
                        const BoxDecoration(

                          color:
                          Colors.red,

                          shape:
                          BoxShape.circle,

                        ),

                      ),

                    ],

                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // =========================
                  // BUTTONS
                  // =========================

                  Row(

                    children: [

                      // OPEN TASK
                      Expanded(

                        child:
                        ElevatedButton.icon(

                          style:
                          ElevatedButton.styleFrom(

                            backgroundColor:
                            Colors.blue,

                            padding:
                            const EdgeInsets.symmetric(

                              horizontal: 8,

                              vertical: 15,

                            ),

                            shape:
                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(18),

                            ),

                          ),

                          onPressed:

                          task == null

                          ? null

                          : () {

                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (context) =>

                                  TaskDetailScreen(

                                    task: task,

                                  ),

                                ),

                              );

                            },

                          icon: const Icon(

                            Icons.task,

                            size: 20,

                          ),

                          label: const FittedBox(

                            fit:
                            BoxFit.scaleDown,

                            child: Text(

                              "Open Task",

                              maxLines: 1,

                            ),

                          ),

                        ),

                      ),

                      const SizedBox(
                        width: 15,
                      ),

                      // MARK READ
                      Expanded(

                        child:
                        ElevatedButton.icon(

                          style:
                          ElevatedButton.styleFrom(

                            backgroundColor:
                            Colors.green,

                            padding:
                            const EdgeInsets.symmetric(

                              horizontal: 8,

                              vertical: 15,

                            ),

                            shape:
                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(18),

                            ),

                          ),

                          onPressed:

                          notification["isRead"]

                          ? null

                          : () {

                              markAsRead(

                                notification["_id"],

                              );

                            },

                          icon: const Icon(

                            Icons.done,

                            size: 20,

                          ),

                          label: FittedBox(

                            fit:
                            BoxFit.scaleDown,

                            child: Text(

                              notification["isRead"]

                              ? "Read"

                              : "Mark Read",

                              maxLines: 1,

                            ),

                          ),

                        ),

                      ),

                    ],

                  ),

                ],

              ),

            );

          },

        ),

    );

  }

}