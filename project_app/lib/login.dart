import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/authentication_service.dart';
import 'package:project_app/login_painter.dart';
import 'package:project_app/signin.dart';
import 'package:provider/provider.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
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
            child: ClipRect(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        width: 200,
                        height: 150,
                        child: Image.asset('assets/icon_app.png')),
                    const MyLoginForm(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Does not have account?'),
                        TextButton(
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MySigninPage()),
                            );
                          },
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class MyLoginForm extends StatefulWidget {
  const MyLoginForm({Key? key}) : super(key: key);

  @override
  State<MyLoginForm> createState() => _MyLoginFormState();
}

class _MyLoginFormState extends State<MyLoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorEmailMsg;
  String? errorPswMsg;

  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: reusableTextFieldForm("Email", Icons.email, false,
                emailController, emailValidator, errorEmailMsg),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: reusableTextFieldForm("Password", Icons.lock, true,
                passwordController, passwordValidator, errorPswMsg),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: const Size(200, 50),
              maximumSize: const Size(200, 50),
            ),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () async {
              await tryLogin(context);
            },
          )
        ],
      ),
    );
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

  Future<void> tryLogin(BuildContext context) async {
    errorEmailMsg = null;
    errorPswMsg = null;

    final bool? isValid = _formKey.currentState?.validate();

    var email = emailController.text;
    var psw = passwordController.text;
    if (isValid == true) {
      String? error =
          await context.read<AuthenticationService>().signIn(email, psw);
      if (error != null) {
        if (error == 'invalid-email') {
          errorEmailMsg = 'The email provided is not valid';
        } else if (error == 'user-not-found') {
          errorEmailMsg = 'No user found for this email.';
        } else if (error == 'wrong-password') {
          errorPswMsg = 'Wrong password provided';
        }
        setState(() {});
      }
    }
  }
}
