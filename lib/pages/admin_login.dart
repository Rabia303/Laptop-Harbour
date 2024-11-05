import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor_app/componenets/my_textfield.dart';
import 'package:laptop_harbor_app/componenets/my_button.dart';
import 'package:laptop_harbor_app/pages/admin_home.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController usercontroller = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //to set the background according to theme
      backgroundColor: Theme.of(context).colorScheme.background,
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
                  hintText: 'username',
                  obscureText: false,
                  controller: usercontroller),

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

              const SizedBox(
                height: 10,
              ),
              //sign in button
              MyButton(
                text: 'Login',
                onTap: () {
                  loginAdmin();
                },
              ),

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then(
      (snapshot) {
        snapshot.docs.forEach(
          (result) {
            if (result.data()['username'] != usercontroller.text.trim()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text(
                    "Your id is not correct",
                    style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w300),
                  ),
                ),
              );
            } else if (result.data()['password'] !=
                passwordController.text.trim()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text(
                    "Your password is not correct",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminHome()),
              );
            }
          },
        );
      },
    );
  }
}
