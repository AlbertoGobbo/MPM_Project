import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:project_app/models/recipe.dart';
import 'package:project_app/models/pair.dart';

class ViewSavedRecipe extends StatefulWidget {
  final Recipe savedRecipe;

  final bool isAddMode;

  const ViewSavedRecipe(
      {Key? key, required this.savedRecipe, required this.isAddMode})
      : super(key: key);

  @override
  State<ViewSavedRecipe> createState() => _ViewSavedRecipeState();
}

class _ViewSavedRecipeState extends State<ViewSavedRecipe> {
  TextEditingController dialogController = TextEditingController();

  double selectedGrams = 100;

  Color colorForCarbo = const Color.fromARGB(255, 14, 201, 207);
  Color colorForProteins = const Color.fromARGB(255, 168, 35, 245);
  Color colorForFats = const Color.fromARGB(255, 218, 171, 17);

  late double totalGrams;
  late double totalCalories;
  late double totalCarbos;
  late double totalProteins;
  late double totalFats;
  late double totalFiber;
  late double totalSugar;

  late double totalCaloriesFor1Gram;
  late double totalCarboFor1Gram;
  late double totalProteinsFor1Gram;
  late double totalFatsFor1Gram;
  late double totalFiberFor1Gram;
  late double totalSugarFor1Gram;

  late int percentCarbo;
  late int percentProteins;
  late int percentFats;

  late Map<String, double> dataMap;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    dialogController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    totalGrams = widget.savedRecipe.ingredients.fold(
        0.0,
        (previousValue, element) =>
            double.parse(previousValue.toString()) +
            double.parse(element.totalGrams));

    totalCalories = widget.savedRecipe.ingredients.fold(
        0.0,
        (previousValue, element) =>
            double.parse(previousValue.toString()) +
            (double.parse(element.caloriesKcal) *
                double.parse(element.totalGrams)));

    totalCarbos = widget.savedRecipe.ingredients.fold(
        0.0,
        (previousValue, element) =>
            double.parse(previousValue.toString()) +
            (double.parse(element.carbohydratesG) *
                double.parse(element.totalGrams)));

    totalProteins = widget.savedRecipe.ingredients.fold(
        0.0,
        (previousValue, element) =>
            double.parse(previousValue.toString()) +
            (double.parse(element.proteinG) *
                double.parse(element.totalGrams)));

    totalFats = widget.savedRecipe.ingredients.fold(
        0.0,
        (previousValue, element) =>
            double.parse(previousValue.toString()) +
            (double.parse(element.totalFatG) *
                double.parse(element.totalGrams)));

    totalFiber = widget.savedRecipe.ingredients.fold(
        0.0,
        (previousValue, element) =>
            double.parse(previousValue.toString()) +
            (double.parse(element.totalFiberG) *
                double.parse(element.totalGrams)));

    totalSugar = widget.savedRecipe.ingredients.fold(
        0.0,
        (previousValue, element) =>
            double.parse(previousValue.toString()) +
            (double.parse(element.totalSugarG) *
                double.parse(element.totalGrams)));

    totalCaloriesFor1Gram = totalCalories / totalGrams;
    totalCarboFor1Gram = totalCarbos / totalGrams;
    totalProteinsFor1Gram = totalProteins / totalGrams;
    totalFatsFor1Gram = totalFats / totalGrams;
    totalFiberFor1Gram = totalFiber / totalGrams;
    totalSugarFor1Gram = totalSugar / totalGrams;

    if (totalCalories == 0) {
      percentProteins = 0;
      percentFats = 0;
      percentCarbo = 0;
    } else {
      percentCarbo = (((totalCarboFor1Gram * selectedGrams).toInt() *
                  4 /
                  (totalCaloriesFor1Gram * 100)) *
              100)
          .round();

      /*percentProteins = (((totalProteinsFor1Gram * selectedGrams).toInt() *
                  4 /
                  (totalCaloriesFor1Gram * 100)) *
              100)
          .round();*/
      percentFats = (((totalFatsFor1Gram * selectedGrams).toInt() *
                  9 /
                  (totalCaloriesFor1Gram * 100)) *
              100)
          .round();

      percentProteins = 100 - (percentCarbo + percentFats);
      if (percentProteins < 0) percentProteins = 0;
    }

