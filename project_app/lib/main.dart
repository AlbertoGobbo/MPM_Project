import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_app/firebase/authentication_service.dart';
import 'package:project_app/models/personal_alimentar_plan.dart';
import 'package:project_app/screens/login.dart';
import 'package:provider/provider.dart';
import 'models/ingredients.dart';
import 'models/recipe.dart';
import 'screens/management_main_screens.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HealthyFood',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 26, 117, 71),
          foregroundColor: Colors.white,
        )),
        home: //const MyLoginPage(),
            const AutenticationWrapper(),
      ),
    );
  }
}

//Use for understand if the user is logged into the application
class AutenticationWrapper extends StatelessWidget {
  const AutenticationWrapper({Key? key}) : super(key: key);

  Future<void> retrieveUsername(User firebaseUser) async {
    if (globals.uidUser.isEmpty) {
      globals.uidUser = firebaseUser.uid;
    }

    if (globals.username.isEmpty) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(globals.uidUser)
          .get()
          .then((querySnapshot) {
            Map<String, dynamic>? data = querySnapshot.data();
            globals.username = data!["username"];
          })
          .whenComplete(() => null)
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => {log(error.message.toString())});
    }
  }

  Future<void> retrieveIngredientsList() async {
    if (globals.listIngredients.isEmpty) {
      await FirebaseFirestore.instance
          .collection('ingredients')
          .get()
          .then((querySnapshot) {
            for (var result in querySnapshot.docs) {
              Map<String, dynamic> data = result.data();
              Ingredients ingredients = Ingredients.fromMap(data);
              globals.listIngredients.add(ingredients);
            }
          })
          .whenComplete(() => globals.listIngredients.sort((a, b) {
                return a.name.compareTo(b.name);
              }))
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => {log(error.message.toString())});
    }
  }

  Future<void> retrieveSavedRecipes() async {
    if (globals.savedRecipes.isEmpty) {
      await FirebaseFirestore.instance
          .collection('recipes')
          .where("userId", isEqualTo: globals.uidUser)
          .get()
          .then((querySnapshot) {
            for (var result in querySnapshot.docs) {
              Map<String, dynamic> data = result.data();
              Recipe recipe = Recipe.fromMap(data);
              globals.savedRecipes.add(recipe);
            }
          })
          .whenComplete(() => null)
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => {log(error.message.toString())});
    }
  }

  Future<void> retrieveSavedAlimentarPlans() async {
    if (globals.listPlans.isEmpty) {
      await FirebaseFirestore.instance
          .collection('alimentarPlans')
          .where("uid", isEqualTo: globals.uidUser)
          .get()
          .then((querySnapshot) {
            for (var result in querySnapshot.docs) {
              Map<String, dynamic> data = result.data();
              AlimentarPlanDiary plan = AlimentarPlanDiary.fromJson(data);
              globals.listPlans.add(plan);
            }
          })
          .whenComplete(() => null)
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => {log(error.message.toString())});
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      retrieveUsername(firebaseUser);
      retrieveIngredientsList();
      retrieveSavedRecipes();
      retrieveSavedAlimentarPlans();

      return const ManagementMainScreens();
    }

    return const MyLoginPage();
  }
}
