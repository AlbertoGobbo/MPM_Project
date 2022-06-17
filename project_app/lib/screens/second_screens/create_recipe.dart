import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  late TextEditingController dialogController;
  String titleRecipe = "";
  String ingredientGrams = "";

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

  Future<String?> openDialogToInsertIngredientGrams() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Ingredient grams"),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: "Enter grams"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
              controller: dialogController,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Submit"),
                onPressed: () {
                  Navigator.of(context).pop(dialogController.text);
                  dialogController.clear();
                },
              ),
            ],
          ));

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    dialogController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    dialogController = TextEditingController();
    super.initState();
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
                return Slidable(
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: (_) async {
                        final grams = await openDialogToInsertIngredientGrams();
                        if (grams == null || grams.isEmpty) return;

                        setState(() {
                          ingredientGrams = grams;
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 19, 189, 84),
                      foregroundColor: Colors.white,
                      icon: Icons.add_box_rounded,
                      label: 'Add grams',
                    ),
                  ]),
                  child: ListTile(
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
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
          Container(
            // TODO: make suitable for all the screens this container
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
                      "${globals.selectedIngredients.fold(0.0, (previousValue, element) => double.parse(previousValue.toString()) + double.parse(element.caloriesKcal)).toStringAsFixed(3).replaceAll(".", ",")} Kcal",
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
                        Recipe newRecipe = Recipe(
                          userId: globals.uidUser,
                          recipeName: titleRecipe,
                          ingredients: preprocessRecipeDataForFirestore(),
                        );

                        await firestoreInstance
                            .collection("recipes")
                            .add(newRecipe.toMap())
                            // ignore: invalid_return_type_for_catch_error
                            .catchError((err) => {
                                  log(err.message.toString()),
                                  Fluttertoast.showToast(
                                      msg:
                                          "Something is not working. Please, try again",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0),
                                });

                        globals.savedRecipes.add(newRecipe);
                        globals.isCheckboxChecked.fillRange(
                            0, globals.isCheckboxChecked.length, false);
                        globals.selectedIngredients.clear();
                        // TODO: before changing the context, disable all the checkboxs

                        //titleController.clear();
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
