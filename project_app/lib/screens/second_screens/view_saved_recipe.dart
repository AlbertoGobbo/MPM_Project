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
        title: Text("Recipe: ${savedRecipe.recipeName}"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        itemCount: savedRecipe.ingredients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              savedRecipe.ingredients[index].name.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                "Calories: ${savedRecipe.ingredients[index].caloriesKcal} Kcal"
                "\n"
                "Carbohydrates: ${savedRecipe.ingredients[index].carbohydratesG} g"
                "\n"
                "Proteins: ${savedRecipe.ingredients[index].proteinG} g"
                "\n"
                "Total Fats: ${savedRecipe.ingredients[index].totalFatG} g"
                "\n"
                "Total Fibers: ${savedRecipe.ingredients[index].totalFiberG} g"
                "\n"
                "Total Sugars: ${savedRecipe.ingredients[index].totalSugarG} g"),
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
