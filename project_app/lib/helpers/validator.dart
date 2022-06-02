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
