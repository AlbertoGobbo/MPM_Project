//Can be usefull
import 'package:flutter/material.dart';

TextFormField reusableTextFieldForm(
    String text,
    IconData icon,
    bool isPasswordType,
    TextEditingController controller,
    String? Function(String?)? validatorFunction,
    String? errorMessage,
    TextInputType? inputType) {
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
    keyboardType: inputType,
  );
}

showSnackbar(String text, BuildContext context) {
  var snackBar = SnackBar(
    content: Text(text),
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
