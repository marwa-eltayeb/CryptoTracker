import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../config/routing/routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/dependency_injection.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../cubit/biometric_cubit.dart';
import '../cubit/biometric_state.dart';
import '../widgets/biometric_Icon.dart';
import '../widgets/biometric_action_button.dart';
import '../widgets/biometric_status_text.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  late BiometricCubit _biometricCubit;
  bool isFromRegister = false;
  bool _isBiometricAvailable = false;

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
    _biometricCubit.checkAvailability();
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
      backgroundColor: AppColors.biometricBackground,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.biometricCircle,
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
                    _isBiometricAvailable = state.isAvailable;
                  }

                  if (state is BiometricSkipped && isFromRegister) {
                    _navigateToNextStep();
                  }
                },
                builder: (context, state) {
                  if (state is BiometricCheckingAvailability) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is BiometricError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${AppStrings.biometricError}${state.message}'),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(AppStrings.goBack),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 80),
                      _buildHeader(),
                      const Spacer(flex: 1),
                      _buildBiometricIcon(state),
                      const SizedBox(height: 40),
                      const Spacer(flex: 1),
                      _buildStatusMessage(state, _isBiometricAvailable),
                      const SizedBox(height: 24),
                      _buildActionButton(state, _isBiometricAvailable, userId),
                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final currentState = _biometricCubit.state;

    if (currentState is BiometricSuccess) {
      return const SizedBox.shrink();
    }

    if (isFromRegister) {
      return Column(
        children: [
          Text(
            AppStrings.setYourFingerPrint,
            textAlign: TextAlign.center,
            style: AppTextStyles.bold32.copyWith(
              color: AppColors.biometricTitle,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.addFingerprintSecurity,
            textAlign: TextAlign.center,
            style: AppTextStyles.regular16.copyWith(
              color: AppColors.biometricSubtitle,
              height: 1.5,
            ),
          ),
        ],
      );
    }

    return Text(
      AppStrings.touchIDSensorVerify,
      textAlign: TextAlign.center,
      style: AppTextStyles.bold32.copyWith(
        color: AppColors.biometricTitle,
      ),
    );
  }

  Widget _buildBiometricIcon(BiometricState state) {
    BiometricIconState iconState = BiometricIconState.idle;

    if (state is BiometricScanning) {
      iconState = BiometricIconState.scanning;
    } else if (state is BiometricSuccess) {
      iconState = BiometricIconState.complete;
    }

    final canTap = _isBiometricAvailable &&
        state is! BiometricScanning &&
        state is! BiometricSuccess;

    return BiometricIcon(
      iconState: iconState,
      type: BiometricType.fingerprint,
      onTap: canTap ? _handleBiometricScan : null,
    );
  }

  Widget _buildStatusMessage(BiometricState state, bool isAvailable) {
    if (!isAvailable) {
      return BiometricStatusText(
        message: AppStrings.biometricNotAvailable,
        color: AppColors.biometricSubtitle,
      );
    }

    if (state is BiometricSuccess) {
      return BiometricStatusText(
        message: isFromRegister
            ? AppStrings.scanningComplete
            : AppStrings.youAreVerifiedBiometric,
        color: AppColors.biometricSubtitle,
      );
    }

    return BiometricStatusText(
      message: isFromRegister
          ? AppStrings.placeFinger
          : AppStrings.verifyIdentityTouchID,
      color: AppColors.biometricSubtitle,
    );
  }

  Widget _buildActionButton(BiometricState state, bool isAvailable, String userId) {
    if (state is BiometricSuccess) {
      return BiometricActionButton(
        text: isFromRegister ? AppStrings.continueText : AppStrings.continueToHome,
        onPressed: _navigateToNextStep,
        isPrimary: true,
      );
    }

    if (isFromRegister) {
      return _buildSkipButton(userId);
    }

    return const SizedBox.shrink();
  }

  Widget _buildSkipButton(String userId) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 160,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.biometricTitle,
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleSkip(userId),
            borderRadius: BorderRadius.circular(28),
            splashColor: AppColors.biometricTitle.withOpacity(0.1),
            highlightColor: AppColors.biometricTitle.withOpacity(0.05),
            child: Center(
              child: Text(
                AppStrings.skip,
                style: AppTextStyles.semiBold16.copyWith(
                  color: AppColors.biometricTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleBiometricScan() {
    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : '';

    _biometricCubit.authenticate(
      userId: userId,
      reason: isFromRegister
          ? AppStrings.registerFingerprintReason
          : AppStrings.verifyIdentityReason,
      savePreference: isFromRegister,
    );
  }

  void _handleSkip(String userId) {
    _biometricCubit.skip(userId);
  }

  void _navigateToNextStep() async {
    if (isFromRegister) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.faceId, arguments: true, (route) => false);
    } else {
      if (_biometricCubit.state is BiometricSuccess) {
        await _biometricCubit.completeLogin();
      }
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    }
  }
}

