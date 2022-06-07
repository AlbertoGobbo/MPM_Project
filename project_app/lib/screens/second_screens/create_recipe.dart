import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/recipe.dart';
import 'package:project_app/variables/global_variables.dart' as globals;
import 'dart:developer';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final firestoreInstance = FirebaseFirestore.instance;
  final myController = TextEditingController();
  String titleRecipe = "";

  Widget setAppBarTitle() {
    if (globals.selectedIngredients.length == 1) {
      return Text(
          "Create recipe (${globals.selectedIngredients.length} ingredient)");
    } else {
      return Text(
          "Create recipe (${globals.selectedIngredients.length} ingredients)");
    }
  }

  List<Ingredients> preprocessRecipeDataForFirestore() {
    List<Ingredients> ingredients = [];
    for (int i = 0; i < globals.selectedIngredients.length; i = i + 1) {
      ingredients.add(Ingredients(
          emoji: globals.selectedIngredients[i].emoji,
          caloriesKcal: globals.selectedIngredients[i].caloriesKcal,
          name: globals.selectedIngredients[i].name,
          totalSugarG: globals.selectedIngredients[i].totalSugarG,
          proteinG: globals.selectedIngredients[i].proteinG,
          totalFatG: globals.selectedIngredients[i].totalFatG,
          carbohydratesG: globals.selectedIngredients[i].carbohydratesG,
          totalFiberG: globals.selectedIngredients[i].totalFiberG));
    }

    return ingredients;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: setAppBarTitle(),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            color: Colors.lightGreen,
            padding:
                const EdgeInsets.only(bottom: 12.0, left: 18.0, right: 18.0),
            alignment: Alignment.topLeft,
            child: TextField(
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Recipe title',
                hintStyle: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 201, 25, 25)),
              ),
              onChanged: (text) {
                titleRecipe = text;
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 10.0, left: 1.0, right: 3.0),
              itemCount: globals.selectedIngredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "${globals.selectedIngredients[index].name.toUpperCase()} "
                    "(${globals.selectedIngredients[index].caloriesKcal} Kcal)",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Carbohydrates: ${globals.selectedIngredients[index].carbohydratesG} g"
                      "\n"
                      "Proteins: ${globals.selectedIngredients[index].proteinG} g"
                      "\n"
                      "Total Fats: ${globals.selectedIngredients[index].totalFatG} g"
                      "\n"
                      "Total Fibers: ${globals.selectedIngredients[index].totalFiberG} g"
                      "\n"
                      "Total Sugars: ${globals.selectedIngredients[index].totalSugarG} g"),
                  trailing: Text(globals.selectedIngredients[index].emoji,
                      style: const TextStyle(fontSize: 40)),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.lightGreen,
            alignment: Alignment.center,
            child: Row(
              children: [
                const SizedBox(
                  width: 18,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Total calories:",
                    ),
                    Text(
                      "${globals.selectedIngredients.fold(0.0, (previousValue, element) => double.parse(previousValue.toString()) + double.parse(element.caloriesKcal)).toStringAsFixed(3)} Kcal",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 88,
                ),
                SizedBox(
                  height: 55,
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      primary: const Color.fromARGB(255, 23, 91, 26),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Create recipe'),
                    onPressed: () async {
                      if (titleRecipe.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please, insert a title to the recipe",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        await firestoreInstance
                            .collection("recipes")
                            .add(Recipe(
                              userId: globals.uidUser,
                              recipeName: titleRecipe,
                              ingredients: preprocessRecipeDataForFirestore(),
                            ).toMap())
                            // ignore: invalid_return_type_for_catch_error
                            .catchError((err) => {
                                  log(err.message.toString()),
                                  Fluttertoast.showToast(
                                      msg:
                                          "Something is not working. Please, try again",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0),
                                });
                        // savedRecipes = []; --> is it necessary??
                        // TODO: before changing the context, disable all the checkboxs
                        globals.isCheckboxChecked.fillRange(
                            0, globals.isCheckboxChecked.length, false);
                        globals.selectedIngredients.clear();

                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
