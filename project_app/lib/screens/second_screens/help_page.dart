import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_app/screens/second_screens/help_screens/add_daily_calories_help.dart';
import 'package:project_app/screens/second_screens/help_screens/create_recipe_help.dart';
import 'package:project_app/screens/second_screens/help_screens/delete_recipe_help.dart';
import 'package:project_app/screens/second_screens/help_screens/manage_alimentary_plan_help.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List _helpScreens = [
    {"screen": const AddDailyCaloriesHelp(), "title": "Add daily calories"},
    {"screen": const CreateRecipeHelp(), "title": "Create recipe"},
    {
      "screen": const ManageAlimentaryPlanHelp(),
      "title": "Manage alimentary plan"
    },
    {"screen": const DeleteRecipeHelp(), "title": "Delete recipe"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemCount: _helpScreens.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _helpScreens[index]["title"],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(
                    Icons.double_arrow_outlined,
                    color: Color.fromARGB(255, 23, 91, 26),
                  ),
                  tileColor: Color.fromARGB(255, 177, 202, 177),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => _helpScreens[index]["screen"]));
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Color.fromARGB(255, 23, 91, 26),
                  thickness: 3,
                );
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: const EdgeInsets.only(left: 10.0),
            color: const Color.fromARGB(255, 168, 230, 170),
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                children: [
                  const TextSpan(text: "For any problem, contact us: "),
                  TextSpan(
                    text: "mpm.project.2022@gmail.com",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 30, 101, 159),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(
                            "mailto:mpm.project.2022@gmail.com?subject=Reporting an app problem"));
                      },
                  ),
                  const TextSpan(text: "\n\n"),
                  const TextSpan(
                      text: "Credits to: Alberto Gobbo, Marco Nardelotto"),
                  const TextSpan(text: "\n"),
                  const TextSpan(text: "MPM project - Unipd, A.Y. 2021-22"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
