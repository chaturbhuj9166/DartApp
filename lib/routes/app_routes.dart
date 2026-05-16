import 'package:flutter/material.dart';

import '../screens/splash/splash_screen.dart';

import '../screens/auth/login_screen.dart';

import '../screens/auth/register_screen.dart';

import '../screens/employee/dashboard_screen.dart';

import '../screens/employee/tasks_screen.dart';

import '../screens/employee/profile_screen.dart';

import '../screens/employee/notification_screen.dart';

import '../screens/employee/attendance_history_screen.dart';

import '../screens/admin/admin_dashboard.dart';

import '../screens/admin/create_task_screen.dart';

import '../screens/admin/manage_users_screen.dart';

import '../screens/admin/reports_screen.dart';

import '../screens/admin/attendance_screen.dart';

import '../screens/admin/admin_pin_screen.dart';

class AppRoutes {

  // =========================
  // ROUTE NAMES
  // =========================

  static const String
  splash =
  "/";

  static const String
  login =
  "/login";

  static const String
  register =
  "/register";

  // =========================
  // EMPLOYEE
  // =========================

  static const String
  dashboard =
  "/dashboard";

  static const String
  tasks =
  "/tasks";

  static const String
  profile =
  "/profile";

  static const String
  notifications =
  "/notifications";

  static const String
  attendanceHistory =
  "/attendance-history";

  // =========================
  // ADMIN
  // =========================

  static const String
  adminDashboard =
  "/admin-dashboard";

  static const String
  createTask =
  "/create-task";

  static const String
  manageUsers =
  "/manage-users";

  static const String
  reports =
  "/reports";

  static const String
  attendance =
  "/attendance";

  static const String
adminPin =
"/admin-pin";

  // =========================
  // ROUTES
  // =========================

  static Map<String, WidgetBuilder>
  routes = {

    // SPLASH
    splash:
    (context) =>
    const SplashScreen(),

    // AUTH
    login:
    (context) =>
    const LoginScreen(),

    register:
    (context) =>
    const RegisterScreen(),

    // =========================
    // EMPLOYEE ROUTES
    // =========================

    dashboard:
    (context) =>
    const DashboardScreen(),

    tasks:
    (context) =>
    const TasksScreen(),

    profile:
    (context) =>
    const ProfileScreen(),

    notifications:
    (context) =>
    const NotificationScreen(),

    attendanceHistory:
    (context) =>
    const AttendanceHistoryScreen(),

    // =========================
    // ADMIN ROUTES
    // =========================

    adminDashboard:
    (context) =>
    const AdminDashboard(),

    createTask:
    (context) =>
    const CreateTaskScreen(),

    manageUsers:
    (context) =>
    const ManageUsersScreen(),

    reports:
    (context) =>
    const ReportsScreen(),

    attendance:
    (context) =>
    const AttendanceScreen(),

    adminPin:
(context) =>
const AdminPinScreen(),

  };

}