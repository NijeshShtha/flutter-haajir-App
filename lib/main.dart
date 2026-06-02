import 'package:flutter/material.dart';
import 'package:my_app/screen/login_screen.dart';

void main(){
  runApp(const AttendenceApp());
}

ValueNotifier<bool> isDarkThemeActivated = ValueNotifier(false);

class AttendenceApp extends StatelessWidget {
  const AttendenceApp({super.key});

  @override
  Widget build(BuildContext context){
    var materialApp = ValueListenableBuilder(
      valueListenable: isDarkThemeActivated,
      builder: (context, value, child) {
        return MaterialApp(
          title: 'Haajir App',
          theme: ThemeData.light().copyWith(
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          themeMode: value ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark().copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith((s) => Colors.black)
              )
            )   
          ),
          home: LoginScreen(),
        );
      }
    );
    return materialApp;
  }
}
