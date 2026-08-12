import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/bloc_auth.dart';
import 'package:my_app/main.dart';
// import 'package:hajir/screens/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Haajir App"),
        actions: [
          ValueListenableBuilder(
            valueListenable: isDarkThemeActivated,
            builder: (context, value, child) {
              return IconButton(
                onPressed: () {
                  isDarkThemeActivated.value = !value;
                },
                icon: Icon(value ? Icons.light_mode : Icons.dark_mode_outlined),
              );
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context, 
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: isDarkThemeActivated,
              builder: (context, value, child) {
                return Image.asset(
                  value ? 'assets/logo-dark.png' : 'assets/logo.png',
                  width: MediaQuery.of(context).size.width / 2,
                );
              },
            ),
            SizedBox(height: 30),
            ValueListenableBuilder(
              valueListenable: isDarkThemeActivated,
              builder: (context, value, child) {
                return Icon(
                  Icons.fingerprint,
                  size: 100,
                  color: value ? Colors.grey : Colors.blue,
                );
              },
            ),
            SizedBox(height: 40, width: MediaQuery.of(context).size.width),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignInWithGooglePressed());
              },
              child: Text("Sign in with Google"),
            ),
          ],
        ),
      ),
    );
  }
}