import 'package:flutter/material.dart';

class DeleteRecipeHelp extends StatelessWidget {
  const DeleteRecipeHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete recipe'),
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
                "- Tap on the following icon from AppBar.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/delete_recipe/delete_recipe_1.jpg",
                scale: 2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- Apply a long press tap in the recipe you want to delete.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/delete_recipe/delete_recipe_2.gif",
                scale: 2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- If necessary, delete other recipes tapping on them.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/delete_recipe/delete_recipe_3.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text("- Tap the trash button.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/delete_recipe/delete_recipe_4.jpg",
                scale: 2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text("- Confirm the delete operation.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/delete_recipe/delete_recipe_5.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text("Now, your view is updated.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
