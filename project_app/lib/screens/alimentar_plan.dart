import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:project_app/firebase/firestore_function.dart';
import 'package:project_app/models/food.dart';
import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/pair.dart';
import 'package:project_app/models/personal_alimentar_plan.dart';
import 'package:project_app/screens/second_screens/choose_aliment.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class AlimentarPlan extends StatelessWidget {
  const AlimentarPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AlimentarPlanPage();
  }
}

class AlimentarPlanPage extends StatefulWidget {
  const AlimentarPlanPage({Key? key}) : super(key: key);

  @override
  State<AlimentarPlanPage> createState() => _AlimentarPlanPageState();
}

class _AlimentarPlanPageState extends State<AlimentarPlanPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<ExpansionTileCardState> cardBreakfast = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardLunch = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardSnack = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardDinner = GlobalKey();
  late AlimentarPlanDiary item;
  late String dropdownvalue;
  //late List<AlimentarPlanDiary> plans;

  @override
  void initState() {
    super.initState();

    // Initial Selected Value
    dropdownvalue = DateFormat('EEEE').format(DateTime.now());

    /*plans = List.of([
      AlimentarPlanDiary(
          uid: globals.uidUser,
          day: "Tuesday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(
          uid: globals.uidUser,
          day: "Wednesday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(
          uid: globals.uidUser,
          day: "Thursday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(
          uid: globals.uidUser,
          day: "Saturday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(
          uid: globals.uidUser,
          day: "Sunday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(uid: globals.uidUser, day: "Monday", breakfast: [
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "avocado")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "avocado")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "rice")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "rice")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.savedRecipes.first,
            grams: 100,
            totalCalories: 300),
      ], lunch: [
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ], snack: [
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ], dinner: [
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ]),
      AlimentarPlanDiary(uid: globals.uidUser, day: "Friday", breakfast: [
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "mushroom")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "mushroom")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.savedRecipes.first,
            grams: 100,
            totalCalories: 300),
      ], lunch: [
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ], snack: [
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ], dinner: [
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            aliment: globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            grams: 100,
            totalCalories: double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ])
    ]);*/

    //saveIntoFirestore(plans);
    item = globals.listPlans
        .where((element) => element.day == dropdownvalue)
        .first;
  }

  callbackRemove(partOfTheDay, indexOfFoodToRemove) {
    setState(() {
      removeFood(partOfTheDay, indexOfFoodToRemove);
    });
  }

  void removeFood(partOfTheDay, indexOfFoodToRemove) {
    var dailyPlan = globals.listPlans.where((element) => element == item).first;
    switch (partOfTheDay) {
      case "Breakfast":
        dailyPlan.breakfast.removeAt(indexOfFoodToRemove);
        break;
      case "Lunch":
        dailyPlan.lunch.removeAt(indexOfFoodToRemove);
        break;
      case "Snack":
        dailyPlan.snack.removeAt(indexOfFoodToRemove);
        break;
      case "Dinner":
        dailyPlan.dinner.removeAt(indexOfFoodToRemove);
        break;
    }

    updateAlimentarPlan(dailyPlan, dropdownvalue);
  }

  callbackSetState() {
    setState(() {});
  }

  void addFood(partOfTheDay, foodToAdd) {
    var dailyPlan = globals.listPlans.where((element) => element == item).first;
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
  }

  callbackMove(partOfTheDayOld, partOfTheDayNew, index) {
    setState(() {
      var dailyPlan =
          globals.listPlans.where((element) => element == item).first;
      late Pair food;
      switch (partOfTheDayOld) {
        case "Breakfast":
          food = dailyPlan.breakfast.elementAt(index);
          break;
        case "Lunch":
          food = dailyPlan.lunch.elementAt(index);
          break;
        case "Snack":
          food = dailyPlan.snack.elementAt(index);
          break;
        case "Dinner":
          food = dailyPlan.dinner.elementAt(index);
          break;
      }

      removeFood(partOfTheDayOld, index);
      addFood(partOfTheDayNew, food);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color:
                      Colors.greenAccent, //background color of dropdown button
                  border: Border.all(
                      color: Colors.black38,
                      width: 3), //border of dropdown button
                  borderRadius: BorderRadius.circular(
                      50), //border raiuds of dropdown button
                  boxShadow: const <BoxShadow>[
                    //apply shadow on Dropdown button
                    BoxShadow(
                        color:
                            Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                        blurRadius: 5) //blur radius of shadow
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: DropdownButton(
                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: globals.days.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                      item = globals.listPlans
                          .where((element) => element.day == dropdownvalue)
                          .first;
                    });
                  },
                  style: const TextStyle(color: Colors.black87, fontSize: 22),
                  underline: Container(),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  MealExpander(
                    cardBreakfast,
                    "Breakfast",
                    item.breakfast,
                    const Icon(Icons.free_breakfast),
                    callbackRemove,
                    dropdownvalue,
                    callbackSetState,
                    callbackMove,
                  ),
                  MealExpander(
                    cardLunch,
                    "Lunch",
                    item.lunch,
                    const Icon(Icons.lunch_dining),
                    callbackRemove,
                    dropdownvalue,
                    callbackSetState,
                    callbackMove,
                  ),
                  MealExpander(
                    cardSnack,
                    "Snack",
                    item.snack,
                    const Icon(Icons.set_meal),
                    callbackRemove,
                    dropdownvalue,
                    callbackSetState,
                    callbackMove,
                  ),
                  MealExpander(
                    cardDinner,
                    "Dinner",
                    item.dinner,
                    const Icon(Icons.dinner_dining),
                    callbackRemove,
                    dropdownvalue,
                    callbackSetState,
                    callbackMove,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> saveIntoFirestore(List<AlimentarPlanDiary> plans) async {
    for (var i in plans) {
      await firestoreInstance
          .collection("alimentarPlans")
          .add(i.toJson())
          // ignore: invalid_return_type_for_catch_error
          .catchError((err) => {
                log(err.message.toString()),
                Fluttertoast.showToast(
                    msg: "Something is not working. Please, try again",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0),
              });
    }
  }
}

class MealExpander extends StatefulWidget {
  final GlobalKey<ExpansionTileCardState> cardKey;
  final String title;
  final List<Pair> foodsList;
  final Icon icon;
  final Function callbackRemove;
  final String day;
  final Function setStateCallback;
  final Function callbackMove;

  const MealExpander(this.cardKey, this.title, this.foodsList, this.icon,
      this.callbackRemove, this.day, this.setStateCallback, this.callbackMove,
      {Key? key})
      : super(key: key);

  @override
  State<MealExpander> createState() => _MealExpanderState();
}

class _MealExpanderState extends State<MealExpander> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTileCard(
        key: widget.cardKey,
        baseColor: Colors.white,
        elevation: 2,
        title: _buildTitle(
            widget.title,
            widget.foodsList.length,
            widget.foodsList.fold(
                0,
                (previousValue, element) =>
                    previousValue + double.parse(element.totalCalories)),
            widget.day,
            widget.setStateCallback),
        leading: widget.icon,
        children: <Widget>[
          const Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                int i = index;
                var item = widget.foodsList[index].aliment;
                return Slidable(
                  key: const ValueKey(0),
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      // An action can be bigger than the others.
                      flex: 1,
                      onPressed: (_) {
                        widget.callbackRemove(widget.title, i);
                      },
                      backgroundColor: const Color.fromARGB(255, 219, 26, 26),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      // An action can be bigger than the others.
                      flex: 1,
                      onPressed: (_) {
                        shoDialogForMoveFood(context, item, index);
                      },
                      backgroundColor: const Color.fromARGB(255, 19, 189, 84),
                      foregroundColor: Colors.white,
                      icon: Icons.drive_file_move,
                      label: 'Move',
                    ),
                  ]),
                  child: ListTile(
                    title: Text(
                      item.getName().toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      item is Ingredients
                          ? item.getAdditionalDetail()
                          : "N° Ingr.: ${item.getAdditionalDetail()}",
                      style: item is Ingredients
                          ? const TextStyle(fontSize: 40)
                          : const TextStyle(fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Total grams: ${widget.foodsList[index].grams}"),
                        Text(
                            "Total calories: ${widget.foodsList[index].totalCalories} Kcal")
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: widget.foodsList.length)
        ],
      ),
    );
  }

  void shoDialogForMoveFood(BuildContext context, Food item, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Where to move ${item.getName().toUpperCase()}:"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.title != "Breakfast")
              TextButton(
                child: const Text("Breakfast"),
                onPressed: () {
                  widget.callbackMove(widget.title, "Breakfast", index);
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Move to Breakfast done!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                },
              ),
            if (widget.title != "Lunch")
              TextButton(
                child: const Text("Lunch"),
                onPressed: () {
                  widget.callbackMove(widget.title, "Lunch", index);
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Move to Lunch done!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                },
              ),
            if (widget.title != "Snack")
              TextButton(
                child: const Text("Snack"),
                onPressed: () {
                  widget.callbackMove(widget.title, "Snack", index);
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Move to Snack done!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                },
              ),
            if (widget.title != "Dinner")
              TextButton(
                child: const Text("Dinner"),
                onPressed: () {
                  widget.callbackMove(widget.title, "Dinner", index);
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Move to Dinner done!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                },
              )
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String titleName, int numberOfItem, double totalCalories,
      String day, Function callbackSetState) {
    int totcal = totalCalories.toInt();
    return Row(
      children: <Widget>[
        Text(titleName),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Items: $numberOfItem", style: const TextStyle(fontSize: 14)),
            Text("Tot. kCal: $totcal", style: const TextStyle(fontSize: 14))
          ],
        ),
        IconButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChooseAliment(
                            partOfDay: titleName,
                            day: day,
                          )));
              callbackSetState();
            },
            icon: const Icon(Icons.add))
      ],
    );
  }
}
