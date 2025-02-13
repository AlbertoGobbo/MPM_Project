import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/recipe.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
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
                    Platform.isAndroid
                        ? FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                        : FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      dialogController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      var dialogText =
                          dialogController.value.text.replaceAll(",", ".");
                      setState(() {
                        if (dialogText.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "N° of grams must not be empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (dialogText.substring(0, 1) == ".") {
                          Fluttertoast.showToast(
                              msg: "N° of grams must not start with .",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (dialogText.split(".").length - 1 > 1) {
                          Fluttertoast.showToast(
                              msg: "There are too much dots",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (double.parse(dialogText) == 0.0) {
                          Fluttertoast.showToast(
                              msg: "N° of grams must be more than 0",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          Navigator.of(context).pop(dialogText);
                        }
                        dialogController.clear();
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
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
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
            color: const Color.fromARGB(255, 168, 230, 170),
            padding:
                const EdgeInsets.only(bottom: 8.0, left: 18.0, right: 18.0),
            alignment: Alignment.topLeft,
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 4.0),
                ),
                border: UnderlineInputBorder(),
                hintText: 'Insert a title',
                hintStyle: TextStyle(
                    fontSize: 20, color: Color.fromARGB(240, 75, 75, 75)),
              ),
              onChanged: (text) {
                titleRecipe = text;
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(top: 10.0, left: 1.0, right: 3.0),
              itemCount: globals.selectedIngredients.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: (_) async {
                        dialogController.clear();
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
                      "(${(double.parse(globals.selectedIngredients[index].caloriesKcal) * double.parse(globals.selectedIngredients[index].totalGrams)).toStringAsFixed(2).replaceAll(".", ",")} Kcal)",
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
            height: MediaQuery.of(context).size.height * 0.1,
            color: const Color.fromARGB(255, 168, 230, 170),
            alignment: Alignment.center,
            child: Row(
              children: [
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Total calories:",
                    ),
                    Text(
                      "${globals.selectedIngredients.fold(0.0, (previousValue, element) => double.parse(previousValue.toString()) + (double.parse(element.caloriesKcal) * double.parse(element.totalGrams))).round()} Kcal",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(
                  flex: 3,
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
                        final bool isTitleNeverUsed = await FirebaseFirestore
                            .instance
                            .collection("recipes")
                            .where("recipeName", isEqualTo: titleRecipe)
                            .get()
                            .then((value) {
                          if (value.docs.isEmpty) {
                            return true;
                          } else {
                            return false;
                          }
                        });

                        if (isTitleNeverUsed) {
                          Recipe newRecipe = Recipe(
                            userId: globals.uidUser,
                            recipeName: titleRecipe.trim(),
                            ingredients: preprocessRecipeDataForFirestore(),
                          );

                          // Remove keyword "await" because the user would get stuck until a Future is returned if the offline mode is on
                          await FirebaseFirestore.instance
                              .collection("recipes")
                              .add(newRecipe.toMap())
                              .whenComplete(() => setState(() {
                                    globals.savedRecipes.add(newRecipe);
                                    globals.savedRecipes.sort((a, b) =>
                                        a.recipeName.compareTo(b.recipeName));

                                    for (int i = 0;
                                        i < globals.selectedIngredients.length;
                                        i = i + 1) {
                                      globals.selectedIngredients[i]
                                          .totalGrams = "1";
                                    }
                                    globals.selectedIngredients.clear();
                                    globals.isCheckboxChecked.fillRange(
                                        0,
                                        globals.isCheckboxChecked.length,
                                        false);
                                  }))
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
                          FocusManager.instance.primaryFocus?.unfocus();
                          Fluttertoast.showToast(
                              msg: "Recipe added!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Insert a new title: it has been already used",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
