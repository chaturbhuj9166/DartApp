import 'package:flutter/material.dart';

import '../../services/user_service.dart';

class ManageUsersScreen
extends StatefulWidget {

  const ManageUsersScreen({
    super.key,
  });

  @override
  State<ManageUsersScreen>
  createState() =>
  _ManageUsersScreenState();

}

class _ManageUsersScreenState
extends State<ManageUsersScreen> {

  final UserService
  userService =
  UserService();

  List users = [];

  List filteredUsers = [];

  bool isLoading = true;

  final TextEditingController
  searchController =
  TextEditingController();

  // =========================
  // GET USERS
  // =========================

  Future<void> getUsers()
  async {

    final response =
    await userService
    .getUsers();

    if(response["success"] == true){

      users =
      response["users"];

      filteredUsers =
      users;

    }

    setState(() {

      isLoading = false;

    });

  }

  // =========================
  // SEARCH USERS
  // =========================

  void searchUsers(String value){

    setState(() {

      filteredUsers =
      users.where((user) {

        return user["name"]
        .toLowerCase()
        .contains(

          value.toLowerCase(),

        );

      }).toList();

    });

  }

  // =========================
  // DELETE USER
  // =========================

  Future<void> deleteUser(
    String id,
  ) async {

    final response =
    await userService
    .deleteUser(id);

    ScaffoldMessenger.of(context)
    .showSnackBar(

      SnackBar(

        content: Text(
          response["message"],
        ),

      ),

    );

    getUsers();

  }

  // =========================
  // CONFIRM DELETE
  // =========================

  void confirmDelete(
    String id,
  ){

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            "Delete User",
          ),

          content: const Text(

            "Are you sure you want to delete this user?",

          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                );

              },

              child: const Text(
                "Cancel",
              ),

            ),

            ElevatedButton(

              onPressed: () {

                Navigator.pop(
                  context,
                );

                deleteUser(id);

              },

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                Colors.red,

              ),

              child: const Text(
                "Delete",
              ),

            ),

          ],

        );

      },

    );

  }

  @override
  void initState() {

    super.initState();

    getUsers();

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

          "Manage Users",

          style: TextStyle(
            color: Colors.white,
          ),

        ),

        actions: [

          IconButton(

            onPressed: getUsers,

            icon: const Icon(

              Icons.refresh,

              color: Colors.white,

            ),

          ),

        ],

      ),

      body:

      isLoading

      ? const Center(

          child:
          CircularProgressIndicator(),

        )

      : Column(

          children: [

            // SEARCH BAR
            Padding(

              padding:
              const EdgeInsets.all(15),

              child: TextField(

                controller:
                searchController,

                onChanged:
                searchUsers,

                style:
                const TextStyle(

                  color:
                  Colors.white,

                ),

                decoration:
                InputDecoration(

                  hintText:
                  "Search Users",

                  hintStyle:
                  const TextStyle(

                    color:
                    Colors.white54,

                  ),

                  prefixIcon:
                  const Icon(

                    Icons.search,

                    color:
                    Colors.white,

                  ),

                  filled: true,

                  fillColor:
                  Colors.white10,

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(20),

                    borderSide:
                    BorderSide.none,

                  ),

                ),

              ),

            ),

            // USER LIST
            Expanded(

              child: ListView.builder(

                itemCount:
                filteredUsers.length,

                itemBuilder:
                (context, index) {

                  final user =
                  filteredUsers[index];

                  return Container(

                    margin:
                    const EdgeInsets.symmetric(

                      horizontal: 15,

                      vertical: 8,

                    ),

                    padding:
                    const EdgeInsets.all(15),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white10,

                      borderRadius:
                      BorderRadius.circular(20),

                    ),

                    child: Row(

                      children: [

                        // AVATAR
                        CircleAvatar(

                          radius: 28,

                          backgroundColor:
                          Colors.blue,

                          child: Text(

                            user["name"][0]
                            .toUpperCase(),

                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight.bold,

                              fontSize: 22,

                            ),

                          ),

                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        // USER INFO
                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(

                                user["name"],

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
                                height: 5,
                              ),

                              Text(

                                user["email"],

                                style:
                                const TextStyle(

                                  color:
                                  Colors.white70,

                                ),

                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Container(

                                padding:
                                const EdgeInsets.symmetric(

                                  horizontal: 12,

                                  vertical: 5,

                                ),

                                decoration:
                                BoxDecoration(

                                  color:

                                  user["role"] == "admin"

                                  ? Colors.purple

                                  : Colors.green,

                                  borderRadius:
                                  BorderRadius.circular(20),

                                ),

                                child: Text(

                                  user["role"]
                                  .toUpperCase(),

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

                        // DELETE BUTTON
                        IconButton(

                          onPressed: () {

                            confirmDelete(
                              user["_id"],
                            );

                          },

                          icon: const Icon(

                            Icons.delete,

                            color: Colors.red,

                          ),

                        ),

                      ],

                    ),

                  );

                },

              ),

            ),

          ],

        ),

    );

  }

}