import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_app/helpers/reusable_widgets.dart';
import 'package:project_app/helpers/validator.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

class SetCaloriesGoal extends StatefulWidget {
  const SetCaloriesGoal({Key? key}) : super(key: key);

  @override
  State<SetCaloriesGoal> createState() => _SetCaloriesGoalState();
}

class _SetCaloriesGoalState extends State<SetCaloriesGoal> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  TextEditingController caloriesController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String? errorAgeMsg;
  String? errorWeightMsg;
  String? errorCaloriesMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calories Goal"),
      ),
      body: Column(
        children: [
          const Text(
            "Set you custom calories goal",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Form(
              key: _formKey1,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: reusableTextFieldForm(
                        "Calories",
                        Icons.fireplace,
                        false,
                        caloriesController,
                        caloriesValidator,
                        errorCaloriesMsg,
                        TextInputType.number),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        trySetCustomCalories();
                      },
                      child: const Text("Set Calories"))
                ],
              )),
          const Divider(height: 2),
          Form(
            key: _formKey2,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: reusableTextFieldForm(
                      "Age",
                      Icons.calendar_view_day_outlined,
                      false,
                      ageController,
                      ageValidator,
                      errorAgeMsg,
                      TextInputType.number),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: reusableTextFieldForm(
                      "Weight",
                      Icons.monitor_weight,
                      false,
                      weightController,
                      weightValidator,
                      errorWeightMsg,
                      TextInputType.number),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void trySetCustomCalories() {
    errorCaloriesMsg = null;

    String calories = caloriesController.text.trim();

    bool? isValid = _formKey1.currentState?.validate();

    if (isValid == true) {
      globals.caloriesGoal = calories;
      Fluttertoast.showToast(
          msg: "Calories Goal Set",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      Navigator.pop(context);
    } else {
      setState(() {});
    }
  }
}
