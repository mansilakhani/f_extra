import 'package:firebase_app/screens/homepage.dart';
import 'package:firebase_app/screens/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.cyan,
        ),
      ),
      initialRoute: 'login_page',
      routes: {
        '/': (context) => const HomePage(),
        'login_page': (context) => const LoginPage(),
      },
    ),
  );
}