    dataMap = <String, double>{
      "Carbos": percentCarbo.toDouble(),
      "Proteins": percentProteins.toDouble(),
      "Fats": percentFats.toDouble()
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "${widget.savedRecipe.recipeName} "
          "(${widget.savedRecipe.ingredients.fold(0.0, (previousValue, element) => double.parse(previousValue.toString()) + (double.parse(element.caloriesKcal) * double.parse(element.totalGrams))).round()} Kcal)",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: widget.isAddMode ? buildEnableAdd() : buildOnlyViewRecipe(),
    );
  }

  buildOnlyViewRecipe() {
    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      itemCount: widget.savedRecipe.ingredients.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            "${widget.savedRecipe.ingredients[index].name.toUpperCase()} "
            "(${(double.parse(widget.savedRecipe.ingredients[index].caloriesKcal) * double.parse(widget.savedRecipe.ingredients[index].totalGrams)).toStringAsFixed(2).replaceAll(".", ",")} Kcal)",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        "Calories (Kcal/g): ${widget.savedRecipe.ingredients[index].caloriesKcal} Kcal"),
                const TextSpan(text: "\n"),
                TextSpan(
                    text:
                        "Carbohydrates/g: ${widget.savedRecipe.ingredients[index].carbohydratesG}"),
                const TextSpan(text: "\n"),
                TextSpan(
                    text:
                        "Proteins/g: ${widget.savedRecipe.ingredients[index].proteinG}"),
                const TextSpan(text: "\n"),
                TextSpan(
                    text:
                        "Total Fats/g: ${widget.savedRecipe.ingredients[index].totalFatG}"),
                const TextSpan(text: "\n"),
                TextSpan(
                    text:
                        "Total Fibers/g: ${widget.savedRecipe.ingredients[index].totalFiberG}"),
                const TextSpan(text: "\n"),
                TextSpan(
                    text:
                        "Total Sugars/g: ${widget.savedRecipe.ingredients[index].totalSugarG}"),
                const TextSpan(text: "\n"),
                TextSpan(
                    text:
                        "Total Grams: ${widget.savedRecipe.ingredients[index].totalGrams} g",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
          trailing: Text(widget.savedRecipe.ingredients[index].emoji,
              style: const TextStyle(fontSize: 40)),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }

  buildEnableAdd() {
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Ingredients list",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 158,
          child: ListView.separated(
            padding: const EdgeInsets.all(10.0),
            itemCount: widget.savedRecipe.ingredients.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  "${widget.savedRecipe.ingredients[index].name.toUpperCase()} "
                  "(${(double.parse(widget.savedRecipe.ingredients[index].caloriesKcal) * double.parse(widget.savedRecipe.ingredients[index].totalGrams)).toStringAsFixed(2).replaceAll(".", ",")} Kcal)",
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
                              "Calories (Kcal/g): ${widget.savedRecipe.ingredients[index].caloriesKcal} Kcal"),
                      const TextSpan(text: "\n"),
                      TextSpan(
                          text:
                              "Carbohydrates/g: ${widget.savedRecipe.ingredients[index].carbohydratesG}"),
                      const TextSpan(text: "\n"),
                      TextSpan(
                          text:
                              "Proteins/g: ${widget.savedRecipe.ingredients[index].proteinG}"),
                      const TextSpan(text: "\n"),
                      TextSpan(
                          text:
                              "Total Fats/g: ${widget.savedRecipe.ingredients[index].totalFatG}"),
                      const TextSpan(text: "\n"),
                      TextSpan(
                          text:
                              "Total Fibers/g: ${widget.savedRecipe.ingredients[index].totalFiberG}"),
                      const TextSpan(text: "\n"),
                      TextSpan(
                          text:
                              "Total Sugars/g: ${widget.savedRecipe.ingredients[index].totalSugarG}"),
                      const TextSpan(text: "\n"),
                      TextSpan(
                          text:
                              "Total Grams: ${((double.parse(widget.savedRecipe.ingredients[index].totalGrams) / totalGrams) * selectedGrams).round()} g",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                ),
                trailing: Text(widget.savedRecipe.ingredients[index].emoji,
                    style: const TextStyle(fontSize: 40)),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        ),
        const Divider(
          height: 10,
          thickness: 3,
          color: Colors.black,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                textAlign: TextAlign.center,
                "Values for total grams selected ($selectedGrams g)",
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                  "Calories (Kcal): ${(totalCaloriesFor1Gram * selectedGrams).toInt()}"),
              Text(
                  "Carbohydrates (g): ${(totalCarboFor1Gram * selectedGrams).toInt()}"),
              Text(
                  "Proteins (g): ${(totalProteinsFor1Gram * selectedGrams).toInt()}"),
              Text(
                  "Total Fat (g): ${(totalFatsFor1Gram * selectedGrams).toInt()}"),
              Text(
                  "Total Fiber (g): ${(totalFiberFor1Gram * selectedGrams).toInt()}"),
              Text(
                  "Total Sugar (g): ${(totalSugarFor1Gram * selectedGrams).toInt()}"),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PieChart(
                dataMap: dataMap,
                chartRadius: MediaQuery.of(context).size.width / 4.4,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                centerText:
                    "${(totalCaloriesFor1Gram * selectedGrams).toInt()} \n kcal",
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
                  (totalCarboFor1Gram * selectedGrams).toInt(),
                  "Carbohydrates",
                  colorForCarbo),
              const Spacer(),
              detailForGrams(
                  percentProteins,
                  (totalProteinsFor1Gram * selectedGrams).toInt(),
                  "Proteins",
                  colorForProteins),
              const Spacer(),
              detailForGrams(
                  percentFats,
                  (totalFatsFor1Gram * selectedGrams).toInt(),
                  "Fats",
                  colorForFats),
              const Spacer(),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                        title:
                            Text("Grams for ${widget.savedRecipe.recipeName}:"),
                        content: TextField(
                          autofocus: true,
                          controller: dialogController,
                          decoration: const InputDecoration(
                            hintText: "Enter grams",
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
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
                                if (dialogController.value.text.isNotEmpty) {
                                  if (dialogController.value.text
                                          .substring(0, 1) !=
                                      ".") {
                                    if ((double.parse(
                                            dialogController.value.text) !=
                                        0.0)) {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        selectedGrams =
                                            double.parse(dialogController.text);
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
            child: const Padding(
              padding: EdgeInsets.all(11.0),
              child: Text(
                "Change total grams",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            int totCalories = (totalCaloriesFor1Gram * selectedGrams).toInt();
            var food = Pair(
                aliment: widget.savedRecipe,
                grams: selectedGrams.toString(),
                totalCalories: totCalories.toString(),
                isRecipe: "true");
            Navigator.of(context).pop(food);
          },
          child: const Padding(
            padding: EdgeInsets.all(11.0),
            child: Text(
              "Add Recipe",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        const Spacer(),
      ],
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
