import 'package:flutter/material.dart';
import 'package:project_app/models/recipe.dart';

class ViewSavedRecipe extends StatelessWidget {
  final Recipe savedRecipe;

  const ViewSavedRecipe({Key? key, required this.savedRecipe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${savedRecipe.recipeName} "
          "(${savedRecipe.ingredients.fold(0.0, (previousValue, element) => double.parse(previousValue.toString()) + (double.parse(element.caloriesKcal) * double.parse(element.totalGrams))).toStringAsFixed(3).replaceAll(".", ",")} Kcal)",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        itemCount: savedRecipe.ingredients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "${savedRecipe.ingredients[index].name.toUpperCase()} "
              "(${(double.parse(savedRecipe.ingredients[index].caloriesKcal) * double.parse(savedRecipe.ingredients[index].totalGrams)).toStringAsFixed(3).replaceAll(".", ",")} Kcal)",
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
                          "Calories (Kcal/g): ${savedRecipe.ingredients[index].caloriesKcal} Kcal"),
                  const TextSpan(text: "\n"),
                  TextSpan(
                      text:
                          "Carbohydrates/g: ${savedRecipe.ingredients[index].carbohydratesG}"),
                  const TextSpan(text: "\n"),
                  TextSpan(
                      text:
                          "Proteins/g: ${savedRecipe.ingredients[index].proteinG}"),
                  const TextSpan(text: "\n"),
                  TextSpan(
                      text:
                          "Total Fats/g: ${savedRecipe.ingredients[index].totalFatG}"),
                  const TextSpan(text: "\n"),
                  TextSpan(
                      text:
                          "Total Fibers/g: ${savedRecipe.ingredients[index].totalFiberG}"),
                  const TextSpan(text: "\n"),
                  TextSpan(
                      text:
                          "Total Sugars/g: ${savedRecipe.ingredients[index].totalSugarG}"),
                  const TextSpan(text: "\n"),
                  TextSpan(
                      text:
                          "Total Grams: ${savedRecipe.ingredients[index].totalGrams} g",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
            trailing: Text(savedRecipe.ingredients[index].emoji,
                style: const TextStyle(fontSize: 40)),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
