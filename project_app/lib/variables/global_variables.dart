library globals;

import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/personal_alimentary_plan.dart';
import 'package:project_app/models/recipe.dart';

String uidUser = "";
String username = "";
String caloriesGoal = "2000";
List<bool> isCheckboxChecked = [];
List<Ingredients> listIngredients = [];
List<Ingredients> selectedIngredients = [];
List<Recipe> savedRecipes = [];
List<AlimentaryPlanDiary> listPlans = [];
List<String> days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

void clearGlobalVariables() {
  username = "";
  uidUser = "";
  listIngredients.clear();
  isCheckboxChecked.clear();
  selectedIngredients.clear();
  savedRecipes.clear();
  listPlans.clear();
}
