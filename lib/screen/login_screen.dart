import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/screen/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Haajir App"), actions: [
        ValueListenableBuilder(
          valueListenable: isDarkThemeActivated,
          builder: (context, value, child) {
            return IconButton(onPressed: (){
              isDarkThemeActivated.value = !value;
            }, 
            icon: Icon(value ? Icons.light_mode : Icons.dark_mode_outlined));
          }
        )
      ],),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: isDarkThemeActivated,
            builder: (context, value, child) {
              return value ? Image.asset('assets/logo.png', width: MediaQuery.of(context).size.width / 2) : Image.asset('assets/images.jpg', width: MediaQuery.of(context).size.width / 2);
            }
          ),
          SizedBox(
            height: 40,
          ),
          Icon(Icons.fingerprint, size: 100, color: Colors.blue),
          SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
          ),
          ElevatedButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
          }, 
          child: Text("Sign in with Google"), 
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith((s) => Colors.red)) 
          )
        ],
      ),
    );
  }
}