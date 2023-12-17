import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/dimensions.dart';

class CTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isPassword;

  const CTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
        borderRadius: BorderRadius.circular(Dimensions.textFieldRadius));
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.textFieldMargin),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: true,
          contentPadding: const EdgeInsets.all(Dimensions.contentPadding),
        ),
        obscureText: isPassword,
        keyboardType: textInputType,
      ),
    );
  }
}
