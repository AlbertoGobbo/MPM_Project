import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/recipe.dart';

import 'food.dart';

class Pair {
  final Food aliment;
  final String grams;
  final String totalCalories;
  final String isRecipe;

  Pair(
      {required this.aliment,
      required this.grams,
      required this.totalCalories,
      required this.isRecipe});

  Map<String, dynamic> toJson() => {
        "aliment": aliment.toMap(),
        "grams": grams,
        "totalCalories": totalCalories,
        "isRecipe": isRecipe
      };

  factory Pair.fromJson(Map<String, dynamic> json) => Pair(
      aliment: json["isRecipe"] == "true"
          ? Recipe.fromMap(json["aliment"])
          : Ingredients.fromMap(json["aliment"]),
      grams: json["grams"],
      totalCalories: json["totalCalories"],
      isRecipe: json["isRecipe"]);
}
