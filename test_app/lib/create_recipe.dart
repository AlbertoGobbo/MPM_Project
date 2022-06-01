import 'package:flutter/material.dart';

class CreateRecipe extends StatelessWidget {
  final List<String> _selectedIngrediants;

  const CreateRecipe(this._selectedIngrediants, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Comment these rows, because the previous appBar is not substituted with the new one, creating a stack of appBars.
      /*appBar: AppBar(
        title: const Text('Create Recipe'),
      ),*/
      body: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        itemCount: _selectedIngrediants.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _selectedIngrediants[index],
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: const Text("Subtitle"),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
