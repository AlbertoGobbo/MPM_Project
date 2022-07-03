import 'package:flutter/material.dart';

class ManageAlimentaryPlanHelp extends StatelessWidget {
  const ManageAlimentaryPlanHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage alimentary plan'),
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
                "- Select the day in which you want to set your alimentary plan, tapping on the drop-down menu. The default day is the current one.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/create_recipe/create_recipe_1.gif",
                scale: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- You want to add some meals for lunch (the same procedure is valid for all the other times of day to eat). So, tap the add button on the expander window.",
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
              child: Text(
                  "- The default tab is about 'Ingredients'. If you want to choose an ingredient, tap on the add button and insert the number of grams.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/create_recipe/create_recipe_3.gif",
                scale: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- If you want to choose a recipe, swipe to 'Recipes' tab, tap on the add button and insert the number of grams.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/create_recipe/create_recipe_4.gif",
                scale: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- Alternatively, you can tap on one ingredient/recipe, tap on the 'Change total grams' button, enter the number of grams and finally tap on the 'Add Ingredient/Recipe' button.",
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
                  "Now, you can see your alimentary plan updated tapping on 'Lunch' window.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
