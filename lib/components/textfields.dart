import 'package:flutter/material.dart';

class RegularExpressionPatterns {
  static RegExp passwordPattern() {
    return RegExp(r'^(?=(.*\d.*){2})(?=(.*[\W_].*)).{8,}$');
  }

  static RegExp emailPattern() {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  }

  static String passwordRequirements() {
    return "Invalid Password:\n8+ characters,\nminimum two numerical characters,\nminimum one symbol.";
  }
}

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: hintText,
      ),
      obscureText: obscureText,
    );
  }
}
