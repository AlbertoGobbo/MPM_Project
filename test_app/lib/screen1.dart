import 'package:flutter/material.dart';

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

  void _pushCreateRecipe() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _selectedIngrediants.map(
            (ingredient) {
              return ListTile(
                title: Text(
                  ingredient,
                  style: const TextStyle(fontSize: 20),
                ),
              );
            },
          );

          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(title: const Text('Create your recipe')),
            body: ListView(children: divided),
          );
        },
      ),
    );
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
            controlAffinity: ListTileControlAffinity.platform,
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Create a toast message if there are no selected ingredients
            _pushCreateRecipe();
          },
          backgroundColor: const Color.fromARGB(255, 26, 117, 71),
          child: const Icon(Icons.add)),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
