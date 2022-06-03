// This code allows to manage the main screens (homepage/ingredients_list/alimentar_plan) after the login/signin procedure
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase/authentication_service.dart';
import 'ingredients_list.dart';
import 'homepage.dart';
import 'alimentar_plan.dart';
import 'second_screens/help_page.dart';
import 'second_screens/saved_recipes.dart';
import '../models/popup_menu_choices.dart';

class ManagementMainScreens extends StatefulWidget {
  const ManagementMainScreens({Key? key}) : super(key: key);

  @override
  State<ManagementMainScreens> createState() => _ManagementMainScreensState();
}

class _ManagementMainScreensState extends State<ManagementMainScreens> {
  int _currentScreenIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List _screens = [
    {"screen": const HomePage(), "title": "Home"},
    {"screen": const IngredientsList(), "title": "Ingredients list"},
    {"screen": const AlimentarPlan(), "title": "Your alimentar plan"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_currentScreenIndex]["title"]),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedRecipes()),
              );
            },
            tooltip: 'Created recipes',
          ),
          PopupMenuButton<PopupMenuChoices>(
            icon: const Icon(Icons.more_vert),
            onSelected: (result) {
              if (result.title == 'Help') {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HelpPage()));
              }
              if (result.title == 'Logout') {
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
                label: "ingredients",
                tooltip: 'The page with the list of all the ingredients'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Alimentar plan',
                tooltip: 'The page with your alimentar plan'),
          ],
          type: BottomNavigationBarType.fixed),
    );
  }
}
