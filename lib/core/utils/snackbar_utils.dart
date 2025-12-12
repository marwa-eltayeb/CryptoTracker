import 'package:flutter/material.dart';

class SnackbarUtils {
  SnackbarUtils._();

  static void showSnackbar(
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
