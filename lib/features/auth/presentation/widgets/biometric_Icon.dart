import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../config/theme/app_colors.dart';

enum BiometricIconState { idle, scanning, complete }

class BiometricIcon extends StatelessWidget {
  final BiometricIconState iconState;
  final VoidCallback? onTap;
  final BiometricType type;


  const BiometricIcon({
    super.key,
    required this.iconState,
    this.onTap,
    this.type = BiometricType.fingerprint,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (iconState) {
      case BiometricIconState.scanning:
        icon = type == BiometricType.face ? Icons.face : Icons.fingerprint;
        color = AppColors.primary;
        break;
      case BiometricIconState.complete:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case BiometricIconState.idle:
      default:
        icon = type == BiometricType.face ? Icons.face : Icons.fingerprint;
        color = Colors.grey;
    }

    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 120,
        color: color,
      ),
    );
  }
}