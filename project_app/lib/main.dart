import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_app/firebase/authentication_service.dart';
import 'package:project_app/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'firebase/firestore_function.dart';
import 'screens/management_main_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
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
        home: const AutenticationWrapper(),
      ),
    );
  }
}

// Used to understand if the user is logged into the application
class AutenticationWrapper extends StatefulWidget {
  const AutenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AutenticationWrapper> createState() => _AutenticationWrapperState();
}

class _AutenticationWrapperState extends State<AutenticationWrapper> {
  bool isLoaded = false;

  Future<void> getValue(User firebaseUser) async {
    setState(() {
      isLoaded = false;
    });

    await retrieveUsername(firebaseUser);
    await retrieveUserKcal(firebaseUser);
    await retrieveIngredientsList();
    await retrieveSavedRecipes();
    await retrieveSavedAlimentarPlans();

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      /*bool operationsOk = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        operationsOk = await getValue(firebaseUser);
      });

      if (operationsOk == false) {
        await getValue(firebaseUser);
      }*/

      await getValue(firebaseUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      if (isLoaded) {
        return const ManagementMainScreens();
      } else {
        return const Scaffold(
          body: Center(
            child: SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Color.fromARGB(255, 23, 91, 26)),
                  strokeWidth: 7,
                )),
          ),
        );
      }
    }

    return const MyLoginPage();
  }
}
