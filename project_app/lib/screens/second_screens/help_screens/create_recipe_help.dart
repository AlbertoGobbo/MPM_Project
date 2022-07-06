import 'package:flutter/material.dart';

class CreateRecipeHelp extends StatelessWidget {
  const CreateRecipeHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                "- Select the ingredients for your recipe.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/create_recipe/create_recipe_1.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text("- Tap on the following icon from AppBar.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/create_recipe/create_recipe_2.jpg",
                scale: 2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text("- Insert a title which will identify your recipe.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/create_recipe/create_recipe_3.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- The default grams for every ingredient is set to 1. If you want to modify this parameter, swipe left on a specific item and tap on the green button and insert the number of grams.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/create_recipe/create_recipe_4.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- Create the recipe tapping the button on the bottom-right of the screen.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/create_recipe/create_recipe_5.jpg",
                scale: 3,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "Now, you will be redirected to the previous page and your recipe has been created with success.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
