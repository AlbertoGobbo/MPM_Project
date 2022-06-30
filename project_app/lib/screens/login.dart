import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_app/firebase/authentication_service.dart';
import 'package:project_app/helpers/validator.dart';
import 'package:project_app/painters/login_painter.dart';
import 'package:project_app/screens/forgot_password.dart';
import 'package:project_app/screens/signin.dart';
import 'package:provider/provider.dart';

import '../helpers/reusable_widgets.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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

  bool _isHidden = true;

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
            child: reusableTextFieldForm(
                "Email",
                Icons.email,
                false,
                emailController,
                emailValidator,
                errorEmailMsg,
                TextInputType.emailAddress),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: TextFormField(
              controller: passwordController,
              obscureText: _isHidden,
              enableSuggestions: false,
              autocorrect: false,
              validator: passwordValidator,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.blue,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                  icon:
                      Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
                ),
                labelText: "Password",
                errorText: errorPswMsg,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage()),
              );
            },
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
          ),
          /*
          Padding(
            padding: const EdgeInsets.all(8),
            child: SignInButton(
              Buttons.Google,
              text: "Log in with Google",
              onPressed: () {
                GoogleSignIn().signIn();
              },
            ),
          )*/
        ],
      ),
    );
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
