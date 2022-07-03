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
                "- Select the day in which you want to set your alimentary plan, tapping on the drop-down menu. The current day is the default voice of the menu.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/manage_alimentary_plan/manage_alimentary_plan_1.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- You want to add some meals for lunch (the same procedure is valid for 'Breakfast', 'Snack' and 'Dinner' windows). So, tap the add button on the expander window.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/manage_alimentary_plan/manage_alimentary_plan_2.jpg",
                scale: 2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- The default tab is about 'Ingredients'. If you want to choose an ingredient, tap on the blue add button and insert the number of grams.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/manage_alimentary_plan/manage_alimentary_plan_3.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- If you want to choose a recipe, swipe to 'Recipes' tab, tap on the blue add button and insert the number of grams.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/manage_alimentary_plan/manage_alimentary_plan_4.gif",
                scale: 1.2,
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
                "assets/manage_alimentary_plan/manage_alimentary_plan_5.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- Now, you can see your alimentary plan updated tapping on 'Lunch' window.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/manage_alimentary_plan/manage_alimentary_plan_6.jpg",
                scale: 2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- Moreover, you can delete an ingredient/recipe swiping left on it and tapping on the red button. After that, you can see the interface is updated.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/manage_alimentary_plan/manage_alimentary_plan_7.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              // TEXT
              alignment: Alignment.centerLeft,
              child: Text(
                  "- Finally, you can move an ingredient/recipe swiping left on it and tapping on the green button. It will appear a dialog with the options available and you only to tap on one option. After that, you can see the interface is updated.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Align(
              // IMAGE
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/manage_alimentary_plan/manage_alimentary_plan_8.gif",
                scale: 1.2,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
