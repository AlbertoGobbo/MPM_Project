import 'package:flutter/material.dart';

class DeleteRecipeHelp extends StatelessWidget {
  const DeleteRecipeHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete recipe'),
      ),
      body: Column(
        children: [
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/delete_recipe.gif",
              scale: 2,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
