import 'package:flutter/material.dart';
import 'package:test_app/create_recipe.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IngrediantsList(),
    );
  }
}

class IngrediantsList extends StatefulWidget {
  const IngrediantsList({Key? key}) : super(key: key);

  @override
  State<IngrediantsList> createState() => _IngrediantsListState();
}

// The state of IngrediantsList, which can be changed inside the immutable IngrediantsList widget
class _IngrediantsListState extends State<IngrediantsList> {
  late List<bool> _isChecked;
  // This list will contain all the ingredients and the information about nutritional values from the dataset
  // _ingrediants = <String>[];
  final List<String> _ingrediants = [
    "Pasta",
    "Rice",
    "Pizza",
    "Ham",
    "Potato",
    "Pomato",
    "Cucumber",
    "Jam",
    "Orange",
    "Apple",
    "Sugar",
    "Salt",
    "Lemon"
  ];

  final List<String> _selectedIngrediants = [];

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(_ingrediants.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        itemCount: _ingrediants.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(
              _ingrediants[index],
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: const Text("Subtitle"),
            secondary: const Icon(Icons.android_sharp),
            activeColor: const Color.fromARGB(255, 26, 117, 71),
            controlAffinity: ListTileControlAffinity.leading,
            value: _isChecked[index],
            onChanged: (bool? value) {
              setState(
                () {
                  _isChecked[index] = value!;
                  if (_isChecked[index] == true) {
                    _selectedIngrediants.add(_ingrediants[index]);
                  } else {
                    _selectedIngrediants.remove(_ingrediants[index]);
                  }
                },
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("New recipe"),
        onPressed: () {
          if (_selectedIngrediants.isEmpty) {
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
                  builder: (context) => CreateRecipe(_selectedIngrediants)),
            );
          }
        },
        backgroundColor: const Color.fromARGB(255, 26, 117, 71),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
