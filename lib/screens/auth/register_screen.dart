import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

import 'login_screen.dart';

class RegisterScreen
extends StatefulWidget {

  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen>
  createState() =>
  _RegisterScreenState();

}

class _RegisterScreenState
extends State<RegisterScreen> {

  // CONTROLLERS
  final TextEditingController
  nameController =
  TextEditingController();

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  // AUTH SERVICE
  final AuthService authService =
  AuthService();

  // LOADING
  bool isLoading = false;

  // REGISTER FUNCTION
  void registerUser() async {

    setState(() {

      isLoading = true;

    });

    final response =
      await authService
      .registerUser(

        name:
        nameController.text.trim(),

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),

      );

    setState(() {

      isLoading = false;

    });

    // SUCCESS
    if(response["success"] == true){

      ScaffoldMessenger.of(context)
      .showSnackBar(

        SnackBar(

          content: Text(
            response["message"]
          ),

        ),

      );

      // GO TO LOGIN
      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
          const LoginScreen(),

        ),

      );

    }

    // ERROR
    else {

      ScaffoldMessenger.of(context)
      .showSnackBar(

        SnackBar(

          content: Text(
            response["message"]
          ),

        ),

      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Register",
        ),

        centerTitle: true,

      ),

      body: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            // NAME
            TextField(

              controller:
              nameController,

              decoration:
              const InputDecoration(

                labelText:
                "Name",

                border:
                OutlineInputBorder(),

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            // EMAIL
            TextField(

              controller:
              emailController,

              decoration:
              const InputDecoration(

                labelText:
                "Email",

                border:
                OutlineInputBorder(),

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            // PASSWORD
            TextField(

              controller:
              passwordController,

              obscureText: true,

              decoration:
              const InputDecoration(

                labelText:
                "Password",

                border:
                OutlineInputBorder(),

              ),

            ),

            const SizedBox(
              height: 30,
            ),

            // REGISTER BUTTON
            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed:
                isLoading
                ? null
                : registerUser,

                child:
                isLoading

                ? const CircularProgressIndicator()

                : const Text(
                  "Register",
                ),

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            // LOGIN BUTTON
            TextButton(

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                    const LoginScreen(),

                  ),

                );

              },

              child: const Text(

                "Already have an account? Login",

              ),

            ),

          ],

        ),

      ),

    );

  }

}