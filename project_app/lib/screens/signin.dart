import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_app/painters/login_painter.dart';
import 'package:project_app/firebase/authentication_service.dart';
import 'package:project_app/helpers/reusable_widgets.dart';
import 'package:project_app/helpers/validator.dart';

class MySigninPage extends StatefulWidget {
  const MySigninPage({Key? key}) : super(key: key);

  @override
  State<MySigninPage> createState() => _MySigninPageState();
}

class _MySigninPageState extends State<MySigninPage> {
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
                  const MySignInForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MySignInForm extends StatefulWidget {
  const MySignInForm({Key? key}) : super(key: key);

  @override
  State<MySignInForm> createState() => _MySignInFormState();
}

class _MySignInFormState extends State<MySignInForm> {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pswController = TextEditingController();
  TextEditingController pswConfController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorEmailMsg;
  String? errorPswMsg;
  String? errorUsernameMsg;
  String? errorPswConfMsg;
  bool _isPswHidden = true;
  bool _isPswConfHidden = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            "REGISTRATION",
            style: TextStyle(
                color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: reusableTextFieldForm(
              "Email",
              Icons.email,
              false,
              emailController,
              emailValidator,
              errorEmailMsg,
              TextInputType.emailAddress,
              null,
              null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: reusableTextFieldForm(
              "Username",
              Icons.person,
              false,
              userController,
              usernameValidator,
              errorUsernameMsg,
              TextInputType.text,
              null,
              null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: TextFormField(
              controller: pswController,
              obscureText: _isPswHidden,
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
                      _isPswHidden = !_isPswHidden;
                    });
                  },
                  icon: Icon(
                      _isPswHidden ? Icons.visibility : Icons.visibility_off),
                ),
                labelText: "Password",
                errorText: errorPswMsg,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: TextFormField(
              controller: pswConfController,
              obscureText: _isPswConfHidden,
              enableSuggestions: false,
              autocorrect: false,
              validator: passwordValidator,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.blue,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPswConfHidden = !_isPswConfHidden;
                    });
                  },
                  icon: Icon(_isPswConfHidden
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                labelText: "Password Confermation",
                errorText: errorPswConfMsg,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.visiblePassword,
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
