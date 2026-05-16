import 'package:flutter/material.dart';

class Helpers {

  // =========================
  // SHOW SNACKBAR
  // =========================

  static void showSnackBar(

    BuildContext context,

    String message,

  ){

    ScaffoldMessenger.of(context)
    .showSnackBar(

      SnackBar(

        content:
        Text(message),

      ),

    );

  }

  // =========================
  // LOADING WIDGET
  // =========================

  static Widget loadingWidget(){

    return const Center(

      child:
      CircularProgressIndicator(),

    );

  }

  // =========================
  // FORMAT DATE
  // =========================

  static String formatDate(
    DateTime date,
  ){

    return
    "${date.day}/"
    "${date.month}/"
    "${date.year}";

  }

}