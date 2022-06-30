import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/firebase/firestore_function.dart';
import 'package:project_app/models/pair.dart';
import 'package:project_app/screens/second_screens/show_add_ingredient.dart';
import 'package:project_app/screens/second_screens/view_saved_recipe.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class ChooseAliment extends StatefulWidget {
  final String partOfDay;
  final String day;
  const ChooseAliment({
    Key? key,
    required this.partOfDay,
    required this.day,
  }) : super(key: key);

  @override
  State<ChooseAliment> createState() => _ChooseAlimentState();
}

class _ChooseAlimentState extends State<ChooseAliment> {
  TextEditingController dialogController = TextEditingController();

  @override
  void dispose() {
    dialogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Ingredients",
              ),
              Tab(
                text: "Recipes",
              ),
            ],
          ),
          title: const Text("Choose Aliments"),
        ),
        body: TabBarView(children: <Widget>[
          ListView.separated(
              itemBuilder: (context, index) {
                var item = globals.listIngredients[index];
                return ListTile(
                  title: Text(
                    item.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading:
                      Text(item.emoji, style: const TextStyle(fontSize: 40)),
                  subtitle: Text(
                      "Calories: ${double.parse(item.caloriesKcal) * 100} Kcal (100g)"),
                  //TODO: insert "TAP FOR MORE INFO"?
                  trailing: IconButton(
                    onPressed: () async {
                      double gramsSelected = 0;
                      await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Grams for ${item.name}:"),
                                content: TextField(
                                  autofocus: true,
                                  controller: dialogController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter grams",
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.]')),
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
                                        if (dialogController
                                            .value.text.isNotEmpty) {
                                          if (dialogController.value.text
                                                  .substring(0, 1) !=
                                              ".") {
                                            if ((double.parse(dialogController
                                                    .value.text) !=
                                                0.0)) {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                gramsSelected = double.parse(
                                                    dialogController.text);
                                              });
                                              dialogController.clear();
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "N° of grams must be more than 0",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "N° of grams must not start with .",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "N° of grams must not be empty",
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

                      if (gramsSelected != 0) {
                        int totCalories =
                            (double.parse(item.caloriesKcal) * gramsSelected)
                                .toInt();
                        var food = Pair(
                            aliment: item,
                            grams: gramsSelected.toString(),
                            totalCalories: totCalories.toString(),
                            isRecipe: "false");
                        addFood(widget.partOfDay, food);
                        updateAlimentarPlan(
                            globals.listPlans
                                .where((element) => element.day == widget.day)
                                .first,
                            widget.day);
                      }
                    },
                    icon: const Icon(Icons.add_circle_rounded),
                    color: const Color.fromARGB(255, 52, 141, 214),
                  ),
                  onTap: () async {
                    final Pair? itemToAdd = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowAddIngredient(
                          ingredient: item,
                        ),
                      ),
                    );
                    if (itemToAdd != null) {
                      addFood(widget.partOfDay, itemToAdd);
                      updateAlimentarPlan(
                          globals.listPlans
                              .where((element) => element.day == widget.day)
                              .first,
                          widget.day);
                    }
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: globals.listIngredients.length),
          ListView.separated(
              itemBuilder: (context, index) {
                var item = globals.savedRecipes[index];
                var totCal = 0;
                totCal = item.ingredients
                    .fold(
                        0.0,
                        (previousValue, element) =>
                            double.parse(previousValue.toString()) +
                            double.parse(element.caloriesKcal) *
                                double.parse(element.totalGrams))
                    .toInt();

                var totgram = 0;
                totgram = item.ingredients
                    .fold(
                        0.0,
                        (previousValue, element) =>
                            double.parse(previousValue.toString()) +
                            double.parse(element.totalGrams))
                    .toInt();
                return ListTile(
                  title: Text(
                    item.recipeName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.menu_book,
                    color: index % 3 == 0
                        ? Colors.green
                        : index % 3 == 2
                            ? Colors.red
                            : Colors.amber,
                  ),
                  subtitle: Text("Calories: $totCal Kcal (${totgram}g)"),
                  trailing: IconButton(
                    onPressed: () async {
                      double gramsSelected = 0;
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Grams for ${item.recipeName}:"),
                                content: TextField(
                                  autofocus: true,
                                  controller: dialogController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter grams",
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.]')),
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
                                        if (dialogController
                                            .value.text.isNotEmpty) {
                                          if (dialogController.value.text
                                                  .substring(0, 1) !=
                                              ".") {
                                            if ((double.parse(dialogController
                                                    .value.text) !=
                                                0.0)) {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                gramsSelected = double.parse(
                                                    dialogController.text);
                                              });
                                              dialogController.clear();
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "N° of grams must be more than 0",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "N° of grams must not start with .",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "N° of grams must not be empty",
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

                      if (gramsSelected != 0) {
                        int totCalories = (totCal * gramsSelected).toInt();
                        var food = Pair(
                            aliment: item,
                            grams: gramsSelected.toString(),
                            totalCalories: totCalories.toString(),
                            isRecipe: "true");
                        addFood(widget.partOfDay, food);
                      }
                    },
                    icon: const Icon(Icons.add_circle_rounded),
                    color: const Color.fromARGB(255, 52, 141, 214),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewSavedRecipe(
                          savedRecipe: item,
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: globals.savedRecipes.length)
        ]),
      ),
    );
  }

  void addFood(partOfTheDay, foodToAdd) {
    var dailyPlan =
        globals.listPlans.where((element) => element.day == widget.day).first;
    switch (partOfTheDay) {
      case "Breakfast":
        dailyPlan.breakfast.add(foodToAdd);
        break;
      case "Lunch":
        dailyPlan.lunch.add(foodToAdd);
        break;
      case "Snack":
        dailyPlan.snack.add(foodToAdd);
        break;
      case "Dinner":
        dailyPlan.dinner.add(foodToAdd);
        break;
    }
    Fluttertoast.showToast(msg: "Ingredient added");
  }
}
