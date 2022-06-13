import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:project_app/models/food.dart';
import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/personal_alimetar_plan.dart';
import 'package:project_app/models/recipe.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class AlimentarPlan extends StatelessWidget {
  const AlimentarPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AlimentarPlanPage();
  }
}

class Pair<Food, int, double> {
  final Food a;
  final int b;
  final double c;

  Pair(this.a, this.b, this.c);
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
  late List<AlimentarPlanDiary> plans;
  late List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();

    // Initial Selected Value
    dropdownvalue = DateFormat('EEEE').format(DateTime.now());

    plans = List.of([
      AlimentarPlanDiary(
          uid: "AAA",
          day: "Tuesday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(
          uid: "AAA",
          day: "Wednesday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(
          uid: "AAA",
          day: "Thursday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(
          uid: "AAA",
          day: "Saturday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(
          uid: "AAA",
          day: "Sunday",
          breakfast: [],
          lunch: [],
          snack: [],
          dinner: []),
      AlimentarPlanDiary(uid: "AAA", day: "Monday", breakfast: [
        Pair(
            globals.listIngredients
                .where((element) => element.name == "avocado")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "avocado")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            globals.listIngredients
                .where((element) => element.name == "rice")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "rice")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            Recipe(userId: "Test", recipeName: "Test Recipe", ingredients: [
              globals.listIngredients
                  .where((element) => element.name == "rice")
                  .first,
              globals.listIngredients
                  .where((element) => element.name == "avocado")
                  .first
            ]),
            100,
            300),
      ], lunch: [
        Pair(
            globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ], snack: [
        Pair(
            globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ], dinner: [
        Pair(
            globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ]),
      AlimentarPlanDiary(uid: "AAA", day: "Friday", breakfast: [
        Pair(
            globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            globals.listIngredients
                .where((element) => element.name == "mushroom")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "mushroom")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            Recipe(userId: "Test", recipeName: "Test Recipe", ingredients: [
              globals.listIngredients
                  .where((element) => element.name == "mushroom")
                  .first,
              globals.listIngredients
                  .where((element) => element.name == "avocado")
                  .first
            ]),
            100,
            300),
      ], lunch: [
        Pair(
            globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ], snack: [
        Pair(
            globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ], dinner: [
        Pair(
            globals.listIngredients
                .where((element) => element.name == "green apple")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "green apple")
                    .first
                    .caloriesKcal) *
                100),
        Pair(
            globals.listIngredients
                .where((element) => element.name == "strawberry")
                .first,
            100,
            double.parse(globals.listIngredients
                    .where((element) => element.name == "strawberry")
                    .first
                    .caloriesKcal) *
                100)
      ])
    ]);

    item = plans.where((element) => element.day == dropdownvalue).first;
  }

  //TODO: to change
  void createListPlans() {
    if (globals.listPlans.isEmpty) {
      firestoreInstance
          .collection('alimentar_plans')
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          Map<String, dynamic> data = result.data();
          AlimentarPlanDiary plans = AlimentarPlanDiary.fromJson(data);
          globals.listPlans.add(plans);
        }
      });
    }
  }

  callbackRemove(partOfTheDay, indexOfFoodToRemove) {
    setState(() {
      removeFood(partOfTheDay, indexOfFoodToRemove);
    });
  }

  void removeFood(partOfTheDay, indexOfFoodToRemove) {
    var dailyPlan = plans.where((element) => element == item).first;
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
  }

  callbackAdd(partOfTheDay, foodToAdd) {
    setState(() {
      addFood(partOfTheDay, foodToAdd);
    });
  }

  void addFood(partOfTheDay, foodToAdd) {
    var dailyPlan = plans.where((element) => element == item).first;
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
      var dailyPlan = plans.where((element) => element == item).first;
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
                  items: days.map((String items) {
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
                      item = plans
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
                      callbackAdd),
                  MealExpander(
                      cardLunch,
                      "Lunch",
                      item.lunch,
                      const Icon(Icons.lunch_dining),
                      callbackRemove,
                      callbackAdd),
                  MealExpander(cardSnack, "Snack", item.snack,
                      const Icon(Icons.set_meal), callbackRemove, callbackAdd),
                  MealExpander(
                      cardDinner,
                      "Dinner",
                      item.dinner,
                      const Icon(Icons.dinner_dining),
                      callbackRemove,
                      callbackAdd),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MealExpander extends StatefulWidget {
  final GlobalKey<ExpansionTileCardState> cardKey;
  final String title;
  final List<Pair<dynamic, dynamic, dynamic>> foods_list;
  final Icon icon;
  final Function callbackRemove;
  final Function callbackAdd;

  const MealExpander(this.cardKey, this.title, this.foods_list, this.icon,
      this.callbackRemove, this.callbackAdd,
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
            widget.foods_list.length,
            widget.foods_list.fold(
                0, (previousValue, element) => previousValue + element.c)),
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
                var item = widget.foods_list[index].a as Food;
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
                      onPressed: (_) {},
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
                        Text("Total grams: ${widget.foods_list[index].b}"),
                        Text(
                            "Total calories: ${widget.foods_list[index].c} Kcal")
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: widget.foods_list.length)
        ],
      ),
    );
  }

  Widget _buildTitle(String titleName, int numberOfItem, double totalCalories) {
    int totcal = totalCalories.round();
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
            onPressed: () {
              //TODO: make the real functionality
              widget.callbackAdd(
                  titleName,
                  Pair(
                      globals.listIngredients
                          .where((element) => element.name == "chicken")
                          .first,
                      100,
                      double.parse(globals.listIngredients
                              .where((element) => element.name == "chicken")
                              .first
                              .caloriesKcal) *
                          100));
            },
            icon: const Icon(Icons.add))
      ],
    );
  }
}
