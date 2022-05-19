import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myprogram4/login/SplashScreen.dart';
import 'package:myprogram4/login/home_screen.dart';
import 'firebase_options.dart';
import 'login/welcome_screen.dart';
import 'login/signup_screen.dart';
import 'login/login_screen.dart';


  Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'login_screen': (context) => LoginScreen(),
        'home_screen': (context) => SplashScreen(),
        'successful': (context) => HomeScreen()
      },
    );
  }
}