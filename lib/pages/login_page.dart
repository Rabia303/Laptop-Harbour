import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor_app/componenets/my_button.dart';
import 'package:laptop_harbor_app/componenets/my_textfield.dart';
import 'package:laptop_harbor_app/helper/helper_functions.dart';
import 'package:laptop_harbor_app/pages/forgot_pw_page.dart';
import 'package:laptop_harbor_app/theme/dark_mode.dart';
import 'package:laptop_harbor_app/user/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

void login() async {
  showDialog(
    context: context,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  // try sign in
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    
    // pop loading circle
    if (context.mounted) Navigator.pop(context);

    // Navigate to homepage after successful login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), 
    );
    
  } on FirebaseAuthException catch (e) {
    // pop loading circle
    Navigator.pop(context);
    displayUserMessage(e.code, context);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      backgroundColor: Theme.of(context).colorScheme.background,
      // theme:darkMode,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.laptop_windows_sharp,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(
                height: 25,
              ),
              //app name
              const Text(
                'L A P T O P   H A R B O R',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 50,
              ),
              //email text field
              MyTextfield(
                  hintText: 'Email',
                  obscureText: false,
                  controller: emailController),

              const SizedBox(
                height: 10,
              ),

              //password text field
              MyTextfield(
                  hintText: 'Password',
                  obscureText: true,
                  controller: passwordController),

              const SizedBox(
                height: 10,
              ),
              //forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ForgotPasswordPage();
                      }));
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              //sign in button
              MyButton(
                text: 'Login',
                onTap: login,
              ),

              const SizedBox(
                height: 10,
              ),
              //dont have an account???Register here..

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Register Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
