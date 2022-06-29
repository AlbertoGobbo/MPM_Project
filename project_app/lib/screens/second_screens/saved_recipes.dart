import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  List<Recipe> selectedRecipes = [];
  List<bool> selectingStateRecipes = [];

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
    selectingStateRecipes =
        List<bool>.filled(globals.savedRecipes.length, false, growable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        itemCount: globals.savedRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              globals.savedRecipes[index].recipeName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("Tap to see all the recipe ingredients"),
            trailing: selectingStateRecipes[index]
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green[700],
                  )
                : null,
            onTap: () {
              setState(() {
                if (selectingMode == true) {
                  _manageSelectingMode(index);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ViewSavedRecipe(
                          savedRecipe: globals.savedRecipes[index])));
                }
              });
            },
            onLongPress: () {
              setState(() {
                selectingMode = true;
                _manageSelectingMode(index);
              });
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
