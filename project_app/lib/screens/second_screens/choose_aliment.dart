import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/firebase/firestore_function.dart';
import 'package:project_app/models/pair.dart';
import 'package:project_app/screens/second_screens/show_add_ingredient.dart';
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
                  trailing: IconButton(
                    onPressed: () {
                      int totCalories =
                          (double.parse(item.caloriesKcal) * 100).toInt();
                      var food = Pair(
                          aliment: item,
                          grams: "100",
                          totalCalories: totCalories.toString(),
                          isRecipe: "false");
                      addFood(widget.partOfDay, food);
                      updateAlimentarPlan(
                          globals.listPlans
                              .where((element) => element.day == widget.day)
                              .first,
                          widget.day);
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
                for (var element in item.ingredients) {
                  totCal += double.parse(element.caloriesKcal).toInt();
                }
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
                  subtitle: Text("Calories: ${totCal * 100} Kcal (100g)"),
                  trailing: IconButton(
                    onPressed: () {
                      int totCalories = totCal * 100;
                      var food = Pair(
                          aliment: item,
                          grams: "100",
                          totalCalories: totCalories.toString(),
                          isRecipe: "true");
                      addFood(widget.partOfDay, food);
                    },
                    icon: const Icon(Icons.add_circle_rounded),
                    color: const Color.fromARGB(255, 52, 141, 214),
                  ),
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
