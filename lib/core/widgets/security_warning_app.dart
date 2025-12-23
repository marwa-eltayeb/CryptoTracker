import 'package:crypto_tracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class SecurityWarningApp extends StatelessWidget {
  const SecurityWarningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            AppStrings.deviceSecurityViolation,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}