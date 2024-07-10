import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const MyTextField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.secondary,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(width: 0.0)),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      obscureText: obscureText,
    );
  }
}
