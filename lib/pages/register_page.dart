import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor_app/componenets/my_button.dart';
import 'package:laptop_harbor_app/componenets/my_textfield.dart';
import 'package:laptop_harbor_app/firestore_firebase.dart';
import 'package:laptop_harbor_app/helper/helper_functions.dart';

//control . to change from stateless to statfeul widget--shortcut key

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text Controllers
  final TextEditingController UsernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController ConfirmPwController = TextEditingController();

  void registerUser() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Make sure passwords match
    if (passwordController.text != ConfirmPwController.text) {
      // Pop loading circle
      Navigator.pop(context);
      // Show error message to the user
      displayUserMessage('Passwords don\'t match!', context);
    } else {
      // Try creating the user
      try {
        // Create user
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        // Add user details to Firestore
        if (userCredential.user != null) {
          String userId = userCredential.user!.uid;

          // Create a user info map
          Map<String, dynamic> userInfoMap = {
            'username': UsernameController.text,
            'email': emailController.text,
            'userId': userId,
          };

          // Add the user details using DatabaseMethods
          await DatabaseMethods().addUserDetails(userInfoMap, userId);
        }
        // Clear text fields
        UsernameController.clear();
        emailController.clear();
        passwordController.clear();
        ConfirmPwController.clear();
        // Pop loading circle
        Navigator.pop(context);

        // Show a success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );

        // Redirect to login page after successful registration
        widget.onTap?.call();
      } on FirebaseAuthException catch (e) {
        // Pop loading circle
        Navigator.pop(context);

        // Show a failure snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );

        // Display error message
        displayUserMessage(e.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.laptop_mac_outlined,
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

              //username text field

              MyTextfield(
                  hintText: 'Username',
                  obscureText: false,
                  controller: UsernameController),

              const SizedBox(
                height: 10,
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

              //confirm password text field
              MyTextfield(
                  hintText: 'Confirm Password',
                  obscureText: true,
                  controller: ConfirmPwController),

              const SizedBox(
                height: 10,
              ),
              //forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              //sign in button
              MyButton(
                text: 'Register',
                onTap: registerUser,
              ),

              const SizedBox(
                height: 10,
              ),
              //Already have an account???Register here..

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login Here",
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
