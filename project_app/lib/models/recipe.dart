import 'package:project_app/models/food.dart';
import 'package:project_app/models/ingredients.dart';
import 'dart:convert';

List<Recipe> ingredientsFromMap(String str) =>
    List<Recipe>.from(json.decode(str).map((x) => Recipe.fromMap(x)));

String ingredientsToMap(List<Recipe> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));


class Recipe extends Food {
  Recipe(
      {required this.userId,
      required this.recipeName,
      required this.ingredients});

  String userId;
  String recipeName;
  List<Ingredients> ingredients;

  Recipe copyWith({
    required String userId,
    required String recipeName,
    required List<Ingredients> ingredients,
  }) =>
      Recipe(
        userId: userId,
        recipeName: recipeName,
        ingredients: ingredients,
      );

  factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
        userId: json["userId"],
        recipeName: json["recipeName"],
        ingredients: List<Ingredients>.from(
            json["ingredients"].map((x) => Ingredients.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "recipeName": recipeName,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toMap())),
      };

  @override
  String getAdditionalDetail() {
    return ingredients.length.toString();
  }

  @override
  String getName() {
    return recipeName;
  }
}
