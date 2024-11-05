import 'package:flutter/material.dart';

void displayUserMessage(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => (AlertDialog(
      title: Text(message),
    )),
  );
}
