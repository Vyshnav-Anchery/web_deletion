import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomTextForm({super.key, required this.hintText, required this.controller,required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration:
          InputDecoration(border: OutlineInputBorder(), hintText: hintText),
    );
  }
}
