import 'package:flutter/material.dart';

import '../models/announcement_model.dart';

import '../services/announcement_service.dart';

class AnnouncementProvider
extends ChangeNotifier {

  // =====================================
  // SERVICE
  // =====================================

  final AnnouncementService
  announcementService =
  AnnouncementService();

  // =====================================
  // VARIABLES
  // =====================================

  bool isLoading = false;

  List<AnnouncementModel>
  announcements = [];

  // =====================================
  // GET ANNOUNCEMENTS
  // =====================================

  Future<void>
  getAnnouncements()
  async {

    isLoading = true;

    notifyListeners();

    final response =

    await announcementService
    .getAnnouncements();

    if (

      response["success"] == true

    ) {

      announcements =

      (response["announcements"]
      as List)

      .map(

        (item) =>

        AnnouncementModel
        .fromJson(item),

      )

      .toList();

    }

    isLoading = false;

    notifyListeners();

  }

  // =====================================
  // MARK AS SEEN
  // =====================================

  Future<void>
  markAsSeen(
    String id,
  ) async {

    await announcementService
    .markAsSeen(id);

    await getAnnouncements();

  }

}