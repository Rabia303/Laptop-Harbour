import 'package:flutter/material.dart';

class HomeButton extends StatefulWidget {
  String route, name;
   HomeButton({super.key, required this.route, required this.name});

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      
    );
  }
}
