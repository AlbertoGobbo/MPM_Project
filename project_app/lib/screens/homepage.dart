import 'package:flutter/material.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome ${globals.username}',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
