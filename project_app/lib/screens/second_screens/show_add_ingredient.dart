import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:project_app/models/ingredients.dart';

import '../../models/pair.dart';

class ShowAddIngredient extends StatefulWidget {
  final Ingredients ingredient;

  const ShowAddIngredient({Key? key, required this.ingredient})
      : super(key: key);

  @override
  State<ShowAddIngredient> createState() => _ShowAddIngredientState();
}

class _ShowAddIngredientState extends State<ShowAddIngredient> {
  double gramsSelected = 100;

  Color colorForCarbo = const Color.fromARGB(255, 14, 201, 207);
  Color colorForProteins = const Color.fromARGB(255, 168, 35, 245);
  Color colorForFats = const Color.fromARGB(255, 218, 171, 17);
  TextEditingController dialogController = TextEditingController();
  late int caloriesCarbo;
  late int caloriesProt;
  late int caloriesFat;
  late int totalRealCalories;
  late int percentCarbo;
  late int percentProteins;
  late int percentFats;

  late Map<String, double> dataMap;

  @override
  void initState() {
    super.initState();

    caloriesCarbo =
        ((double.parse(widget.ingredient.carbohydratesG) * gramsSelected)
                    .toInt() *
                4)
            .round();
    caloriesProt =
        ((double.parse(widget.ingredient.proteinG) * gramsSelected).toInt() * 4)
            .round();
    caloriesFat =
        ((double.parse(widget.ingredient.totalFatG) * gramsSelected).toInt() *
                9)
            .round();
    totalRealCalories = caloriesCarbo + caloriesProt + caloriesFat;

    if (totalRealCalories == 0) {
      percentProteins = 0;
      percentFats = 0;
      percentCarbo = 0;
    } else {
      percentCarbo =
          ((double.parse(widget.ingredient.carbohydratesG) * gramsSelected)
                      .toInt() *
                  4 /
                  totalRealCalories *
                  100)
              .round();

      percentProteins =
          ((double.parse(widget.ingredient.proteinG) * gramsSelected).toInt() *
                  4 /
                  totalRealCalories *
                  100)
              .round();
      percentFats =
          (((double.parse(widget.ingredient.totalFatG) * gramsSelected)
                          .toInt() *
                      9) /
                  totalRealCalories *
                  100)
              .round();
    }

    dataMap = <String, double>{
      "Carbos": percentCarbo.toDouble(),
      "Proteins": percentProteins.toDouble(),
      "Fats": percentFats.toDouble()
    };
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    dialogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            const Divider(
              height: 2,
              color: Colors.black26,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                "Values for total grams selected ($gramsSelected g)",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PieChart(
                    dataMap: dataMap,
                    chartRadius: MediaQuery.of(context).size.width / 4.4,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    centerText:
                        "${(double.parse(widget.ingredient.caloriesKcal) * gramsSelected).toInt()} \n kcal",
                    centerTextStyle: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    ringStrokeWidth: 8,
                    legendOptions: const LegendOptions(
                      showLegends: false,
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValues: false,
                    ),
                    colorList: [colorForCarbo, colorForProteins, colorForFats],
                  ),
                  const Spacer(),
                  detailForGrams(
                      percentCarbo,
                      (double.parse(widget.ingredient.carbohydratesG) *
                              gramsSelected)
                          .toInt(),
                      "Carbohydrates",
                      colorForCarbo),
                  const Spacer(),
                  detailForGrams(
                      percentProteins,
                      (double.parse(widget.ingredient.proteinG) * gramsSelected)
                          .toInt(),
                      "Proteins",
                      colorForProteins),
                  const Spacer(),
                  detailForGrams(
                      percentFats,
                      (double.parse(widget.ingredient.totalFatG) *
                              gramsSelected)
                          .toInt(),
                      "Fats",
                      colorForFats),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Grams for ${widget.ingredient.name}:"),
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
                                        if ((double.parse(
                                                dialogController.value.text) !=
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
                },
                child: const Text("Change total grams"),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  int totCalories =
                      (double.parse(widget.ingredient.caloriesKcal) *
                              gramsSelected)
                          .toInt();
                  var food = Pair(
                      aliment: widget.ingredient,
                      grams: gramsSelected.toString(),
                      totalCalories: totCalories.toString(),
                      isRecipe: "false");
                  Navigator.of(context).pop(food);
                },
                child: const Text("Add Ingredient")),
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
