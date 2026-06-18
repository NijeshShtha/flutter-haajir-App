import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/bloc_auth.dart';
import 'package:my_app/main.dart';

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
          if(state is AuthFailure){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: isDarkThemeActivated,
              builder: (context, value, child) {
                return value
                    ? Image.asset(
                        'assets/logo.png',
                        width: MediaQuery.of(context).size.width / 2,
                      )
                    : Image.asset(
                        'assets/images.jpg',
                        width: MediaQuery.of(context).size.width / 2,
                      );
              },
            ),
            SizedBox(height: 40),
            Icon(Icons.fingerprint, size: 100, color: Colors.blue),
            SizedBox(height: 40, width: MediaQuery.of(context).size.width),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignInWithGooglePressed());
              },
              child: Text("Sign in with Google"),
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                  (s) => Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
