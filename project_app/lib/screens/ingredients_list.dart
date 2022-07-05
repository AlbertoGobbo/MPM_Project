import 'package:flutter/material.dart';
import 'package:project_app/models/ingredients.dart';
import 'package:project_app/helpers/search_widget.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class IngredientsList extends StatefulWidget {
  const IngredientsList({Key? key}) : super(key: key);

  @override
  State<IngredientsList> createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList>
    with AutomaticKeepAliveClientMixin {
  String searchText = '';
  var mapIngredientToCheckboxIndex = {};

  bool containsSearchText(Ingredients ingredients) {
    return ingredients.name.toLowerCase().contains(searchText.toLowerCase());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    globals.isCheckboxChecked = List<bool>.filled(
        globals.listIngredients.length, false,
        growable: true);
    for (int i = 0; i < globals.listIngredients.length; i = i + 1) {
      mapIngredientToCheckboxIndex[globals.listIngredients[i].name] = i;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ingredientsFromSearch =
        globals.listIngredients.where(containsSearchText).toList();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              color: const Color.fromARGB(0, 255, 255, 255),
              padding: const EdgeInsets.only(top: 17.0),
              child: SearchWidget(
                text: searchText,
                hintText: "Search ingredients",
                onChanged: (text) => setState(
                  () {
                    searchText = text;
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                itemCount: ingredientsFromSearch.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(
                      ingredientsFromSearch[index].name.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: globals.isCheckboxChecked[index] == false
                        ? const Visibility(
                            child: Text("Tap to see nutritional values"),
                            visible: true,
                          )
                        : Visibility(
                            child: Text(
                                "Calories (Kcal/g): ${ingredientsFromSearch[index].caloriesKcal}"
                                "\n"
                                "Carbohydrates/g: ${ingredientsFromSearch[index].carbohydratesG}"
                                "\n"
                                "Proteins/g: ${ingredientsFromSearch[index].proteinG}"
                                "\n"
                                "Total Fats/g: ${ingredientsFromSearch[index].totalFatG}"
                                "\n"
                                "Total Fibers/g: ${ingredientsFromSearch[index].totalFiberG}"
                                "\n"
                                "Total Sugars/g: ${ingredientsFromSearch[index].totalSugarG}"),
                            visible: true,
                          ),
                    secondary: Text(ingredientsFromSearch[index].emoji,
                        style: const TextStyle(fontSize: 40)),
                    activeColor: const Color.fromARGB(255, 26, 117, 71),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: ingredientsFromSearch.length ==
                            globals.listIngredients.length
                        ? globals.isCheckboxChecked[index]
                        : globals.isCheckboxChecked[
                            mapIngredientToCheckboxIndex[
                                ingredientsFromSearch[index].name]],
                    onChanged: (bool? value) {
                      setState(
                        () {
                          dynamic realIndex;
                          // Map the real index of the ingredient, if search is applied
                          if (ingredientsFromSearch.length ==
                              globals.listIngredients.length) {
                            realIndex = index;
                          } else {
                            realIndex = mapIngredientToCheckboxIndex[
                                ingredientsFromSearch[index].name];
                          }

                          globals.isCheckboxChecked[realIndex] = value!;
                          if (globals.isCheckboxChecked[realIndex] == true) {
                            globals.selectedIngredients
                                .add(globals.listIngredients[realIndex]);
                            globals.selectedIngredients.sort((a, b) {
                              return a.name.compareTo(b.name);
                            });
                          } else {
                            globals.selectedIngredients
                                .remove(globals.listIngredients[realIndex]);
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
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
