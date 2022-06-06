import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/models/ingredients.dart';
import 'package:project_app/models/recipe.dart';
import 'package:project_app/variables/global_variables.dart' as globals;
import 'dart:developer';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final firestoreInstance = FirebaseFirestore.instance;

  List<Ingredients> preprocessRecipeDataForFirestore() {
    List<Ingredients> ingredients = [];
    for (int i = 0; i < globals.selectedIngredients.length; i = i + 1) {
      ingredients.add(Ingredients(
          emoji: globals.selectedIngredients[i].emoji,
          caloriesKcal: globals.selectedIngredients[i].caloriesKcal,
          name: globals.selectedIngredients[i].name,
          totalSugarG: globals.selectedIngredients[i].totalSugarG,
          proteinG: globals.selectedIngredients[i].proteinG,
          totalFatG: globals.selectedIngredients[i].totalFatG,
          carbohydratesG: globals.selectedIngredients[i].carbohydratesG,
          totalFiberG: globals.selectedIngredients[i].totalFiberG));
    }

    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            color: Colors.lightGreen,
            padding: const EdgeInsets.only(top: 10.0, left: 18.0),
            alignment: Alignment.topLeft,
            child: Text(
              "${globals.selectedIngredients.length} ingredients selected:",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 23, 6, 205)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 10.0, left: 1.0, right: 3.0),
              itemCount: globals.selectedIngredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "${globals.selectedIngredients[index].name.toUpperCase()} "
                    "(${globals.selectedIngredients[index].caloriesKcal} Kcal)",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Carbohydrates: ${globals.selectedIngredients[index].carbohydratesG} g"
                      "\n"
                      "Proteins: ${globals.selectedIngredients[index].proteinG} g"
                      "\n"
                      "Total Fats: ${globals.selectedIngredients[index].totalFatG} g"
                      "\n"
                      "Total Fibers: ${globals.selectedIngredients[index].totalFiberG} g"
                      "\n"
                      "Total Sugars: ${globals.selectedIngredients[index].totalSugarG} g"),
                  trailing: Text(globals.selectedIngredients[index].emoji,
                      style: const TextStyle(fontSize: 40)),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.lightGreen,
            alignment: Alignment.center,
            child: Row(
              children: [
                const SizedBox(
                  width: 18,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Total calories:",
                    ),
                    Text(
                      "${globals.selectedIngredients.fold(0.0, (previousValue, element) => double.parse(previousValue.toString()) + double.parse(element.caloriesKcal)).toStringAsFixed(3)} Kcal",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 88,
                ),
                SizedBox(
                  height: 55,
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      primary: const Color.fromARGB(255, 23, 91, 26),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Create recipe'),
                    onPressed: () async {
                      await firestoreInstance
                          .collection("recipes")
                          .add(Recipe(
                            userId:
                                "1", // TODO: UID given after the user authentication
                            recipeName:
                                "recipeName", // TODO: insert a textbox in which the user can type a name for its recipe
                            ingredients: preprocessRecipeDataForFirestore(),
                          ).toMap())
                          // ignore: invalid_return_type_for_catch_error
                          .catchError((err) => {
                                log(err.message.toString()),
                                Fluttertoast.showToast(
                                    msg:
                                        "Something is not working. Please, try again",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0),
                              });
                      // savedRecipes = []; --> is it necessary??
                      // TODO: before changing the context, disable all the checkboxs
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* TODO: HOW TO CAPTURE THE USER ID (FOR LOGIN!!!)
                        void addUser(User user) async {   
                        Map<String, dynamic> userData = user.ToMap();
                        await Firestore.instance.collection('user').add(userData).then(
                          (document) {
                            userId = document.documentID;
                            for (var i = 0; i < user.address.length; i++) {
                              Firestore.instance
                                  .collection('user')
                                  .document('$userId')
                                  .collection('address')
                                  .add(user.address.get(i));
                                }
                              },
                            );
                        }*/
