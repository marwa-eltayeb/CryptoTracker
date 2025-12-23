import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.logoutDialogTitle),
      content: Text(AppStrings.logoutDialogMessage),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.cancel,
            style: TextStyle(color: AppColors.greyText),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<AuthCubit>().logout();
          },
          child: Text(
            AppStrings.logout,
            style: TextStyle(color: AppColors.red),
          ),
        ),
      ],
    );
  }
}