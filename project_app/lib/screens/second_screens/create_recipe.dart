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
  TextEditingController dialogController = TextEditingController();
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
          totalFiberG: globals.selectedIngredients[i].totalFiberG,
          totalGrams: globals.selectedIngredients[i].totalGrams));
    }

    return ingredients;
  }

  Future<String?> openDialogToModifyIngredientGrams(String ingredientName) =>
      showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Grams for $ingredientName:"),
                content: TextField(
                  autofocus: true,
                  controller: dialogController,
                  decoration: const InputDecoration(
                    hintText: "Enter grams",
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
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
                      setState(() {
                        if (dialogController.value.text.isNotEmpty) {
                          if (dialogController.value.text.substring(0, 1) !=
                                  "," &&
                              dialogController.value.text.substring(0, 1) !=
                                  ".") {
                            if ((double.parse(dialogController.value.text) !=
                                0.0)) {
                              Navigator.of(context).pop(dialogController.text);
                              dialogController.clear();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "N° of grams must be more than 0",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "N° of grams must not start with , or .",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "N° of grams must not be empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      });
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
                        final grams = await openDialogToModifyIngredientGrams(
                            globals.selectedIngredients[index].name);
                        if (grams == null || grams.isEmpty) return;

                        setState(() {
                          globals.selectedIngredients[index].totalGrams = grams;
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 19, 189, 84),
                      foregroundColor: Colors.white,
                      icon: Icons.mode,
                      label: 'Modify grams',
                    ),
                  ]),
                  child: ListTile(
                    title: Text(
                      "${globals.selectedIngredients[index].name.toUpperCase()} "
                      "(${(double.parse(globals.selectedIngredients[index].caloriesKcal) * double.parse(globals.selectedIngredients[index].totalGrams)).toStringAsFixed(3).replaceAll(".", ",")} Kcal)",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 133, 132, 132),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  "Carbohydrates/g: ${globals.selectedIngredients[index].carbohydratesG}"),
                          const TextSpan(text: "\n"),
                          TextSpan(
                              text:
                                  "Proteins/g: ${globals.selectedIngredients[index].proteinG}"),
                          const TextSpan(text: "\n"),
                          TextSpan(
                              text:
                                  "Total Fats/g: ${globals.selectedIngredients[index].totalFatG}"),
                          const TextSpan(text: "\n"),
                          TextSpan(
                              text:
                                  "Total Fibers/g: ${globals.selectedIngredients[index].totalFiberG}"),
                          const TextSpan(text: "\n"),
                          TextSpan(
                              text:
                                  "Total Sugars/g: ${globals.selectedIngredients[index].totalSugarG}"),
                          const TextSpan(text: "\n"),
                          TextSpan(
                              text:
                                  "Total Grams: ${globals.selectedIngredients[index].totalGrams} g",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
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
                      "${globals.selectedIngredients.fold(0.0, (previousValue, element) => double.parse(previousValue.toString()) + (double.parse(element.caloriesKcal) * double.parse(element.totalGrams))).toStringAsFixed(3).replaceAll(".", ",")} Kcal",
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
                  //TODO: modify title style, in order to be more usable
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
