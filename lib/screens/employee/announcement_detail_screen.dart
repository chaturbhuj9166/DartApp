import 'package:flutter/material.dart';

import '../../services/announcement_service.dart';

class AnnouncementDetailScreen
extends StatefulWidget {

  final Map announcement;

  const AnnouncementDetailScreen({

    super.key,

    required this.announcement,

  });

  @override
  State<AnnouncementDetailScreen>
  createState() =>
  _AnnouncementDetailScreenState();

}

class _AnnouncementDetailScreenState
extends State<AnnouncementDetailScreen> {

  final AnnouncementService
  announcementService =
  AnnouncementService();

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
    await announcementService.replyAnnouncement(

      announcementId:
      widget.announcement["_id"] ?? "",

      reply:
      replyController.text.trim(),

      status:
      "Seen",

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
    widget.announcement["title"] ??
    "No Title";

    final String description =
    widget.announcement["description"] ??
    "No Description";

    final String status =
    widget.announcement["status"] ??
    "Unread";

    final String reply =
    widget.announcement["reply"] ?? "";

    final String createdAt =
    widget.announcement["createdAt"] ??
    "";

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F172A),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Announcement Details",

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

            // CARD

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

                      status == "Seen"

                      ? Colors.green

                      : Colors.orange,

                      borderRadius:
                      BorderRadius.circular(20),

                    ),

                    child: Text(

                      status,

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

                  // DATE

                  Row(

                    children: [

                      const Icon(

                        Icons.calendar_month,

                        color:
                        Colors.white,

                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(

                        child: Text(

                          createdAt,

                          style:
                          const TextStyle(

                            color:
                            Colors.white70,

                          ),

                        ),

                      ),

                    ],

                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // DESCRIPTION TITLE

                  const Text(

                    "Announcement Message",

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

            // CURRENT REPLY

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(20),

              decoration:
              BoxDecoration(

                color:
                Colors.white10,

                borderRadius:
                BorderRadius.circular(25),

              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(

                    "Your Reply",

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

            // REPLY FIELD

            TextField(

              controller:
              replyController,

              maxLines: 5,

              style:
              const TextStyle(

                color:
                Colors.white,

              ),

              decoration:
              InputDecoration(

                hintText:
                "Write your reply...",

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

            // BUTTON

            SizedBox(

              width: double.infinity,

              height: 60,

              child:
              ElevatedButton.icon(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.blue,

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

                  : "Send Reply",

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

}