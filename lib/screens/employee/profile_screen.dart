import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth_service.dart';

import '../auth/login_screen.dart';

class ProfileScreen
extends StatefulWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen>
  createState() =>
  _ProfileScreenState();

}

class _ProfileScreenState
extends State<ProfileScreen> {

  final AuthService
  authService =
  AuthService();

  final TextEditingController
  nameController =
  TextEditingController();

  final TextEditingController
  emailController =
  TextEditingController();

  String userRole =
  "employee";

  String profileImage =
  "";

  bool isLoading = false;

  // IMAGE
  File? selectedImage;

  final ImagePicker
  picker = ImagePicker();

  // =========================
  // LOAD USER DATA
  // =========================

  Future<void> loadUserData()
  async {

    SharedPreferences prefs =
    await SharedPreferences
    .getInstance();

    setState(() {

      nameController.text =
      prefs.getString(
        "userName",
      ) ?? "";

      emailController.text =
      prefs.getString(
        "userEmail",
      ) ?? "";

      userRole =
      prefs.getString(
        "userRole",
      ) ?? "employee";

      profileImage =
      prefs.getString(
        "profileImage",
      ) ?? "";

    });

  }

  // =========================
  // PICK IMAGE
  // =========================

  Future<void> pickImage()
  async {

    final XFile? image =
    await picker.pickImage(

      source:
      ImageSource.gallery,

    );

    if(image != null){

      setState(() {

        selectedImage =
        File(image.path);

      });

    }

  }

  // =========================
  // UPDATE PROFILE
  // =========================

  Future<void> updateProfile()
  async {

    setState(() {

      isLoading = true;

    });

    final response =
    await authService
    .updateProfile(

      name:
      nameController.text.trim(),

      email:
      emailController.text.trim(),

      profileImage:

      selectedImage != null

      ? selectedImage!.path

      : profileImage,

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

  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logoutUser()
  async {

    await authService
    .logoutUser();

    if(!mounted) return;

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (context) =>
        const LoginScreen(),

      ),

      (route) => false,

    );

  }

  @override
  void initState() {

    super.initState();

    loadUserData();

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

          "Profile",

          style: TextStyle(
            color: Colors.white,
          ),

        ),

      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(
              height: 20,
            ),

            // =========================
            // PROFILE IMAGE
            // =========================

            Stack(

              children: [

                CircleAvatar(

                  radius: 60,

                  backgroundColor:
                  Colors.blue,

                  backgroundImage:

                  selectedImage != null

                  ? FileImage(
                      selectedImage!,
                    )

                  : profileImage.isNotEmpty

                  ? FileImage(
                      File(profileImage),
                    )

                  : null,

                  child:

                  selectedImage == null &&
                  profileImage.isEmpty

                  ? Text(

                      nameController
                      .text
                      .isNotEmpty

                      ? nameController
                      .text[0]
                      .toUpperCase()

                      : "E",

                      style:
                      const TextStyle(

                        fontSize: 40,

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    )

                  : null,

                ),

                Positioned(

                  bottom: 0,

                  right: 0,

                  child: GestureDetector(

                    onTap: pickImage,

                    child: Container(

                      padding:
                      const EdgeInsets.all(10),

                      decoration:
                      const BoxDecoration(

                        color:
                        Colors.white,

                        shape:
                        BoxShape.circle,

                      ),

                      child: const Icon(

                        Icons.camera_alt,

                        size: 22,

                      ),

                    ),

                  ),

                ),

              ],

            ),

            const SizedBox(
              height: 35,
            ),

            // =========================
            // NAME FIELD
            // =========================

            TextField(

              controller:
              nameController,

              style:
              const TextStyle(

                color:
                Colors.white,

              ),

              decoration:
              InputDecoration(

                labelText:
                "Name",

                labelStyle:
                const TextStyle(

                  color:
                  Colors.white70,

                ),

                prefixIcon:
                const Icon(

                  Icons.person,

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

            const SizedBox(
              height: 20,
            ),

            // =========================
            // EMAIL FIELD
            // =========================

            TextField(

              controller:
              emailController,

              style:
              const TextStyle(

                color:
                Colors.white,

              ),

              decoration:
              InputDecoration(

                labelText:
                "Email",

                labelStyle:
                const TextStyle(

                  color:
                  Colors.white70,

                ),

                prefixIcon:
                const Icon(

                  Icons.email,

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

            const SizedBox(
              height: 20,
            ),

            // =========================
            // ROLE
            // =========================

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(18),

              decoration:
              BoxDecoration(

                color:
                Colors.white10,

                borderRadius:
                BorderRadius.circular(20),

              ),

              child: Row(

                children: [

                  const Icon(

                    Icons.badge,

                    color:
                    Colors.white,

                  ),

                  const SizedBox(
                    width: 15,
                  ),

                  Text(

                    userRole
                    .toUpperCase(),

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                ],

              ),

            ),

            const SizedBox(
              height: 35,
            ),

            // =========================
            // UPDATE BUTTON
            // =========================

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed:

                isLoading

                ? null

                : updateProfile,

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.blue,

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(18),

                  ),

                ),

                child:

                isLoading

                ? const CircularProgressIndicator(

                    color:
                    Colors.white,

                  )

                : const Text(

                    "Update Profile",

                    style: TextStyle(

                      fontSize: 18,

                    ),

                  ),

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            // =========================
            // LOGOUT BUTTON
            // =========================

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton.icon(

                onPressed:
                logoutUser,

                icon: const Icon(
                  Icons.logout,
                ),

                label: const Text(
                  "Logout",
                ),

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.red,

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(18),

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