import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/bloc/bloc_auth.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/screen/dashboard_screen.dart';
import 'package:my_app/screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase SDK
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize Google Sign-in singleton
  await GoogleSignIn.instance.initialize();
  runApp(const HaajirApp());
}

ValueNotifier<bool> isDarkThemeActivated = ValueNotifier(false);

class HaajirApp extends StatelessWidget {
  const HaajirApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Instantiates AuthBloc and immediately dispatches the initial login
      create: (context) => AuthBloc()..add(AuthCheckRequested()),
      child: ValueListenableBuilder(
        valueListenable: isDarkThemeActivated,
        builder: (context, value, child) {
          return MaterialApp(
            title: 'Haajir App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            themeMode: value ? ThemeMode.dark : ThemeMode.light,
            home: const AuthWrapper(), // Router handles screen transitions
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return DashboardScreen();
        } else if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
