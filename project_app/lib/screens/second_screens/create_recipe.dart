import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class CreateRecipe extends StatelessWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            color: Colors.lightGreen,
            padding: const EdgeInsets.only(top: 10.0, left: 27.0),
            alignment: Alignment.topLeft,
            child: Text(
              "${globals.selectedIngredients.length} ingredients selected:",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 23, 6, 205)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemCount: globals.selectedIngredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "${globals.listIngredients[index].name.toUpperCase()} "
                    "(${globals.listIngredients[index].caloriesKcal} Kcal)",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Carbohydrates: ${globals.listIngredients[index].carbohydratesG} g"
                      "\n"
                      "Proteins: ${globals.listIngredients[index].proteinG} g"
                      "\n"
                      "Total Fats: ${globals.listIngredients[index].totalFatG} g"
                      "\n"
                      "Total Fibers: ${globals.listIngredients[index].totalFiberG} g"
                      "\n"
                      "Total Sugars: ${globals.listIngredients[index].totalSugarG} g"),
                  trailing: Text(globals.listIngredients[index].emoji,
                      style: const TextStyle(fontSize: 40)),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.08,
              color: Colors.grey,
              alignment: Alignment.center,
              child: TextButton(
                child: const Text(
                  'Create recipe',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SavedRecipe()),
                  );
                  // USE IT AFTER SAVING THE RECIPE IN THE DATASET
                  Navigator.pop(context);*/
                  Fluttertoast.showToast(
                      msg: "Let's insert the recipe!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
              )),
        ],
      ),
    );
  }
}
