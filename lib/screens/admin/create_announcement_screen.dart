import 'package:flutter/material.dart';

import '../../services/announcement_service.dart';

import '../../services/user_service.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  final AnnouncementService announcementService = AnnouncementService();

  final UserService userService = UserService();

  List users = [];

  Map? selectedUser;

  bool sendToAll = false;

  bool isLoading = false;

  // =====================================
  // GET USERS
  // =====================================

  Future<void> getUsers() async {
    final response = await userService.getUsers();

    if (response["success"] == true) {
      setState(() {
        users = response["users"];
      });
    }
  }

  // =====================================
  // INIT
  // =====================================

  @override
  void initState() {
    super.initState();

    getUsers();
  }

  // =====================================
  // CREATE ANNOUNCEMENT
  // =====================================

  Future<void> createAnnouncement() async {
    if (titleController.text.isEmpty ||
        messageController.text.isEmpty ||
        (!sendToAll && selectedUser == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));

      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await announcementService.createAnnouncement(
      title: titleController.text.trim(),

      description: messageController.text.trim(),

      assignedTo: sendToAll ? "" : selectedUser!["_id"],

      sendToAll: sendToAll,
    );

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(response["message"])));

    if (response["success"] == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Announcement")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // TITLE
            TextField(
              controller: titleController,

              decoration: const InputDecoration(
                labelText: "Announcement Title",
              ),
            ),

            const SizedBox(height: 20),

            // MESSAGE
            TextField(
              controller: messageController,

              maxLines: 5,

              decoration: const InputDecoration(
                labelText: "Announcement Message",
              ),
            ),

            const SizedBox(height: 20),

            // SEND TO ALL
            SwitchListTile(
              value: sendToAll,

              onChanged: (value) {
                setState(() {
                  sendToAll = value;
                });
              },

              title: const Text("Send To All Users"),
            ),

            const SizedBox(height: 10),

            // USER SELECT
            if (!sendToAll)
              DropdownButtonFormField(
                initialValue: selectedUser,

                items: users.map((user) {
                  return DropdownMenuItem(
                    value: user,

                    child: Text(user["name"]),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedUser = value as Map;
                  });
                },

                decoration: const InputDecoration(labelText: "Select User"),
              ),

            const SizedBox(height: 30),

            // BUTTON
            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed: isLoading ? null : createAnnouncement,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Send Announcement"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
