import 'package:flutter/material.dart';

class CreateRecipeHelp extends StatelessWidget {
  const CreateRecipeHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create recipe'),
      ),
      body: Column(
        children: [
          const Spacer(),
          // PROBLEMS WITH create_recipe.gif
          /*Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/create_recipe.gif",
              scale: 2,
            ),
          ),*/
          const Spacer(),
        ],
      ),
    );
  }
}
