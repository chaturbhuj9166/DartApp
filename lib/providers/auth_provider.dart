import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider
extends ChangeNotifier {

  final AuthService
  authService =
  AuthService();

  bool isLoading = false;

  Map<String, dynamic>? userData;

  // LOGIN
  Future<Map<String, dynamic>>
  login({

    required String email,

    required String password,

  }) async {

    isLoading = true;

    notifyListeners();

    final response =
      await authService.loginUser(

        email: email,

        password: password,

      );

    isLoading = false;

    notifyListeners();

    return response;
  }

  // REGISTER
  Future<Map<String, dynamic>>
  register({

    required String name,

    required String email,

    required String password,

  }) async {

    isLoading = true;

    notifyListeners();

    final response =
      await authService.registerUser(

        name: name,

        email: email,

        password: password,

      );

    isLoading = false;

    notifyListeners();

    return response;
  }

}