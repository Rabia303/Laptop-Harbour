import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor_app/auth/auth.dart';
import 'package:laptop_harbor_app/theme/dark_mode.dart';
import 'package:laptop_harbor_app/user/category_product.dart';
import 'package:laptop_harbor_app/firebase_options.dart';
import 'package:laptop_harbor_app/pages/admin_home.dart';
import 'package:laptop_harbor_app/pages/admin_login.dart';
import 'package:laptop_harbor_app/pages/splashscreen.dart';
import 'package:laptop_harbor_app/theme/light_mode.dart';
import 'package:laptop_harbor_app/user/contactus.dart';
import 'package:laptop_harbor_app/user/home.dart';
import 'package:laptop_harbor_app/user/profile.dart';
import 'package:laptop_harbor_app/user/welcome.dart';
import 'package:laptop_harbor_app/user/wishlist.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkMode,
      darkTheme: LightMode,
      home: Builder(
        builder: (context) {
          // Getting device size and determining which screen to show
          double logicalWidth = MediaQuery.of(context).size.width;
          double logicalHeight = MediaQuery.of(context).size.height;

          if (logicalWidth >= 1440 && logicalHeight >= 770) {
            return AdminLogin(); // Shows Admin Login for higher resolutions
          } else {
            return SplashScreen(); // Shows Splash Screen for lower resolutions
          }
        },
      ),
     
      routes: {
        '/adminHome': (context) => AdminHome(),
        '/auth': (context) => const AuthPage(),
      
      },
    );
  }
}

//for resolving the issue of object progress event run this instead of flutter run
//flutter run -d chrome --web-renderer html