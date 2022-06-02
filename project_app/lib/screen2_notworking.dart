import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app/models/ingredients.dart';
import './create_recipe.dart';

class Screen2NotWorking extends StatelessWidget {
  const Screen2NotWorking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IngredientsList(),
    );
  }
}

class IngredientsList extends StatefulWidget {
  const IngredientsList({Key? key}) : super(key: key);

  @override
  State<IngredientsList> createState() => _IngredientsListState();
}

// The state of ingredientsList, which can be changed inside the immutable ingredientsList widget
class _IngredientsListState extends State<IngredientsList> {
  final Stream<QuerySnapshot> _ingredientsStream =
      FirebaseFirestore.instance.collection('ingredients').snapshots();

  // Map<String, bool?> ingredientState = {};

  late Ingredients ingredients;
  //late List<bool> _isChecked;
  List<Ingredients> listIngredients = [];

  final List<String> _selectedIngredients = [];

  /*
  @override
  void initState() {
    super.initState();
    _isChecked = [];
  }*/

  @override
  Widget build(BuildContext context) {
    bool _isChecked = false;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _ingredientsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            //_isChecked = List<bool>.filled(snapshot.data!.size, false);

            /*for (int i = 0; i <= length_ingredients_list; i++) {
              Map<String, dynamic>? data =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>?;
              print("${i} : ${data}");
              ingredients = Ingredients.fromMap(data!);
              listIngredients.add(ingredients);
              snapshot.data!.docs.iterator.moveNext();
            }*/

            /*snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              );
            }).toList(),*/

            return ListView(
              padding: const EdgeInsets.all(0.0),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                ingredients = Ingredients.fromMap(data);

                // Save also the list locally
                listIngredients.add(ingredients);

                return CheckboxListTile(
                  title: Text(
                    ingredients.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                      "Carbohydrates: ${ingredients.carbohydratesG} g"
                      "\n"
                      "Proteins: ${ingredients.proteinG} g"), // Add the other voices
                  secondary: const Icon(Icons.android_sharp), // change icon
                  activeColor: const Color.fromARGB(255, 26, 117, 71),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(
                      () {
                        _isChecked = value!;
                        if (_isChecked == true) {
                          _selectedIngredients.add(ingredients.name);
                        } else {
                          _selectedIngredients.remove(ingredients.name);
                        }
                      },
                    );
                  },
                );
              }).toList(),
            );
            /*return ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(
                    listIngredients[index].name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                      "Carbohydrates: ${listIngredients[0].carbohydratesG} g  "
                      "Proteins: ${listIngredients[0].proteinG} g  "), // Add the other voices
                  secondary: const Icon(Icons.android_sharp), // change icon
                  activeColor: const Color.fromARGB(255, 26, 117, 71),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isChecked[index],
                  onChanged: (bool? value) {
                    setState(
                      () {
                        _isChecked[index] = value!;
                        if (_isChecked[index] == true) {
                          _selectedIngredients.add(listIngredients[index].name);
                        } else {
                          _selectedIngredients
                              .remove(listIngredients[index].name);
                        }
                      },
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );*/
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("New recipe"),
        onPressed: () {
          if (_selectedIngredients.isEmpty) {
            Fluttertoast.showToast(
                msg: "Please, select at least one ingredient",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateRecipe(_selectedIngredients)),
            );
          }
        },
        backgroundColor: const Color.fromARGB(255, 26, 117, 71),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
