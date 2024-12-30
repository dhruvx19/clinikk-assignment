import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/posts_provider.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'package:todo_app/services/auth_services.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:todo_app/views/home_page.dart';
import 'package:todo_app/views/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PostsProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              primaryColor: const Color(0xFF7B68EE),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF7B68EE),
                secondary: Color(0xFF7B68EE),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: const Color(0xFF7B68EE),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF7B68EE),
                secondary: Color(0xFF7B68EE),
              ),
              scaffoldBackgroundColor: Colors.black,
            ),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: FutureBuilder(
              future: AuthService().isUserLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.data == true) {
                  return HomePage();
                }

                return Login();
              },
            ),
          );
        },
      ),
    );
  }
}