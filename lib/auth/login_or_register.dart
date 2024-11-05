import 'package:flutter/material.dart';
import 'package:laptop_harbor_app/pages/login_page.dart';
import 'package:laptop_harbor_app/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
//initially show login page
  bool ShowLoginPage = true;

//toggle between login and register
  void togglePages() {
    setState(() {
      ShowLoginPage = !ShowLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ShowLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
