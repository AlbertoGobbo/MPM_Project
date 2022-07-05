import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController heightController = TextEditingController();
  String? errorAgeMsg;
  String? errorWeightMsg;
  String? errorHeightMsg;
  String? errorCaloriesMsg;

  List<bool> isSelectedGender = [true, false];
  List<bool> isSelectedBaseActivity = [true, false, false];
  List<bool> isSelectedAuspicActivity = [true, false];

  List<String> basicActivityDescriptions = [
    "If you are: employed administrative and managerial staff freelancers, technicians or similar",
    "If you are: housewives domestic helpers sales staff tertiary workers or similar",
    "If you are: workers in agriculture, livestock, forestry and fishing unskilled workers production and transport equipment operators or similar"
  ];

  int indexBaseAcitivity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Calories Goal"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Set your custom calories goal",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red),
              ),
            ),
            Form(
                key: _formKey1,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: reusableTextFieldForm(
                          "Calories",
                          Icons.fireplace,
                          false,
                          caloriesController,
                          caloriesValidator,
                          errorCaloriesMsg,
                          TextInputType.number,
                          RegExp('[0-9]'),
                          "Kcal"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        trySetCustomCalories();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(11.0),
                        child: Text(
                          "Set Calories",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                )),
            const Divider(
              height: 30,
              thickness: 3,
              color: Colors.black,
            ),
            Form(
              key: _formKey2,
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      "Calculate your goal",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              /*const Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: Text(
                                  "Gender:",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),*/
                              ToggleButtons(
                                constraints: BoxConstraints(
                                    minWidth:
                                        (MediaQuery.of(context).size.width -
                                                36) /
                                            5,
                                    minHeight: 50),
                                children: const <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Male",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Female",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                                onPressed: (int index) {
                                  setState(() {
                                    for (int buttonIndex = 0;
                                        buttonIndex < isSelectedGender.length;
                                        buttonIndex++) {
                                      if (buttonIndex == index) {
                                        isSelectedGender[buttonIndex] = true;
                                      } else {
                                        isSelectedGender[buttonIndex] = false;
                                      }
                                    }
                                  });
                                },
                                isSelected: isSelectedGender,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: reusableTextFieldForm(
                              "Age",
                              Icons.calendar_view_day_outlined,
                              false,
                              ageController,
                              ageValidator,
                              errorAgeMsg,
                              TextInputType.number,
                              RegExp('[0-9]'),
                              "Year"),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 20.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: reusableTextFieldForm(
                              "Weight",
                              Icons.monitor_weight,
                              false,
                              weightController,
                              weightValidator,
                              errorWeightMsg,
                              TextInputType.number,
                              RegExp('[0-9.]'),
                              "Kg"),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: reusableTextFieldForm(
                              "Height",
                              Icons.height,
                              false,
                              heightController,
                              heightValidator,
                              errorHeightMsg,
                              TextInputType.number,
                              RegExp('[0-9]'),
                              "Cm"),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Basic physical activity:",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 16),
                    child: Text(
                      "Choose your daily physical activity level based on the work you do",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ToggleButtons(
                    constraints: BoxConstraints(
                        minWidth: (MediaQuery.of(context).size.width - 36) / 5,
                        minHeight: 50),
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Soft",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Moderate",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Intense",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelectedBaseActivity.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            isSelectedBaseActivity[buttonIndex] = true;
                            indexBaseAcitivity = index;
                          } else {
                            isSelectedBaseActivity[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    isSelected: isSelectedBaseActivity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      basicActivityDescriptions[indexBaseAcitivity],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 22, 110, 181)),
                    ),
                  ),
                  const Text(
                    "Workout during the week:",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 16),
                    child: Text(
                      "A healthy adult engages in desirable physical activity if it spends at least 20 minutes of exercise of sufficient intensity four to five times a week to cause noticeable sweating.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ToggleButtons(
                    constraints: BoxConstraints(
                        minWidth: (MediaQuery.of(context).size.width - 36) / 5,
                        minHeight: 50),
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "YES",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "NO",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelectedAuspicActivity.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            isSelectedAuspicActivity[buttonIndex] = true;
                          } else {
                            isSelectedAuspicActivity[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    isSelected: isSelectedAuspicActivity,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        tryCalculateCaloriesGoal();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(11.0),
                        child: Text(
                          "Calculate Calories",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> trySetCustomCalories() async {
    errorCaloriesMsg = null;

    String calories = caloriesController.text.trim();

    bool? isValid = _formKey1.currentState?.validate();

    if (isValid == true) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(globals.uidUser)
          .update({"user_kcal": calories}).then((value) {
        globals.caloriesGoal = calories;
        Fluttertoast.showToast(
            msg: "Calories Goal Set",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pop(context);
      },
              onError: (e) =>
                  log("Error updating document: " + e.message.toString()));
    } else {
      setState(() {});
    }
  }

  void tryCalculateCaloriesGoal() async {
    bool? isValid = _formKey2.currentState?.validate();

    if (isValid == true) {
      String gender = "M";
      if (isSelectedGender[0] == true) {
        gender = "M";
      } else {
        gender = "F";
      }

      String age = ageController.text.trim();
      String weight = weightController.text.trim().replaceAll(",", ".");
      // ignore: unused_local_variable
      String height = heightController.text.trim();

      double basale = getBasale(gender, age, weight);

      double laf =
          getLAF(gender, age, isSelectedBaseActivity, isSelectedAuspicActivity);

      showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Calories goal obtained:"),
                content: Text("${(basale * laf).toInt()}"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Recalculate"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Set Goal"),
                    onPressed: () async {
                      globals.caloriesGoal = "${(basale * laf).toInt()}";
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(globals.uidUser)
                          .update({
                        "users_kcal": (basale * laf).toInt().toString()
                      }).then((value) {
                        globals.caloriesGoal = "${(basale * laf).toInt()}";
                        Fluttertoast.showToast(
                            msg: "Calories Goal Set",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      },
                              onError: (e) => log("Error updating document: " +
                                  e.message.toString()));
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
  }

  double getBasale(String gender, String age, String weight) {
    double basale = 0;
    if (gender == "M") {
      if (int.parse(age) <= 29 && int.parse(age) >= 18) {
        basale = 15.3 * double.parse(weight) + 679;
      } else if (int.parse(age) <= 59 && int.parse(age) >= 30) {
        basale = 11.6 * double.parse(weight) + 879;
      } else if (int.parse(age) <= 74 && int.parse(age) >= 60) {
        basale = 11.9 * double.parse(weight) + 700;
      } else {
        basale = 8.4 * double.parse(weight) + 819;
      }
    } else {
      if (int.parse(age) <= 29 && int.parse(age) >= 18) {
        basale = 14.7 * double.parse(weight) + 496;
      } else if (int.parse(age) <= 59 && int.parse(age) >= 30) {
        basale = 8.7 * double.parse(weight) + 829;
      } else if (int.parse(age) <= 74 && int.parse(age) >= 60) {
        basale = 9.2 * double.parse(weight) + 688;
      } else {
        basale = 9.8 * double.parse(weight) + 624;
      }
    }
    return basale;
  }

  double getLAF(String gender, String age, List<bool> isSelectedBaseActivity,
      List<bool> isSelectedAuspicActivity) {
    double laf = 0;

    if (gender == "M") {
      if (int.parse(age) <= 59 && int.parse(age) >= 18) {
        switch (
            isSelectedBaseActivity.indexWhere((element) => element == true)) {
          case 0:
            laf = isSelectedAuspicActivity[0] == true ? 1.55 : 1.41;
            break;

          case 1:
            laf = isSelectedAuspicActivity[0] == true ? 1.78 : 1.70;
            break;

          case 2:
            laf = isSelectedAuspicActivity[0] == true ? 2.10 : 2.01;
            break;
        }
      } else if (int.parse(age) <= 74 && int.parse(age) >= 60) {
        laf = isSelectedAuspicActivity[0] == true ? 1.51 : 1.40;
      } else {
        laf = isSelectedAuspicActivity[0] == true ? 1.51 : 1.33;
      }
    } else {
      if (int.parse(age) <= 59 && int.parse(age) >= 18) {
        switch (
            isSelectedBaseActivity.indexWhere((element) => element == true)) {
          case 0:
            laf = isSelectedAuspicActivity[0] == true ? 1.56 : 1.42;
            break;

          case 1:
            laf = isSelectedAuspicActivity[0] == true ? 1.64 : 1.56;
            break;

          case 2:
            laf = isSelectedAuspicActivity[0] == true ? 1.82 : 1.73;
            break;
        }
      } else if (int.parse(age) <= 74 && int.parse(age) >= 60) {
        laf = isSelectedAuspicActivity[0] == true ? 1.56 : 1.44;
      } else {
        laf = isSelectedAuspicActivity[0] == true ? 1.56 : 1.37;
      }
    }
    return laf;
  }
}
