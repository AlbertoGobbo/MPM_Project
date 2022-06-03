import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase/authentication_service.dart';
import 'screen2.dart';
import 'screen1.dart';
import './screen3.dart';
import './help_page.dart';
import './saved_recipes.dart';
import 'popup_menu_choices.dart';

/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthyFood',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 26, 117, 71),
        foregroundColor: Colors.white,
      )),
      home: const HomePage(),
    );
  }
}*/

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// The state of HomePage, which can be changed inside the immutable HomePage widget
class _HomePageState extends State<HomePage> {
  int _currentScreenIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List _screens = [
    {"screen": const Screen1(), "title": "Home"},
    {"screen": const Screen2(), "title": "Ingredients list"},
    {"screen": const Screen3(), "title": "Your weekly alimentar plan"},
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
