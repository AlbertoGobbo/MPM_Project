import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/login_painter.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';

class MySigninPage extends StatefulWidget {
  const MySigninPage({Key? key}) : super(key: key);

  @override
  State<MySigninPage> createState() => _MySigninPageState();
}

class _MySigninPageState extends State<MySigninPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pswController = TextEditingController();
  TextEditingController pswConfController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorEmailMsg;
  String? errorPswMsg;
  String? errorUsernameMsg;
  String? errorPswConfMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: Center(
        child: CustomPaint(
          painter: MyShapePainter(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "REGISTRATION",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: reusableTextFieldForm(
                          "Email",
                          Icons.email,
                          false,
                          emailController,
                          emailValidator,
                          errorEmailMsg,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: reusableTextFieldForm(
                          "Username",
                          Icons.person,
                          false,
                          userController,
                          usernameValidator,
                          errorUsernameMsg,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: reusableTextFieldForm(
                          "Password",
                          Icons.lock,
                          true,
                          pswController,
                          passwordValidator,
                          errorPswMsg,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: reusableTextFieldForm(
                          "Password Confermation",
                          Icons.lock_outline,
                          true,
                          pswConfController,
                          passwordValidator,
                          errorPswConfMsg,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: const Size(200, 50),
                          maximumSize: const Size(200, 50),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: () async {
                          await trySignUp(context);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> trySignUp(BuildContext context) async {
    errorEmailMsg = null;
    errorPswConfMsg = null;
    errorPswMsg = null;
    errorUsernameMsg = null;

    String username = userController.text.trim();
    String psw = pswController.text.trim();
    String pswC = pswConfController.text.trim();
    String email = emailController.text.trim();

    bool? isValid = _formKey.currentState?.validate();

    //Controll passwords matches
    if (pswC != psw) {
      isValid = false;
      errorPswConfMsg = 'Password does not match';
    }

    //Controll Username not already taken
    final usernameDB = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();

    if (usernameDB.size > 0) {
      isValid = false;
      errorUsernameMsg = 'Username already taken';
    }

    if (isValid == true) {
      String? result = await context.read<AuthenticationService>().signUp(
            email,
            psw,
            username,
          );
      if (result == "Sign Up") {
        Navigator.pop(context);
      } else {
        if (result == 'email-already-in-use') {
          errorEmailMsg = 'Email already used';
        } else if (result == 'invalid-email') {
          errorEmailMsg = 'Email not valid';
        } else if (result == 'operation-not-allowed') {
          errorPswMsg = 'Wrong password provided';
        } else if (result == 'weak-password') {
          errorPswMsg = 'Password not enough safe';
        }
        setState(() {});
      }
    } else {
      setState(() {});
    }
  }
}

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

//Can be usefull
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
