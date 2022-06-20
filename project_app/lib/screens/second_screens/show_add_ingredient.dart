import 'package:flutter/material.dart';
import 'package:project_app/models/ingredients.dart';

class ShowAddIngredient extends StatefulWidget {
  final Ingredients ingredient;

  const ShowAddIngredient({Key? key, required this.ingredient})
      : super(key: key);

  @override
  State<ShowAddIngredient> createState() => _ShowAddIngredientState();
}

class _ShowAddIngredientState extends State<ShowAddIngredient> {
  double gramsSelected = 100;

  Color colorForCarbo = const Color.fromARGB(255, 12, 235, 243);
  Color colorForProteins = const Color.fromARGB(255, 168, 35, 245);
  Color colorForFats = const Color.fromARGB(255, 240, 169, 39);

  @override
  Widget build(BuildContext context) {
    int caloriesCarbo =
        ((double.parse(widget.ingredient.carbohydratesG) * gramsSelected)
                    .toInt() *
                4)
            .round();
    int caloriesProt =
        ((double.parse(widget.ingredient.proteinG) * gramsSelected).toInt() * 4)
            .round();
    int caloriesFat =
        ((double.parse(widget.ingredient.totalFatG) * gramsSelected).toInt() *
                9)
            .round();
    int totalRealCalories = caloriesCarbo + caloriesProt + caloriesFat;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.ingredient.name.toUpperCase() + " Information")),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Values for 100 g",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "Calories (kcal): ${(double.parse(widget.ingredient.caloriesKcal) * 100).toInt()}"),
                          Text(
                              "Carbohydrates (g): ${(double.parse(widget.ingredient.carbohydratesG) * 100).toInt()}"),
                          Text(
                              "Proteins (g): ${(double.parse(widget.ingredient.proteinG) * 100).toInt()}"),
                          Text(
                              "Total Fat (g): ${(double.parse(widget.ingredient.totalFatG) * 100).toInt()}"),
                          Text(
                              "Total Fiber (g): ${(double.parse(widget.ingredient.totalFiberG) * 100).toInt()}"),
                          Text(
                              "Total Sugar (g): ${(double.parse(widget.ingredient.totalSugarG) * 100).toInt()}"),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.ingredient.emoji,
                        style: const TextStyle(fontSize: 80)),
                  ),
                ),
              ],
            ),
            Text(
              "Values for total gram selected ($gramsSelected g)",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                detailForGrams(
                    ((double.parse(widget.ingredient.carbohydratesG) *
                                    gramsSelected)
                                .toInt() *
                            4 /
                            totalRealCalories *
                            100)
                        .round(),
                    (double.parse(widget.ingredient.carbohydratesG) *
                            gramsSelected)
                        .toInt(),
                    "Carbohydrates",
                    colorForCarbo),
                detailForGrams(
                    ((double.parse(widget.ingredient.proteinG) * gramsSelected)
                                .toInt() *
                            4 /
                            totalRealCalories *
                            100)
                        .round(),
                    (double.parse(widget.ingredient.proteinG) * gramsSelected)
                        .toInt(),
                    "Proteins",
                    colorForProteins),
                detailForGrams(
                    (((double.parse(widget.ingredient.totalFatG) *
                                        gramsSelected)
                                    .toInt() *
                                9) /
                            totalRealCalories *
                            100)
                        .round(),
                    (double.parse(widget.ingredient.totalFatG) * gramsSelected)
                        .toInt(),
                    "Fats",
                    colorForFats),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget detailForGrams(int percent, int totalgram, String name, Color color) {
    return Column(
      children: <Widget>[
        Text(
          "$percent%",
          style: TextStyle(color: color),
        ),
        Text("${totalgram}g"),
        Text(name),
      ],
    );
  }
}
