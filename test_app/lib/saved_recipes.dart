import 'package:flutter/material.dart';

class SavedRecipes extends StatelessWidget {
  const SavedRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your recipes'),
      ),
      body: const Text("The list with saved recipes"),
    );
  }
}
