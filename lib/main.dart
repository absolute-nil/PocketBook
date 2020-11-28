import 'package:flutter/material.dart';
import 'package:pocketbook/screens/welcome_screen.dart';
import 'package:pocketbook/screens/login_screen.dart';
import 'package:pocketbook/screens/registration_screen.dart';
import 'package:pocketbook/screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ProflieScreen.id: (context) => ProflieScreen()
      },
    );
  }
}
