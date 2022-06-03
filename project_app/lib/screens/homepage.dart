import 'package:flutter/material.dart';
import 'package:project_app/firebase/authentication_service.dart';
import 'package:provider/provider.dart';

//Fake homepage class, need to be substitute with real homepage
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ElevatedButton(
        child: const Text("Log Out"),
        onPressed: () {
          context.read<AuthenticationService>().signOut();
        },
      ),
    );
  }
}
