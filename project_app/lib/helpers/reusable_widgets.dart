//Can be usefull
import 'package:flutter/material.dart';

TextFormField reusableTextFieldForm(
    String text,
    IconData icon,
    bool isPasswordType,
    TextEditingController controller,
    String? Function(String?)? validatorFunction,
    String? errorMessage) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    validator: validatorFunction,
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.blue,
      ),
      labelText: text,
      errorText: errorMessage,
      border: const OutlineInputBorder(),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}
