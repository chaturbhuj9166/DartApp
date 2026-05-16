import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_screen.dart';

import '../employee/dashboard_screen.dart';

import '../admin/admin_dashboard.dart';

class SplashScreen
extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen>
  createState() =>
  _SplashScreenState();

}

class _SplashScreenState
extends State<SplashScreen>
with SingleTickerProviderStateMixin {

  late AnimationController
  _controller;

  late Animation<double>
  _fadeAnimation;

  late Animation<double>
  _scaleAnimation;

  // =========================
  // INIT STATE
  // =========================

  @override
  void initState() {

    super.initState();

    // ANIMATION
    _controller = AnimationController(

      vsync: this,

      duration:
      const Duration(seconds: 2),

    );

    _fadeAnimation =
    CurvedAnimation(

      parent: _controller,

      curve: Curves.easeIn,

    );

    _scaleAnimation =
    Tween<double>(

      begin: 0.7,

      end: 1,

    ).animate(

      CurvedAnimation(

        parent: _controller,

        curve: Curves.easeOutBack,

      ),

    );

    _controller.forward();

    // CHECK LOGIN
    checkLogin();

  }

  // =========================
  // CHECK LOGIN
  // =========================

  Future<void> checkLogin()
  async {

    SharedPreferences prefs =
    await SharedPreferences
    .getInstance();

    String? token =
    prefs.getString("token");

    String? role =
    prefs.getString("userRole");

    await Future.delayed(

      const Duration(seconds: 3),

    );

    if(!mounted) return;

    // =========================
    // USER LOGGED IN
    // =========================

    if(token != null){

      // ADMIN
      if(role == "admin"){

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) =>
            const AdminDashboard(),

          ),

        );

      }

      // EMPLOYEE
      else {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) =>
            const DashboardScreen(),

          ),

        );

      }

    }

    // =========================
    // LOGIN SCREEN
    // =========================

    else {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
          const LoginScreen(),

        ),

      );

    }

  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [

              Color(0xFF0F172A),

              Color(0xFF1E293B),

              Color(0xFF2563EB),

            ],

          ),

        ),

        child: Center(

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              // =========================
              // LOGO
              // =========================

              FadeTransition(

                opacity:
                _fadeAnimation,

                child: ScaleTransition(

                  scale:
                  _scaleAnimation,

                  child: Container(

                    height: 130,

                    width: 130,

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(35),

                      boxShadow: [

                        BoxShadow(

                          color:
                          Colors.black
                          .withOpacity(0.25),

                          blurRadius: 25,

                          offset:
                          const Offset(0, 12),

                        ),

                      ],

                    ),

                    child: const Icon(

                      Icons.fingerprint,

                      size: 70,

                      color: Color(0xFF2563EB),

                    ),

                  ),

                ),

              ),

              const SizedBox(
                height: 35,
              ),

              // =========================
              // APP NAME
              // =========================

              FadeTransition(

                opacity:
                _fadeAnimation,

                child: const Text(

                  "PunchIn Pro",

                  style: TextStyle(

                    color:
                    Colors.white,

                    fontSize: 34,

                    fontWeight:
                    FontWeight.bold,

                    letterSpacing: 1,

                  ),

                ),

              ),

              const SizedBox(
                height: 12,
              ),

              // =========================
              // SUBTITLE
              // =========================

              FadeTransition(

                opacity:
                _fadeAnimation,

                child: Text(

                  "Smart Employee Management",

                  style: TextStyle(

                    color:
                    Colors.white.withOpacity(0.8),

                    fontSize: 16,

                    letterSpacing: 0.5,

                  ),

                ),

              ),

              const SizedBox(
                height: 50,
              ),

              // =========================
              // LOADING
              // =========================

              const SizedBox(

                height: 35,

                width: 35,

                child:
                CircularProgressIndicator(

                  color: Colors.white,

                  strokeWidth: 3,

                ),

              ),

              const SizedBox(
                height: 20,
              ),

              // =========================
              // LOADING TEXT
              // =========================

              Text(

                "Loading...",

                style: TextStyle(

                  color:
                  Colors.white.withOpacity(0.8),

                  fontSize: 15,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}