library globals;

import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/personal_alimentar_plan.dart';
import 'package:project_app/models/recipe.dart';

String uidUser = "";
String username = "";
List<bool> isCheckboxChecked = [];
List<Ingredients> listIngredients = [];
List<Ingredients> selectedIngredients = [];
List<Recipe> savedRecipes = [];
List<AlimentarPlanDiary> listPlans = [];

void clearGlobalVariables() {
  username = "";
  uidUser = "";
  listIngredients.clear();
  isCheckboxChecked.clear();
  selectedIngredients.clear();
  savedRecipes.clear();
  listPlans.clear();
}
