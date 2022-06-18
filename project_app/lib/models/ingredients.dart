import 'dart:convert';

import 'package:project_app/models/food.dart';

List<Ingredients> ingredientsFromMap(String str) =>
    List<Ingredients>.from(json.decode(str).map((x) => Ingredients.fromMap(x)));

String ingredientsToMap(List<Ingredients> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Ingredients extends Food {
  Ingredients({
    required this.emoji,
    required this.caloriesKcal,
    required this.name,
    required this.totalSugarG,
    required this.proteinG,
    required this.totalFatG,
    required this.carbohydratesG,
    required this.totalFiberG,
    required this.totalGrams,
  });

  String emoji;
  String caloriesKcal;
  String name;
  String totalSugarG;
  String proteinG;
  String totalFatG;
  String carbohydratesG;
  String totalFiberG;
  String totalGrams;

  Ingredients copyWith({
    required String emoji,
    required String caloriesKcal,
    required String name,
    required String totalSugarG,
    required String proteinG,
    required String totalFatG,
    required String carbohydratesG,
    required String totalFiberG,
    required String totalGrams,
  }) =>
      Ingredients(
        emoji: emoji,
        caloriesKcal: caloriesKcal,
        name: name,
        totalSugarG: totalSugarG,
        proteinG: proteinG,
        totalFatG: totalFatG,
        carbohydratesG: carbohydratesG,
        totalFiberG: totalFiberG,
        totalGrams: totalGrams,
      );

  factory Ingredients.fromMap(Map<String, dynamic> json) => Ingredients(
        emoji: json["emoji"],
        caloriesKcal: json["Calories (kcal)"],
        name: json["name"],
        totalSugarG: json["Total Sugar (g)"],
        proteinG: json["Protein (g)"],
        totalFatG: json["Total Fat (g)"],
        carbohydratesG: json["Carbohydrates (g)"],
        totalFiberG: json["Total Fiber (g)"],
        totalGrams: json["Total Grams"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "emoji": emoji,
        "Calories (kcal)": caloriesKcal,
        "name": name,
        "Total Sugar (g)": totalSugarG,
        "Protein (g)": proteinG,
        "Total Fat (g)": totalFatG,
        "Carbohydrates (g)": carbohydratesG,
        "Total Fiber (g)": totalFiberG,
        "Total Grams": totalGrams,
      };

  @override
  String getAdditionalDetail() {
    return emoji;
  }

  @override
  String getName() {
    return name;
  }
}
