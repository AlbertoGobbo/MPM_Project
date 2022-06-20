import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_app/firebase/authentication_service.dart';
import 'package:project_app/screens/login.dart';
import 'package:provider/provider.dart';
import 'firebase/firestore_function.dart';
import 'screens/management_main_screens.dart';

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
          backgroundColor: Color.fromARGB(255, 26, 117,
              71), //TODO: cambio colore Color.fromARGB(255, 74, 212, 143)
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
