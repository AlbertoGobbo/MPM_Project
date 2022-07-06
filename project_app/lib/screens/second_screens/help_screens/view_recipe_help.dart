import 'package:flutter/material.dart';

class ViewRecipeHelp extends StatelessWidget {
  const ViewRecipeHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View recipe'),
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
                "There are two ways to view a recipe.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                "- The first way is tapping on the following icon from AppBar.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/view_recipe/view_recipe_1.jpg",
                scale: 2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- You can see a list of saved recipes. To go into detail about a specific recipe, tap on it.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/view_recipe/view_recipe_2.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- The second way is tapping on one item of the recipes carousel located in the homepage.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/view_recipe/view_recipe_3.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text("- In both situations, you can see the same page.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
