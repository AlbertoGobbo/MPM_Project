// This code allows to manage the main screens (homepage/ingredients_list/alimentary_plan) after the login/signin procedure
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:project_app/firebase/authentication_service.dart';
import 'package:project_app/screens/second_screens/create_recipe.dart';
import 'package:project_app/screens/ingredients_list.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:project_app/screens/alimentary_plan.dart';
import 'package:project_app/screens/second_screens/help_page.dart';
import 'package:project_app/screens/second_screens/saved_recipes.dart';
import 'package:project_app/models/popup_menu_choices.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class ManagementMainScreens extends StatefulWidget {
  const ManagementMainScreens({Key? key}) : super(key: key);

  @override
  State<ManagementMainScreens> createState() => _ManagementMainScreensState();
}

class _ManagementMainScreensState extends State<ManagementMainScreens> {
  final homepageKey = GlobalKey<State<Homepage>>();
  final ingredientListKey = GlobalKey<State<IngredientsList>>();
  int _currentScreenIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late List _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      {"screen": Homepage(key: homepageKey), "title": "Home"},
      {
        "screen": IngredientsList(
          key: ingredientListKey,
        ),
        "title": "Ingredients"
      },
      {"screen": const AlimentaryPlan(), "title": "Alimentary Plan"},
    ];
  }

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
            onPressed: () async {
              if (globals.selectedIngredients.isEmpty) {
                if (_currentScreenIndex == 0 || _currentScreenIndex == 2) {
                  setState(() {
                    _currentScreenIndex = 1;
                    _pageController.animateToPage(_currentScreenIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  });
                }

                Fluttertoast.showToast(
                    msg: "Please, select at least one ingredient",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                FocusScope.of(context).unfocus();
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateRecipe()),
                );

                if (ingredientListKey.currentState != null) {
                  final state = ingredientListKey.currentState!;
                  state.setState(() {});
                }
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
                if (_currentScreenIndex == 0 || _currentScreenIndex == 2) {
                  setState(() {
                    _currentScreenIndex = 1;
                    _pageController.animateToPage(_currentScreenIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  });
                }

                Fluttertoast.showToast(
                    msg: "No recipes created: please, create one",
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

                if (homepageKey.currentState != null) {
                  final state = homepageKey.currentState!;
                  state.setState(() {});
                }
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
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
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
                icon: Icon(Icons.home), label: 'Home', tooltip: 'The homepage'),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant),
                label: "Ingredients",
                tooltip: 'The page with the list of all the ingredients'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Alimentary Plan',
                tooltip: 'The page with your alimentary plan'),
          ],
          type: BottomNavigationBarType.fixed),
      resizeToAvoidBottomInset: false,
    );
  }
}
