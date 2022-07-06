import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/firebase/firestore_function.dart';
import 'package:project_app/helpers/search_widget.dart';
import 'package:project_app/models/recipe.dart';
import 'package:project_app/screens/second_screens/view_saved_recipe.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class SavedRecipes extends StatefulWidget {
  const SavedRecipes({Key? key}) : super(key: key);

  @override
  State<SavedRecipes> createState() => _SavedRecipesState();
}

class _SavedRecipesState extends State<SavedRecipes> {
  bool selectingMode = false;
  String searchTextRecipe = '';
  List<Recipe> selectedRecipes = [];
  List<bool> selectingStateRecipes = [];
  var mapSavedRecipesToCheckboxIndex = {};

  bool containsSearchTextRecipe(Recipe recipes) {
    return recipes.recipeName
        .toLowerCase()
        .contains(searchTextRecipe.toLowerCase());
  }

  void _manageSelectingMode(int index) {
    selectingStateRecipes[index] = !selectingStateRecipes[index];
    if (selectingStateRecipes[index] == true) {
      selectedRecipes.add(globals.savedRecipes[index]);
    } else {
      selectedRecipes.remove(globals.savedRecipes[index]);
    }
  }

  Future<void> _showDeleteRecipesDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: const Text("Do you want to delete the selected recipes?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                for (int i = 0; i < selectedRecipes.length; i = i + 1) {
                  globals.savedRecipes.remove(selectedRecipes[i]);
                  removeRecipeFromAlimentaryPlan(selectedRecipes[i]);

                  // Remove keyword "await" because the user would get stuck until a Future is returned if the offline mode is on
                  FirebaseFirestore.instance
                      .collection("recipes")
                      .where("userId", isEqualTo: globals.uidUser)
                      .where("recipeName",
                          isEqualTo: selectedRecipes[i].recipeName)
                      .get()
                      .then(
                          (snapshot) => snapshot.docs.single.reference.delete())
                      .whenComplete(() => setState(() {}));
                }

                setState(() {
                  selectedRecipes.clear();
                  selectingStateRecipes = List<bool>.filled(
                      globals.savedRecipes.length, false,
                      growable: true);
                  for (int i = 0; i < globals.savedRecipes.length; i = i + 1) {
                    mapSavedRecipesToCheckboxIndex[
                        globals.savedRecipes[i].recipeName] = i;
                  }
                  selectingMode = false;
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    selectingStateRecipes =
        List<bool>.filled(globals.savedRecipes.length, false, growable: true);
    for (int i = 0; i < globals.savedRecipes.length; i = i + 1) {
      mapSavedRecipesToCheckboxIndex[globals.savedRecipes[i].recipeName] = i;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipesFromSearch =
        globals.savedRecipes.where(containsSearchTextRecipe).toList();

    return Scaffold(
      appBar: AppBar(
        leading: selectingMode
            ? IconButton(
                icon: const Icon(Icons.undo),
                onPressed: () {
                  setState(() {
                    selectingStateRecipes.fillRange(
                        0, selectingStateRecipes.length, false);
                    selectedRecipes.clear();
                    selectingMode = false;
                  });
                },
              )
            : null,
        title: selectingMode
            ? Text("${selectedRecipes.length} recipes selected")
            : const Text("Your recipes"),
        actions: selectingMode && selectedRecipes.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  iconSize: 30.0,
                  padding: const EdgeInsets.all(13.5),
                  onPressed: () {
                    _showDeleteRecipesDialog();
                  },
                  tooltip: 'Delete selected recipes',
                ),
              ]
            : [],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            color: const Color.fromARGB(0, 255, 255, 255),
            padding: const EdgeInsets.only(top: 17.0),
            child: SearchWidget(
              text: searchTextRecipe,
              hintText: "Search recipes",
              onChanged: (text) => setState(
                () {
                  searchTextRecipe = text;
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(10.0),
              itemCount: recipesFromSearch.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    recipesFromSearch[index].recipeName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Tap to see all the recipe ingredients"),
                  trailing:
                      (recipesFromSearch.length == globals.savedRecipes.length
                              ? selectingStateRecipes[index]
                              : selectingStateRecipes[
                                  mapSavedRecipesToCheckboxIndex[
                                      recipesFromSearch[index].recipeName]])
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green[700],
                            )
                          : null,
                  onTap: () {
                    setState(() {
                      if (selectingMode == true) {
                        recipesFromSearch.length == globals.savedRecipes.length
                            ? _manageSelectingMode(index)
                            : _manageSelectingMode(
                                mapSavedRecipesToCheckboxIndex[
                                    recipesFromSearch[index].recipeName]);
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewSavedRecipe(
                                  savedRecipe: recipesFromSearch[index],
                                  isAddMode: false,
                                )));
                      }
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      selectingMode = true;
                      recipesFromSearch.length == globals.savedRecipes.length
                          ? _manageSelectingMode(index)
                          : _manageSelectingMode(mapSavedRecipesToCheckboxIndex[
                              recipesFromSearch[index].recipeName]);
                    });
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}

void removeRecipeFromAlimentaryPlan(Recipe selectedRecipe) {
  for (var plan in globals.listPlans) {
    bool isRemovedB = false;
    bool isRemovedL = false;
    bool isRemovedS = false;
    bool isRemovedD = false;

    if (plan.breakfast.isNotEmpty) {
      plan.breakfast.removeWhere((element) =>
          isRemovedB = element.aliment.getName() == selectedRecipe.recipeName);
    }

    if (plan.lunch.isNotEmpty) {
      plan.lunch.removeWhere((element) =>
          isRemovedL = element.aliment.getName() == selectedRecipe.recipeName);
    }

    if (plan.snack.isNotEmpty) {
      plan.snack.removeWhere((element) =>
          isRemovedS = element.aliment.getName() == selectedRecipe.recipeName);
    }

    if (plan.dinner.isNotEmpty) {
      plan.dinner.removeWhere((element) =>
          isRemovedD = element.aliment.getName() == selectedRecipe.recipeName);
    }

    if (isRemovedB || isRemovedL || isRemovedS || isRemovedD) {
      updateAlimentaryPlan(plan, plan.day);
    }
  }
}
