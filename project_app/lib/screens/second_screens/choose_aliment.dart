import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;
import 'package:project_app/firebase/firestore_function.dart';
import 'package:project_app/helpers/search_widget.dart';
import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/pair.dart';
import 'package:project_app/models/recipe.dart';
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
  String searchTextIngred = '';
  String searchTextRecipe = '';

  @override
  void dispose() {
    dialogController.dispose();
    super.dispose();
  }

  bool containsSearchTextIngred(Ingredients ingredients) {
    return ingredients.name
        .toLowerCase()
        .contains(searchTextIngred.toLowerCase());
  }

  bool containsSearchTextRecipe(Recipe recipes) {
    return recipes.recipeName
        .toLowerCase()
        .contains(searchTextRecipe.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsFromSearch =
        globals.listIngredients.where(containsSearchTextIngred).toList();

    final recipesFromSearch =
        globals.savedRecipes.where(containsSearchTextRecipe).toList();

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
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: const Color.fromARGB(0, 255, 255, 255),
                padding: const EdgeInsets.only(top: 17.0),
                child: SearchWidget(
                  text: searchTextIngred,
                  hintText: "Search ingredients",
                  onChanged: (text) => setState(
                    () {
                      searchTextIngred = text;
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (context, index) {
                    var item = ingredientsFromSearch[index];
                    return ListTile(
                      title: Text(
                        item.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Text(item.emoji,
                          style: const TextStyle(fontSize: 40)),
                      subtitle: Text(
                          "Calories: ${(double.parse(item.caloriesKcal) * 100).round()} Kcal (100g)"),
                      trailing: IconButton(
                        onPressed: () async {
                          dialogController.clear();
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
                                        Platform.isAndroid
                                            ? FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.]'))
                                            : FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.,]')),
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
                                          var dialogText = dialogController
                                              .value.text
                                              .replaceAll(",", ".");
                                          setState(() {
                                            if (dialogText.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "N° of grams must not be empty",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else if (dialogText.substring(
                                                    0, 1) ==
                                                ".") {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "N° of grams must not start with .",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else if (dialogText
                                                        .split(".")
                                                        .length -
                                                    1 >
                                                1) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "There are too much dots",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else if (double.parse(
                                                    dialogText) ==
                                                0.0) {
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
                                            } else {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                gramsSelected =
                                                    double.parse(dialogText);
                                              });
                                            }
                                            dialogController.clear();
                                          });
                                        },
                                      ),
                                    ],
                                  ));

                          if (gramsSelected != 0) {
                            int totCalories = (double.parse(item.caloriesKcal) *
                                    gramsSelected)
                                .toInt();
                            var food = Pair(
                                aliment: item,
                                grams: gramsSelected.toString(),
                                totalCalories: totCalories.toString(),
                                isRecipe: "false");
                            addFood(widget.partOfDay, food);
                            updateAlimentaryPlan(
                                globals.listPlans
                                    .where(
                                        (element) => element.day == widget.day)
                                    .first,
                                widget.day);
                          }
                        },
                        icon: const Icon(Icons.add_circle_rounded, size: 35),
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
                          updateAlimentaryPlan(
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
                  itemCount: ingredientsFromSearch.length,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: const Color.fromARGB(0, 255, 255, 255),
                padding: const EdgeInsets.only(top: 17.0),
                child: SearchWidget(
                  text: searchTextRecipe,
                  hintText: "Search recipes",
                  onChanged: (text) => setState(
                    () {
                      searchTextRecipe = text;
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (context, index) {
                    var item = recipesFromSearch[index];
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
                          dialogController.clear();
                          double gramsSelected = 0;
                          await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title:
                                        Text("Grams for ${item.recipeName}:"),
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
                                        Platform.isAndroid
                                            ? FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.]'))
                                            : FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.,]')),
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
                                          setState(() {
                                            var dialogText = dialogController
                                                .value.text
                                                .replaceAll(",", ".");
                                            if (dialogText.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "N° of grams must not be empty",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else if (dialogText.substring(
                                                    0, 1) ==
                                                ".") {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "N° of grams must not start with .",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else if (dialogText
                                                        .split(".")
                                                        .length -
                                                    1 >
                                                1) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "There are too much dots",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else if (double.parse(
                                                    dialogText) ==
                                                0.0) {
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
                                            } else {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                gramsSelected =
                                                    double.parse(dialogText);
                                              });
                                            }
                                            dialogController.clear();
                                          });
                                        },
                                      ),
                                    ],
                                  ));

                          if (gramsSelected != 0) {
                            int totCalories =
                                (totCal / totgram * gramsSelected).toInt();
                            var food = Pair(
                                aliment: item,
                                grams: gramsSelected.toString(),
                                totalCalories: totCalories.toString(),
                                isRecipe: "true");
                            addFood(widget.partOfDay, food);
                          }
                        },
                        icon: const Icon(Icons.add_circle_rounded, size: 35),
                        color: const Color.fromARGB(255, 52, 141, 214),
                      ),
                      onTap: () async {
                        final Pair? itemToAdd = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewSavedRecipe(
                              savedRecipe: item,
                              isAddMode: true,
                            ),
                          ),
                        );
                        if (itemToAdd != null) {
                          addFood(widget.partOfDay, itemToAdd);
                          updateAlimentaryPlan(
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
                  itemCount: recipesFromSearch.length,
                ),
              ),
            ],
          )
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
    Fluttertoast.showToast(msg: "Meal added");
  }
}
