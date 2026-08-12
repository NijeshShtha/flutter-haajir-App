import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/bloc/attendance_cubit.dart';
import 'package:my_app/bloc/bloc_auth.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/repositories/attendance_repository.dart';
import 'package:my_app/screen/attendance_history_screen.dart';
// import 'package:my_app/screens/dashboard_screen.dart';
import 'package:my_app/screen/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Grab the key from your environment
  final String? webClientId = dotenv.env['WEB_CLIENT_ID'];

  await GoogleSignIn.instance.initialize(
    serverClientId: webClientId,
  );
  runApp(const HaajirApp());
}

ValueNotifier<bool> isDarkThemeActivated = ValueNotifier(false);

class HaajirApp extends StatelessWidget {
  const HaajirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(AuthCheckRequested()),
      child: ValueListenableBuilder(
        valueListenable: isDarkThemeActivated,
        builder: (context, value, child) {
          return MaterialApp(
            title: 'Haajir App',
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFF8F9FF),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF005885),
                primary: const Color(0xFF000000),
                secondary: const Color(0xFF00588E),
                secondaryContainer: const Color(0xFF2170E4),
                onSecondaryContainer: const Color(0xFFFEFCFF),
                surface: const Color(0xFFF8F9FF),
                surfaceContainer: const Color(0xFFE5EEFF),
                surfaceContainerLowest: const Color(0xFFFFFFFF),
                surfaceContainerHighest: const Color(0xFFD3E4F5),
                onSurface: const Color(0xFF0B1C30),
                onSurfaceVariant: const Color(0xFF454640),
                outlineVariant: const Color(0xFFC6C6CD),
              ),
            ),
            themeMode: value ? ThemeMode.dark : ThemeMode.light,
            darkTheme: ThemeData.dark().copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (s) => Colors.blueAccent,
                  ),
                ),
              ),
            ),
            home: AuthWrapper(),
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
        print("AUTH WRAPPER STATE: ${state.runtimeType}");
        if (state is Authenticated) {
          print("SHOWING ATTENDANCE HISTORY");
          return BlocProvider(
            create: (context) => AttendanceCubit(repository: AttendanceRepository())..loadAttendance(),
            child: const AttendanceHistoryScreen(),
          );
        } else if (state is AuthLoading) {
          print("SHOWING LOADING");
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print("SHOWING LOGIN SCREEN");
          return const LoginScreen();
        }
      },
    );
  }
}
