import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/login_painter.dart';

class MySigninPage extends StatefulWidget {
  const MySigninPage({Key? key}) : super(key: key);

  @override
  State<MySigninPage> createState() => _MySigninPageState();
}

class _MySigninPageState extends State<MySigninPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController pswController = TextEditingController();
  TextEditingController pswConfController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

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
                Column(
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
                        child: reusableTextField(
                            "Email", Icons.email, false, userController)),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: reusableTextField(
                            "Username", Icons.person, false, userController)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: reusableTextField(
                          "Password", Icons.lock, true, pswController),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: reusableTextField("Password Confermation",
                          Icons.lock_outline, true, pswConfController),
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
                      onPressed: () {
                        // Create a new user with a first and last name
                        final user = <String, dynamic>{
                          "username": "InsertTest",
                          "password": "insertTest",
                          "email": "insertTest"
                        };

                        // Add a new document with a generated ID
                        db.collection("users").add(user).then((DocumentReference
                                doc) =>
                            print('DocumentSnapshot added with ID: ${doc.id}'));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Can be usefull
TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.blue,
      ),
      labelText: text,
      border: const OutlineInputBorder(),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}
