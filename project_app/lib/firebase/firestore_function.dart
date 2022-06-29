//Alimentar Plan Functions
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/personal_alimentar_plan.dart';
import 'package:project_app/models/recipe.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

// Main function
Future<void> retrieveUsername(User firebaseUser) async {
  if (globals.uidUser.isEmpty) {
    globals.uidUser = firebaseUser.uid;
  }

  if (globals.username.isEmpty) {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(globals.uidUser)
        .get()
        .then((querySnapshot) {
          Map<String, dynamic>? data = querySnapshot.data();
          globals.username = data!["username"];
        })
        .whenComplete(() => null)
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {log(error.message.toString())});
  }
}

// Main function
Future<void> retrieveIngredientsList() async {
  if (globals.listIngredients.isEmpty) {
    await FirebaseFirestore.instance
        .collection("ingredients")
        .get()
        .then((querySnapshot) {
          for (var result in querySnapshot.docs) {
            Map<String, dynamic> data = result.data();
            Ingredients ingredients = Ingredients.fromMap(data);
            globals.listIngredients.add(ingredients);
          }
        })
        .whenComplete(() => globals.listIngredients.sort((a, b) {
              return a.name.compareTo(b.name);
            }))
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {log(error.message.toString())});
  }
}

// Main function
Future<void> retrieveSavedRecipes() async {
  if (globals.savedRecipes.isEmpty) {
    await FirebaseFirestore.instance
        .collection("recipes")
        .where("userId", isEqualTo: globals.uidUser)
        .get()
        .then((querySnapshot) {
          for (var result in querySnapshot.docs) {
            Map<String, dynamic> data = result.data();
            Recipe recipe = Recipe.fromMap(data);
            globals.savedRecipes.add(recipe);
          }
        })
        .whenComplete(() => globals.savedRecipes.sort((a, b) {
              return a.recipeName.compareTo(b.recipeName);
            }))
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {log(error.message.toString())});
  }
}

// Main function
Future<void> retrieveSavedAlimentarPlans() async {
  if (globals.listPlans.isEmpty) {
    await FirebaseFirestore.instance
        .collection("alimentarPlans")
        .where("uid", isEqualTo: globals.uidUser)
        .get()
        .then((querySnapshot) {
          for (var result in querySnapshot.docs) {
            Map<String, dynamic> data = result.data();
            AlimentarPlanDiary plan = AlimentarPlanDiary.fromJson(data);
            globals.listPlans.add(plan);
          }
        })
        .whenComplete(() => null)
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {log(error.message.toString())});
  }

  if (globals.listPlans.isEmpty) {
    for (var day in globals.days) {
      await createAlimentarPlanForDay(day);
    }
  } else if (globals.listPlans.length != 7) {
    for (var day in globals.days) {
      var emptyCheck =
          globals.listPlans.where((element) => element.day == day).isEmpty;
      if (emptyCheck) {
        await createAlimentarPlanForDay(day);
      }
    }
  }
}

Future<void> updateAlimentarPlan(
    AlimentarPlanDiary dailyPlan, String day) async {
  var coll = await FirebaseFirestore.instance
      .collection("alimentarPlans")
      .where("uid", isEqualTo: globals.uidUser)
      .where("day", isEqualTo: day)
      .get();
  var id = coll.docs.first.id;
  FirebaseFirestore.instance
      .collection("alimentarPlans")
      .doc(id)
      .set(dailyPlan.toJson());
}

Future<void> createAlimentarPlanForDay(String day) async {
  AlimentarPlanDiary d = AlimentarPlanDiary(
      uid: globals.uidUser,
      day: day,
      breakfast: [],
      lunch: [],
      snack: [],
      dinner: []);

  globals.listPlans.add(d);
  await FirebaseFirestore.instance.collection("alimentarPlans").add(d.toJson());
}
