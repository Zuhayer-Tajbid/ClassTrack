import 'package:class_management/colors.dart';
import 'package:flutter/material.dart';

void showNotification(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontFamily: 'font1',
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(seconds: 1),
      backgroundColor: bodyC2,
    ),
  );
}
