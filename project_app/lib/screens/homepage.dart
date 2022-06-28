import 'package:flutter/material.dart';
import 'package:project_app/screens/second_screens/set_calories.dart';
import 'package:project_app/variables/global_variables.dart' as globals;
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:intl/intl.dart';

import '../models/pair.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(flex: 1),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Text(
              "Welcome\n"
              "${globals.username}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(flex: 2),
          buildCaloriesConsume(context),
          const Spacer(flex: 2),
          const Expanded(
            child: Text(
              "Your recipes:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          buildListRecipes(),
          buildRowListRecipes(),
          const Spacer(),
        ],
      ),
    );
  }

  buildCaloriesConsume(BuildContext context) {
    var colors = [
      const Color.fromARGB(255, 0, 255, 0),
      const Color.fromARGB(255, 251, 255, 3),
      const Color.fromARGB(255, 255, 0, 0),
    ];

    var today = DateFormat('EEEE').format(DateTime.now());
    var todayAlimentarPlan =
        globals.listPlans.where((element) => element.day == today).first;
    var totCaloriesConsumedToday = 0.0;
    bool overflow = false;

    List<Pair> breakfast = todayAlimentarPlan.breakfast;
    List<Pair> lunch = todayAlimentarPlan.lunch;
    List<Pair> snack = todayAlimentarPlan.snack;
    List<Pair> dinner = todayAlimentarPlan.dinner;

    var totB = 0.0;

    for (Pair p in breakfast) {
      totB += double.parse(p.totalCalories);
    }

    var totL = 0.0;

    for (Pair p in lunch) {
      totL += double.parse(p.totalCalories);
    }

    var totS = 0.0;

    for (Pair p in snack) {
      totS += double.parse(p.totalCalories);
    }

    var totD = 0.0;

    for (Pair p in dinner) {
      totD += double.parse(p.totalCalories);
    }

    totCaloriesConsumedToday = totB + totL + totS + totD;

    var caloriesOverflow =
        totCaloriesConsumedToday.toInt() - int.parse(globals.caloriesGoal);

    if (caloriesOverflow > 0) {
      totCaloriesConsumedToday = double.parse(globals.caloriesGoal);
      overflow = true;
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Column(
          children: [
            const Text("CALORIES GOAL:"),
            Text(
              globals.caloriesGoal,
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SetCaloriesGoal(),
                ))
              },
              child: const Text("Change Goal"),
            ),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(progressBarWidth: 10),
                  customColors: CustomSliderColors(
                      trackColor: Colors.greenAccent,
                      progressBarColors: colors),
                  infoProperties: InfoProperties(
                    modifier: (percentage) {
                      return overflow
                          ? "${percentage.toInt()}+"
                          : "${percentage.toInt()}";
                    },
                  )),
              min: 0,
              max: double.parse(globals.caloriesGoal),
              initialValue:
                  totCaloriesConsumedToday, //totCaloriesConsumedToday.toDouble(),
            ),
            const Text("CALORIES OVERFLOW:"),
            Text(
              "$caloriesOverflow",
              style: TextStyle(color: getColorOveflow(caloriesOverflow)),
            ),
          ],
        ),
      ),
    );
  }

  buildListRecipes() {
    return const Text("TODO LIST");
  }

  getColorOveflow(int caloriesOverflow) {
    int cal = int.parse(globals.caloriesGoal);
    var divisor = cal / 3;
    if (caloriesOverflow > 0) {
      return Colors.red;
    } else if (caloriesOverflow > -cal && caloriesOverflow < -cal + divisor) {
      return Colors.redAccent;
    } else if (caloriesOverflow > -cal + divisor &&
        caloriesOverflow < -cal + divisor * 2) {
      return Colors.amber;
    } else if (caloriesOverflow > cal + divisor * 2 && caloriesOverflow <= 0) {
      return Colors.greenAccent;
    }
  }

  buildRowListRecipes() {
    return const Text("TODO");
  }
}
