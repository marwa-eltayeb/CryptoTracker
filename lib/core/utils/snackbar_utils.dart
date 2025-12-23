import 'package:flutter/material.dart';

class SnackBarUtils {
  SnackBarUtils._();

  static void showSnackBar(
      BuildContext context,
      String message, {
        Color backgroundColor = Colors.black87,
        Duration duration = const Duration(seconds: 3),
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
}
