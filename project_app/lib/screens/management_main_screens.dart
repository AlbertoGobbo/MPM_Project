// This code allows to manage the main screens (homepage/ingredients_list/alimentar_plan) after the login/signin procedure
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/screens/second_screens/create_recipe.dart';
import 'package:provider/provider.dart';
import '../firebase/authentication_service.dart';
import 'ingredients_list.dart';
import 'homepage.dart';
import 'alimentar_plan.dart';
import 'second_screens/help_page.dart';
import 'second_screens/saved_recipes.dart';
import '../models/popup_menu_choices.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class ManagementMainScreens extends StatefulWidget {
  const ManagementMainScreens({Key? key}) : super(key: key);

  @override
  State<ManagementMainScreens> createState() => _ManagementMainScreensState();
}

class _ManagementMainScreensState extends State<ManagementMainScreens> {
  int _currentScreenIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List _screens = [
    {"screen": const Homepage(), "title": "Home"},
    {"screen": const IngredientsList(), "title": "Ingredients"},
    {"screen": const AlimentarPlan(), "title": "Alimentar plan"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_currentScreenIndex]["title"]),
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add_rounded),
            iconSize: 27.0,
            padding: const EdgeInsets.all(13.5),
            onPressed: () {
              if (globals.selectedIngredients.isEmpty) {
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
                  MaterialPageRoute(builder: (context) => const CreateRecipe()),
                );
              }
            },
            tooltip: 'Create a new recipe',
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            iconSize: 27.0,
            padding: const EdgeInsets.all(13.5),
            onPressed: () {
              if (globals.savedRecipes.isEmpty) {
                Fluttertoast.showToast(
                    msg: "No recipes create: please, create one",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedRecipes()),
                );
              }
            },
            tooltip: 'Your recipes',
          ),
          PopupMenuButton<PopupMenuChoices>(
            icon: const Icon(Icons.more_vert),
            iconSize: 27.0,
            padding: const EdgeInsets.all(13.5),
            onSelected: (result) async {
              if (result.title == 'Help') {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HelpPage()));
              }
              if (result.title == 'Logout') {
                globals.clearGlobalVariables();
                context.read<AuthenticationService>().signOut();
              }
            },
            itemBuilder: (BuildContext context) {
              return choices.map((PopupMenuChoices choice) {
                return PopupMenuItem<PopupMenuChoices>(
                  value: choice,
                  child: ListTile(
                    minLeadingWidth: 1,
                    minVerticalPadding: 1,
                    leading: Icon(choice.icon),
                    title: Text(choice.title),
                  ),
                );
              }).toList();
            },
            tooltip: 'Other options',
          ),
        ],
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentScreenIndex = newIndex;
          });
        },
        children: [
          _screens[0]["screen"],
          _screens[1]["screen"],
          _screens[2]["screen"],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentScreenIndex,
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Homepage',
                tooltip: 'The homepage'),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant),
                label: "Ingredients",
                tooltip: 'The page with the list of all the ingredients'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Alimentar plan',
                tooltip: 'The page with your alimentar plan'),
          ],
          type: BottomNavigationBarType.fixed),
      resizeToAvoidBottomInset: false,
    );
  }
}
