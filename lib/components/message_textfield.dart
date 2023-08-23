import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MessageTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      n});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(50)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.pink.shade300, width: 2.0),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
    );
  }
}
