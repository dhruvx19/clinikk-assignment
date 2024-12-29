import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/login/login.dart';
import 'package:todo_app/services/auth/auth_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF7B68EE),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7B68EE),
          secondary: Color(0xFF7B68EE),
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: FutureBuilder<bool>(
        future: AuthService().isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          // If user is logged in, go to home page
          if (snapshot.data == true) {
            return HomePage();
          }
          
          // Otherwise, go to login page
          return Login();
        },
      ),
    );
  }
}