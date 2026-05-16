import 'package:flutter/material.dart';

import '../../services/admin_service.dart';

import '../../routes/app_routes.dart';

class AdminPinScreen
extends StatefulWidget {

  const AdminPinScreen({
    super.key,
  });

  @override
  State<AdminPinScreen>
  createState() =>
  _AdminPinScreenState();

}

class _AdminPinScreenState
extends State<AdminPinScreen> {

  final TextEditingController
  pinController =
  TextEditingController();

  final AdminService
  adminService =
  AdminService();

  bool isLoading = false;

  // VERIFY PIN
  void verifyPin() async {

    if(pinController.text
    .trim()
    .isEmpty){

      return;

    }

    setState(() {

      isLoading = true;

    });

    final response =
    await adminService
    .verifyAdminPin(

      pin:
      pinController.text.trim(),

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

      Navigator.pushReplacementNamed(

        context,

        AppRoutes.adminDashboard,

      );

    }

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

        title: const Text(
          "Admin Access",
        ),

      ),

      body: Padding(

        padding:
        const EdgeInsets.all(25),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            const Icon(

              Icons.lock,

              size: 90,

              color: Colors.white,

            ),

            const SizedBox(
              height: 30,
            ),

            const Text(

              "Enter Admin PIN",

              style: TextStyle(

                color:
                Colors.white,

                fontSize: 28,

                fontWeight:
                FontWeight.bold,

              ),

            ),

            const SizedBox(
              height: 30,
            ),

            TextField(

              controller:
              pinController,

              obscureText: true,

              style:
              const TextStyle(

                color:
                Colors.white,

              ),

              decoration:
              InputDecoration(

                hintText:
                "Enter PIN",

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
                  BorderRadius.circular(20),

                  borderSide:
                  BorderSide.none,

                ),

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

                : verifyPin,

                child:

                isLoading

                ? const CircularProgressIndicator()

                : const Text(
                    "Verify",
                  ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}