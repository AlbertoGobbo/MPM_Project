import 'package:flutter/material.dart';
import 'package:project_app/screens/second_screens/set_calories.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project_app/screens/second_screens/view_saved_recipe.dart';
import 'package:project_app/variables/global_variables.dart' as globals;
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:intl/intl.dart';

import '../models/pair.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentCarouselIndex = 0;

  List<T> mapRecipes<T>(List list, Function handler) {
    List<T> result = [];
    if (list.isEmpty) {
      result.add(handler(0, null));
    } else {
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }
    }

    return result;
  }

  setStateCallback() {
    setState(() {});
  }

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
        buildCaloriesConsume(
          context,
        ),
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
    ));
  }

  CarouselSlider buildListRecipes() {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: 160.0,
        enableInfiniteScroll: globals.savedRecipes.length <= 1 ? false : true,
        autoPlayCurve: Curves.fastOutSlowIn,
        aspectRatio: 2.0,
        onPageChanged: (index, reason) {
          setState(() {
            _currentCarouselIndex = index;
          });
        },
      ),
      itemCount: globals.savedRecipes.isEmpty ? 1 : globals.savedRecipes.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        if (globals.savedRecipes.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.3,
                        1
                      ],
                      colors: [
                        Color.fromARGB(255, 23, 91, 26),
                        Color.fromARGB(255, 168, 230, 170),
                      ]),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.warning_amber, color: Colors.white, size: 30),
                    SizedBox(height: 20),
                    Text(
                        "No recipe found"
                        "\n"
                        "Please create one",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.3,
                        1
                      ],
                      colors: [
                        Color.fromARGB(255, 23, 91, 26),
                        Color.fromARGB(255, 168, 230, 170),
                      ]),
                ),
                child: GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(globals.savedRecipes[index].recipeName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text(
                          "${globals.savedRecipes[index].ingredients.length} ingredients"
                          "\n"
                          "(${globals.savedRecipes[index].ingredients.fold(0.0, (previousValue, element) => double.parse(previousValue.toString()) + (double.parse(element.caloriesKcal) * double.parse(element.totalGrams))).toStringAsFixed(3).replaceAll(".", ",")} Kcal)",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewSavedRecipe(
                              savedRecipe: globals.savedRecipes[index],
                              isAddMode: false,
                            )));
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Row buildRowListRecipes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: mapRecipes<Widget>(globals.savedRecipes, (index, url) {
        return Container(
          width: 10.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentCarouselIndex == index
                ? const Color.fromARGB(255, 23, 91, 26)
                : const Color.fromARGB(255, 168, 230, 170),
          ),
        );
      }),
    );
  }

  buildCaloriesConsume(BuildContext context) {
    var colors = [
      const Color.fromARGB(255, 0, 255, 0),
      const Color.fromARGB(255, 251, 255, 3),
      const Color.fromARGB(255, 255, 0, 0),
    ];

    var today = DateFormat('EEEE').format(DateTime.now());
    var todayAlimentaryPlan =
        globals.listPlans.where((element) => element.day == today).first;
    var totCaloriesConsumedToday = 0.0;
    bool overflow = false;

    List<Pair> breakfast = todayAlimentaryPlan.breakfast;
    List<Pair> lunch = todayAlimentaryPlan.lunch;
    List<Pair> snack = todayAlimentaryPlan.snack;
    List<Pair> dinner = todayAlimentaryPlan.dinner;

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

    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              SetCaloriesGoal(setStateCallback: setStateCallback),
        ))
      },
      child: Container(
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
      ),
    );
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
}
