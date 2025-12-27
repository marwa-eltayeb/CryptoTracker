import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routing/app_router.dart';
import 'config/routing/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/dependency_injection.dart';
import 'core/security/root_checker.dart';
import 'core/widgets/security_warning_app.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  initializeDependencies();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await RootChecker.enforce(allowEmulator: true);

    runApp(MyApp());
  } catch (e) {
    runApp(SecurityWarningApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Crypto Tracker',
            navigatorKey: navigatorKey,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            initialRoute: Routes.splash,
            onGenerateRoute: AppRouter().generateRoute,
            builder: (context, child) {
              return BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthUnauthenticated) {
                    navigatorKey.currentState?.pushNamedAndRemoveUntil(Routes.login, (route) => false,);
                  }
                },
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}