String? passwordValidator(String? value) {
  //<-- add String? as a return type
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  if (value.trim().length < 8) {
    return 'Password must be at least 8 characters in length';
  }
  // Return null if the entered password is valid
  return null;
}

String? emailValidator(String? value) {
  //<-- add String? as a return type
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your email address';
  }
  // Check if the entered email has the right format
  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? usernameValidator(String? value) {
  //<-- add String? as a return type
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your username';
  }
  if (value.trim().length < 3) {
    return 'Username must be at least 8 characters in length';
  }
  return null;
}

String? ageValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your age';
  }
  if (value.contains(".") || value.contains(",") || value.contains("-")) {
    return 'Age must contains only numbers';
  }
  if (int.parse(value) <= 0 || int.parse(value) > 99) {
    return 'Insert valid age';
  }
  return null;
}

String? weightValidator(String? value) {
  value = value?.replaceAll(",", ".");

  if (value == null || value.trim().isEmpty) {
    return 'Please enter your weight';
  }
  if (value.contains('-')) {
    return 'Invalid format for weight';
  }
  if (value.split(".").toList().length - 1 > 1) {
    return 'Invalid format for weight';
  }
  if (double.parse(value) <= 0) {
    return 'Weight must be greater than 0';
  }
  return null;
}

String? heightValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your height';
  }
  if (value.contains('.') || value.contains(',') || value.contains('-')) {
    return 'Invalid format for height';
  }
  if (int.parse(value) <= 10 || int.parse(value) >= 300) {
    return 'Insert a valid height';
  }
  return null;
}

String? caloriesValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your calories goal';
  }
  if (value.trim().contains('.') ||
      value.trim().contains(',') ||
      value.trim().contains('-')) {
    return 'Calories must contains only numbers';
  }
  if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
    return 'Calories must be greater than 0';
  }
  return null;
}
