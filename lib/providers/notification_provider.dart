import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class NotificationProvider
extends ChangeNotifier {

  final NotificationService
  notificationService =
  NotificationService();

  bool isLoading = false;

  List notifications = [];

  // GET NOTIFICATIONS
  Future<void>
  getNotifications()
  async {

    isLoading = true;

    notifyListeners();

    final response =
      await notificationService
      .getNotifications();

    if(response["success"] == true){

      notifications =
      response["notifications"];

    }

    isLoading = false;

    notifyListeners();

  }

  // MARK AS READ
  Future<void>
  markAsRead(String id)
  async {

    await notificationService
    .markAsRead(id);

    await getNotifications();

  }

}