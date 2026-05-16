import 'package:flutter/material.dart';

class CustomTextField
extends StatelessWidget {

  final TextEditingController
  controller;

  final String hintText;

  final bool obscureText;

  final int maxLines;

  const CustomTextField({

    super.key,

    required this.controller,

    required this.hintText,

    this.obscureText = false,

    this.maxLines = 1,

  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      obscureText: obscureText,

      maxLines: maxLines,

      decoration: InputDecoration(

        hintText: hintText,

        border:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(14),

        ),

      ),

    );

  }

}