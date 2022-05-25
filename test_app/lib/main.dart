import 'package:flutter/material.dart';
import './screen1.dart';
import './screen2.dart';
import './screen3.dart';

void main() {
  runApp(const MyApp());
}

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
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      )),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// The state of HomePage, which can be changed inside the immutable HomePage widget
class _HomePageState extends State<HomePage> {
  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": const Screen1(), "title": "Ingrediants List"},
    {"screen": const Screen2(), "title": "Screen 2 Title"},
    {"screen": const Screen3(), "title": "Screen 3 Title"},
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedScreenIndex]["title"]),
        /*actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions')
        ]*/
      ),
      body: _screens[_selectedScreenIndex]["screen"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Screen 2"),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: 'Screen 3'),
        ],
      ),
    );
  }
}
