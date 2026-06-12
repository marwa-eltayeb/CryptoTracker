import 'package:crypto_tracker/config/theme/app_colors.dart';
import 'package:crypto_tracker/config/theme/app_style.dart';
import 'package:crypto_tracker/core/constants/app_assets.dart';
import 'package:crypto_tracker/core/constants/app_strings.dart';
import 'package:crypto_tracker/core/di/dependency_injection.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_state.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/biometric_cubit.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/biometric_state.dart';
import 'package:crypto_tracker/features/auth/presentation/widgets/biometric_action_button.dart';
import 'package:crypto_tracker/features/auth/presentation/widgets/face_id_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:crypto_tracker/config/routing/routes.dart';

class FaceIdScreen extends StatefulWidget {
  const FaceIdScreen({super.key});

  @override
  State<FaceIdScreen> createState() => _FaceIdScreenState();
}

class _FaceIdScreenState extends State<FaceIdScreen> {
  late BiometricCubit _biometricCubit;
  bool isFromRegister = false;
  bool _isFaceIDAvailable = false;
  bool _showInstructions = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is bool) {
      isFromRegister = args;
    }
  }

  @override
  void initState() {
    super.initState();
    _biometricCubit = sl<BiometricCubit>();
    _biometricCubit.checkAvailability(specificType: BiometricType.face);
  }

  @override
  void dispose() {
    _biometricCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : '';

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.faceIdBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BlocConsumer<BiometricCubit, BiometricState>(
                bloc: _biometricCubit,
                listener: (context, state) {


                  if (state is BiometricAvailable) {
                    _isFaceIDAvailable = state.isAvailable;

                    // Auto-trigger scan for login flow when Face ID becomes available
                    if (!isFromRegister && state.isAvailable) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) {
                          _handleFaceIdScan();
                        }
                      });
                    }
                  }

                  if (state is BiometricSkipped && isFromRegister) {
                    _navigateToHome();
                  }

                  // When scanning starts, show instructions screen for register flow
                  if (state is BiometricScanning && isFromRegister) {
                    setState(() {
                      _showInstructions = true;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is BiometricCheckingAvailability) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.white),
                    );
                  }

                  if (state is BiometricError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${AppStrings.biometricError}${state.message}',
                            style: AppTextStyles.regular16.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          BiometricActionButton(
                            text: AppStrings.goBack,
                            onPressed: () => Navigator.pop(context),
                            isPrimary: true,
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        _buildHeader(state),
                        const Spacer(flex: 1),
                        _buildFaceIdCard(state),
                        const SizedBox(height: 40),
                        const Spacer(flex: 1),
                        _buildStatusMessage(state, _isFaceIDAvailable),
                        const SizedBox(height: 24),
                        _buildActionButton(state, _isFaceIDAvailable, userId),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BiometricState state) {
    final currentState = _biometricCubit.state;

    if (currentState is BiometricSuccess && !isFromRegister) {
      return const SizedBox.shrink();
    }

    if (currentState is BiometricSuccess && isFromRegister) {
      return Text(
        AppStrings.youreReady,
        textAlign: TextAlign.center,
        style: AppTextStyles.bold32.copyWith(
          color: AppColors.white,
        ),
      );
    }

    if (!isFromRegister) {
      return const SizedBox.shrink();
    }

    if (_showInstructions) {
      return Column(
        children: [
          Text(
            AppStrings.placeFaceIDInScanner,
            textAlign: TextAlign.center,
            style: AppTextStyles.regular16.copyWith(
              color: AppColors.white,
              height: 1.5,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          AppStrings.setYourFaceID,
          textAlign: TextAlign.center,
          style: AppTextStyles.bold32.copyWith(
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.addFaceIDSecurity,
          textAlign: TextAlign.center,
          style: AppTextStyles.regular16.copyWith(
            color: AppColors.white,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFaceIdCard(BiometricState state) {
    FaceIdCardState cardState = FaceIdCardState.idle;

    if (state is BiometricScanning) {
      cardState = FaceIdCardState.scanning;
    } else if (state is BiometricSuccess) {
      cardState = FaceIdCardState.complete;
    }

    final canTap = _isFaceIDAvailable &&
        state is! BiometricScanning &&
        state is! BiometricSuccess &&
        (!isFromRegister);

    return FaceIdCard(
      cardState: cardState,
      onTap: canTap ? _handleFaceIdScan : null,
    );
  }

  Widget _buildStatusMessage(BiometricState state, bool isAvailable) {
    if (!isAvailable) {
      return Text(
        AppStrings.biometricNotAvailable,
        textAlign: TextAlign.center,
        style: AppTextStyles.regular16.copyWith(
          color: AppColors.white,
          height: 1.5,
        ),
      );
    }

    if (!isFromRegister && state is BiometricSuccess) {
      return Column(
        children: [
          Text(
            AppStrings.yourAreVerified,
            textAlign: TextAlign.center,
            style: AppTextStyles.bold24.copyWith(
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            AppStrings.yourHaveBeenVerified,
            textAlign: TextAlign.center,
            style: AppTextStyles.regular16.copyWith(
              color: AppColors.black,
              height: 1.5,
            ),
          ),
        ],
      );
    }

    if (state is BiometricScanning && isFromRegister && _showInstructions) {
      return Text(
        AppStrings.scanningCompleteSignIn,
        textAlign: TextAlign.center,
        style: AppTextStyles.regular16.copyWith(
          color: AppColors.white,
          height: 1.5,
        ),
      );
    }

    if (state is BiometricScanning && !isFromRegister) {
      return Text(
        AppStrings.pleaseWaitScanning,
        textAlign: TextAlign.center,
        style: AppTextStyles.regular16.copyWith(
          color: AppColors.white,
          height: 1.5,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActionButton(BiometricState state, bool isAvailable, String userId) {

    if (state is BiometricSuccess) {
      return BiometricActionButton(
        text: isFromRegister
            ? AppStrings.continueText
            : AppStrings.continueToHome,
        onPressed: _navigateToHome,
        isPrimary: true,
      );
    }

    if (isFromRegister && !_showInstructions) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: OutlinedButton(
                onPressed: () => _handleSkip(userId),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  AppStrings.skip,
                  style: AppTextStyles.semiBold16.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _handleFaceIdScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  AppStrings.continueText,
                  style: AppTextStyles.semiBold16.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _handleFaceIdScan() {
    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : '';

    if (isFromRegister) {
      setState(() {
        _showInstructions = true;
      });
    }

    _biometricCubit.authenticate(
      userId: userId,
      reason: isFromRegister
          ? AppStrings.registerFaceIDReason
          : AppStrings.verifyFaceIDReason,
      savePreference: isFromRegister,
      specificType: BiometricType.face,
    );
  }

  void _handleSkip(String userId) {
    _biometricCubit.skip(userId);
  }

  void _navigateToHome() async {
    if (!isFromRegister && _biometricCubit.state is BiometricSuccess) {
      await _biometricCubit.completeLogin();
    }

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.main, (route) => false);
    }
  }
}