import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

import '../employee/dashboard_screen.dart';

import 'register_screen.dart';

class LoginScreen
extends StatefulWidget {

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen>
  createState() =>
  _LoginScreenState();

}

class _LoginScreenState
extends State<LoginScreen> {

  // =========================
  // CONTROLLERS
  // =========================

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  // =========================
  // AUTH SERVICE
  // =========================

  final AuthService
  authService =
  AuthService();

  // =========================
  // VARIABLES
  // =========================

  bool isLoading = false;

  bool obscurePassword = true;

  // =========================
  // LOGIN FUNCTION
  // =========================

  void loginUser() async {

    // VALIDATION
    if(

      emailController.text
      .trim()
      .isEmpty ||

      passwordController.text
      .trim()
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
    await authService.loginUser(

      email:
      emailController.text.trim(),

      password:
      passwordController.text.trim(),

    );

    if(!mounted) return;

    setState(() {

      isLoading = false;

    });

    // =========================
    // SUCCESS
    // =========================

    if(response["success"] == true){

      ScaffoldMessenger.of(context)
      .showSnackBar(

        SnackBar(

          content: Text(

            response["message"]
            ?? "Login Successful",

          ),

        ),

      );

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
          const DashboardScreen(),

        ),

      );

    }

    // =========================
    // ERROR
    // =========================

    else {

      ScaffoldMessenger.of(context)
      .showSnackBar(

        SnackBar(

          content: Text(

            response["message"]
            ?? "Login Failed",

          ),

        ),

      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F172A),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(25),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              const SizedBox(
                height: 40,
              ),

              // =========================
              // LOGO
              // =========================

              Center(

                child: Container(

                  width: 110,

                  height: 110,

                  decoration:
                  BoxDecoration(

                    gradient:
                    const LinearGradient(

                      colors: [

                        Color(0xFF2563EB),

                        Color(0xFF06B6D4),

                      ],

                    ),

                    borderRadius:
                    BorderRadius.circular(30),

                  ),

                  child: const Icon(

                    Icons.fingerprint,

                    color: Colors.white,

                    size: 60,

                  ),

                ),

              ),

              const SizedBox(
                height: 40,
              ),

              // =========================
              // TITLE
              // =========================

              const Text(

                "Welcome Back 👋",

                style: TextStyle(

                  color:
                  Colors.white,

                  fontSize: 32,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

              const SizedBox(
                height: 10,
              ),

              const Text(

                "Login to continue using PunchIn Pro",

                style: TextStyle(

                  color:
                  Colors.white70,

                  fontSize: 16,

                ),

              ),

              const SizedBox(
                height: 40,
              ),

              // =========================
              // EMAIL
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

                  hintText:
                  "Enter Email",

                  hintStyle:
                  const TextStyle(

                    color:
                    Colors.white54,

                  ),

                  prefixIcon:
                  const Icon(

                    Icons.email,

                    color:
                    Colors.white70,

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
                height: 25,
              ),

              // =========================
              // PASSWORD
              // =========================

              TextField(

                controller:
                passwordController,

                obscureText:
                obscurePassword,

                style:
                const TextStyle(

                  color:
                  Colors.white,

                ),

                decoration:
                InputDecoration(

                  hintText:
                  "Enter Password",

                  hintStyle:
                  const TextStyle(

                    color:
                    Colors.white54,

                  ),

                  prefixIcon:
                  const Icon(

                    Icons.lock,

                    color:
                    Colors.white70,

                  ),

                  suffixIcon:
                  IconButton(

                    onPressed: () {

                      setState(() {

                        obscurePassword =
                        !obscurePassword;

                      });

                    },

                    icon: Icon(

                      obscurePassword

                      ? Icons.visibility

                      : Icons.visibility_off,

                      color:
                      Colors.white70,

                    ),

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
                height: 35,
              ),

              // =========================
              // LOGIN BUTTON
              // =========================

              SizedBox(

                width: double.infinity,

                height: 60,

                child: ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    const Color(0xFF2563EB),

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(20),

                    ),

                  ),

                  onPressed:

                  isLoading
                  ? null
                  : loginUser,

                  child:

                  isLoading

                  ? const SizedBox(

                      height: 24,

                      width: 24,

                      child:
                      CircularProgressIndicator(

                        color:
                        Colors.white,

                        strokeWidth: 2,

                      ),

                    )

                  : const Text(

                      "Login",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                ),

              ),

              const SizedBox(
                height: 25,
              ),

              // =========================
              // REGISTER
              // =========================

              Center(

                child: TextButton(

                  onPressed: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (context) =>
                        const RegisterScreen(),

                      ),

                    );

                  },

                  child: const Text(

                    "Don't have an account? Register",

                    style: TextStyle(

                      color:
                      Colors.white70,

                    ),

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}